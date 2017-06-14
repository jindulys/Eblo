//
//  String+Utilities.swift
//  SiYuanKit
//
//  Created by yansong li on 2017-04-15.
//
//

import Foundation

/// Parsing Extension
extension String {
  /// Suppose a string has a query like format, return the keys and values.
  /// E.g self = "company=Yelp&companyURL=https://engineeringblog.yelp.com"
  /// Return ["company" : "Yelp",
  ///         "companyURL" : "https://engineeringblog.yelp.com"]
  /// Return nil if not a valid format.
  public func queryKeysAndValues() -> [String : String]? {
    let querySeperatedArray =
      self.characters.split(separator: "&").map(String.init).map { str -> [String] in
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
  
  // TODO(simonli): use binary search to improve performance.
  public func appendTrimmedRepeatedElementString(_ sec: String) -> String {
    if self.characters.count == 0 {
      return sec
    }
    if sec.characters.count == 0 {
      return self
    }
    var potentialRepeatedEndIndex = 0
    var longestCommonPartIndex = 0
    while potentialRepeatedEndIndex < sec.characters.count {
      potentialRepeatedEndIndex += 1
      let currentPrefix = String(sec.characters.prefix(potentialRepeatedEndIndex))
      if !self.contains(currentPrefix) {
        break
      }
      if self.hasSuffix(currentPrefix) {
        longestCommonPartIndex = potentialRepeatedEndIndex
      }
    }
    let fixed = String(sec.characters.dropFirst(longestCommonPartIndex))
    return self + fixed
  }
}
