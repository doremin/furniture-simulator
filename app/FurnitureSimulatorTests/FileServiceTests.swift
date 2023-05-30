//
//  FileServiceTests.swift
//  FurnitureSimulatorTests
//
//  Created by doremin on 2023/05/30.
//

import XCTest
import Moya

@testable import FurnitureSimulator

final class FileServiceTests: XCTestCase {
  private var fileService: FileService!
  
  override func setUpWithError() throws {
    let endpointClosure = { (target: FSAPIService) -> Endpoint in
      return Endpoint(url: URL(target: target).absoluteString,
                      sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                      method: target.method,
                      task: target.task,
                      httpHeaderFields: target.headers)
    }
    let provider = MoyaProvider<FSAPIService>(endpointClosure: endpointClosure, stubClosure: MoyaProvider.immediatelyStub)
    self.fileService = FileService(provider: provider)
  }
  
  func testRemoveExtensions() throws {
    XCTAssertEqual(self.fileService.removeExtension(fileName: "abcd.ee.txt"), "abcd.ee")
  }
  
  
  override func tearDownWithError() throws {
    self.fileService = nil
  }

}
