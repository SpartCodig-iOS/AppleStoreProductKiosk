//
//  ProductListView.swift
//  AppleStoreProductKiosk
//
//  Created by 홍석현 on 9/17/25.
//

import SwiftUI
import ComposableArchitecture

public struct ProductListView: View {
  let store: StoreOf<ProductListFeature>
  
  public var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

#Preview {
  let initialSelected = Shared<[Product]>(value: [])
  return ProductListView(store: Store(initialState: ProductListFeature.State(selectedProducts: initialSelected)) {
    ProductListFeature()
  })
}
