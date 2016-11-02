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
  
  static func concatenateTwoStringWithoutRepeatedCharactersAtTheJointPoint(firstString: String,
                                                                           secondeString: String) -> String {
    if firstString.characters.count == 0 {
      return secondeString
    }
    if secondeString.characters.count == 0 {
      return firstString
    }
    var potentialRepeatedEndIndex = 1
    var findPotentialEnd = false
    while potentialRepeatedEndIndex <= secondeString.characters.count {
      let currentPrefix = String(secondeString.characters.prefix(potentialRepeatedEndIndex))
      if !firstString.hasSuffix(currentPrefix) && findPotentialEnd {
        potentialRepeatedEndIndex -= 1
        break
      } else if potentialRepeatedEndIndex != 1 && firstString.hasSuffix(currentPrefix) {
        findPotentialEnd = true
      }
      potentialRepeatedEndIndex += 1
    }
    if findPotentialEnd == false {
      potentialRepeatedEndIndex = 1
    }
    let fixed = String(secondeString.characters.dropFirst(potentialRepeatedEndIndex))
    return firstString + fixed
  }
  
  func appendTrimmedRepeatedElementString(_ sec: String) -> String {
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

extension String: URISource {
  public var URI: String {
    return self
  }
}
