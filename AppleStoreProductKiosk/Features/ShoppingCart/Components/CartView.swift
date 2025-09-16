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
        CartItemRowView(item: $item)
          .padding(.horizontal, 20)
          .padding(.vertical, 10)
      }

      Divider()
    }
  }
}

#Preview {
  CartView()
}
