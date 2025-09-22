# 🍎 Apple Store Product Kiosk

Apple Store 제품을 탐색하고 장바구니에 담을 수 있는 키오스크 앱입니다.
TCA(The Composable Architecture)와 Clean Architecture를 적용한 iOS 앱으로, 실제 Apple Store와 유사한 UI/UX를 제공합니다.

## 📱 주요 기능

### 🏪 제품 탐색
- **카테고리별 브라우징**: iPhone, MacBook, Apple Watch, AirPods, Vision 카테고리
- **반응형 그리드 레이아웃**: 기기별 최적화된 컬럼 수 (iPhone 2-3개, iPad 4-5개)
- **실시간 제품 정보**: 이름, 설명, 가격, 고해상도 이미지

### 🛒 장바구니 관리
- **제품 추가/제거**: 원터치로 장바구니 관리
- **수량 조절**: 직관적인 +/- 버튼으로 수량 변경
- **실시간 계산**: 개별 상품 소계 및 전체 합계 자동 계산
- **스마트 UI**: 장바구니가 비어있을 때 버튼 자동 숨김

### 🎨 사용자 경험
- **Apple 디자인 시스템**: SF Symbols, 시스템 폰트 사용
- **다크모드 지원**: 자동 다크모드 대응
- **애니메이션**: 부드러운 전환 효과 및 피드백
- **접근성**: VoiceOver 및 Dynamic Type 지원

## 🛠 기술 스택

### 🏗 아키텍처
- **TCA (The Composable Architecture)**: 단방향 데이터 플로우 및 상태 관리
- **Clean Architecture**: Domain, Data, Presentation 계층 분리
- **MVVM + Reducer 패턴**: SwiftUI와 TCA의 조합

### 📱 UI/UX
- **SwiftUI**: 선언적 UI 프레임워크
- **Composable Navigation**: TCA 기반 네비게이션
- **Adaptive Layout**: Size Class 기반 반응형 디자인

### 🌐 네트워킹
- **Custom Network Layer**: URLSession 기반 네트워크 레이어
- **Async/Await**: 모던 비동기 처리
- **Retry Strategy**: 지수 백오프 재시도 로직
- **Response Handler**: 통합 응답 처리

