//
//  ColorCornerView.swift
//  Eblo
//
//  Created by yansong li on 2016-11-06.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import UIKit

/// The colored corner location.
enum ColoredCornerLocation: Int {
  case topRight = 1, bottomRight, topLeft, bottomLeft
}

/// A view with a colored corner.
class ColorCornerView: UIView {

  /// Color for the colored corner.
  let color: UIColor

  /// Position for the colored corner.
  let coloredPosition: ColoredCornerLocation
  
  /// The size of the triangle.
  let triangleSize: CGFloat
  
  init(color: UIColor, position: ColoredCornerLocation, triangleSize: CGFloat = 50.0) {
    self.color = color
    self.coloredPosition = position
    self.triangleSize = triangleSize
    super.init(frame: CGRect.zero)
    self.backgroundColor = UIColor.clear
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UIView
  
  override func draw(_ rect: CGRect) {
    let trianglePath = UIBezierPath()
    switch coloredPosition {
    case .topRight:
      trianglePath.move(to: CGPoint(x: bounds.width - triangleSize, y: 0))
      trianglePath.addLine(to: CGPoint(x: bounds.width, y: 0))
      trianglePath.addLine(to: CGPoint(x: bounds.width, y: triangleSize))
      trianglePath.close()
    case .topLeft:
      trianglePath.move(to: CGPoint(x: 0, y: 0))
      trianglePath.addLine(to: CGPoint(x: triangleSize, y: 0))
      trianglePath.addLine(to: CGPoint(x: 0, y: triangleSize))
      trianglePath.close()
    case .bottomRight:
      trianglePath.move(to: CGPoint(x: bounds.width, y: bounds.height - triangleSize))
      trianglePath.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
      trianglePath.addLine(to: CGPoint(x: bounds.width - triangleSize, y: bounds.height))
      trianglePath.close()
    case .bottomLeft:
      trianglePath.move(to: CGPoint(x: 0, y: bounds.height - triangleSize))
      trianglePath.addLine(to: CGPoint(x: 0, y: bounds.height))
      trianglePath.addLine(to: CGPoint(x: triangleSize, y: bounds.height))
      trianglePath.close()
    }
    self.color.setFill()
    trianglePath.fill()
  }
}
