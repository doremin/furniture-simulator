//
//  SceneDelegate.swift
//  FurnitureSimulator
//
//  Created by doremin on 2023/01/04.
//

import UIKit

import Moya

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let provider = MoyaProvider<FSAPIService>()
    let fileService = FileService(provider: provider)
    fileService.updateModels()
    
    self.window = UIWindow(windowScene: windowScene)
    self.window?.rootViewController = FSMainViewController(fileService: fileService)
    self.window?.makeKeyAndVisible()
  }
}
