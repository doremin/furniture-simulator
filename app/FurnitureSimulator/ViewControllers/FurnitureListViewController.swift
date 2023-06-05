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
  private let tableView = UITableView()
  
  // MARK: Properties
  private let fileService: FileService
  private let furnitureModels: [FurnitureModel]
  var onDismiss: ((FurnitureModel) -> Void)?
  
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
    self.view.addSubview(self.tableView)
    
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.register(FurnitureTalbeViewCell.self, forCellReuseIdentifier: FurnitureTalbeViewCell.reuseIdentifier)
    self.tableView.backgroundColor = .white
    self.tableView.estimatedRowHeight = 150
    
    self.tableView.pin.all()
  }
}

extension FurnitureListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.onDismiss?(self.furnitureModels[indexPath.row])
    self.dismiss(animated: true)
  }
}

extension FurnitureListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: FurnitureTalbeViewCell.reuseIdentifier) as? FurnitureTalbeViewCell else {
      return UITableViewCell()
    }
    
    cell.furnitureModel = self.furnitureModels[indexPath.row]
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.furnitureModels.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}
