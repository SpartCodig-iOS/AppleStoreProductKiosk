//
//  CartItemRowView.swift
//  AppleStoreProductKiosk
//
//  Created by 김민희 on 9/16/25.
//

import SwiftUI

//TODO: 데이터 작업할 때 없앨예정
struct CartItem {
  let name: String = "iphone17 pro"
  let price: Int = 1000000
  let imageName: String = "iphone17pro"
  var quantity: Int = 2
}

struct CartItemRowView: View {
  @Binding var item: CartItem

  var body: some View {
    HStack(spacing: 0) {
      Image(item.imageName)
        .resizable()
        .scaledToFit()
        .frame(width: 80, height: 80)
        .cornerRadius(10)

      Spacer()
        .frame(width: 20)

      VStack(alignment: .leading, spacing: 10) {
        Text(item.name)
          .font(.system(size: 17, weight: .semibold))

        Text("₩\(item.price)")
          .font(.system(size: 14, weight: .regular))
          .foregroundStyle(.black.opacity(0.7))

        Text("소계: ₩\(item.price * item.quantity)")
          .font(.system(size: 12, weight: .regular))
          .foregroundStyle(.blue)
      }

      Spacer()

      HStack(spacing: 13) {
        if item.quantity > 1 {
          Button {
            item.quantity -= 1
          } label: {
            Image(systemName: "minus")
              .font(.system(size: 15))
              .padding(12)
              .foregroundStyle(.black)
              .background(.white)
              .clipShape(Circle())
              .overlay(
                Circle()
                  .stroke(.gray.opacity(0.3), lineWidth: 0.7)
              )
          }
        } else {
          Button {
            //삭제
          } label: {
            Image(systemName: "trash")
              .font(.system(size: 13))
              .padding(8)
              .foregroundStyle(.red)
              .background(.white)
              .clipShape(Circle())
              .overlay(
                Circle()
                  .stroke(.gray.opacity(0.3), lineWidth: 0.7)
              )
          }
        }

        Text("\(item.quantity)").frame(minWidth: 20)

        Button {
          item.quantity += 1
        } label: {
          Image(systemName: "plus")
            .font(.system(size: 15))
            .padding(7)
            .foregroundStyle(.black)
            .background(.white)
            .clipShape(Circle())
            .overlay(
              Circle()
                .stroke(.gray.opacity(0.3), lineWidth: 0.7)
            )
        }
      }
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 20)
    .background(.gray.opacity(0.05))
    .clipShape(RoundedRectangle(cornerRadius: 14))
  }
}

#Preview {
  @State var item = CartItem(quantity: 1)
  CartItemRowView(item: $item)
}
