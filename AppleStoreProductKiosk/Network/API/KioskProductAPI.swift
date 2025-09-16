//
//  KioskProductAPI.swift
//  AppleStoreProductKiosk
//
//  Created by Wonji Suh  on 9/16/25.
//

import Foundation

enum  KioskProductAPI {
  case productLists

  var description: String {
    switch self {
      case .productLists:
        return "/products"
    }
  }
}
