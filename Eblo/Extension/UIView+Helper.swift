//
//  UIView+Helper.swift
//  Eblo
//
//  Created by yansong li on 2017-06-04.
//  Copyright © 2017 YANSONG LI. All rights reserved.
//

import UIKit

extension UIView {
  
  /// Return the screen scale 1px.
  static func screenScale() -> CGFloat {
    return 1.0 / UIScreen.main.scale
  }
  
}
