# 수행평가 AI 도우미 — Claude 작업 매뉴얼

이 파일은 Claude가 이 프로젝트를 유지·개선할 때 참고할 핵심 정보를 담고 있습니다.
세션이 새로 시작되어도 이 파일만 읽으면 전체 구조와 규칙을 파악할 수 있도록 작성합니다.

---

## 1. 프로젝트 개요

- **이름**: 수행평가 AI 도우미
- **목적**: 교사가 학생 수행평가 결과물(파일)을 업로드하면 AI가 ① 생기부용 관찰 문장(3버전) 자동 생성, ② 루브릭 기반 자동 채점·총평을 만들어 주는 단일 페이지 웹앱
- **사용자**: 고등학교 교사 (연락처는 푸터 참조)
- **배포 URL**: Vercel (`*.vercel.app`)
- **저장소**: GitHub `jerry5026-dotcom/saenggibu-observation`

---

## 2. 사용자 가이드 — 왜, 그리고 어떻게 쓰는가

### 🤔 이 프로그램이 왜 필요한가

학기 말, 선생님 책상에는 30명 × 4~5개 수행평가 결과물이 쌓입니다.
하나하나 읽고, 루브릭에 비춰 점수를 매기고, 생기부에 들어갈 관찰 문장을 학생마다 다른 표현으로 써 내려가는 일.
**한 반에 5~6시간, 여러 반이면 주말이 통째로 사라집니다.**

이 프로그램은 그 시간을 돌려드립니다.

| 기존 방식 | 이 프로그램 사용 시 |
|-----------|---------------------|
| 학생 결과물 한 장씩 읽기 | 폴더 통째로 드래그 → AI가 자동 추출 |
| 루브릭 들고 항목별로 점수 매기기 | 루브릭 한 번 업로드 → 전원 자동 채점 |
| 학생마다 다른 문장 짜내기 | 1인당 관찰 문장 **3가지 버전** 자동 생성 |
| 엑셀에 점수 옮겨 적기 | **한 번에 통합 엑셀 다운로드** |
| 손글씨/스캔본은 직접 타이핑 | PDF·이미지 OCR 자동 처리 |

> "선생님의 소중한 퇴근 시간을 응원합니다" — 푸터 문구가 곧 이 프로그램의 존재 이유입니다.

---

### 🚀 5분 안에 시작하기

#### STEP 1. 실행 모드 선택 (사이드바 상단)

상황에 맞는 모드를 고르세요:

| 모드 | 이런 분께 |
|------|----------|
| **관찰만** | "채점은 끝났고, 생기부 문장만 빨리 뽑고 싶다" |
| **채점만** | "점수만 빨리 매기고 싶다, 문장은 직접 쓸 것" |
| **관찰+채점 동시** | "한 번에 다 끝내고 싶다" (가장 많이 쓰는 모드) |
| **프롬프트 복사 (무료)** | "API 키 결제는 부담스럽다 — ChatGPT/Claude 웹에 직접 붙여넣겠다" |

#### STEP 2. AI 제공자·모델 선택

처음 쓰신다면 추천 조합:
- **무료로 시작**: Gemini → `Gemini 3 Flash` (구글 계정만 있으면 무료)
- **품질 우선**: Claude → `Sonnet 4.6` (한국어 자연스러움 가장 좋음, 유료)
- **속도/비용 우선**: OpenAI → `GPT-5.4 mini` (빠르고 저렴, 유료)

> API 키는 **브라우저에만** 저장됩니다. 서버에 올라가지 않으니 안심하세요.

#### STEP 3. 기본 정보 입력

- **과목**, **활동 유형**(서술형/발표/협업/보고서…), **주제**
- **성취 수준**(상/중/하) — AI가 톤을 맞춤

#### STEP 4. 루브릭 업로드 (채점 모드만)

채점 기준표 파일(한글/워드/PDF/이미지) 1개 드래그.
→ AI가 자동으로 항목·배점·등급 기준을 읽어냅니다.

#### STEP 5. 학생 결과물 업로드

여러 파일을 한꺼번에 드래그하세요. 지원 형식:
- 📄 한글(.hwp/.hwpx 변환본), 워드(.docx), PPT(.pptx), PDF
- 🖼️ 이미지(.jpg/.png) — **손글씨도 OK** (자동 OCR)
- 📑 스캔 PDF — 자동으로 이미지로 변환해 인식

