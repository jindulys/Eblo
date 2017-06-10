//
//  EbloCompany.swift
//  Eblo
//
//  Created by yansong li on 2017-05-31.
//  Copyright © 2017 YANSONG LI. All rights reserved.
//

import Foundation
import IGListKit
import RealmSwift

/// Class represents a company.
public final class EbloCompany: Object {
  
  /// Blog's company name.
  dynamic var companyName: String = ""
  
  /// url string for this company.
  dynamic var urlString: String = ""
  
  /// The companyid
  dynamic var companyID: Int = 0
  
  /// This field is used for positioning this company object.
  dynamic var positionIndex: Int = 0
  
  /// The first blog title.
  dynamic var firstBlogTitle: String = ""
  
  /// Whether or not this company has update.
  dynamic var hasUpdated: Bool = false
  
  override public static func primaryKey() -> String? {
    return "companyID"
  }
  
  /// The ui identifier.
  public var uiIdentifier: String {
    return companyName + firstBlogTitle
  }
}

extension EbloCompany: Unique {
  public func identifier() -> String {
    return self.companyName
  }
}

extension EbloCompany: ListDiffable {
  
  public func diffIdentifier() -> NSObjectProtocol {
    return self.uiIdentifier as NSString
  }
  
  public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let other = object as? EbloCompany else {
      return false
    }
    return self.uiIdentifier == other.uiIdentifier
  }
}
