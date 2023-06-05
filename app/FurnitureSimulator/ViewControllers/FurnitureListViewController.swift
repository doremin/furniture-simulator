//
//  FurnitureListViewController.swift
//  FurnitureSimulator
//
//  Created by doremin on 2023/05/30.
//

import UIKit

import Moya

final class FurnitureListViewController: UIViewController {
  
  // MARK: UI
  
  // MARK: Properties
  private let fileService: FileService
  private let furnitureModels: [FurnitureModel]
  
  // MARK: Initialize
  init(fileService: FileService) {
    self.fileService = fileService
    self.furnitureModels = self.fileService.loadModels()
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: View Controller Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .white
    print(fileService.loadModels())
  }
}