> 파일명에 학생 이름이 들어 있으면 자동으로 학생별로 분리됩니다.

#### STEP 6. (선택) 발표·협업 체크리스트

발표·모둠 활동이라면 사이드바 아코디언을 펴서 학생별 관찰을 입력하세요.
→ 채점·총평에 반영되어 더 풍부한 결과가 나옵니다.

#### STEP 7. 실행 → 결과 확인 → 내보내기

- 결과는 학생별 카드로 표시됩니다.
- 관찰 문장은 **3가지 버전**(짧게/표준/풍부) 중 마음에 드는 것 복사
- 채점은 항목별 점수표 + AI 총평 함께 표시
- 하단의 **"통합 엑셀 다운로드"** 버튼 → 점수·관찰 문장이 한 시트에 정리된 .xlsx

---

### 💡 이런 분께 강력 추천

- ✅ 수행평가 결과물을 **반별로 일괄 처리**하고 싶은 분
- ✅ 생기부 문장이 매번 비슷해 **표현 다양성**이 고민이신 분
- ✅ 루브릭 채점이 **객관적·일관적**이길 원하는 분 (AI는 피곤하지 않습니다)
- ✅ **손글씨 답안**이 많아 타이핑이 부담인 분
- ✅ API 결제는 부담스럽지만 **AI의 도움은 받고 싶은** 분 → 프롬프트 복사 모드

---

### ⚠️ 알아두실 점

- AI 결과는 **초안**입니다. 최종 책임은 선생님께 있으니 검토 후 사용하세요.
- 학생 개인정보(이름·학번 등)가 포함된 파일을 업로드하실 때는 학교 정보보호 지침을 따르세요.
- Gemini 무료 티어는 분당 호출 제한이 있습니다 — 한 번에 30명 이상이면 잠시 대기가 발생할 수 있습니다.
- 데이터(파일·이력)는 **사용자 브라우저 내부**(IndexedDB)에만 저장됩니다. 다른 PC에서는 보이지 않습니다.

---

## 3. 파일 구조

```
수행평가 결과물 요약 프로그램/
├── index.html       # 단일 파일 웹앱 (HTML/CSS/JS 전체, ~4085줄)
├── api/
│   └── proxy.js     # Vercel Edge Function — Anthropic·OpenAI CORS 프록시
└── CLAUDE.md        # 이 파일
```

`index.html` 한 파일에 UI/스타일/로직이 전부 들어있는 구조. 외부 라이브러리는 CDN으로 로드:
- pdf.js 3.11.174 (PDF 텍스트·이미지 추출)
- mammoth 1.6.0 (.docx 텍스트 추출)
- jszip 3.10.1 (.pptx 파싱용)
- xlsx 0.18.5 (결과 엑셀 내보내기)

---

## 4. 왜 Vercel인가 (GitHub Pages 아님)

브라우저에서 Anthropic/OpenAI API를 직접 호출하면 **CORS 차단**됨. 이를 우회하기 위해 Vercel Edge Function (`api/proxy.js`)을 프록시로 둠.

- **Anthropic/OpenAI** → Edge Function 경유 (`/api/proxy`)
- **Gemini** → 브라우저에서 직접 호출 (CORS 허용됨)

`api/proxy.js` 보안:
- `*.vercel.app`, `*.github.io`, `localhost`, `127.0.0.1` Origin만 허용 (타 사이트의 무단 사용 차단)
- API 키는 `X-Api-Key` 헤더로 받아 그대로 업스트림에 전달 (서버 저장 ❌)
- 요청 본문 `X-Provider` 헤더로 anthropic/openai 분기

---

## 5. 핵심 데이터 구조 (index.html 내부)

### `CONFIG` (1443~1455줄) — 전역 튜닝 상수
```js
RETRY_WAIT_SECONDS: 62        // 429 시 대기
MAX_RETRIES:        2
PDF_MAX_PAGES:      10        // 스캔 PDF 최대 렌더링
PDF_SCALE:          1.8       // 손글씨 OCR 대응 배율
PDF_JPEG_QUALITY:   0.75
PDF_MAX_BODY_BYTES: 4_000_000 // Vercel Edge 4.5MB 한도 마진
TASK_DELAY_MS:      1500      // 파일 간 호출 간격
MAX_FILE_SIZE_BYTES: 30 * 1024 * 1024
STEP1_MAX_TOKENS:   1500      // 1단계(추출) 토큰
STEP2_MAX_TOKENS:   2500      // 2단계(생성) 토큰
RUBRIC_OCR_MAX_TOKENS: 2000
```

