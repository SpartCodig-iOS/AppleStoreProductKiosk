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

   enum Action: ViewAction, BindableAction {
    case binding(BindingAction<State>)
    case view(View)
    case async(AsyncAction)
    case inner(InnerAction)
    case navigation(NavigationAction)

  }

  //MARK: - ViewAction
  @CasePathable
   enum View {
    case onTapAddProduct(id: String)
     case onAppear
  }



  //MARK: - AsyncAction 비동기 처리 액션
   enum AsyncAction: Equatable {
    case fetchProductCatalog

  }

  //MARK: - 앱내에서 사용하는 액션
   enum InnerAction: Equatable {
    case fetchProductCatalogResponse(Result<ProductCatalog, DataError>)
  }

  //MARK: - NavigationAction
   enum NavigationAction: Equatable {


  }

  private struct ProductListCancel: Hashable {}

  @Dependency(\.productUseCase) var productUseCase

   var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        case .binding(_):
          return .none

        case .view(let viewAction):
          return handleViewAction(state: &state, action: viewAction)

        case .async(let asyncAction):
          return handleAsyncAction(state: &state, action: asyncAction)

        case .inner(let innerAction):
          return handleInnerAction(state: &state, action: innerAction)

        case .navigation(let navigationAction):
          return handleNavigationAction(state: &state, action: navigationAction)
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

    }
  }

  private func handleNavigationAction(
    state: inout State,
    action: NavigationAction
  ) -> Effect<Action> {
    switch action {

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

    }
  }
}

