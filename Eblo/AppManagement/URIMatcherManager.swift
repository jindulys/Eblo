//
//  URIMatcherManager.swift
//  Eblo
//
//  Created by yansong li on 2016-10-29.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import UIKit

/// The URIMatcher protocol which could return the view controller if matches.
protocol URIMatcher {

  /// Match a uri and return a view controller or nil.
  static func matchURI(_ uri: URISource) -> UIViewController?

  /// Matched screen name.
  static var matchScreenName: String { get }
}

extension URIMatcher {

  /// Extension on URIMatcher, which will handle the URI with a handler.
  static func handleURI(_ uri: URISource, handler: URIHandler) -> Bool {
    guard let resolvedViewController = self.matchURI(uri) else {
      // Not find a matched view controller.
      return false
    }
    guard let paramDict = self.retreiveParamsFromURI(uri).queryKeysAndValues(),
      let actionMethod = paramDict["action"] else {
      return false
    }
    let transitionMethod = TransitionMethod.transitionMethodFor(str: actionMethod)
    if transitionMethod == TransitionMethod.UNKNOWN {
      return false
    }
    let animated = paramDict["animated"] ?? "true"
    let defaultAction: URIAction = { aggressiveViewController in
      if transitionMethod == TransitionMethod.NAV {
        if let navController = aggressiveViewController is UINavigationController ? (aggressiveViewController as? UINavigationController) : aggressiveViewController.navigationController {
          navController.pushViewController(resolvedViewController, animated: true)
        }
      } else if transitionMethod == TransitionMethod.POP {
        let animated = animated == "true"
        aggressiveViewController.present(resolvedViewController, animated: animated, completion: nil)
      }
    }
    handler(defaultAction, resolvedViewController)
    return true
  }

  /// retreive the parames part from uri.
  /// E.g Eblo/EditRecordViewController/action=navigate 
  /// return action=navigate
  static func retreiveParamsFromURI(_ uri: URISource) -> String {
    var trimmedString = uri.URI
    if let toRemoveRange = uri.URI.range(of: "Eblo/\(self.matchScreenName)/") {
      trimmedString.replaceSubrange(toRemoveRange, with: "")
    }
    return trimmedString
  }
}

/// The class to match a URI
class URIMatcherManager {
  static func matchers() -> [URIMatcher.Type] {
    return [EditRecordScreenMatcher.self,
            CompanyBlogListScreenMatcher.self]
  }
}

/// The EditRecordViewController Matcher
class EditRecordScreenMatcher: URIMatcher {
  static func matchURI(_ uri: URISource) -> UIViewController? {
    if uri.URI.hasPrefix("Eblo/\(self.matchScreenName)") {
      return EditRecordViewController()
    }
    return nil
  }

  static var matchScreenName: String {
    return "EditRecordViewController"
  }
}

/// The CompanyBlogListViewController Matcher
class CompanyBlogListScreenMatcher: URIMatcher {
  static func matchURI(_ uri: URISource) -> UIViewController? {
    if uri.URI.hasPrefix("Eblo/\(self.matchScreenName)") {
      guard let paramDict = self.retreiveParamsFromURI(uri).queryKeysAndValues(),
        let companyUUID = paramDict["uuid"] else {
          return nil
      }
      return CompanyBlogListViewController(companyUUID: companyUUID)
    }
    return nil
  }

  static var matchScreenName: String {
    return "CompanyBlogListViewController"
  }
}
