//
//  Promise.swift
//  SiYuanKit
//
//  Created by yansong li on 2016-07-23.
//
//
// NOTE: No dependency

import Foundation

/// Promise state.
enum PromiseState {
  case Pending
  case FulFilled
  case Rejected
}

public typealias EmptyPromise = Promise<Void>

/// Promise class with quite cool sequential feature.
/// We need class here because `Promise` is reference semantic.
public class Promise<T> {
  public typealias ResolveCallBack = (T) -> Void
  public typealias RejectCallBack = (ErrorProtocol) -> Void
  public typealias PromiseCallBack = (resolve: ResolveCallBack, reject: RejectCallBack) -> Void
  
  /// Success block to be executed on success.
  private var successBlock: ResolveCallBack = { t in }
  
  /// Failure callback.
  private var failBlock: RejectCallBack = { _ in }
  
  /// Final callback.
  private var finallyBlock: () -> Void = {}
  
  /// The main block which contains the functionality of this Promise.
  private var promiseCallBack: PromiseCallBack!
  
  /// Indicates whether or not this promise has started.
  private var promiseStarted = false
  
  /// This promise currently state.
  private var state: PromiseState = .Pending
  
  /// The result of this Promise operation.
  private var value: T?
  
  /// The error that might occur.
  private var error: ErrorProtocol?
  
  /// The preprocessed block to be executed before start.
  var prePromiseStart: (() -> Void)?
  
  /// Indicate whether or not finishing pre start process.
  var prePromiseStarted = false
  
  /// Designated Initializer.
  public init(callBack: PromiseCallBack) {
    promiseCallBack = callBack
  }
  
  /// Start this promise's operation.
  public func start() {
    promiseStarted = true
    promiseCallBack(resolve: resolvePromise, reject: rejectPromise)
  }
  
  // MARK: - then((T) -> X)
  // NOTE: because of `block` need to return something, block must be a sync operation instead of
  // async one, this is also the reason why result could be chained together in correct order.
  @discardableResult
  public func then<X>(block: (T) -> X) -> Promise<X> {
    tryPreStartPromise()
    startPromiseIfNeeded()
    return registerThen(block: block)
  }
  
  /// Register a block to produce a new Promise.
  // NOTE: the purpose is actually switch the successBlock, failBlock of current one, so that when
  // current one success, the new one could execute block and set correct
  public func registerThen<X>(block: (T) -> X) -> Promise<X> {
    let p = Promise<X>{ resolve, reject in
      switch self.state {
        case .FulFilled:
          let x: X = block(self.value!)
          resolve(x)
        case .Rejected:
          reject(self.error!)
        case .Pending:
          self.registerSuccess(resolve: resolve, block: block)
          self.failBlock = reject
      }
    }
    /**
     NOTE: The reason call start() here is it could effectively reflect updates on self.successBlock.
     */
    p.start()
    /**
     NOTE: This is the secret of how chaining achieved.
     */
    passAlongFirstPromiseStartFunctionAndStateTo(next: p)
    return p
  }
  
  // MARK: - then((T) -> Promise<X>)
  
  public func then<X>(block:(T) -> Promise<X>) -> Promise<X>{
    tryPreStartPromise()
    startPromiseIfNeeded()
    return registerThen(block: block)
  }
  
  public func registerThen<X>(block:(T) -> Promise<X>) -> Promise<X>{
    let p = Promise<X>{ resolve, reject in
      switch self.state {
      case .FulFilled:
        self.registerNextPromise(block: block, result: self.value!,resolve:resolve,reject:reject)
      case .Rejected:
        reject(self.error!)
      case .Pending:
        self.successBlock = { t in
          self.registerNextPromise(block: block, result: t,resolve:resolve,reject:reject)
        }
        self.failBlock = reject
      }
    }
    p.start()
    passAlongFirstPromiseStartFunctionAndStateTo(next: p)
    return p
  }
  
  // MARK: - then(Promise<X>)
  
  public func then<X>(p:Promise<X>) -> Promise<X>{
    return then { _ in p }
  }
  
  public func registerThen<X>(p:Promise<X>) -> Promise<X>{
    return registerThen { _ in p }
  }
  
  //MARK: - Error
  @discardableResult
  public func onError(block:(ErrorProtocol) -> Void) -> Self  {
    startPromiseIfNeeded()
    if state == .Rejected { block(error!) }
    else { failBlock = block }
    return self
  }
  
  // MARK: - Helpers
  
  private func tryPreStartPromise() {
    if !prePromiseStarted {
      prePromiseStart?()
      prePromiseStarted = true
    }
  }
  
  private func startPromiseIfNeeded() {
    if !promiseStarted { start() }
  }
  
  private func passAlongFirstPromiseStartFunctionAndStateTo<X>(next: Promise<X>) {
    if let preStartBlock = self.prePromiseStart {
      // If self is not the first Promise, propagate it.
      next.prePromiseStart = preStartBlock
    } else {
      // If set is the first promise, pass it start to next one, so next one could call start of 
      // the first one if needed.
      next.prePromiseStart = self.start
    }
    next.prePromiseStarted = self.prePromiseStarted
  }
  
  private func registerSuccess<X>(resolve:(X) -> Void, block: (T) -> X) {
    self.successBlock = { r in
      resolve(block(r))
    }
  }
  
  private func registerNextPromise<X>(block:(T) -> Promise<X>,
                                     result:T,
                                    resolve:(X) -> Void,
                                     reject:RejectCallBack) {
    let nextPromise:Promise<X> = block(result)
    nextPromise.then { x in
      resolve(x)
    }.onError(block: reject)
  }
  
  /// Called on success
  private func resolvePromise(result: T) {
    state = .FulFilled
    value = result
    successBlock(result)
    finallyBlock()
  }
  
  /// Called on failure
  private func rejectPromise(e: ErrorProtocol) {
    state = .Rejected
    error = e
    failBlock(e)
    finallyBlock()
  }
}
