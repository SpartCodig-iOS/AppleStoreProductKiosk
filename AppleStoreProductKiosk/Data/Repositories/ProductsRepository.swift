//
//  ProductsRepository.swift
//  AppleStoreProductKiosk
//
//  Created by 홍석현 on 9/16/25.
//

import Foundation

public struct DefaultProductsRepository: ProductsRepository {
  public func fetchProducts() -> [ProductCategory] {
    return ProductCategory.allCategories
  }
}
