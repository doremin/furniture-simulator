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
  private let provider: MoyaProvider<FSAPIService>
  
  // MARK: Initialize
  init(provider: MoyaProvider<FSAPIService>) {
    self.provider = provider
    
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: View Controller Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .white
  }
}
