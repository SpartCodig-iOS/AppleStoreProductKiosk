//
//  FetchProductsUseCase.swift
//  AppleStoreProductKiosk
//
//  Created by 홍석현 on 9/17/25.
//

import Foundation
import Dependencies

public protocol FetchProductsUseCase {
  func execute() async throws -> [ProductCategory]
}

public struct FetchProducts: FetchProductsUseCase {
  private let repository: ProductsRepository
  
  public init(repository: ProductsRepository) {
    self.repository = repository
  }
  
  public func execute() async throws -> [ProductCategory] {
    return try await repository.fetchProducts()
  }
}

public enum FetchProductsDependencyKey: DependencyKey {
    public static var liveValue: any FetchProductsUseCase = FetchProducts(repository: DefaultProductsRepository())
    
    public static var testValue: any FetchProductsUseCase = FetchProducts(repository: DefaultProductsRepository())
    
    public static var previewValue: any FetchProductsUseCase = FetchProducts(repository: DefaultProductsRepository())
}

public extension DependencyValues {
    var fetchProductsUseCase: any FetchProductsUseCase {
        get { self[FetchProductsDependencyKey.self] }
        set { self[FetchProductsDependencyKey.self] = newValue }
    }
}
