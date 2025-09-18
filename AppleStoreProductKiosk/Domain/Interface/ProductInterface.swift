//
//  ProductInterface.swift
//  AppleStoreProductKiosk
//
//  Created by 홍석현 on 9/16/25.
//

import Foundation

protocol ProductInterface {
  func fetchProductCatalog() async throws -> ProductCatalog
  func fetchProducts(for category: String) async throws -> [Product]
}