### `PROVIDER_MODELS` (1599~1618줄) — AI 모델 목록
- **anthropic**: `claude-sonnet-4-6` (권장), `claude-opus-4-7`, `claude-haiku-4-5` — 전부 유료
- **openai**: `gpt-5.4-mini` (권장), `gpt-5.5`, `gpt-5.5-pro` (최고품질) — 전부 유료
- **gemini**: `gemini-3-flash-preview` (권장·무료), `gemini-3.1-pro-preview` (유료), `gemini-3.1-flash-lite-preview` (무료)

> 모델은 공식 문서 기준 최신 3종으로 유지. 새 버전 출시 시 이 배열만 갱신하면 UI에 자동 반영됨.

### `PROVIDER_META` (1620~1645줄)
각 제공자별 `label / placeholder / storageKey / modelKey / hint / keyValid` 정의. 새 제공자 추가 시 여기와 `PROVIDER_MODELS`만 손대면 됨.

### `PRES_OBS_ITEMS` / `COLLAB_OBS_ITEMS` (1494~1505줄)
발표·협업 체크리스트 항목 정의. `key`, `label`만 바꾸면 UI/저장키/요약 모두 자동 적용.

---

## 6. 실행 모드 (4가지)

`localStorage.app_mode` 값으로 분기 (`switchMode` @ 1465줄):

| 모드 | 값 | 동작 |
|------|-----|------|
| 관찰만 | `observation` | 학생 결과물 → 관찰 문장 3버전 |
| 채점만 | `grading` | 결과물 + 루브릭 → 채점표 + 총평 |
| 동시 | `both` | 관찰 + 채점 한 번에 |
| 프롬프트 복사 | `prompt-copy` | API 호출 없이 프롬프트 텍스트만 생성 → 사용자가 ChatGPT/Claude 웹에 붙여넣기 (무료) |

`prompt-copy` 모드는 추가로 `localStorage.app_promptCopySub`로 관찰/채점/동시 서브 선택.

---

## 7. 상태 관리

### localStorage 키 일람
| 키 | 용도 |
|----|------|
| `app_mode` | 실행 모드 |
| `app_promptCopySub` | 프롬프트 복사 서브 모드 |
| `app_provider` | 현재 AI 제공자 (anthropic/openai/gemini) |
| `anthro_key`, `openai_key`, `gemini_key` | 각 제공자 API 키 |
| `anthro_model`, `openai_model`, `gemini_model` | 각 제공자 선택 모델 |
| `app_activityTypes` | 활동 유형 체크박스 (JSON 배열) |
| `app_achieveLevel` | 성취 수준 |
| `app_presObs_<key>`, `app_collabObs_<key>` | 체크리스트 항목별 상/중/하 |
| `app_presMemo`, `app_collabMemo` | 체크리스트 메모 |
| 그 외 입력 필드는 `_saveField` (1851줄)로 자동 저장 |

### IndexedDB (`saenggibu_db` v2)
- `student_files` — 학생 파일 영속 저장 (새로고침해도 유지)
- `analysis_history` — 분석 이력

---

## 8. 주요 함수 인덱스 (index.html)

### 데이터/스토리지
- `_openDB`, `_saveFile`, `_loadAllFiles`, `_deleteFile` (1678~)
- `_saveHistory`, `_loadHistory`, `_deleteHistEntry`, `_clearHistAll` (1722~)

### 파일 파싱
- `parsePDF` (2242), `parsePDFFromBuf` (2251), `parseDOCX` (2258), `parsePPTX` (2267)
- `parsePDFImagesFromBuf` (2340) — 스캔 PDF → 이미지로 변환 (손글씨 대응)
- `parseImageFile` (2349), `parseFile` (2359) — 디스패처

### AI 호출
- `callClaude` (2419), `callGemini` (2464), `callOpenAI` (2506)
- `callAI` (2556) — 제공자별 디스패처 (모든 호출의 단일 진입점)
- `_readSSE` (2382) — SSE 스트리밍 파서
- `_waitWithRetry` (2403) — 429 재시도 백오프

### 프롬프트 빌더
- `buildStep1Prompt` (2575) — 결과물 텍스트 구조화 추출
- `buildStep2Prompt` (2614) — 관찰 문장 3버전 생성
- `buildGradingPrompt` (2672) — 채점 + 총평
- `buildPromptCopyText` (3572) — API 미사용 모드용 통합 프롬프트

