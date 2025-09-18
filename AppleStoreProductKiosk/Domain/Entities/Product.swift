//
//  Untitled.swift
//  AppleStoreProductKiosk
//
//  Created by 홍석현 on 9/16/25.
//

import Foundation

struct ProductCatalog: Equatable {
  let categories: [Category]

}

struct Category: Equatable {
  public let name: String
  public let products: [Product]
}


struct Product: Equatable {
  public let id: String
  public let name: String
  public let description: String
  public let priceFormatted: String
  public let mainImageURL: URL?
}
