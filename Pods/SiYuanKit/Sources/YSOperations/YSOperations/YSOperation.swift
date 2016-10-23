//
//  YSOperation.swift
//  SiYuanKit
//
//  Created by yansong li on 2016-07-16.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import Foundation

/**
  The State enum which defines state an operation could be in.
 */
private enum State: Int, Comparable {
  /// The initial state of an `Operation`.
  case Initialized
  
  /// The `Operation` is ready to begin evaluating conditions.
  case Pending
  
  /// The `Operation` is evaluating conditions.
  case EvaluatingConditions
  
  /// The `Operation`'s conditions have all been satisfied, and it is ready to execute.
  case Ready
  
  /// The `Operation` is executing.
  case Executing
  
  /// Execution of the `Operation` has finished, but it has not yet notified the queue of this.
  case Finishing
  
  /// The `Operation` has finished executing.
  case Finished
  
  func canTransitionTo(state target: State) -> Bool {
    switch (self, target) {
    case (.Initialized, .Pending):
      return true
    case (.Pending, .EvaluatingConditions):
      return true
    case (.EvaluatingConditions, .Ready):
      return true
    case (.Ready, .Executing):
      return true
    case (.Executing, .Finishing):
      return true
    case (.Finishing, .Finished):
      return true
    default:
      return false
    }
  }
}

private func <(lhs: State, rhs: State) -> Bool {
  return lhs.rawValue < rhs.rawValue
}

private func ==(lhs: State, rhs: State) -> Bool {
  return lhs.rawValue == rhs.rawValue
}

/**
  The subclass of `Operation` from which all other operations should be derived.
  This class adds both Conditions and Observers, which allow the operation to define
  extended readiness requirements, as well as notify many interested parties about
  interesting operation state changes
 */
open class YSOperation: Operation {
  
  // use the KVO mechanism to indicate that changes to "state" affect other properties as well.
  class func keyPathsForValuesAffectingIsReady() -> Set<NSObject> {
    return ["state" as NSString]
  }
  
  class func keyPathsForValuesAffectingIsExecuting() -> Set<NSObject> {
    return ["state" as NSString]
  }
  
  class func keyPathsForValuesAffectingIsFinished() -> Set<NSObject> {
    return ["state" as NSString]
  }
  
  /// Private storage for the `state` property that will be KVO observed.
  private var _state = State.Initialized
  
  /// A lock to guard reads and writes to the `_state` property.
  private let stateLock = NSLock()

  /// Internal Errors
  private var _internalErrors = [Error]()
  
  /// The computed variable of current state.
  private var state: State {
    get {
      return stateLock.withCriticalScope {_state}
    }
    
    set(newState) {
      /**
        It's important to note that the KVO notifications are NOT called from inside 
        the lock. If they were, the app would deadlock, because in the middle of calling the
        `didChangeValueForKey()` method, the observers try to access properties like "isReady"
        or "isFinished". Since those methods also acquire the lock, then we'd be stuck waiting
        on our own lock. It's the classic definition of deadlock.
       */
      willChangeValue(forKey: "state")
      stateLock.withCriticalScope {
        guard self._state != .Finished else {
          return
        }
        assert(_state.canTransitionTo(state: newState),
               "Performing invalid state transition.")
        self._state = newState
      }
      didChangeValue(forKey: "state")
    }
  }
  
  /// Indicates that the Operation can now begin to evaluate readiness conditions, if appropriate.
  func willEnqueue() -> Void {
    self.state = .Pending
  }
  
  // Here is where we extend our definition of "readiness".
  open override var isReady: Bool {
    switch state {
    case .Initialized:
      // If the operation has been cancelled, "isReady" should return true.
      return isCancelled
      
    case .Pending:
      // if the operation has been cancellled, "isReady" should return true.
      guard !isCancelled else {
        return true
      }
      
      // If super isReady, conditions can be evaluated.
      if super.isReady {
        evaluateConditions()
      }
      
      return false
      
    case .Ready:
      return super.isReady || isCancelled
      
    default:
      return false
    }
  }
  
