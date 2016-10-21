//
//  OperationQueue.swift
//  SiYuanKit
//
//  Created by yansong li on 2016-07-17.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import Foundation

@objc public protocol YSOperationQueueDelegate: NSObjectProtocol {
  @objc optional func operationQueue(operationQueue: YSOperationQueue, willAddOperation: Operation)
  @objc optional func operationQueue(operationQueue: YSOperationQueue,
                               operationDidFinish operation: Operation,
                               withErrors errors: [Error])
}

/**
  `YSOperationQueue` is an `OperationQueue` subclass that implements a large
  number of "extra features" related to the `YSOperation` class:
 
  - Notifying a delegate of all operation completion
  - Extracting generated dependencies from operation conditions
  - Setting up dependencies to enforce mutual exclusivity
 */
public class YSOperationQueue: OperationQueue {

  public weak var delegate: YSOperationQueueDelegate?
  
  public override func addOperation(_ op: Operation) {
    if let op = op as? YSOperation {
      let delegate = BlockObserver(startHandler: nil,
                                   produceHandler: { [weak self] in
                                     self?.addOperation($1)
                                   },
                                   finishHandler: nil)
      op.addObserver(observer: delegate)
      
      let dependenciesFromConditions = op.conditions.flatMap {
        $0.dependencyFor(operation:op)
      }
      
      for dependency in dependenciesFromConditions {
        op.addDependency(dependency)
        self.addOperation(dependency)
      }
      
      let concurrencyCategories: [String] = op.conditions.flatMap { condition in
        if !condition.isMutuallyExclusive { return nil }
        return "\(type(of: condition))"
      }
      if !concurrencyCategories.isEmpty {
        let exclusivityController = ExclusivityController.sharedExclusivityController
        exclusivityController.add(operation: op, categories: concurrencyCategories)
        op.addObserver(observer: BlockObserver { operation, _ in
            ExclusivityController.sharedExclusivityController.remove(operation: operation, categories: concurrencyCategories)
        })
      }
      op.willEnqueue()
    } else {
      op.addCompletionBlock { [weak self, weak op] in
        // TODO(simonli): notify delegate about the completion of this operation
        guard let queue = self, let operation = op else {
          return
        }
        queue.delegate?.operationQueue?(operationQueue: queue,
          operationDidFinish: operation,
          withErrors: [])
        operation.dependencies.forEach {
          operation.removeDependency($0)
        }
      }
    }
    delegate?.operationQueue?(operationQueue: self, willAddOperation: op)
    super.addOperation(op)
  }
}
