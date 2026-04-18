# ============================================================
#  수행평가 결과물 요약 프로그램 — 로컬 서버 (PowerShell)
#  역할: index.html 제공 + Anthropic API 프록시(CORS 우회)
# ============================================================

$ErrorActionPreference = 'Stop'
$PORT   = 8888
$SCRIPT = Split-Path -Parent $MyInvocation.MyCommand.Path

# ── 포트 바인딩 ──────────────────────────────────────────────
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$PORT/")

try {
    $listener.Start()
} catch {
    Write-Host ""
    Write-Host "  [오류] 포트 $PORT 를 사용할 수 없습니다." -ForegroundColor Red
    Write-Host "  다른 프로그램이 해당 포트를 사용 중일 수 있습니다." -ForegroundColor Yellow
    Write-Host "  server.ps1 파일을 메모장으로 열어 PORT 값을 변경하세요." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter 키를 눌러 종료"
    exit 1
}

Write-Host ""
Write-Host "  ================================================" -ForegroundColor Cyan
Write-Host "   수행평가 결과물 요약 프로그램" -ForegroundColor Cyan
Write-Host "  ================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  서버 주소 : http://localhost:$PORT" -ForegroundColor Green
Write-Host "  종 료     : 이 창을 닫거나 Ctrl+C" -ForegroundColor Yellow
Write-Host ""

# 브라우저 자동 실행
Start-Sleep -Milliseconds 400
Start-Process "http://localhost:$PORT"

# ── 요청 처리 루프 ────────────────────────────────────────────
while ($listener.IsListening) {
    try {
        $ctx = $listener.GetContext()
    } catch {
        break
    }

    $req = $ctx.Request
    $res = $ctx.Response

    # 공통 CORS 헤더
    $res.Headers.Add("Access-Control-Allow-Origin",  "*")
    $res.Headers.Add("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
    $res.Headers.Add("Access-Control-Allow-Headers", "Content-Type, X-Api-Key")

    $method = $req.HttpMethod
    $path   = $req.Url.LocalPath

    # ── CORS 프리플라이트 ──────────────────────────────────────
    if ($method -eq "OPTIONS") {
        $res.StatusCode = 204
        $res.Close()
        continue
    }

    # ── index.html 제공 ───────────────────────────────────────
    if ($method -eq "GET" -and ($path -eq "/" -or $path -eq "/index.html")) {
        try {
            $htmlFile = Join-Path $SCRIPT "index.html"
            $bytes = [System.IO.File]::ReadAllBytes($htmlFile)
            $res.ContentType     = "text/html; charset=utf-8"
            $res.ContentLength64 = $bytes.Length
            $res.OutputStream.Write($bytes, 0, $bytes.Length)
        } catch {
            $res.StatusCode = 500
        }
        $res.Close()
        continue
    }

    # ── Anthropic API 프록시 ──────────────────────────────────
    if ($method -eq "POST" -and $path -eq "/proxy") {
        $apiKey = $req.Headers["X-Api-Key"]

        if (-not $apiKey) {
            $err = [System.Text.Encoding]::UTF8.GetBytes('{"error":{"message":"X-Api-Key header missing"}}')
            $res.StatusCode      = 400
            $res.ContentType     = "application/json"
            $res.ContentLength64 = $err.Length
            $res.OutputStream.Write($err, 0, $err.Length)
            $res.Close()
            continue
        }

        # 요청 본문 읽기
        $memIn = New-Object System.IO.MemoryStream
        $req.InputStream.CopyTo($memIn)
        $bodyBytes = $memIn.ToArray()

        # Anthropic API 호출
        $webReq = [System.Net.WebRequest]::Create("https://api.anthropic.com/v1/messages")
        $webReq.Method          = "POST"
        $webReq.ContentType     = "application/json"
        $webReq.ContentLength   = $bodyBytes.Length
        $webReq.Timeout         = 180000
        $webReq.ReadWriteTimeout = 180000
        $webReq.Headers.Add("x-api-key",         $apiKey)
        $webReq.Headers.Add("anthropic-version",  "2023-06-01")

        $wStream = $webReq.GetRequestStream()
        $wStream.Write($bodyBytes, 0, $bodyBytes.Length)
        $wStream.Close()

        try {
            $webRes = $webReq.GetResponse()

            # 스트리밍 응답 설정
            $res.ContentType    = "text/event-stream; charset=utf-8"
            $res.SendChunked    = $true
            $res.Headers.Add("Cache-Control",     "no-cache")
            $res.Headers.Add("X-Accel-Buffering", "no")

            $src = $webRes.GetResponseStream()
            $out = $res.OutputStream
            $buf = New-Object byte[] 4096

            do {
                $n = $src.Read($buf, 0, $buf.Length)
                if ($n -gt 0) {
                    $out.Write($buf, 0, $n)
                    $out.Flush()
                }
            } while ($n -gt 0)

            $src.Close()
            $webRes.Close()

        } catch [System.Net.WebException] {
            $exRes = $_.Exception.Response
            if ($exRes) {
                $errStream = $exRes.GetResponseStream()
                $errMem    = New-Object System.IO.MemoryStream
                $errStream.CopyTo($errMem)
                $errBytes = $errMem.ToArray()
                $res.StatusCode      = [int]$exRes.StatusCode
                $res.ContentLength64 = $errBytes.Length
                $res.ContentType     = "application/json"
                $res.OutputStream.Write($errBytes, 0, $errBytes.Length)
            } else {
                $msg   = [System.Text.Encoding]::UTF8.GetBytes('{"error":{"message":"' + $_.Exception.Message + '"}}')
                $res.StatusCode      = 500
                $res.ContentLength64 = $msg.Length
                $res.ContentType     = "application/json"
                $res.OutputStream.Write($msg, 0, $msg.Length)
            }
        }

        try { $res.Close() } catch {}
        continue
    }

    # ── 404 ───────────────────────────────────────────────────
    $res.StatusCode = 404
    $res.Close()
}
