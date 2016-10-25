//
//  Company.swift
//  Eblo
//
//  Created by yansong li on 2016-10-15.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import RealmSwift
import Foundation

/// Company Model.
class EBCompany: Object {
  dynamic var companyName = ""
  dynamic var blogURL = ""
  dynamic var UUID = ""
  dynamic var blogTitle = ""
  dynamic var xPathArticleTitle: String? = nil
  dynamic var xPathArticleURL: String? = nil
  dynamic var articleURLNeedBlogURL = false
  dynamic var hasNewArticlesToRead = false
  dynamic var latestArticleTitle: String? = nil
  let blogs = List<EBBlog>()

  override static func primaryKey() -> String? {
    return "UUID"
  }
}

