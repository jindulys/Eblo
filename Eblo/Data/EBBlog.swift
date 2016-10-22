//
//  EBBlog.swift
//  Eblo
//
//  Created by yansong li on 2016-10-20.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import RealmSwift
import Foundation

/// Blog Model.
class EBBlog: Object {
  dynamic var blogTitle = ""
  dynamic var blogURL = ""

  /// Extension defines String Keys.
  static let BLOGTITLE = "blogTitle"
  static let BLOGURL = "blogURL"
}
