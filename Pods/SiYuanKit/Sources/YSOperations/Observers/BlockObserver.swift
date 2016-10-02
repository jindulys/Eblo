//
//  BlockOperation.swift
//  SiYuanKit
//
//  Created by yansong li on 2016-07-24.
//
//

import Foundation

/**
  The `BlockObserver` is a way to attach arbitrary blocks to significant events in an 
 `Operation`'s lifecycle.
 */
struct BlockObserver: OperationObserver {
  // MARK: Properties
  
  private let startHandler: ((YSOperation) -> Void)?
  private let produceHandler: ((YSOperation, Operation) -> Void)?
  private let finishHandler: ((YSOperation, [Error]) -> Void)?
  
  init(startHandler: ((YSOperation) -> Void)? = nil,
       produceHandler: ((YSOperation, Operation) -> Void)? = nil,
       finishHandler:((YSOperation, [Error]) -> Void)? = nil) {
    self.startHandler = startHandler
    self.produceHandler = produceHandler
    self.finishHandler = finishHandler
  }
  
  // MARK: OperationObserver
  
  func operationDidStart(operation: YSOperation) {
    self.startHandler?(operation)
  }
  
  func operation(operation: YSOperation, didProduceOperation newOperation: Operation) {
    self.produceHandler?(operation, newOperation)
  }
  
  func operationDidFinish(operation: YSOperation, errors: [Error]) {
    self.finishHandler?(operation, errors)
  }
}
