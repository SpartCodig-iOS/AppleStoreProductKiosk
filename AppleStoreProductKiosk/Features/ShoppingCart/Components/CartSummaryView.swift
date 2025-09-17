//
//  CartSummaryView.swift
//  AppleStoreProductKiosk
//
//  Created by 김민희 on 9/17/25.
//

import SwiftUI

struct CartSummaryView: View {
  @Binding var item: CartItem
  
  var body: some View {
    HStack(spacing: 0) {
      VStack(alignment: .leading, spacing: 10) {
        Text("상품 개수")
          .font(.system(size: 14, weight: .regular))
          .foregroundStyle(.black.opacity(0.7))
        Text("총 결제금액")
          .font(.system(size: 18, weight: .semibold))
      }

      Spacer()

      VStack(alignment: .trailing, spacing: 10) {
        Text("\(item.quantity)개")
          .font(.system(size: 14, weight: .semibold))
        Text("₩\(item.price * item.quantity)")
          .font(.system(size: 20, weight: .bold))
          .foregroundStyle(.blue)
      }

    }
    .padding(.horizontal, 20)
  }
}

#Preview {
  @State var item = CartItem()
  CartSummaryView(item: $item)
}
