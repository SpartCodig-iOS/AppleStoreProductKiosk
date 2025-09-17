//
//  CartView.swift
//  AppleStoreProductKiosk
//
//  Created by 김민희 on 9/16/25.
//

import SwiftUI

struct CartView: View {
  @State var item = CartItem()
  var body: some View {
    VStack(spacing: 0) {
      CartHeaderView()

      Divider()

      ScrollView {
        VStack(spacing: 15) {
          CartItemRowView(item: $item)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
      }
      .scrollIndicators(.hidden)

      Divider()

      CartSummaryView(item: $item)
        .padding(.vertical, 20)

      CartActionButtonsView()
    }
  }
}

#Preview {
  CartView()
}
