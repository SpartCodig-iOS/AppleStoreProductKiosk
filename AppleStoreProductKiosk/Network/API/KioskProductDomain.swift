//
//  KioskProductDomain.swift
//  AppleStoreProductKiosk
//
//  Created by Wonji Suh  on 9/16/25.
//

import Foundation

enum  KioskProductDomain {
  case producut
}


extension KioskProductDomain {
  var url: String {
    switch self {
      case .producut:
        return "/api/apple-store-kiosk"
    }
  }
}
