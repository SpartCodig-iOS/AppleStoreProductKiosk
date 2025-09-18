//
//  ModuleFactoryManager.swift
//  AppleStoreProductKiosk
//
//  Created by Wonji Suh  on 9/17/25.
//

import Foundation

import DiContainer

extension ModuleFactoryManager {
      mutating func registerDefaultDependencies() {
          // Repository
        repositoryFactory.registerDefaultDefinitions()

        useCaseFactory.registerDefaultDefinitions()
      }
  }
