//
//  FileService.swift
//  FurnitureSimulator
//
//  Created by doremin on 2023/05/30.
//

import Foundation

import SceneKit.ModelIO
import Moya

final class FileService {
  
  private let provider: MoyaProvider<FSAPIService>
  
  init(provider: MoyaProvider<FSAPIService>) {
    self.provider = provider
  }
  
  private var documentURL: URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
  
  public func loadModel(modelName: String) -> SCNNode {
    let filePath = self.documentURL.appendingPathComponent(modelName)
    let asset = MDLAsset(url: filePath)
    asset.loadTextures()
    let node = SCNScene(mdlAsset: asset).rootNode.flattenedClone()
    node.scale = SCNVector3(x: 0.1, y: 0.1, z: 0.1)
    return node
  }
  
  public func updateModels() {
    
  }
  
  public func removeExtension(fileName: String) -> String {
    guard let lastIndex = fileName.lastIndex(of: ".") else {
      return fileName
    }
    
    return String(fileName[fileName.startIndex ..< lastIndex])
  }
}
