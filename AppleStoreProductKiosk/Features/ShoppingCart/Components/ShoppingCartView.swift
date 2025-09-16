//
//  ShoppingCartView.swift
//  AppleStoreProductKiosk
//
//  Created by 김민희 on 9/16/25.
//

import SwiftUI

struct ShoppingCartView: View {
  @Environment(\.dismiss) var dismiss

  var body: some View {
    headerView
  }

  private var headerView: some View {
    HStack (spacing: 0) {
      Text("장바구니")
        .font(.system(size: 20, weight: .bold))
      Spacer()

      Button {
        dismiss()
      } label: {
        Image(systemName: "xmark")
          .foregroundColor(.black)
          .font(.system(size: 15))
          .padding(8)
          .background(Color.gray.opacity(0.15))
          .clipShape(Circle())
      }
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 25)
  }
}

#Preview {
  ShoppingCartView()
}
