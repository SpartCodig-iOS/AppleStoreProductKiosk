//
//  MockProductRepository.swift
//  AppleStoreProductKiosk
//
//  Created by Wonji Suh  on 9/17/25.
//

import Foundation

class MockProductRepository: ProductInterface {
  private let categoriesData: [Category]

  init(categories: [Category]? = nil) {
    if let categories {
      self.categoriesData = categories
    } else {
      self.categoriesData = MockProductRepository.defaultCategories
    }
  }

  func fetchProductCatalog() async throws -> ProductCatalog {
    .init(categories: categoriesData)
  }

  func fetchProducts(for category: String) async throws -> [Product] {
    let lowercased = category.lowercased()
    return categoriesData.first { $0.name.lowercased() == lowercased }?.products ?? []
  }
}

// MARK: - Default Mock Data
extension MockProductRepository {
  static var defaultCategories: [Category] {
    [
      Category(
        name: "iPhone",
        products: [
          Product(
            id: "iphone-15-pro",
            name: "iPhone 15 Pro",
            description: "Titanium. A17 Pro chip. Pro camera system.",
            priceFormatted: "$999",
            mainImageURL: URL(string: "https://example.com/images/iphone15pro.jpg")
          ),
          Product(
            id: "iphone-15",
            name: "iPhone 15",
            description: "Dynamic Island. 48MP Main camera.",
            priceFormatted: "$799",
            mainImageURL: URL(string: "https://example.com/images/iphone15.jpg")
          )
        ]
      ),
      Category(
        name: "Mac",
        products: [
          Product(
            id: "macbook-air-m2",
            name: "MacBook Air",
            description: "Supercharged by M2.",
            priceFormatted: "$1199",
            mainImageURL: URL(string: "https://example.com/images/macbookairm2.jpg")
          ),
          Product(
            id: "macbook-pro-m3",
            name: "MacBook Pro",
            description: "M3 power. Stunning Liquid Retina XDR display.",
            priceFormatted: "$1999",
            mainImageURL: URL(string: "https://example.com/images/macbookprom3.jpg")
          )
        ]
      ),
      Category(
        name: "iPad",
        products: [
          Product(
            id: "ipad-pro-m2",
            name: "iPad Pro",
            description: "M2 chip. ProMotion. Thunderbolt.",
            priceFormatted: "$1099",
            mainImageURL: URL(string: "https://example.com/images/ipadpro.jpg")
          ),
          Product(
            id: "ipad-mini",
            name: "iPad mini",
            description: "Compact. Powerful. Pocketable.",
            priceFormatted: "$499",
            mainImageURL: URL(string: "https://example.com/images/ipadmini.jpg")
          )
        ]
      ),
      Category(
        name: "Watch",
        products: [
          Product(
            id: "apple-watch-series-9",
            name: "Apple Watch Series 9",
            description: "Powerful health features. Double Tap gesture.",
            priceFormatted: "$399",
            mainImageURL: URL(string: "https://example.com/images/watchs9.jpg")
          ),
          Product(
            id: "apple-watch-ultra-2",
            name: "Apple Watch Ultra 2",
            description: "Adventure ready. Brightest display yet.",
            priceFormatted: "$799",
            mainImageURL: URL(string: "https://example.com/images/watchultra2.jpg")
          )
        ]
      ),
      Category(
        name: "Accessories",
        products: [
          Product(
            id: "airpods-pro-2",
            name: "AirPods Pro (2nd generation)",
            description: "H2 chip. Adaptive Audio.",
            priceFormatted: "$249",
            mainImageURL: URL(string: "https://example.com/images/airpodspro2.jpg")
          ),
          Product(
            id: "magic-keyboard",
            name: "Magic Keyboard",
            description: "Comfortable typing. Touch ID option.",
            priceFormatted: "$99",
            mainImageURL: URL(string: "https://example.com/images/magickeyboard.jpg")
          )
        ]
      )
    ]
  }
}
