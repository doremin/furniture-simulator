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
    self.window = UIWindow(windowScene: windowScene)
    self.window?.rootViewController = FSMainViewController()
    self.window?.makeKeyAndVisible()
    
    let provider = MoyaProvider<FSAPIService>()
    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    print(try! FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil))
//    provider.request(.downloadModel(modelName: "cube", fileName: "cube.obj")) { result in
//      switch result {
//      case .success(_):
//        print(try! FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil))
//      case .failure(let error):
//        print(error)
//      }
//    }
  }
}
