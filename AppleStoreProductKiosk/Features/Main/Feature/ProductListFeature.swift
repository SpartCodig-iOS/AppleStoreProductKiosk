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
public struct ProductListFeature {
  
  @Dependency(\.fetchProductsUseCase) var fetchProducts
  
  @ObservableState
  public struct State: Equatable {
    @Shared var selectedProducts: [Product]
    var productCategories: IdentifiedArrayOf<ProductCategory> = []
    var currentSelectedCategoryId: String = ""
    var currentItems: IdentifiedArrayOf<Product> {
      guard
        !currentSelectedCategoryId.isEmpty,
        let products = productCategories[id: currentSelectedCategoryId]?.products
      else {
        return []
      }
      return IdentifiedArray(uniqueElements: products)
    }
    var isHiddenCartButton: Bool {
      return selectedProducts.isEmpty
    }
    var cartButtonState: CartButtonFeature.State

    @Presents var alert: AlertState<Action.Alert>?

    init(selectedProducts: Shared<[Product]>) {
      self._selectedProducts = selectedProducts
      self.cartButtonState = CartButtonFeature.State(selectedProducts: selectedProducts)
    }
  }
  
  @CasePathable
  public enum Action: FeatureAction, ViewAction, Equatable, BindableAction {
    case binding(BindingAction<State>)
    case view(ViewAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
    case inner(InnerAction)
    
    @CasePathable
    public enum ViewAction: Equatable {
      case onAppear
      case onTapCategory(id: String)
      case onTapAddItem(id: String)
      case alert(PresentationAction<Alert>)
    }
    
    @CasePathable
    public enum AsyncAction: Equatable {
      case fetchProductData
    }
    
    @CasePathable
    public enum ScopeAction: Equatable {
      case cardButton(CartButtonFeature.Action)
    }
    
    @CasePathable
    public enum DelegateAction: Equatable { }
    
    @CasePathable
    public enum InnerAction: Equatable {
      case updateProductCategories([ProductCategory])
      case updateSelectedCategoryId(String)
      case showErrorAlert(message: String)
    }

    @CasePathable
    public enum Alert: Equatable {
      case confirmRetry
      case dismiss
    }
  }
  
  public var body: some Reducer<State, Action> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      case .view(let action):
        return handleViewAction(state: &state, action: action)
      case .async(let action):
        return handleAsyncAction(state: &state, action: action)
      case .scope(let action):
        return handleScopeAction(state: &state, action: action)
      case .delegate(let action):
        return handleDelegateAction(state: &state, action: action)
      case .inner(let action):
        return handleInnerAction(state: &state, action: action)
      @unknown default:
        return .none
      }
    }
    .ifLet(\.$alert, action: \.view.alert)

    Scope(state: \.cartButtonState, action: \.scope.cardButton) {
      CartButtonFeature()
    }
  }
}

extension ProductListFeature {
  private func handleViewAction(
    state: inout State,
    action: Action.ViewAction
  ) -> Effect<Action> {
    switch action {
    case .onAppear:
      return .send(.async(.fetchProductData))
    case .onTapCategory(let categoryId):
      return .send(.inner(.updateSelectedCategoryId(categoryId)))
    case .onTapAddItem(let itemId):
      guard let product = state.currentItems[id: itemId] else { return .none }
      state.$selectedProducts.withLock { $0 = $0 + [product] }
      return .none
    case .alert(.presented(.confirmRetry)):
      return .send(.async(.fetchProductData))
    case .alert(.presented(.dismiss)):
      return .none
    case .alert(.dismiss):
      return .none
    }
  }
  
  private func handleAsyncAction(
    state: inout State,
    action: Action.AsyncAction
  ) -> Effect<Action> {
    switch action {
    case .fetchProductData:
      return .run { send in
        do {
          let products = try await fetchProducts.execute()
          await send(.inner(.updateProductCategories(products)))
        } catch {
          let errorMessage = error.localizedDescription
          await send(.inner(.showErrorAlert(message: errorMessage)))
        }
      }
    }
  }
  
  private func handleScopeAction(
    state: inout State,
    action: Action.ScopeAction
  ) -> Effect<Action> {
    switch action {
    case .cardButton(let action):
      guard case .view(.onTap) = action else { return .none }
      return .none
    }
  }
  
  private func handleDelegateAction(
    state: inout State,
    action: Action.DelegateAction
  ) -> Effect<Action> {
    return .none
  }
  
  private func handleInnerAction(
    state: inout State,
    action: Action.InnerAction
  ) -> Effect<Action> {
    switch action {
    case .updateProductCategories(let categories):
      state.productCategories = IdentifiedArray(uniqueElements: categories)
      return .send(.inner(.updateSelectedCategoryId(categories.first?.id ?? "")))
    case .updateSelectedCategoryId(let id):
      state.currentSelectedCategoryId = id
      return .none
    case .showErrorAlert(let message):
      state.alert = AlertState {
        TextState("오류")
      } actions: {
        ButtonState(action: .confirmRetry) {
          TextState("다시 시도")
        }
        ButtonState(role: .cancel, action: .dismiss) {
          TextState("취소")
        }
      } message: {
        TextState(message)
      }
      return .none
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
