//
//  EbloBlog.swift
//  Eblo
//
//  Created by yansong li on 2017-05-28.
//  Copyright © 2017 YANSONG LI. All rights reserved.
//

import Foundation
import IGListKit

/// Class represents a blog.
public final class EbloBlog {

  /// Title for this blog.
  public var title: String
  
  /// url string for this blog.
  public var urlString: String
  
  /// Blog's company name.
  public var companyName: String
  
  /// the author name.
  public var authorName: String
  
  /// the author avatar url.
  public var authorAvatar: String
  
  /// the publish date.
  public var publishDate: String
  
  /// The publish date time interval.
  public var publishDateInterval: Double
  
  public init(title: String,
              urlString: String,
              companyName: String,
              authorName: String = "",
              authorAvatar: String = "",
              publishDate: String = "",
              publishDateInterval: Double = 0.0) {
    self.title = title
    self.urlString = urlString
    self.companyName = companyName
    self.authorAvatar = authorAvatar
    self.authorName = authorName
    self.publishDate = publishDate
    self.publishDateInterval = publishDateInterval
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

extension EbloBlog: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "title \(self.title), companyName \(self.companyName)"
  }
}

