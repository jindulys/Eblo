//
//  EbloBlog.swift
//  Eblo
//
//  Created by yansong li on 2017-05-28.
//  Copyright © 2017 YANSONG LI. All rights reserved.
//

import Foundation
import IGListKit
import RealmSwift

/// Class represents a blog.
public final class EbloBlog: Object {

  /// Title for this blog.
  dynamic var title: String = ""
  
  /// url string for this blog.
  dynamic var urlString: String = ""
  
  /// Blog's company name.
  dynamic var companyName: String = ""
  
  /// the author name.
  dynamic var authorName: String = ""
  
  /// the author avatar url.
  dynamic var authorAvatar: String = ""
  
  /// the publish date.
  dynamic var publishDate: String = ""
  
  /// The publish date time interval.
  dynamic var publishDateInterval: Double = 0.0
  
  /// Whether or not this blog get favourited.
  dynamic var favourite: Bool = false
  
  /// The blogID.
  dynamic var blogID: Int = 0
  
  /// The company's id, which this blog belongs to.
  dynamic var companyID: String = ""
  
  override public static func primaryKey() -> String? {
    return "blogID"
  }
}

extension EbloBlog: Unique {
  public func identifier() -> String {
    return self.title + self.companyName
  }
}

extension EbloBlog: ListDiffable {
  
  public func diffIdentifier() -> NSObjectProtocol {
    return self.identifier() as NSString
  }
  
  public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let other = object as? EbloBlog else {
      return false
    }
    return self.identifier() == other.identifier()
  }
}
