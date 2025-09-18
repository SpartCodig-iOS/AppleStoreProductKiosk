//
//  CartFeature.swift
//  AppleStoreProductKiosk
//
//  Created by 김민희 on 9/18/25.
//
import Foundation
import ComposableArchitecture

@Reducer
public struct CartFeature {
  @ObservableState
  public struct State: Equatable {
    @Shared var selectedProducts: [Product]
  }
  
  @CasePathable
  public enum Action: Equatable {

  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      return .none
    }
  }
}
