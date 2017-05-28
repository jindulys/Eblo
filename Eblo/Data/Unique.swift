//
//  Unique.swift
//  Eblo
//
//  Created by yansong li on 2017-05-28.
//  Copyright © 2017 YANSONG LI. All rights reserved.
//

import Foundation

/// Protocol for object with unique identifier.
public protocol Unique {
  associatedtype Key: CustomStringConvertible
  func identifier() -> Key
}

extension Unique {
  public func string() -> String {
    return String(describing: identifier())
  }
}
