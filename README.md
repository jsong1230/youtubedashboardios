# 📱 YouTube Channel Real-Time Dashboard

YouTube 채널 통계를 실시간으로 보여주는 iOS SwiftUI 앱입니다.

**Repository**: [https://github.com/jsong1230/youtubedashboardios](https://github.com/jsong1230/youtubedashboardios)

## 🏗️ 프로젝트 구조

```
Sources/
├── Models/
│   └── YouTubeStats.swift          # API 응답 모델
├── ViewModels/
│   └── YouTubeViewModel.swift      # MVVM ViewModel
├── Views/
│   ├── ContentView.swift           # 메인 뷰
│   └── Components/
│       └── StatCard.swift          # 통계 카드 UI 컴포넌트
└── App.swift                        # 앱 진입점
```

## 🚀 실행 방법

### 1. API 키 및 채널 ID 설정

1. **YouTube Data API v3 키 발급**
   - [Google Cloud Console](https://console.cloud.google.com/)에 접속
   - 프로젝트 생성 또는 기존 프로젝트 선택
   - "API 및 서비스" > "라이브러리"에서 "YouTube Data API v3" 활성화
   - "사용자 인증 정보"에서 API 키 생성

2. **채널 ID 확인**
   - YouTube 채널 페이지 접속
   - 채널 설정 > 고급 설정에서 채널 ID 확인
   - 또는 채널 URL에서 확인 (예: `youtube.com/channel/UC...`)

3. **환경 변수 파일 설정**
   - `YouTubeDashboard/YouTubeDashboard/` 폴더로 이동합니다
   - `.env.example` 파일을 복사하여 `.env` 파일을 만듭니다:
   
   ```bash
   cd YouTubeDashboard/YouTubeDashboard
   cp .env.example .env
   ```
   
   - `.env` 파일을 열어서 실제 값으로 교체합니다:
   
   ```
   YOUTUBE_API_KEY=여기에_API_키_입력
   YOUTUBE_CHANNEL_ID=여기에_채널_ID_입력
   ```
   
   - **중요**: `.env` 파일은 Git에 커밋되지 않습니다 (보안상의 이유)
   
4. **Xcode 프로젝트에 .env 파일 추가**
   - Xcode에서 프로젝트 네비게이터 열기
   - `YouTubeDashboard` 폴더 우클릭 → "Add Files to 'YouTubeDashboard'..."
   - `.env` 파일 선택
   - 옵션 확인:
     - "Copy items if needed" 체크 해제
     - "Add to targets: YouTubeDashboard" 체크
     - "Create folder references" 선택하지 않음
   - "Add" 클릭
   
   - 프로젝트 설정에서 확인:
     - TARGETS > YouTubeDashboard > Build Phases > Copy Bundle Resources
     - `.env` 파일이 포함되어 있는지 확인

### 2. .env 파일 생성 및 설정

1. **터미널에서 .env 파일 생성**
   ```bash
   cd YouTubeDashboard/YouTubeDashboard
   cp .env.example .env
   ```

2. **.env 파일 편집**
   - 텍스트 에디터로 `.env` 파일을 엽니다
   - 실제 API 키와 채널 ID로 교체합니다:
   ```
   YOUTUBE_API_KEY=실제_API_키
   YOUTUBE_CHANNEL_ID=실제_채널_ID
   ```

3. **Xcode 프로젝트에 .env 파일 추가**
   - Xcode에서 프로젝트 네비게이터 열기
   - `YouTubeDashboard` 폴더 우클릭 → "Add Files to 'YouTubeDashboard'..."
   - `.env` 파일 선택
   - 옵션 확인:
     - "Copy items if needed" 체크 해제 (이미 올바른 위치에 있음)
     - "Add to targets: YouTubeDashboard" 체크
   - "Add" 클릭
   
   - 프로젝트 설정에서 확인:
     - TARGETS > YouTubeDashboard > Build Phases > Copy Bundle Resources
     - `.env` 파일이 포함되어 있는지 확인

### 3. Xcode에서 실행

1. **Xcode 프로젝트 열기**
   - Xcode를 실행합니다
   - "Create a new Xcode project" 선택
   - "iOS" > "App" 템플릿 선택
   - 프로젝트 이름: `YouTubeDashboard`
   - Interface: SwiftUI
   - Language: Swift
   - Use Core Data: 체크 해제

2. **파일 추가**
   - 생성된 `Sources/` 폴더의 모든 파일을 Xcode 프로젝트에 드래그 앤 드롭
   - "Copy items if needed" 체크
   - "Create groups" 선택
   - Target에 추가 확인

3. **기존 App 파일 교체**
   - Xcode가 자동 생성한 `App.swift` 또는 `YouTubeDashboardApp.swift` 파일을 삭제
   - `Sources/App.swift` 파일이 프로젝트에 포함되어 있는지 확인

4. **빌드 및 실행**
   - Deployment Target이 iOS 16.0 이상인지 확인
   - 시뮬레이터 또는 실제 기기 선택
   - ⌘ + R (또는 Run 버튼)으로 빌드 및 실행

## ✨ 주요 기능

- ✅ 실시간 YouTube 채널 통계 조회
  - 구독자 수 (Subscribers)
  - 총 조회수 (Views)
  - 비디오 수 (Videos)
- ✅ 자동 새로고침 (앱 실행 시)
- ✅ 수동 새로고침 버튼
- ✅ 로딩 상태 표시
- ✅ 에러 메시지 표시
- ✅ 마지막 업데이트 시간 표시
- ✅ 깔끔한 카드 기반 UI

## 📋 요구사항

- iOS 16.0+
- Xcode 14.0+
- Swift 5.7+
- YouTube Data API v3 키

## 🛠️ 기술 스택

- **언어**: Swift
- **프레임워크**: SwiftUI
- **아키텍처**: MVVM
- **네트워킹**: URLSession
- **API**: YouTube Data API v3

## 📝 참고사항

- API 키는 안전하게 관리하세요. 실제 배포 시에는 환경 변수나 설정 파일로 관리하는 것을 권장합니다.
- API 할당량에 주의하세요. YouTube Data API는 일일 할당량이 있습니다.
- 네트워크 연결이 필요합니다.

## 📅 TODO 히스토리

### 2025-11-25
- ✅ 프로젝트 폴더 구조 생성 (Sources/Models, Sources/ViewModels, Sources/Views/Components)
- ✅ YouTubeStats.swift 모델 파일 생성
- ✅ YouTubeViewModel.swift ViewModel 파일 생성
- ✅ StatCard.swift UI 컴포넌트 생성
- ✅ ContentView.swift 메인 뷰 생성
- ✅ App.swift 앱 진입점 파일 생성
- ✅ .cursorrules 파일 생성 및 규칙 추가
- ✅ README.md TODO 히스토리 섹션 추가
- ✅ Git 저장소 초기화 및 초기 커밋 완료 (커밋: 66f1070)
- ✅ GitHub 원격 저장소 생성 및 푸시 완료 (https://github.com/jsong1230/youtubedashboardios)
- ✅ Xcode 프로젝트 생성 및 파일 통합
- ✅ App.swift 구조체 이름 충돌 해결 (App → YouTubeDashboardApp)
- ✅ YouTubeViewModel.swift에 import Combine 추가
- ✅ API 키 및 채널 ID 설정 완료
- ✅ 앱 빌드 및 실행 성공, 통계 데이터 정상 표시 확인
- ✅ AICryptoFunk 채널 아이콘을 앱 아이콘으로 설정
- ✅ 실제 iPhone 기기에 앱 설치 완료
- ✅ 채널 기본 정보 기능 추가 (채널 제목, 설명, 썸네일, 생성일, 국가 정보)
- ✅ 최근 비디오 목록 기능 추가 (비디오 카드, 통계 정보)
- ✅ 통계 상세 정보 및 시각화 기능 추가 (차트, 통계 요약 카드)
- ✅ 비디오 상세 보기 기능 추가 (NavigationLink, YouTube 앱 연동)
- ✅ API 에러 처리 개선 (할당량 초과 등 명확한 에러 메시지)
- ✅ Git 커밋 및 푸시 완료 (커밋: 6f9c0b7)
- ✅ API 키 및 채널 ID를 .env 파일로 분리 (.gitignore에 추가)
- ✅ EnvLoader 유틸리티 클래스 생성

