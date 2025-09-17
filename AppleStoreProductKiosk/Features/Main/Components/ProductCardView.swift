//
//  ProductCardView.swift
//  AppleStoreProductKiosk
//
//  Created by 홍석현 on 9/16/25.
//

import SwiftUI

public struct ProductCardView: View {
  private enum Layout {
    static let imageHeight: CGFloat = 200
    static let textAreaHeight: CGFloat = 55
    static let cornerRadius: CGFloat = 12
    static let cardPadding: CGFloat = 16
    static let buttonPadding: CGFloat = 8
  }
  private let imageURL: URL?
  private let title: String
  private let subTitle: String
  private let price: Double
  
  public init(
    imageURL: URL?,
    title: String,
    subTitle: String,
    price: Double
  ) {
    self.imageURL = imageURL
    self.title = title
    self.subTitle = subTitle
    self.price = price
  }
  
  public var body: some View {
    VStack(spacing: 8) {
      AsyncImage(url: self.imageURL) { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
      } placeholder: {
        Rectangle()
          .fill(Color.gray.opacity(0.2))
          .overlay(
            ProgressView()
              .scaleEffect(0.8)
          )
      }
      .frame(height: Layout.imageHeight)
      .clipped()
      
      VStack(alignment: .leading, spacing: 8) {
        VStack(alignment: .leading, spacing: 4) {
          Text(title)
            .font(.headline)
            .foregroundStyle(Color.primary)
            .lineLimit(1)

          Text(subTitle)
            .font(.caption)
            .foregroundStyle(Color.secondary)
            .lineLimit(2)
        }
        .frame(height: Layout.textAreaHeight, alignment: .top)

        Text(formatCurrency(amount: price))
          .font(.system(size: 20, weight: .semibold))
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      
      Button {
        
      } label: {
        Text("담기")
          .foregroundStyle(Color.white)
          .font(.system(size: 14, weight: .bold))
          .frame(maxWidth: .infinity)
      }
      .padding(.vertical, Layout.buttonPadding)
      .padding(.horizontal, Layout.cardPadding)
      .background(Color.accentColor)
      .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius))
    }
    .padding(Layout.cardPadding)
  }
  
  private static let currencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.maximumFractionDigits = 0
    return formatter
  }()

  private func formatCurrency(amount: Double) -> String {
    Self.currencyFormatter.string(from: NSNumber(value: amount)) ?? ""
  }
}

#Preview {
  let sampleImageURL = URL(string: "https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/iphone-compare-iphone-17-pro-202509?fmt=jpeg&hei=320&qlt=85&wid=250")

  VStack(spacing: 16) {
    HStack(spacing: 16) {
      ProductCardView(
        imageURL: sampleImageURL,
        title: "MacBook Pro 16",
        subTitle: "M3 Pro 칩이 탑재된 프로 노트북 긴 텍스트 테스트용 매우 긴 설명입니다",
        price: 3199000
      )

      ProductCardView(
        imageURL: sampleImageURL,
        title: "MacBook Pro 15",
        subTitle: "놀랍도록 얇고 가벼운 노트북",
        price: 2599000
      )
    }

    HStack(spacing: 16) {
      ProductCardView(
        imageURL: sampleImageURL,
        title: "iPhone 15 Pro",
        subTitle: "티타늄 소재의 프로 모델",
        price: 1550000
      )

      ProductCardView(
        imageURL: sampleImageURL,
        title: "iPad Air",
        subTitle: "M2 칩 탑재 매우 긴 제품 설명 텍스트로 레이아웃 테스트를 진행합니다",
        price: 899000
      )
    }
  }
  .padding()
}
