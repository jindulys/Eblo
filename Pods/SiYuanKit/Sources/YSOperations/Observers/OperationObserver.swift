//
//  OperationObserver.swift
//  SiYuanKit
//
//  Created by yansong li on 2016-07-24.
//
//

import Foundation

/**
  The protocol that types may implement if they wish to be notified of significant
  operation lifecycle events.
 */
protocol OperationObserver {
  /// Invoked immediately prior to the `Operation`'s `execute()` method.
  func operationDidStart(operation: YSOperation)
  
  /// Invoked when `Operation.produceOperation(_:)` is executed.
  func operation(operation: YSOperation, didProduceOperation newOperation: Operation)
  
  /**
    Invoked as an `Operation` finishes, along with any errors produced during execution
    (or readiness evalution).
   */
  func operationDidFinish(operation: YSOperation, errors: [Error])
}
