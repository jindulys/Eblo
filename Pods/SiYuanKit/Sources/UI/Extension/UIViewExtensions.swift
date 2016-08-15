//
//  UIViewExtensions.swift
//  SiYuanKit
//
//  Created by yansong li on 2016-07-31.
//
//

import Foundation

// MARK: Auto layout.
extension UIView {
  /// Add a view as subview, turn off autoresizingmask.
  public func addAutoLayoutSubView(_ view: UIView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(view)
  }
}
