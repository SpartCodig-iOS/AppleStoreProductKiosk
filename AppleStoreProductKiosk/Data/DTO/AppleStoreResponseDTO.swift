//
//  AppleStoreResponseDTO.swift
//  AppleStoreProductKiosk
//
//  Created by 홍석현 on 9/17/25.
//

import Foundation

public struct AppleStoreResponseDTO: Decodable {
  private let data: StoreDataDTO
}

extension AppleStoreResponseDTO {
  func toDomain() -> [ProductCategory] {
    return data.categories.map { category in
      return ProductCategory(
        id: category.category,
        name: category.category,
        products: category.products.map {
          Product(
            id: $0.id,
            name: $0.name ?? String(),
            description: $0.description ?? String(),
            price: Double($0.fromPrice.amount),
            imageURL: URL(string: $0.images.main)
          )
      })
    }
  }
}

struct StoreDataDTO: Decodable {
  fileprivate let store: StoreInfoDTO
  fileprivate let categories: [CategoryDTO]
}

struct StoreInfoDTO: Decodable {
  fileprivate let id: String
  fileprivate let region: String
  fileprivate let currency: String
  fileprivate let updatedAt: String
}

struct CategoryDTO: Decodable {
  fileprivate let category: String
  fileprivate let products: [ProductDTO]
}

struct ProductDTO: Decodable {
  fileprivate let id: String
  fileprivate let name: String?
  fileprivate let description: String?
  fileprivate let fromPrice: PriceDTO
  fileprivate let links: ProductLinksDTO?
  fileprivate let images: ProductImagesDTO
}

struct PriceDTO: Decodable {
  fileprivate let amount: Int
  fileprivate let currency: String
  fileprivate let formatted: String
}

struct ProductLinksDTO: Decodable {
  fileprivate let buy: String?
  fileprivate let imagePage: String?
}

struct ProductImagesDTO: Decodable {
  fileprivate let main: String
  fileprivate let thumbnails: [String]
}
