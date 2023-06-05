//
//  FurnitureTableViewCell.swift
//  FurnitureSimulator
//
//  Created by doremin on 2023/06/06.
//

import UIKit

import PinLayout

final class FurnitureTalbeViewCell: UITableViewCell {
  
  static var reuseIdentifier = "FurnitureTalbeViewCell"
  
  // MARK: UI
  private var label: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14)
    label.textColor = .black
    label.textAlignment = .center
    
    return label
  }()
  
  private var thumbnailView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    
    return imageView
  }()
  
  // MARK: Properties
  var furnitureModel: FurnitureModel? {
    willSet {
      self.label.text = FileService.removeExtension(fileName: newValue?.objURL.lastPathComponent ?? "")
      DispatchQueue.global().async {
        let data = try? Data(contentsOf: newValue!.thumbnailURL)
        DispatchQueue.main.async {
          self.thumbnailView.image = UIImage(data: data!)
        }
      }
    }
  }
  
  // MARK: Initializer
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.contentView.addSubview(self.label)
    self.contentView.addSubview(self.thumbnailView)
    self.backgroundColor = .white
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    self.label.text = nil
    
    super.prepareForReuse()
  }
  
  private func layout() {
    self.thumbnailView.pin.vCenter().size(CGSize(width: 100, height: 100)).left(30)
    self.label.pin.vCenter().right(30).size(CGSize(width: 100, height: 20))
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    layout()
  }
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    contentView.pin.width(size.width)
    layout()
    
    return CGSize(width: contentView.frame.width, height: 150)
  }
  
}
