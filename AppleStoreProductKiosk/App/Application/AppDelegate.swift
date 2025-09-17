//
//  AppDelegate.swift
//  AppleStoreProductKiosk
//
//  Created by Wonji Suh  on 9/17/25.
//

import Foundation
import UIKit

import DiContainer

class AppDelegate: UIResponder, UIApplicationDelegate {



  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {


    DependencyContainer.bootstrapInTask { _ in
      await AppDIContainer.shared.registerDefaultDependencies()
    }

    UnifiedDI.enablePerformanceOptimization()

    return true
  }
}
