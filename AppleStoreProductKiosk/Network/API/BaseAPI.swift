//
//  BaseAPI.swift
//  AppleStoreProductKiosk
//
//  Created by Wonji Suh  on 9/16/25.
//

import Foundation

enum BaseAPI  {
  case baseURL

  var description: String {
    switch self {
      case .baseURL:
        return "https://applestoreproductkiosk.free.beeceptor.com"
    }
  }
}
