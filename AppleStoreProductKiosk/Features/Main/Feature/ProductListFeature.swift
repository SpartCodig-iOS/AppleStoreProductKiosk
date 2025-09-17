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
  }
  
  public enum Action: FeatureAction, ViewAction {
    case view(ViewAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
    case inner(InnerAction)
    
    public enum ViewAction { }
    
    public enum AsyncAction { }
    
    public enum ScopeAction { }
    
    public enum DelegateAction { }
    
    public enum InnerAction { }
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
    return .none
  }
  
  private func handleAsyncAction(
    state: inout State,
    action: Action.AsyncAction
  ) -> Effect<Action> {
    return .none
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
    return .none
  }
}
