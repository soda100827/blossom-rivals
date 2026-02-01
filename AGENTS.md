# AGENTS.md — Roblox (Luau) Non‑Negotiable Style Rules

> 이 문서는 **절대 규칙**이다.
> 개인 취향, 파일 크기, 담당자, 기능 범위, 모듈 분리 여부와 무관하게 **항상 동일하게 적용**한다.
> 스타일은 토론 대상이 아니다.

---

## 0) Mandatory Baseline (절대 전제)
- 모든 Luau 파일은 **반드시 첫 줄이 `--!strict`** 여야 한다.
- 모든 파일은 **아래의 File Template 순서를 1바이트도 어기지 않는다**.
- 섹션에 코드가 없어도 **헤더 주석은 삭제 금지**.
- 프로젝트 구조가 변경되어도 **룰은 변경되지 않는다**.

---

## 1) File Template — Fixed Order (누락 불가)
모든 파일은 아래 순서를 **그대로** 유지한다.

1. `--!strict`
2. `-- Services`
3. `-- Dependencies (require)`
4. `-- Constants`
5. `-- Types`
6. `-- Private state`
7. `-- Private helpers`
8. `-- Public API`
9. `return <Module>`

단, 주석은 쓰지 말것
섹션 위치 이동, 병합, 생략 **전부 금지**.

---

## 2) Naming Rules — 기계적으로 지켜야 함

### 2.1 Case 규칙
- **PascalCase**
  - 모듈 파일
  - class‑like table
  - exported type
  - 시스템 / 서비스 / 컨트롤러
  - 예: `CombatService`, `PlayerState`, `FastSignal`

- **camelCase**
  - 함수
  - 메서드
  - 지역 변수
  - 예: `getTarget`, `updateState`

- **UPPER_SNAKE_CASE**
  - 모든 상수
  - 예: `MAX_DISTANCE`, `DEFAULT_FOV`

### 2.2 Boolean 규칙 (강제)
Boolean 이름은 반드시 아래 접두사 중 하나로 시작한다.
- `is` → 상태
- `has` → 보유 여부
- `can` → 가능 여부
- `should` → 의도 / 정책

예:
- `isAlive`
- `hasTarget`
- `canFire`
- `shouldRender`

### 2.3 Private 규칙
- **모든 private 필드 / 함수는 `_`로 시작**
- 외부에서 접근될 가능성이 있으면 private 아님

예:
- `_maid`
- `_state`
- `_signals`
- `_connect()`

---

## 3) Formatting — 사람이 만지지 않은 것처럼
- 들여쓰기: **2 spaces 고정**
- 연산자/쉼표 뒤 공백 필수
  - `a + b`
  - `f(x, y)`
- 문자열 기본값은 `""`
- 테이블 trailing comma 허용 (파일 전체에서 일관성 유지)
- 라인이 길어지면 **의미 단위로 줄바꿈**

---

## 4) Services & require — 상단 고정 규칙

### 4.1 Services
- 반드시 아래 형태만 허용
```lua
game:GetService("ServiceName")
```
- Services 섹션 외 사용 금지

### 4.2 require
- Dependencies 섹션에서만 허용
- 프로젝트 루트 기준 합의된 경로만 사용
- 즉석 상대 경로, 동적 require 금지

---

## 5) Types — Public API는 항상 타입 명시
- 외부 노출 타입은 반드시 `export type`
- Public 함수는 **모든 파라미터 + 반환 타입 명시**
- `any` 사용 금지
  - 불가피한 경우 **이유를 한국어로 한 줄 주석**

---

## 6) Events — 무조건 Maid 사용

### 6.1 절대 규칙
- 모든 `:Connect()` 는 **즉시 Maid에 등록**
- 예외 없음 (한 번만 쓰는 이벤트도 포함)

허용 패턴 (프로젝트 고정):
```lua
_maid:GiveTask(connection)
```

### 6.2 구조 규칙
- 이벤트 연결은 **오직 `_connect()` 함수 안에서만**
- `Init / Start` 에서는 `_connect()` 만 호출
- 로직 + 연결 혼합 금지

---

## 7) Signals — FastSignal 강제

### 7.1 기본 규칙
- 커스텀 이벤트는 **무조건 FastSignal 사용**
- `BindableEvent` 사용 금지
- 직접 Signal 구현 금지

### 7.2 저장 규칙 (강제)
- 모든 시그널은 `_signals` 테이블에 저장
```lua
_signals.TargetChanged = FastSignal.new()
```

### 7.3 노출 방식 (프로젝트 단일 선택)
- **Getter 방식만 허용**
```lua
function Module.GetTargetChanged()
	return _signals.TargetChanged
end
```

다른 방식 혼용 금지.

---

## 8) State & Resource Management

### 8.1 필수 private 필드
모든 모듈은 아래 필드를 **항상 동일한 이름으로 사용**
- `_maid`
- `_state`
- `_signals`

### 8.2 Cleanup 규칙
- 라이프사이클 종료 함수는 **`Destroy()` 하나만 사용**
- `Destroy()` 내부에서 반드시
```lua
_maid:DoCleaning()
```

---

## 9) Control Flow — Guard First
- 조건 실패는 즉시 return
- 3단 이상 중첩되면 helper로 분리
- else 남발 금지

---

## 10) Comments — 원칙은 주석 없음
- 기본 원칙: **주석은 작성하지 않는다**
- 코드만으로 의도가 드러나야 한다
- 설명이 필요한 구조는 잘못된 구조로 간주한다

### 허용되는 경우 (극소수)
- 언어/환경 제약으로 코드만으로 의도가 절대 드러나지 않는 경우
- 외부 시스템/엔진 제약으로 우회 로직이 필요한 경우

이 경우에도:
- 주석은 **한국어만 허용**
- 한 줄로 끝낼 것
- "왜"만 설명 ("무엇" 설명 금지)

### TODO 규칙
- **TODO 주석 전면 금지**
- 미완성, 임시 로직, 추후 작업은 코드에 존재하면 안 된다

---

## 11) Project Structure — 이 코드베이스 기준

```
src/
  core/
  ui/
  features/
    <feature>/
      Init.luau
      Constants.luau
      Types.luau
      State.luau
      Systems/
      Mods/
      Utils/
  shared/
    *.luau
    types/
```

- `Constants.luau` → 상수만
- `Types.luau` → 타입만
- `State.luau` → 상태 구조만
- `Init.luau` → 진입점만

역할 섞기 금지.

---

## 12) Standard Module Skeleton (복붙 기준)

```lua
--!strict

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Dependencies (require)
-- local Maid = require(...)
-- local FastSignal = require(...)

-- Constants
local DEFAULT_COOLDOWN = 1

-- Types
export type Example = {
	id: string,
}

-- Private state
local Module = {}
Module.__index = Module

local _maid = nil :: any
local _state = {}
local _signals = {}

-- Private helpers
local function _initSignals()
	-- 필요한 경우만 한국어 주석
end

local function _connect()
	-- 모든 이벤트는 Maid 등록
end

-- Public API
function Module.Init()
	_initSignals()
	_connect()
end

function Module.Destroy()
	_maid:DoCleaning()
end

return Module
```

이 스켈레톤에서 **섹션/네이밍/패턴 변경 금지**.

