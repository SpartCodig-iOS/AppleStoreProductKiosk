//
//  ProductListFeature.swift
//  AppleStoreProductKiosk
//
//  Created by 홍석현 on 9/16/25.
//

import ComposableArchitecture

@Reducer
public struct ProductListFeature {
  
  @ObservableState
  public struct State {
    var productCategories: IdentifiedArrayOf<ProductCategory> = []
    var currentSelectedCategoryId: String?
    
    var isHiddenCardButton = true
  }
  
  public enum Action: FeatureAction, ViewAction {
    case view(ViewAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
    case inner(InnerAction)
    
    public enum ViewAction {
      case onAppear
      case onTapCategory(id: String)
      case onTapAddItem(id: String)
    }
    
    public enum AsyncAction {
      case fetchProductData
    }
    
    public enum ScopeAction { }
    
    public enum DelegateAction { }
    
    public enum InnerAction {
      case updateProductCategories([ProductCategory])
      case updateSelectedCategoryId(String)
    }
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
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
      return .none
    }
  }
  
  private func handleAsyncAction(
    state: inout State,
    action: Action.AsyncAction
  ) -> Effect<Action> {
    switch action {
    case .fetchProductData:
      let mockData = ProductCategory.allCategories
      return .send(.inner(.updateProductCategories(mockData)))
    }
  }
  
  private func handleScopeAction(
    state: inout State,
    action: Action.ScopeAction
  ) -> Effect<Action> {
    return .none
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
    }
  }
}