### 채점 결과
- `parseGradingResult` (2821), `renderGradingCard` (2884)
- `extractAllowedScores` (2777), `snapScoreToAllowed` (2804) — 루브릭에서 허용 점수 후보 추출 후 가장 가까운 값으로 보정

### 메인 플로우
- `startAnalysis` (3057) — API 호출 모드의 메인
- `startPromptCopyMode` (3462) — 프롬프트 복사 모드 메인
- `analyzePastedResponse` (3705) — 사용자가 AI 응답을 붙여넣으면 파싱

### 결과 내보내기
- `downloadOne`, `exportAll` (관찰)
- `downloadGradingOne`, `exportGradingAll` (채점)
- `exportCombinedXLSX` (3006) — 관찰+채점 통합 엑셀

---

## 9. 반응형 브레이크포인트

- **900px 이하**: 2단 → 1단 레이아웃 (사이드바가 위로)
- **600px 이하**: 모바일 — 헤더 세로 스택, 카드 패딩 축소
- **400px 이하**: 초소형 화면 미세조정

CSS 미디어쿼리는 462줄(900px), 491줄(600px), 672줄(400px)부터.

---

## 10. 푸터 자동 갱신

```html
마지막 업데이트 <span id="lastUpdateDate">—</span> · v1.0 · 계속 다듬어 나가는 중입니다
```

`fetchLastUpdate` (4071줄)가 GitHub API로 최근 커밋 날짜를 자동 표시 (`YYYY.MM.DD.` 형식). **수동 갱신 불필요.**

---

## 11. 버전 관리 규칙 (Semantic Versioning)

`index.html` footer의 `v?.?.?` 표기는 **수정할 때마다 Claude가 변경 규모를 판단해 자동으로 올립니다.**

### 버전 변화 기준

| 종류 | 트리거 | 버전 변화 |
|------|--------|-----------|
| **Major** | 프롬프트 구조 전면 개편, 핵심 기능 교체, 기존 동작 방식 변경 | `1.x.x → 2.0.0` |
| **Minor** | 새 기능/항목/모드 추가 (기존 것은 유지) | `1.0.x → 1.1.0` |
| **Patch** | 오타·색상·문구·작은 버그·UI 미세조정 | `1.0.0 → 1.0.1` |

### 운영 방식

1. 코드 수정이 끝나면 변경 규모를 판단해 `index.html` 푸터의 버전 표기를 갱신
2. 커밋 메시지에 버전 표기 (예: `fix: 푸터 오타 수정 (v1.0.0 → v1.0.1)`)
3. 작업 보고 시 **"이번 변경은 ○○라 v?.?.? → v?.?.?로 올렸습니다"** 형식으로 알림

### 판단이 애매한 경우
임의로 결정하지 않고 먼저 사용자에게 질문.
> "이건 minor로 볼지, patch로 볼지 애매한데 어느 쪽으로 할까요?"

### 버전을 올리지 않는 경우 (사용자 향 변경 아님)
- `CLAUDE.md`, `README.md` 등 메타 문서
- 주석만 추가/수정
- 코드 포매팅(공백·들여쓰기)만 변경
- `.gitignore`, 설정 파일

### 현재 버전
- 표기: **`v2.0.6`** (2026-05 기준)
- 자세한 변경 이력은 §15 참조

---

## 12. 자주 발생하는 유지보수 작업 — 빠른 가이드

| 작업 | 손댈 곳 |
|------|---------|
| 새 AI 모델 추가 | `PROVIDER_MODELS` (1599) |
| 새 AI 제공자 추가 | `PROVIDER_MODELS` + `PROVIDER_META` + `callXxx` 함수 + `callAI` 디스패처 |
| 체크리스트 항목 변경 | `PRES_OBS_ITEMS` / `COLLAB_OBS_ITEMS` (1494~) |
| 토큰 한도/타임아웃 조정 | `CONFIG` (1443) |
| 프롬프트 문구 수정 | `buildStep1Prompt` / `buildStep2Prompt` / `buildGradingPrompt` |
| 푸터 문구 변경 | `<footer class="page-footer">` (HTML 하단부) |
| 색상 테마 | `header` 그라디언트 (27줄), `.page-footer` 색상 (686줄~) |
| 반응형 깨짐 | 462/491/672줄 미디어쿼리 |

---

