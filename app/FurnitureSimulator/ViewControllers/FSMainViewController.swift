//
//  ViewController.swift
//  FurnitureSimulator
//
//  Created by doremin on 2023/01/04.
//

import UIKit

import ARKit
import SceneKit.ModelIO
import Moya

final class FSMainViewController: UIViewController {
  
  // MARK: UI
  private let mainView = ARSCNView()
  
  private let planeDetectingView = PlaneDetectingView()
  
  private lazy var removeButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .white
    button.layer.cornerRadius = 15
    button.setTitle("Remove", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.isHidden = true
    button.addTarget(self, action: #selector(self.removeButtonTapped), for: .touchUpInside)
    
    return button
  }()
  
  private lazy var furnitureListButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .white
    button.layer.cornerRadius = 20
    button.setTitle("Furnitures", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(self.furnitureListButtonTapped), for: .touchUpInside)
    
    return button
  }()
  
  // MARK: Properties
  private var selectedNode: SCNNode? {
    didSet {
      SCNTransaction.animationDuration = 0.3
      oldValue?.position.y -= 0.05
      
      self.selectedNode?.position.y += 0.05
      
      self.removeButton.isHidden = self.selectedNode == nil
    }
  }
  
  private var targetNode: SCNNode? = nil
  
  // MARK: Dependencies
  private let fileService: FileService
  
  // MARK: Initialize
  init(fileService: FileService) {
    self.fileService = fileService
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: View Controller Life Cycle
  override func loadView() {
    self.view = self.mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let configuration = ARWorldTrackingConfiguration()
    configuration.planeDetection = [.horizontal]
    self.mainView.delegate = self
    self.mainView.session.run(configuration)
    
    self.attatchGestureRecognizers()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    self.mainView.addSubview(self.planeDetectingView)
    self.mainView.addSubview(self.removeButton)
    self.mainView.addSubview(self.furnitureListButton)
    
    self.planeDetectingView.pin.all()
    self.removeButton.pin.hCenter().top(self.view.pin.safeArea.top).width(100).height(30)
    self.furnitureListButton.pin.hCenter().bottom(self.view.pin.safeArea.bottom).width(150).height(40)
  }
  
  // MARK: Actions
  func attatchGestureRecognizers() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.mainViewTapped(sender:)))
    let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(self.rotateObject(sender:)))
    let pangestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.translateObject(sender:)))
    let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.scaleObject(sender:)))
    
    self.mainView.addGestureRecognizer(tapGestureRecognizer)
    self.mainView.addGestureRecognizer(rotationGestureRecognizer)
    self.mainView.addGestureRecognizer(pangestureRecognizer)
    self.mainView.addGestureRecognizer(pinchGestureRecognizer)
  }
  
  private func radianToDegrees(radian: CGFloat) -> CGFloat {
    return 180 / CGFloat.pi * radian
  }
  
  @objc func furnitureListButtonTapped() {
    let furnitureListViewController = FurnitureListViewController(fileService: self.fileService)
    furnitureListViewController.modalPresentationStyle = .formSheet
    furnitureListViewController.onDismiss = { [weak self] model in
      guard let self = self else { return }
      self.targetNode = self.fileService.loadModel(url: model.objURL)
    }
    
    self.present(furnitureListViewController, animated: true)
  }
 
  @objc func removeButtonTapped() {
    guard let node = self.selectedNode else {
      return
    }
    
    self.selectedNode = nil
    node.removeFromParentNode()
  }
  
  @objc func scaleObject(sender: UIPinchGestureRecognizer) {
    guard let node = self.selectedNode else {
      return
    }
  
    node.scale = SCNVector3(sender.scale * 0.1, sender.scale * 0.1, sender.scale * 0.1)
  }
  
  @objc func rotateObject(sender: UIRotationGestureRecognizer) {
    guard let node = self.selectedNode else {
      return
    }
    
    node.eulerAngles = SCNVector3(0, -sender.rotation, 0)
  }
  
  @objc func translateObject(sender: UIPanGestureRecognizer) {
    guard let node = self.selectedNode else {
      return
    }
    
    guard let query =  self.mainView.raycastQuery(
      from: sender.location(in: self.mainView),
      allowing: .existingPlaneGeometry,
      alignment: .horizontal
    ) else {
      return
    }
    
    guard let result = self.mainView.session.raycast(query).first else {
      return
    }
    
    let thirdColumn = result.worldTransform.columns.3
    let position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)
    node.worldPosition = position
    
//    node.localTranslate(by: SCNVector3(result.worldCoordinates.x, result.worldCoordinates.y, 0))
  }
  
  @objc func mainViewTapped(sender: UITapGestureRecognizer) {
    let location = sender.location(in: self.mainView)
    
    guard let query = self.mainView.raycastQuery(from: location, allowing: .existingPlaneGeometry, alignment: .horizontal) else {
      return
    }
    
    guard let result = self.mainView.session.raycast(query).first else {
      return
    }
    
    guard let hitTestResult = self.mainView.hitTest(location).first else {
      if self.selectedNode == nil {
        addItem(raycastResult: result)
      } else {
        selectedNode = nil
      }
      
      return
    }
    
    guard self.selectedNode != hitTestResult.node else {
      self.selectedNode = nil
      return
    }

    self.selectedNode = hitTestResult.node
  }
  
  func addItem(raycastResult: ARRaycastResult) {
    guard let node = self.targetNode else { return }
    
    let transform = raycastResult.worldTransform
    
    let column = transform.columns.3
    
    node.position = SCNVector3(x: column.x, y: column.y, z: column.z)
    self.mainView.scene.rootNode.addChildNode(node)
  }
}

extension FSMainViewController: ARSCNViewDelegate {
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard anchor is ARPlaneAnchor else { return }
    
    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.3, animations: {
        self.planeDetectingView.alpha = 0.0
      }) { _ in
        self.planeDetectingView.removeFromSuperview()
      }
    }
  }
  
}
