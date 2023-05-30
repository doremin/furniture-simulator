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
    URL(string: "http://13.125.249.235")!
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
        let url = documentURL.appendingPathComponent(fileName)
        
        return (url, [.removePreviousFile])
      }
    case .model:
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    return [:]
  }
  
  private var documentURL: URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
}
