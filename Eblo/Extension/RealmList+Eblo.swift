//
//  RealmList+Eblo.swift
//  Eblo
//
//  Created by yansong li on 2017-06-02.
//  Copyright © 2017 YANSONG LI. All rights reserved.
//

import Foundation
import RealmSwift

extension Results {
  
  /// Convert list to an array.
  func toArray() -> [T] {
    var result: [T] = []
    self.forEach { element in
      result.append(element)
    }
    return result
  }
}
