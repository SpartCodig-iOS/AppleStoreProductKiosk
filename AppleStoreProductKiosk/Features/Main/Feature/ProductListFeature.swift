//
//  ProductListFeature.swift
//  AppleStoreProductKiosk
//
//  Created by 홍석현 on 9/16/25.
//

import Foundation
import ComposableArchitecture

import LogMacro

@Reducer
 struct ProductListFeature {
  public init() {}

  @ObservableState
   struct State: Equatable {

     init() {}
    var productCatalogModel : ProductCatalog? = nil
  }

  @CasePathable
   enum Action: ViewAction {
    case view(View)
    case async(AsyncAction)
    case inner(InnerAction)

  }

  //MARK: - ViewAction
  @CasePathable
   enum View {
    case onTapAddProduct(id: String)
    case onSelectCategory(String)
     case onAppear
  }



  //MARK: - AsyncAction 비동기 처리 액션
  @CasePathable
   enum AsyncAction: Equatable {
    case fetchProductCatalog
    case fetchProducts(String)

  }

  //MARK: - 앱내에서 사용하는 액션
  @CasePathable
   enum InnerAction: Equatable {
    case fetchProductCatalogResponse(Result<ProductCatalog, DataError>)
    case fetchProductsResponse(category: String, Result<[Product], DataError>)
  }


  private struct ProductListCancel: Hashable {}

  @Dependency(\.productUseCase) var productUseCase
   @Dependency(\.mainQueue) var mainQueue

   var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        case .view(let viewAction):
          return handleViewAction(state: &state, action: viewAction)

        case .async(let asyncAction):
          return handleAsyncAction(state: &state, action: asyncAction)

        case .inner(let innerAction):
          return handleInnerAction(state: &state, action: innerAction)

      }
    }
  }

  private func handleViewAction(
    state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {
      case .onTapAddProduct(let id):
        return .none

      case .onAppear:
        return .run  { send in
          await send(.async(.fetchProductCatalog))
        }
        .debounce(id: ProductListCancel(), for: 0.3, scheduler: mainQueue)

      case .onSelectCategory(let category):
        return .run { send in
          await send(.async(.fetchProducts(category)))
        }

    }
  }

  private func handleAsyncAction(
    state: inout State,
    action: AsyncAction
  ) -> Effect<Action> {
    switch action {
      case .fetchProductCatalog:
        return .run { send in
          let productCatalogResult = await Result {
            try await productUseCase.fetchProductCatalog()
          }

          switch productCatalogResult {
            case .success(let productCatalogData):
              await send(.inner(.fetchProductCatalogResponse(.success(productCatalogData))))

            case .failure(let error):
              await send(.inner(.fetchProductCatalogResponse(.failure(.decodingError(error)))))
          }

        }

      case .fetchProducts(let category):
        return .run { send in
          let result = await Result {
            try await productUseCase.fetchProducts(for: category)
          }

          switch result {
            case .success(let products):
              await send(.inner(.fetchProductsResponse(category: category, .success(products))))
            case .failure(let error):
              await send(.inner(.fetchProductsResponse(category: category, .failure(.decodingError(error)))))
          }
        }

    }
  }

  private func handleInnerAction(
    state: inout State,
    action: InnerAction
  ) -> Effect<Action> {
    switch action {
      case .fetchProductCatalogResponse(let result):
        switch result {
          case .success(let data):
            state.productCatalogModel = data

            #logDebug("데이터", data)

          case .failure(let error):
            #logNetwork("데이터 통신 실패", error.localizedDescription)
        }
        return .none

      case .fetchProductsResponse(let category, let result):
        switch result {
          case .success(let products):
            state.productCatalogModel = ProductCatalog(categories: [
              Category(name: category, products: products)
            ])
            #logDebug("상품 로드 완료: \(category)", products)
          case .failure(let error):
            #logNetwork("상품 로드 실패: \(category)", error.localizedDescription)
        }
        return .none

    }
  }
}
