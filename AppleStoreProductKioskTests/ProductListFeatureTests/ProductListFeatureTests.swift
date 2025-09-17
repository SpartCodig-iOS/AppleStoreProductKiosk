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
    let store = TestStore(initialState: ProductListFeature.State()) {
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
      #expect($0.currentItems == expectedItems)
    }
  }
  
  @Test
  func onTapCategoryButton_호출시_현재상품들이업데이트된다() async {
    let store = TestStore(initialState: ProductListFeature.State()) {
        ProductListFeature()
    }
    
    store.exhaustivity = .off(showSkippedAssertions: false)
    
    await store.send(.async(.fetchProductData))
    
    await store.send(.view(.onTapCategory(id: ProductCategory.AirPods.id)))
    
    await store.receive(\.inner.updateSelectedCategoryId) {
      $0.currentSelectedCategoryId = ProductCategory.AirPods.id
      
      let expectedItems = ProductCategory.AirPods.products
      #expect($0.currentItems == expectedItems)
    }
  }
}
