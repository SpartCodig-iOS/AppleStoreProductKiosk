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

struct ProductListFeatureTests {
  @Test
  func onAppear_호출시_상품데이터를_가져오고_카테고리를_초기화한다() async {
    let store = await TestStore(initialState: ProductListFeature.State()) {
        ProductListFeature()
    }
    
    await store.send(.view(.onAppear))
    
    await store.receive(\.async.fetchProductData)
    await store.receive(\.inner.updateProductCategories) {
      $0.productCategories = IdentifiedArray(uniqueElements: ProductCategory.allCategories)
    }
    await store.receive(\.inner.updateSelectedCategoryId) {
      $0.currentSelectedCategoryId = ProductCategory.allCategories.first!.id
    }
  }
}
