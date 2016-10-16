//
//  Company.swift
//  Eblo
//
//  Created by yansong li on 2016-10-15.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import RealmSwift
import Foundation

class EBCompany: Object {
  dynamic var companyName = ""
  dynamic var blogURL = ""
  dynamic var UUID = ""
  dynamic var blogTitle = ""

  override static func primaryKey() -> String? {
    return "UUID"
  }
}