## 13. 작업 시 주의사항 (gotchas)

- **단일 HTML 파일이라 Edit 시 컨텍스트가 길다** — 작은 수정도 정확한 `old_string`이 필요. 먼저 Grep/Read로 정확한 줄을 잡을 것.
- **CDN 라이브러리 버전 변경 신중하게** — pdf.js·mammoth는 API 호환성 깨질 수 있음.
- **Vercel Edge Function 본문 크기 한도 ≈ 4.5MB** — `PDF_MAX_BODY_BYTES`로 마진 두고 있음. 늘리지 말 것.
- **Gemini 무료 티어 쿼터 매우 작음** — Flash 권장이지만 학생 수 많으면 429 빈발.
- **API 키는 절대 서버에 저장하지 않음** — 브라우저 localStorage 전용. 코드 변경 시 이 원칙 유지.
- **푸터 날짜는 자동** — 절대 수동으로 날짜 텍스트 박지 말 것.
- **커밋 메시지 한국어 스타일** — `feat:`, `fix:`, `style:`, `refactor:`, `docs:` prefix + 한국어 설명. 마지막 줄에 `Co-Authored-By: Claude ... <noreply@anthropic.com>`.
- **destructive git (force push, reset --hard 등) 사용자 명시 요청 없으면 금지.**

---

## 14. 배포 흐름

1. 로컬에서 `index.html` 또는 `api/proxy.js` 수정
2. `git add` → `git commit` → `git push origin main`
3. Vercel이 GitHub webhook으로 자동 빌드·배포 (보통 30초~1분)
4. 배포 완료 후 푸터의 "마지막 업데이트" 날짜가 새 커밋 날짜로 자동 갱신됨

---

## 15. 작업 이력 (Changelog) — 향후 세션 인계용

> 이 섹션은 **다음 세션에서 작업을 이어받을 때 맥락을 빠르게 파악**할 수 있도록 정리한 것입니다.
> 새로운 작업이 끝날 때마다 항목을 추가해 주세요.

### v1.0 → v2.0.0 (메이저 — 레이아웃 전면 개편) `33d8130`
**변경 동기**: 좌측 350px 사이드바에 11개 카드가 세로로 줄지어 있어 작업 흐름이 직관적이지 않다는 사용자 피드백.

**핵심 변경**:
- 사이드바 제거 → **가로 컴팩트 툴바 2줄** (Row 1: 모드·AI, Row 2: 수업정보)
- 길거나 선택적인 콘텐츠 4종을 **모달로 분리**:
  1. **사용 방법 모달** (`guideModal`) — 첫 방문 시 자동 표시 (`app_guideShown` localStorage). 7단계 STEP + "왜 필요한가" + 추천 대상 + 알아두실 점 등 풍부한 사용자 가이드 포함.
  2. **체크리스트 모달** (`checklistModal`) — 발표/협업 두 탭. 입력 항목 수 배지 표시.
  3. **분석 이력 모달** (`historyModal`) — 헤더 버튼 → 모달.
  4. **API 키 관리 모달** (`apiKeyModal`) — 헤더 버튼이 키 상태에 따라 "🔑 키 없음" vs "🔑 ✓"로 동적 표시.
- 결과 카드는 **메인 영역 안에 그대로 펼침** (별도 영역 X).
- 헤더 버튼 5개: 📖 사용방법, 📚 이력, 🔑 키 관리, 🔄 초기화, 🔗 생기부 도우미 Ⅱ.

**호환성 보장**:
- 모든 `localStorage` 키와 IndexedDB 스토어 그대로 유지 (기존 사용자 데이터 보존).
- 모든 기존 JS 함수 시그니처 유지. `toggleAct`/`toggleLevel`은 호환 stub로 남김.
- `_updateLevelSummaryHint` 등 일부 함수는 no-op stub로 유지 (옛 콜 사이트 보호용).

**새 모달 인프라**:
- `openModal(id)` / `closeModal(id)` — ESC·배경클릭·스크롤 잠금 처리.
- 모달별 초기화 훅: `historyModal` 열 때 `loadAndRenderHistory`, `apiKeyModal` 열 때 키 상태 갱신.
- `closeGuideModal()` — "다음에 띄우지 않기" 체크박스 처리.
- `switchChecklistTab(tab)` — 모달 내 탭 전환.
- `_updateChecklistBadge()` — 헤더 배지 카운트.

