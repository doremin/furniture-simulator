//
//  JSONDecoder+Extension.swift
//  FurnitureSimulator
//
//  Created by doremin on 2023/06/06.
//

import Foundation

extension JSONDecoder {
  public func decodeJSON<T: Decodable>(_ type: T.Type, data: Data) -> T? {
    return try? self.decode(type, from: data)
  }
}
