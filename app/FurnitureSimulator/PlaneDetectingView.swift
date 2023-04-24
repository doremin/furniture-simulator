//
//  PlaneDetectingView.swift
//  FurnitureSimulator
//
//  Created by doremin on 2023/03/15.
//

import UIKit

import PinLayout

final class PlaneDetectingView: UIView {
  
  private let detectingLabel: UILabel = {
    let label = UILabel()
    label.text = "Detecting Plane ..."
    label.font = .systemFont(ofSize: 15)
    label.textColor = .white
    label.textAlignment = .center
    
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    self.backgroundColor = UIColor(rgb: 0x000000).withAlphaComponent(0.8)
    self.addSubview(self.detectingLabel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.detectingLabel.pin.horizontally().height(100).vCenter()
  }
}
