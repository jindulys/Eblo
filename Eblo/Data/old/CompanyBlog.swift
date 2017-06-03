//
//  CompanyBlog.swift
//  Eblo
//
//  Created by yansong li on 2016-10-20.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import RealmSwift
import Foundation

/// Blog Model.
class CompanyBlog: Object {
  dynamic var blogTitle = ""
  dynamic var blogURL = ""
  // Primary Key, an auto-incremented key.
  dynamic var blogID = 0

  override class func primaryKey() -> String? {
    return "blogID"
  }

  /// Extension defines String Keys.
  static let BLOGTITLE = "blogTitle"
  static let BLOGURL = "blogURL"
}
