//
//  ProductListFeatureTest.swift
//  AppleStoreProductKioskTests
//
//  Created by Codex CLI on 9/17/25.
//

import Testing
import ComposableArchitecture
@testable import AppleStoreProductKiosk

@Suite("ProductListFeatureTest", .tags(.feature, .productList))
@MainActor
struct ProductListFeatureTest {

  @Test("onAppear 시 카탈로그 로드 및 상태 업데이트", .tags(.load))
  func loadCatalog_onAppear_updatesState() async throws {
    let expectedCatalog = try await MockProductRepository().fetchProductCatalog()

    let store = TestStore(initialState: ProductListFeature.State()) {
      ProductListFeature()
    } withDependencies: {
      $0.productUseCase = ProductUseCaseImpl.testValue
      $0.mainQueue = .immediate
    }

    await store.send(.view(.onAppear))
    await store.receive(\.async.fetchProductCatalog)
    await store.receive(\.inner.fetchProductCatalogResponse) {
      $0.productCatalogModel = expectedCatalog
    }
  }

  @Test("카탈로그 로드 실패 시 상태는 변경되지 않는다", .tags(.error))
  func loadCatalog_failure_keepsStateNil() async throws {
    struct ThrowingUseCase: ProductInterface {
      func fetchProductCatalog() async throws -> ProductCatalog { throw DataError.customError("boom") }
      func fetchProducts(for category: String) async throws -> [Product] { [] }
    }

    let store = TestStore(initialState: ProductListFeature.State()) {
      ProductListFeature()
    } withDependencies: {
      $0.productUseCase = ThrowingUseCase()
      $0.mainQueue = .immediate
    }

    await store.send(.view(.onAppear))
    await store.receive(\.async.fetchProductCatalog)
    await store.receive(\.inner.fetchProductCatalogResponse)

    #expect(store.state.productCatalogModel == nil)
  }

  @Test("상품 추가 탭은 현재 상태를 변경하지 않는다", .tags(.action))
  func onTapAddProduct_noStateChange() async throws {
    let initial = ProductListFeature.State()
    let store = TestStore(initialState: initial) {
      ProductListFeature()
    } withDependencies: {
      $0.productUseCase = ProductUseCaseImpl.testValue
    }

    await store.send(.view(.onTapAddProduct(id: "some-id")))
    #expect(store.state == initial)
  }

  @Test("카테고리 선택 시 상품 목록 로드", .tags(.load))
  func selectCategory_loadsProducts() async throws {
    let repo = MockProductRepository()
    let expected = try await repo.fetchProducts(for: "iPhone")

    let store = TestStore(initialState: ProductListFeature.State()) {
      ProductListFeature()
    } withDependencies: {
      $0.productUseCase = ProductUseCaseImpl.testValue
    }

    let category = "iPhone"
    await store.send(.view(.onSelectCategory(category)))
    await store.receive(\.async.fetchProducts)
    await store.receive(\.inner.fetchProductsResponse) { state in
      state.productCatalogModel = ProductCatalog(categories: [
        Category(name: category, products: expected)
      ])
    }
  }
}
