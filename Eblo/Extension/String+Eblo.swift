//
//  String+Parse.swift
//  Eblo
//
//  Created by yansong li on 2016-10-29.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import Foundation

/// Parsing Extension
extension String {
  /// Suppose a string has a query like format, return the keys and values.
  /// E.g self = "company=Yelp&companyURL=https://engineeringblog.yelp.com"
  /// Return ["company" : "Yelp",
  ///         "companyURL" : "https://engineeringblog.yelp.com"]
  /// Return nil if not a valid format.
  func queryKeysAndValues() -> [String : String]? {
    let querySeperatedArray =
      self.characters.split(separator: "&").map(String.init).map { (str) -> [String] in
        return str.characters.split(separator: "=").map(String.init)
    }
    if querySeperatedArray.count == 0 {
      return nil
    }
    var queryDicts = [String : String]()
    for arr in querySeperatedArray {
      if arr.count != 2 {
        return nil
      }
      queryDicts[arr[0]] = arr[1]
    }
    return queryDicts
  }
}

extension String: URISource {
  public var URI: String {
    return self
  }
}
