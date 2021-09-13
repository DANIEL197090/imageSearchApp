//
//  ImageCollectionViewCell.swift
//  searchImages
//
//  Created by Decagon on 13/09/2021.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
  
  static let identifier = "ImageCollectionViewCell"
  private var imageView: UIImageView = {
    let img = UIImageView()
    img.clipsToBounds = true
    img.contentMode = .scaleAspectFill
    return img
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(imageView)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    imageView.frame = contentView.bounds
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
  }
  
  func configure(with urlString: String){
    guard let url = URL(string: urlString) else {
      return
    }
    
    URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      guard let data = data , error == nil else {
        return
      }
      
      DispatchQueue.main.async {
        let image = UIImage(data: data)
        self?.imageView.image = image
      }
    }.resume()
  }
  
}