  open override var isExecuting: Bool {
    return state == .Executing
  }
  
  open override var isFinished: Bool {
    return state == .Finished
  }
  
  /// Evaluate current operation conditions.
  private func evaluateConditions() {
    assert(state == .Pending && !isCancelled, "")
    self.state = .EvaluatingConditions
    OperationConditionEvaluator.evaluate(conditions: conditions,
                                         operation: self) { errors in
      self._internalErrors.append(contentsOf: errors)
      self.state = .Ready
    }
  }
  
  private(set) var conditions = [OperationCondition]()
  
  /// Add \a condition for this operation.
  open func add(condition: OperationCondition) {
    assert(state < .EvaluatingConditions,"Cannot modify conditions after execution has begun.")
    conditions.append(condition)
  }
  
  private(set) var observers = [OperationObserver]()
  
  open func addObserver(observer: OperationObserver) {
    assert(state < .Executing, "Cannot modify observers after execution has begun.")
    observers.append(observer)
  }
  
  
  /// Cancel this operation with \a error.
  open func cancelWithError(error: Error? = nil) {
    if let error = error {
      _internalErrors.append(error)
    }
    cancel()
  }
  
  // MARK: Execution and Cancellation
  
  open override func start() {
    // NSOperation.start() contains important logic that shouldn't be bypassed.
    super.start()
    
    // If the operation has been cancelled, we still nedd to enter the "Finished" state.
    if self.isCancelled {
      finish()
    }
  }
  
  open override func main() {
    assert(state == .Ready, "This operation must be performed on an operation queue.")
    state = .Executing
    if _internalErrors.isEmpty && !self.isCancelled {
      observers.forEach { observer in
        observer.operationDidStart(operation: self)
      }
      self.execute()
    } else {
      finish()
    }
  }
  
  /**
    `execute()` is the entry point of execution for all `Operation` subclasses.
    If you subclass `Operation` and wish to customize its execution, you would
    do so by overriding the `execute()` method.
   
    At some point, your `Operation` subclass must call one of the "finish"
    methods defined below; this is how you indicate that your operation has
    finished its execution, and that operations dependent on yours can re-evaluate
    their readiness state.
   */
  open func execute() {
    print("\(type(of: self)) must override `execute()`")
    finish()
  }
  
  private var hasFinishedAlready = false
  
  /// finish method need to be called when you finish.
  public final func finish(errors: [Error] = []) {
    if !hasFinishedAlready {
      hasFinishedAlready = true
      state = .Finishing
      let combinedErrors = _internalErrors + errors
      finished(errors: combinedErrors)
      observers.forEach { observer in
        observer.operationDidFinish(operation: self, errors: combinedErrors)
      }
      state = .Finished
    }
  }

  public final func produceOperation(operation: Operation) {
    for observer in observers {
      observer.operation(operation: self, didProduceOperation: operation)
    }
  }

  /**
    Subclasses may override `finished(_:)` if they wish to react to the operation
    finishing with errors. For example, the `LoadModelOperation` implements
    this method to potentially inform the user about an error when trying to
    bring up the Core Data stack.
   */
  func finished(errors: [Error]) {
    // No op.
  }
}

/**
  A common error type for YSOperations.
 */
public enum YSOperationError: Error {
  /// Indicates that a condition of the Operation failed.
  case conditionFailed
}

extension Operation {
  public func addCompletionBlock(_ block: @escaping (Void) -> Void) {
    if let existing = completionBlock {
      completionBlock = {
        block()
        existing()
      }
    } else {
      completionBlock = block
    }
  }
}

extension NSLock {
  func withCriticalScope<T>( _ block: () -> T) -> T {
    self.lock()
    let result = block()
    self.unlock()
    return result
  }
}
