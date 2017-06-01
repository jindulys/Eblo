//
//  EbloCompany.swift
//  Eblo
//
//  Created by yansong li on 2017-05-31.
//  Copyright © 2017 YANSONG LI. All rights reserved.
//

import Foundation
import IGListKit

/// Class represents a company.
public final class EbloCompany {
  
  /// Blog's company name.
  public var companyName: String
  
  /// url string for this company.
  public var urlString: String
  
  /// The companyid
  public var companyID: Int
  
  public init(companyName: String,
              urlString: String,
              companyID: Int) {
    self.companyName = companyName
    self.urlString = urlString
    self.companyID = companyID
  }
}

extension EbloCompany: Unique {
  public func identifier() -> String {
    return self.companyName + self.urlString
  }
}

extension EbloCompany: ListDiffable {
  
  public func diffIdentifier() -> NSObjectProtocol {
    return self.identifier() as NSString
  }
  
  public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let other = object as? EbloCompany else {
      return false
    }
    return self.identifier() == other.identifier()
  }
}

extension EbloCompany: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "company \(self.companyName), companyURL \(self.urlString)"
  }
}
