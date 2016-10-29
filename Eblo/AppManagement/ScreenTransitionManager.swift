//
//  ScreenTransitionManager.swift
//  Eblo
//
//  Created by yansong li on 2016-10-29.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import Foundation

/// The protocol defines a transition view controller.
protocol TransitionViewController {
  var sourceScreenName: String { get }
}

enum TransitionMethod: String {
  case navigate = "navigate"
  case present = "present"
}

/// A manager whose responsibility is to generate the path for screen transition.
class ScreenTransitionManager {
  /// Transition Routes Table all the transition management are here.
  static let transitionRoutesTable =
    [ "MainViewController" :
        ["companyBlogList" : (TransitionMethod.navigate, "EditRecordViewController"),
         "editRecord" : (TransitionMethod.present, "EditRecordViewController")]
  ]

  /// Transition screen with source view controller, entryPoint, and params.
  public static func transitionScreenWith<T: TransitionViewController>(viewController: T,
                                   entryPoint: String,
                                   params: String? = nil) -> String? {
    guard let routesTable =
      self.transitionRoutesTable[viewController.sourceScreenName],
      let (transitionMethod, toViewController) = routesTable[entryPoint] else {
      return nil
    }
    var baseURI = "Eblo/"
    // NOTE: append destination view controller name.
    baseURI.append("\(toViewController)/")
    // NOTE: append action.
    baseURI.append("action=\(transitionMethod.rawValue)")
    if let passedParams = params {
      baseURI.append(passedParams)
    }
    return baseURI
  }
}
