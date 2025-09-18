//
//  ProductsRepository.swift
//  AppleStoreProductKiosk
//
//  Created by 홍석현 on 9/16/25.
//

import Foundation
import DiContainer

public struct DefaultProductsRepository: ProductsRepository {
  private let provider = AsyncProvider<KioskProductService>(session: .shared)
  
  public func fetchProducts() async throws -> [ProductCategory] {
    try await provider.requestAsync(
      .getAllProducts,
      decodeTo: AppleStoreResponseDTO.self
    ).toDomain()
  }
}

extension RegisterModule {
  var productsRepositoryModule: () -> Module {
    makeDependencyImproved(ProductsRepository.self) {
      DefaultProductsRepository()
    }
  }
}
