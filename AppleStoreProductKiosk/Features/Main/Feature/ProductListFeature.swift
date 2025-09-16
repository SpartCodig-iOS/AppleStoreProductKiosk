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
    
  }
  
  public enum Action {
    case onTapAddProduct(id: String)
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onTapAddProduct(let _):
        return .none
      }
    }
  }
}
