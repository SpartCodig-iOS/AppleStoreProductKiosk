//
//  ProductListFeatureTests.swift
//  AppleStoreProductKioskTests
//
//  Created by 홍석현 on 9/17/25.
//

import Foundation
import ComposableArchitecture
import Testing

@testable import AppleStoreProductKiosk

@MainActor
struct ProductListFeatureTests {
  @Test
  func onAppear_호출시_상품데이터를_가져오고_카테고리를_초기화한다() async {
    let initialSelected = Shared<[Product]>(value: [])
    let store = TestStore(
      initialState: ProductListFeature.State(
        selectedProduct: initialSelected
      )
    ) {
      ProductListFeature()
    }
    
    await store.send(.view(.onAppear))
    
    await store.receive(\.async.fetchProductData)
    await store.receive(\.inner.updateProductCategories) {
      $0.productCategories = IdentifiedArray(uniqueElements: ProductCategory.allCategories)
    }
    await store.receive(\.inner.updateSelectedCategoryId) {
      $0.currentSelectedCategoryId = ProductCategory.allCategories.first!.id
      // 계산 프로퍼티 결과 검증
      let expectedItems = ProductCategory.allCategories.first!.products
      #expect($0.currentItems == IdentifiedArray(uniqueElements: expectedItems))
    }
  }
  
  @Test
  func onTapCategoryButton_호출시_현재상품들이업데이트된다() async {
    let initialSelected = Shared<[Product]>(value: [])
    let store = TestStore(
      initialState: ProductListFeature.State(
        selectedProduct: initialSelected
      )
    ) {
      ProductListFeature()
    }
    
    store.exhaustivity = .off(showSkippedAssertions: false)
    
    await store.send(.async(.fetchProductData))
    
    await store.send(.view(.onTapCategory(id: ProductCategory.AirPods.id)))
    
    await store.receive(\.inner.updateSelectedCategoryId) {
      $0.currentSelectedCategoryId = ProductCategory.AirPods.id
      
      let expectedItems = ProductCategory.AirPods.products
      #expect($0.currentItems == IdentifiedArray(uniqueElements: expectedItems))
    }
  }
  
  @Test
  func onTapAddItem_호출시_selectedProduct에_아이템이_추가된다() async {
    let initialSelected = Shared<[Product]>(value: [])
    let store = TestStore(
      initialState: ProductListFeature.State(
        selectedProduct: initialSelected
      )
    ) {
      ProductListFeature()
    }
    
    store.exhaustivity = .off(showSkippedAssertions: false)
    
    // 2) 데이터 로드 및 초기 카테고리 선택까지 진행
    await store.send(.view(.onAppear))
    
    // 3) 현재 카테고리의 첫 상품 선택
    let firstItemId = ProductCategory.allCategories.first!.products.first!.id
    
    // 4) 아이템 추가 액션 전송 → selectedProduct가 업데이트되는지 검증
    await store.send(.view(.onTapAddItem(id: firstItemId))) {
      // 상태 스냅샷 기반 검증
      let expected = [ProductCategory.allCategories.first!.products.first!]
      $0.$selectedProduct.withLock { $0 = expected }
    }
  }
  
  @Test
  func onTapAddItem_두번호출시_selectedProduct가_누적된다() async {
    let initialSelected = Shared<[Product]>(value: [])
    let store = TestStore(
      initialState: ProductListFeature.State(
        selectedProduct: initialSelected
      )
    ) {
      ProductListFeature()
    }
    
    store.exhaustivity = .off(showSkippedAssertions: false)
    
    await store.send(.view(.onAppear))
    
    let firstCategory = ProductCategory.allCategories.first!
    
    let p1 = firstCategory.products[0]
    let p2 = firstCategory.products[1]
    
    await store.send(.view(.onTapAddItem(id: p1.id))) {
      $0.$selectedProduct.withLock { $0 = [p1] }
    }
    await store.send(.view(.onTapAddItem(id: p2.id))) {
      $0.$selectedProduct.withLock { $0 = [p1, p2] }
    }
  }
}
