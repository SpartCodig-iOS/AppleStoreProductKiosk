//
//  ProductListView.swift
//  AppleStoreProductKiosk
//
//  Created by 홍석현 on 9/17/25.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: ProductListFeature.self)
public struct ProductListView: View {
  @Perception.Bindable public var store: StoreOf<ProductListFeature>
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.verticalSizeClass) var verticalSizeClass
  
  private var adaptiveColumnCount: Int {
    switch (horizontalSizeClass, verticalSizeClass) {
    case (.compact, .regular):     // iPhone 세로
      return 2
    case (.compact, .compact):     // iPhone 가로
      return 3
    case (.regular, .regular):     // iPad 세로
      return 4
    case (.regular, .compact):     // iPad 가로
      return 5
    default:
      return 2
    }
  }
  
  public var body: some View {
    WithPerceptionTracking {
      VStack {
        Text("Apple Store")
          .font(.largeTitle)
          .fontWeight(.bold)
        Text("원하는 제품을 선택하고 주문하세요.")
          .font(.subheadline)
          .foregroundStyle(Color.secondary)
        
        SegmentsView(
          items: store.productCategories
            .map {
              SegmentData(
                id: $0.id,
                title: $0.name,
                icon: $0.name
              )
            },
          selectedID: $store.currentSelectedCategoryId
        )
        
        ScrollView {
          LazyVGrid(
            columns: Array(
              repeating: GridItem(.flexible(), spacing: 16),
              count: adaptiveColumnCount
            ),
            spacing: 16
          ) {
            ForEach(store.currentItems) { product in
              ProductCardView(product: product)
            }
          }
          .padding(8)
          
          Spacer()
        }
        .scrollIndicators(.hidden)
      }
      .onAppear {
        send(.onAppear)
      }
    }
  }
}

#Preview {
  let initialSelected = Shared<[Product]>(value: [])
  return ProductListView(store: Store(initialState: ProductListFeature.State(selectedProducts: initialSelected)) {
    ProductListFeature()
  })
}