**작업 방식**: 워크트리 격리된 에이전트로 진행 후 메인 클로드가 정적 검증·머지·배포.

---

### v2.0.1 — 체크리스트 버튼 재배치 `3abfb3f`
체크리스트는 발표·협업 활동과 직접 연관 → 헤더가 아닌 **툴바 Row 2의 활동 그룹 바로 뒤**로 이동. 헤더 간소화.

### v2.0.2 — 시각 구분 + 필수/선택 배지 `0a2c3e1`
- 활동 ↔ 체크리스트 사이에 **세로 구분선**(`.tb-divider`) + 체크리스트 버튼에 **호박색 톤**(`.tb-checklist-btn`)으로 시각 분리.
- 모든 툴바 항목에 **(필수)/(선택) 배지** 부착:
  - 필수(빨강 `.tb-req`): 모드, AI, 과목, 글자수
  - 선택(회색 `.tb-opt`): 활동, 체크리스트, 주제, 성취

### v2.0.3 → v2.0.4 — 푸터 블로그 링크 `deb08cd`, `1224c96`
- 푸터에 블로그 링크 추가 → 이름·URL 수정.
- **현재 상태**: "**교무실 옆 작업실**" → `https://jerry5026-dotcom.github.io/`

### v2.0.5 → v2.0.6 — OpenAI 모델 라인업 갱신 `6c5304e`, `f7ea520`
- **GPT-5.5 출시(2026.04.23)** 반영. 그러나 `5.5-mini`/`5.5-nano`는 아직 미출시 → mini는 5.4 유지.
- **최종 라인업** (`PROVIDER_MODELS.openai`):
  1. `gpt-5.4-mini` — 균형 · 권장 · 유료
  2. `gpt-5.5` — 최신 고품질 · 유료
  3. `gpt-5.5-pro` — 최고품질 · 유료
- 품질 부족 우려로 **`gpt-5.4-nano` 제거**, `gpt-5.5-pro`로 교체.

### Claude/Gemini 모델 상태 확인 (2026-05) — 변경 없음
- **Claude**: Opus 4.7 (2026.04.16) / Sonnet 4.6 (권장, 2026.02) / Haiku 4.5 — 모두 최신.
- **Gemini**: 3.1 Pro Preview / 3 Flash Preview (권장) / 3.1 Flash-Lite Preview — 모두 최신.
- ⚠️ 주의: Gemini 3 Flash가 GA로 승격될 가능성 있어, 어느 날 `-preview` 접미어를 떼야 할 수도 있음.

### CLAUDE.md 익명화 `de0aa6d`
사용자 표기에서 이름·학교명 제거. 코드 동작·웹앱 화면에는 영향 없음 (메타 문서 작업이라 버전 안 올림).

---

## 16. 향후 세션 빠른 시작 가이드

새 세션에서 작업을 이어받을 때 추천 절차:

1. **이 파일(`CLAUDE.md`) 통독** — 특히 §15 작업 이력
2. **`git log --oneline -20`** 으로 최근 커밋 확인
3. 사용자 요청 들으면:
   - **버전 영향 판단** (§11 규칙 따라 major/minor/patch 결정)
   - **단일 파일 Edit이 어려운 큰 작업**이면 worktree 격리 에이전트 사용 검토
4. **수정 후 정적 검증** (Grep으로 onclick·ID 매칭 확인) → 커밋 → push
5. 커밋 메시지 끝에 `Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>` trailer 필수
6. **destructive git 금지** (사용자 명시 요청 없으면 force push·reset --hard 절대 금지)

### 자주 묻는 위치 (line number 무관, 함수명/ID로 찾기)
| 찾을 것 | 방법 |
|---------|------|
| 모델 추가 | `Grep "PROVIDER_MODELS"` |
| 모달 인프라 | `Grep "function openModal"` |
| 푸터 | `Grep "page-footer"` |
| 첫 방문 자동 모달 | `Grep "app_guideShown"` |
| 메인 분석 플로우 | `Grep "function startAnalysis"` |
| 채점 결과 렌더 | `Grep "renderGradingCard"` |
| 통합 엑셀 내보내기 | `Grep "exportCombinedXLSX"` |

> v2.0 리팩터링 이후 `index.html`은 약 4400줄. §8 함수 인덱스의 라인 번호는 v1.0 기준이라 ~280줄씩 밀려 있을 수 있음. **함수명/ID로 Grep해서 정확한 위치를 잡는 게 더 안전합니다.**
