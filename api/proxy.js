// Vercel Edge Function — AI API 프록시 (Anthropic · OpenAI CORS 해결)
export const config = { runtime: 'edge' };

// 허용 Origin — 실제 배포 도메인만 허용하여 타 사이트의 무단 proxy 사용 차단
function isAllowedOrigin(origin) {
  if (!origin) return false;
  return (
    /^https:\/\/[a-z0-9-]+\.vercel\.app$/i.test(origin) ||
    /^https:\/\/[a-z0-9-]+\.github\.io$/i.test(origin) ||
    /^http:\/\/localhost(:\d+)?$/i.test(origin) ||
    /^http:\/\/127\.0\.0\.1(:\d+)?$/i.test(origin)
  );
}

export default async function handler(req) {
  const origin = req.headers.get('origin') || '';
  const allowed = isAllowedOrigin(origin);

  const corsHeaders = {
    'Access-Control-Allow-Origin': allowed ? origin : 'null',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, X-Api-Key, X-Provider',
    'Vary': 'Origin',
  };

  // CORS 프리플라이트
  if (req.method === 'OPTIONS') {
    return new Response(null, { status: 204, headers: corsHeaders });
  }

  // 허용되지 않은 Origin 차단 (origin 헤더 없는 서버 요청은 통과 허용)
  if (origin && !allowed) {
    return new Response(
      JSON.stringify({ error: { message: '허용되지 않은 Origin 입니다' } }),
      { status: 403, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }

  if (req.method !== 'POST') {
    return new Response('Method Not Allowed', { status: 405, headers: corsHeaders });
  }

  const apiKey  = req.headers.get('x-api-key');
  const provider = (req.headers.get('x-provider') || 'anthropic').toLowerCase();

  if (!apiKey) {
    return new Response(
      JSON.stringify({ error: { message: 'X-Api-Key 헤더가 필요합니다' } }),
      { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }

  const body = await req.text();

  let upstreamUrl, upstreamHeaders;

  if (provider === 'openai') {
    // OpenAI Chat Completions API
    upstreamUrl = 'https://api.openai.com/v1/chat/completions';
    upstreamHeaders = {
      'Authorization': `Bearer ${apiKey}`,
      'content-type': 'application/json',
    };
  } else {
    // Anthropic Messages API (기본값)
    upstreamUrl = 'https://api.anthropic.com/v1/messages';
    upstreamHeaders = {
      'x-api-key': apiKey,
      'anthropic-version': '2023-06-01',
      'content-type': 'application/json',
    };
  }

  const upstream = await fetch(upstreamUrl, {
    method: 'POST',
    headers: upstreamHeaders,
    body,
  });

  // 스트리밍 응답 그대로 전달
  return new Response(upstream.body, {
    status: upstream.status,
    headers: {
      ...corsHeaders,
      'Content-Type': upstream.headers.get('content-type') || 'text/event-stream',
      'Cache-Control': 'no-cache',
      'X-Accel-Buffering': 'no',
    },
  });
}
