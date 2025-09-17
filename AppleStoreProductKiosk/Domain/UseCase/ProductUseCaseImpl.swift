//
//  ProductUseCase.swift
//  AppleStoreProductKiosk
//
//  Created by 홍석현 on 9/16/25.
//

import Foundation

import ComposableArchitecture
import DiContainer

struct ProductUseCase: ProductInterface {
  private let repository: ProductInterface

  init(repository: ProductInterface) {
    self.repository = repository
  }


  func fetchProductCatalog() async throws -> ProductCatalog {
    return try await repository.fetchProductCatalog()
  }

  func fetchProducts(for category: String) async throws -> [Product] {
    return try await repository.fetchProducts(for: category)
  }
}
