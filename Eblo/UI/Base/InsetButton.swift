//
//  InsetButton.swift
//  Eblo
//
//  Created by yansong li on 2017-06-04.
//  Copyright © 2017 YANSONG LI. All rights reserved.
//

import UIKit
import SiYuanKit

/// A button can set inset around image
class InsetButton: UIButton {
  
  /// The image view.
  var innerImageView: UIImageView {
    didSet {
      self.buildConstraints()
    }
  }
  
  /// The inset around an image.
  let contentInset: UIEdgeInsets
  
  /// The image size.
  let imageSize: CGSize
  
  init(image:UIImage, contentInset: UIEdgeInsets, imageSize: CGSize) {
    self.innerImageView = UIImageView()
    self.innerImageView.contentMode = .scaleAspectFit
    self.innerImageView.image = image

    self.contentInset = contentInset
    self.imageSize = imageSize

    super.init(frame: CGRect.zero)
    self.addAutoLayoutSubView(self.innerImageView)
    self.buildConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func buildConstraints() {
    self.innerImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                 constant: self.contentInset.left).isActive = true
    self.innerImageView.topAnchor.constraint(equalTo: self.topAnchor,
                                             constant: self.contentInset.top).isActive = true
    self.innerImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                  constant: -self.contentInset.right).isActive = true
    self.innerImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                constant: -self.contentInset.bottom).isActive = true
    self.innerImageView.widthAnchor.constraint(equalToConstant: self.imageSize.width).isActive = true
    self.innerImageView.heightAnchor.constraint(equalToConstant: self.imageSize.height).isActive = true
  }
}