### 🔧 의존성 관리
- **[DiContainer](https://github.com/Roy-wonji/DiContainer)**: 커스텀 의존성 주입 컨테이너
- **Repository Pattern**: 데이터 소스 추상화
- **UseCase Pattern**: 비즈니스 로직 캡슐화

### 🧪 테스팅
- **XCTest**: 유닛 테스트 프레임워크
- **TCA TestStore**: TCA 전용 테스트 스토어
- **Swift Testing**: 모던 테스트 프레임워크 (@Test)

## 📁 프로젝트 구조

```
AppleStoreProductKiosk/
├── App/                          # 앱 레벨 설정
│   ├── Application/              # 앱 진입점 (AppDelegate, App)
│   ├── Di/                      # 의존성 주입 설정
│   │   ├── ModuleFactoryManager.swift
│   │   ├── Extension+AppDIContainer.swift
│   │   ├── Extension+RepositoryModuleFactory.swift
│   │   └── Extension+UseCaseModuleFactory.swift
│   ├── View/                    # 루트 뷰 (AppView)
│   └── Reducer/                 # 앱 리듀서 (AppReducer)
│
├── Features/                     # 기능별 모듈
│   ├── Main/                    # 메인 제품 화면
│   │   ├── Components/          # 재사용 컴포넌트
│   │   │   ├── CartButton/      # 장바구니 버튼 컴포넌트
│   │   │   ├── ProductCardView.swift
│   │   │   └── SegmentsView.swift
│   │   └── Feature/             # 비즈니스 로직
│   │       ├── ProductListFeature.swift
│   │       └── ProductListView.swift
│   │
│   └── ShoppingCart/            # 장바구니 화면
│       ├── CartView.swift       # 메인 장바구니 화면
│       └── Components/          # 장바구니 컴포넌트들
│           ├── CartHeaderView.swift
│           ├── CartItemRowView.swift
│           ├── CartSummaryView.swift
│           └── CartActionButtonsView.swift
│
├── Domain/                      # 도메인 계층
│   ├── Entities/               # 도메인 모델
│   │   └── Product.swift       # Product, Category, ProductCatalog
│   ├── Interface/              # 프로토콜 정의
│   │   ├── ProductRepositoryProtocol.swift
│   │   └── ProductInterface.swift
│   └── UseCase/                # 비즈니스 로직
│       ├── FetchProductsUseCase.swift
│       └── ProductUseCaseImpl.swift
│
├── Data/                       # 데이터 계층
│   ├── API/                    # API 정의
│   │   ├── APIEndpoint.swift   # API 엔드포인트 프로토콜
│   │   ├── APIDomain.swift     # API 도메인 설정
│   │   └── KioskProductAPI.swift # 키오스크 API 구현
│   ├── Model/                  # 데이터 모델
│   │   └── Product/            # 제품 관련 DTO
│   │       ├── AppleStoreResponseDTO.swift
│   │       └── Mapper+/        # DTO → Entity 매퍼
│   ├── Repositories/           # 저장소 구현
│   │   ├── ProductRepositoryImpl.swift
│   │   ├── ProductsRepository.swift
│   │   └── MockProductRepository.swift
│   └── Service/                # 네트워크 서비스
│       └── KioskProductService.swift
│
├── Network/                    # 네트워크 계층
│   └── Core/                   # 네트워크 코어 모듈
│       ├── Data/               # 데이터 확장
│       ├── Logger/             # 네트워크 로깅
│       ├── Provider/           # 네트워크 프로바이더
│       │   ├── AsyncProvider.swift
│       │   ├── NetworkConfig.swift
│       │   ├── ResponseHandler.swift
│       │   └── RetryStrategy.swift
│       ├── Method/             # HTTP 메서드
│       ├── TargetType/         # 타겟 타입 정의
│       ├── URLRequestBuilder/  # URL 요청 빌더
│       ├── header/             # API 헤더 관리
│       └── Errors/            # 네트워크 에러
│
└── Shared/                     # 공통 유틸리티
    ├── Double+.swift           # Double 확장
    └── FeatureAction.swift     # TCA 액션 프로토콜
```

## 👥 팀 구성 및 담당 영역

### 김민희 - 장바구니 UI 전담
**"사용자가 직관적으로 사용할 수 있는 장바구니 경험 구현"**

#### 🎯 담당 컴포넌트
- **`CartView.swift`** - 장바구니 메인 화면 레이아웃 및 구조
- **`CartHeaderView.swift`** - 장바구니 상단 헤더 (타이틀, 뒤로가기)
- **`CartItemRowView.swift`** - 개별 장바구니 아이템 행 (이미지, 정보, 수량 조절)
- **`CartSummaryView.swift`** - 장바구니 하단 요약 (총액, 할인 정보)
- **`CartActionButtonsView.swift`** - 액션 버튼들 (주문하기, 계속 쇼핑)

#### 🎨 주요 기능 구현
- **수량 조절 UI**: +/- 버튼으로 직관적인 수량 변경
- **동적 버튼 상태**: 수량이 1일 때 삭제 아이콘으로 변경
- **실시간 계산**: 개별 소계 및 전체 합계 실시간 업데이트
- **반응형 레이아웃**: 다양한 기기 크기에 대응하는 유연한 디자인

### 서원지 - 데이터 & 인프라 전담
**"확장 가능하고 안정적인 데이터 플로우 구축"**

#### 🏗 네트워크 아키텍처 설계
- **Network Core 모듈**: 재사용 가능한 네트워크 레이어
  - `AsyncProvider.swift` - 비동기 네트워크 프로바이더
  - `NetworkConfig.swift` - 환경별 네트워크 설정
  - `ResponseHandler.swift` - 통합 응답 처리
  - `RetryStrategy.swift` - 지수 백오프 재시도 로직
  - `URLRequestBuilder.swift` - 타입 안전한 URL 요청 빌더

#### 🔗 API 레이어 구현
- **API 추상화**: `APIEndpoint` 프로토콜 기반 API 정의
- **도메인 분리**: `APIDomain` 으로 환경별 도메인 관리
- **타입 안전성**: `KioskProductAPI` enum으로 컴파일 타임 검증

#### 💾 데이터 레이어 구축
- **Repository 패턴**: 데이터 소스 추상화 및 테스트 가능성 확보
- **DTO ↔ Entity 매핑**: 데이터 변환 로직 분리
- **Mock 데이터**: 개발 및 테스트를 위한 가짜 데이터 제공

#### 🧩 의존성 주입 시스템
- **[DiContainer](https://github.com/Roy-wonji/DiContainer)** 커스텀 DI 컨테이너 활용
- **모듈별 팩토리**: Repository, UseCase 팩토리 분리
- **환경별 설정**: 개발/테스트/프로덕션 환경 대응

#### 🎯 비즈니스 로직 구현
- **UseCase 패턴**: 순수한 비즈니스 로직 캡슐화
- **`FetchProductsUseCase`**: 제품 데이터 조회 로직
- **`ProductUseCaseImpl`**: 제품 관련 비즈니스 로직 구현

### 홍석현 - 메인 화면 & 앱 아키텍처
**"Apple스러운 사용자 경험과 탄탄한 앱 구조 구현"**

#### 🏠 메인 화면 구현
- **`ProductListView.swift`** - 제품 리스트 메인 화면
  - 적응형 그리드 레이아웃 (기기별 컬럼 수 자동 조절)
  - 카테고리 세그먼트 컨트롤
  - 제품 카드 그리드 표시
- **`ProductListFeature.swift`** - TCA 기반 비즈니스 로직
  - 상태 관리 및 사이드 이펙트 처리
  - 카테고리 전환 로직
  - 장바구니 상태 동기화

#### 🧩 재사용 컴포넌트 개발
- **`ProductCardView.swift`** - 제품 카드 컴포넌트
  - AsyncImage를 활용한 이미지 로딩
  - 제품 정보 표시 (이름, 가격, 설명)
  - 장바구니 추가 액션
- **`SegmentsView.swift`** - 카테고리 세그먼트 컨트롤
- **`CartButtonView.swift`** - 플로팅 장바구니 버튼

#### 🏗 앱 전체 아키텍처
- **`AppView.swift`** - 루트 뷰 구현 및 네비게이션
- **`AppReducer.swift`** - 앱 레벨 상태 관리
- **`AppleStoreProductKioskApp.swift`** - 앱 진입점 설정

#### 📊 도메인 모델 설계
- **`Product.swift`** - 제품 엔티티 정의
  - Product, Category, ProductCatalog 모델
  - Mock 데이터 제공 (15개 제품, 5개 카테고리)
  - 카테고리별 제품 분류

## 🏗 아키텍처 상세

### Clean Architecture + TCA
```
┌─────────────────────────────────────────────────────────┐
│                   Presentation Layer                     │
│  ┌─────────────────┐    ┌─────────────────────────────┐ │
│  │   SwiftUI Views │◄──►│     TCA Features/Reducers   │ │
│  │                 │    │                             │ │
│  └─────────────────┘    └─────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────┐
│                    Domain Layer                         │
│  ┌─────────────────┐    ┌─────────────────────────────┐ │
│  │    Entities     │    │           UseCases          │ │
│  │   (Product,     │    │  (FetchProductsUseCase)     │ │
│  │   Category)     │    │                             │ │
│  └─────────────────┘    └─────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────┐
│                     Data Layer                          │
│  ┌─────────────────┐    ┌─────────────────────────────┐ │
│  │  Repositories   │    │       Network/API           │ │
│  │ (ProductRepo)   │    │   (KioskProductService)     │ │
│  └─────────────────┘    └─────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

### TCA 데이터 플로우
```
┌──────────────┐    Action    ┌──────────────┐
│     View     │─────────────►│   Reducer    │
│              │              │              │
└──────────────┘              └──────────────┘
        ▲                            │
        │ State                      │ Effect
        │                            ▼
┌──────────────┐              ┌──────────────┐
│    Store     │◄─────────────│  Dependencies │
│              │    Result    │  (Repository, │
└──────────────┘              │   UseCase)   │
                              └──────────────┘
```

### 의존성 주입 흐름
```
App Startup
     │
     ▼
ModuleFactoryManager
     │
     ├─► RepositoryModuleFactory
     │   ├─► ProductRepository
     │   └─► MockProductRepository
     │
     └─► UseCaseModuleFactory
         ├─► FetchProductsUseCase
         └─► ProductUseCase
```

## 🌐 API 구조

### 엔드포인트 설계
```swift
// Base URL: https://applestoreproductkiosk.free.beeceptor.com
enum KioskAPI {
  enum Product: APIEndpoint {
    case list  // GET /api/kiosk/products
  }
}
```

### 데이터 플로우
```
Network Request → DTO → Mapper → Entity → State → View
     ▲                                           │
     └─────────────── User Action ◄──────────────┘
```

### Response 구조
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "store": {
      "id": "apple-store-kr",
      "region": "KR",
      "currency": "KRW",
      "updatedAt": "2025-09-16T10:00:00Z"
    },
    "categories": [
      {
        "category": "iPhone",
        "products": [
          {
            "id": "iphone-16",
            "name": "iPhone 16",
            "description": "갖고 싶던 iPhone. 이제 당신의 취향대로",
            "fromPrice": {
              "amount": 1150000,
              "currency": "KRW",
              "formatted": "₩1,150,000"
            },
            "images": {
              "main": "https://...",
              "thumbnails": ["https://..."]
            }
          }
        ]
      }
    ]
  }
}
```

## 🧪 테스트 전략

### 테스트 구조
```
AppleStoreProductKioskTests/
├── Domain/
│   └── ProductUseCaseImplTests.swift     # 비즈니스 로직 테스트
├── Data/
│   └── MockProductRepositoryTests.swift  # 데이터 레이어 테스트
├── Network/
│   └── KioskProductServiceLiveTests.swift # 네트워크 레이어 테스트
└── Feature/
    └── ProductListFeatureTests.swift     # TCA Feature 테스트
```

### TCA 테스트 예시
```swift
@Test
func onAppear_호출시_상품데이터를_가져오고_카테고리를_초기화한다() async {
    let store = TestStore(
        initialState: ProductListFeature.State(selectedProducts: shared)
    ) {
        ProductListFeature()
    }

    await store.send(.view(.onAppear))
    await store.receive(\.async.fetchProductData)
    await store.receive(\.inner.updateProductCategories) {
        $0.productCategories = IdentifiedArray(uniqueElements: Category.allCategories)
    }
}
```

### 테스트 커버리지
- **Domain Layer**: 비즈니스 로직 단위 테스트
- **Data Layer**: Repository 및 Service 테스트
- **Presentation Layer**: TCA Feature 통합 테스트
- **Network Layer**: API 호출 및 응답 처리 테스트

## 🚀 빌드 및 실행

### 개발 환경 요구사항
- **Xcode**: 15.0+ (Swift 5.9+)
- **iOS**: 17.0+
- **macOS**: 14.0+ (Xcode 실행용)

### 프로젝트 설정
```bash
# 1. 저장소 클론
git clone [repository-url]
cd AppleStoreProductKiosk

# 2. Xcode에서 프로젝트 열기
open AppleStoreProductKiosk.xcodeproj

# 3. 의존성 자동 해결 (Swift Package Manager)
# Xcode에서 자동으로 패키지 다운로드 수행

# 4. 빌드 및 실행
⌘ + R
```

### 시뮬레이터 권장 설정
- **iPhone 15 Pro**: 메인 테스트 기기
- **iPad Pro 12.9"**: 태블릿 레이아웃 테스트
- **iPhone SE (3rd gen)**: 소형 화면 대응 테스트

## 🧪 테스트 실행

### 전체 테스트 실행
```bash
# Xcode 내에서
⌘ + U

# 터미널에서
xcodebuild test \
  -scheme AppleStoreProductKiosk \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -testPlan AppleStoreProductKiosk.xctestplan
```

### 특정 테스트 실행
```bash
# TCA Feature 테스트만 실행
xcodebuild test \
  -scheme AppleStoreProductKiosk \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -only-testing:AppleStoreProductKioskTests/ProductListFeatureTests
```

## 📦 주요 의존성

### 외부 라이브러리
- **[The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture)** `1.15.0`
  - 단방향 데이터 플로우 아키텍처
  - 상태 관리 및 사이드 이펙트 처리
  - 테스트 가능한 앱 구조

- **[DiContainer](https://github.com/Roy-wonji/DiContainer)** `1.0.0`
  - 경량 의존성 주입 컨테이너
  - 모듈별 의존성 관리
  - 런타임 의존성 해결

### 시스템 프레임워크
- **SwiftUI**: 선언적 UI 프레임워크
- **Combine**: 리액티브 프로그래밍 (TCA 내부적 사용)
- **Foundation**: 기본 시스템 기능
- **XCTest**: 유닛 테스트 프레임워크

## 🔧 개발 도구 및 워크플로우

### 개발 워크플로우
1. **Feature 브랜치**: `feature/기능명` 패턴
2. **Pull Request**: 코드 리뷰 필수
3. **테스트**: 모든 테스트 통과 필수
4. **린트**: SwiftLint 규칙 준수

### 코드 스타일
- **Swift API Design Guidelines** 준수
- **TCA Best Practices** 적용
- **Clean Code 원칙** 적용

### 디버깅 도구
- **TCA Reducer 로그**: `._printChanges()` 활용
- **Network 로그**: `URLSessionLogger` 활용
- **Xcode Instruments**: 성능 프로파일링

---

**프로젝트 정보**
- **개발 기간**: 2025년 9월 16일 - 9월 22일 (1주일)
- **개발 환경**: Xcode 15, iOS 17+, Swift 5.9
- **팀 구성**: iOS 개발자 3명 (UI 전담, 인프라 전담, 아키텍처 전담)
- **아키텍처**: Clean Architecture + TCA
- **상태**: 프로토타입 완성 ✅