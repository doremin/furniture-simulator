//
//  FileService.swift
//  FurnitureSimulator
//
//  Created by doremin on 2023/05/30.
//

import Foundation

import SceneKit.ModelIO
import Moya

enum Ext {
  case png
  case obj
  case mtl
}

final class FileService {
  
  private let provider: MoyaProvider<FSAPIService>
  
  init(provider: MoyaProvider<FSAPIService>) {
    self.provider = provider
  }
  
  private var documentURL: URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
  
  public func loadModel(url: URL) -> SCNNode {
    let asset = MDLAsset(url: url)
    asset.loadTextures()
    let node = SCNScene(mdlAsset: asset).rootNode.flattenedClone()
    node.scale = SCNVector3(x: 0.1, y: 0.1, z: 0.1)
    return node
  }
  
  public func updateModels() {
    self.provider.request(.model) { result in
      switch result {
      case .success(let response):
        self.updateModelSuccessHandler(response: response)
      case .failure(let error):
        self.updateModelErrorHandler(error: error)
      }
    }
  }
  
  public func loadModels() -> [FurnitureModel] {
    guard let contents = try? FileManager.default.contentsOfDirectory(at: documentURL, includingPropertiesForKeys: nil) else {
      return []
    }
    
    return contents.compactMap { directoryURL -> FurnitureModel? in
      guard let directoryContents = try? FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil) else {
        return nil
      }
      
      guard !directoryURL.lastPathComponent.starts(with: ".") else {
        return nil
      }
      
      var thumbnailURL = documentURL
      var objURL = documentURL
      var mtl = documentURL
      
      for content in directoryContents {
        switch FileService.extensionOfFile(fileName: content.path()) {
        case .obj:
          objURL = content
        case .png:
          thumbnailURL = content
        case .mtl:
          mtl = content
        default:
          return nil
        }
      }
      
      return FurnitureModel(objURL: objURL, thumbnailURL: thumbnailURL, mtl: mtl)
    }
  }
  
  private func updateModelErrorHandler(error: MoyaError) {
    print(error)
  }
  
  private func updateModelSuccessHandler(response: Response) {
    guard let modelResponse = JSONDecoder().decodeJSON([ModelInfo].self, data: response.data) else {
      return
    }
    
    modelResponse.forEach { modelInfo in
      let modelName = FileService.removeExtension(fileName: modelInfo.model)
    
      self.provider.request(
        .downloadModel(modelName: modelName, fileName: modelInfo.model)
      ) { result in
          switch result {
          case .success(let response):
            self.downloadSuccessHandler(response: response)
          case .failure(let error):
            self.downloadFailureHandler(error: error)
          }
        }
      
      self.provider.request(
        .downloadModel(modelName: modelName, fileName: modelInfo.thumbnail)
      ) { result in
          switch result {
          case .success(let response):
            self.downloadSuccessHandler(response: response)
          case .failure(let error):
            self.downloadFailureHandler(error: error)
          }
        }
      
      }
  }
  
  private func downloadSuccessHandler(response: Response) {
    print("success")
  }
  
  private func downloadFailureHandler(error: MoyaError) {
    print(error)
  }
  
  static public func removeExtension(fileName: String) -> String {
    guard let lastIndex = fileName.lastIndex(of: ".") else {
      return fileName
    }
    
    return String(fileName[fileName.startIndex ..< lastIndex])
  }
  
  static public func extensionOfFile(fileName: String) -> Ext? {
    guard let lastIndex = fileName.lastIndex(of: ".") else {
      return nil
    }
    
    let ext = String(fileName[fileName.index(lastIndex, offsetBy: 1) ..< fileName.endIndex])
    
    if ext == "png" {
      return .png
    } else if ext == "obj" {
      return .obj
    } else if ext == "mtl" {
      return .mtl
    }
    
    return nil
  }
}
