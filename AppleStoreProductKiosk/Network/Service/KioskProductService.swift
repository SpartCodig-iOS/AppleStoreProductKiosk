//
//  KioskProductService.swift
//  AppleStoreProductKiosk
//
//  Created by Wonji Suh  on 9/16/25.
//


import Foundation


enum KioskProductService {
  case proudctList
}


extension KioskProductService: BaseTargetType {
  var domain: KioskProductDomain {
    return .producut
  }

  var urlPath: String {
    switch self {
      case .proudctList:
        return KioskProductAPI.productLists.description
    }
  }

  var parameters: [String : Any]? {
    switch self {
      case .proudctList:
        return nil
    }
  }

  var method: HTTPMethod {
    switch self {
      case .proudctList:
        return .get
    }
  }
}
