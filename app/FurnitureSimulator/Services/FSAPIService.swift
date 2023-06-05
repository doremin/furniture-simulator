//
//  FSAPIService.swift
//  FurnitureSimulator
//
//  Created by doremin on 2023/05/11.
//

import Foundation

import Moya

enum FSAPIService {
  case model
  case downloadModel(modelName: String, fileName: String)
}

extension FSAPIService: TargetType {
  var baseURL: URL {
    URL(string: "http://13.209.49.118")!
  }
  
  var path: String {
    switch self {
    case .model:
      return "/model"
    case let .downloadModel(modelName, fileName):
      return "model/\(modelName)/\(fileName)"
    }
  }
  
  var method: Moya.Method {
    return .get
  }
  
  var task: Moya.Task {
    switch self {
    case .downloadModel(_, let fileName):
      return .downloadDestination { _, _ in
        let modelName = FileService.removeExtension(fileName: fileName)
        let url = documentURL.appendingPathComponent(modelName)
        if !FileManager.default.fileExists(atPath: url.path()) {
          try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }
        
        return (url.appendingPathComponent(fileName), [.removePreviousFile])
      }
    case .model:
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    return [:]
  }
  
  var sampleData: Data {
    switch self {
    case .model:
      let data = ["cube", "couch", "table"]
      if let data = try? JSONEncoder().encode(data) {
        return data
      } else {
        return Data()
      }
    case .downloadModel:
      return Data()
    }
  }
  
  private var documentURL: URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
}
