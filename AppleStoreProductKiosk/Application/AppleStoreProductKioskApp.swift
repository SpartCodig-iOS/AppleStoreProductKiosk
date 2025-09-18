//
//  AppleStoreProductKioskApp.swift
//  AppleStoreProductKiosk
//
//  Created by 홍석현 on 9/16/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct AppleStoreProductKioskApp: App {
  var body: some Scene {
    WindowGroup {
      let selectedProducts = Shared<[Product]>(value: [])
      
      // Store 생성 후 View 주입
      let store = Store(
        initialState: ProductListFeature.State(selectedProducts: selectedProducts)
      ) {
        ProductListFeature()
      }
      ProductListView(store: store)
    }
  }
}
