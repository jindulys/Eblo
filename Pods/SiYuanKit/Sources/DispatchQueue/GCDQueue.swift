//
//  GCDQueue.swift
//  SiYuanKit
//
//  Created by yansong li on 2016-07-21.
//
//
// NOTE: No dependency

import Foundation

public enum GCDQueue: Comparable {
  /// The main queue
  case main

  /// The default QOS
  case `default`

  /// Use for user initiated tasks which do not impact the UI. Such as data processing.
  case initiated

  /// Use for user initiated tasks which do impact the UI - e.g. a rendering pipeline.
  case interactive

  /// Use for non-user initiated task.
  case utility

  /// Background QOS is a severly limited class, should not be used for anything
  /// when the app is active.
  case background

  /// A serial queue, with a name and QOS class.
  indirect case serial(String, GCDQueue)

  /// A concurrent queue, which a name and QOS class.
  indirect case concurrent(String, GCDQueue)

  /// DummySerial queue for comparison.
  private var dummySerial: GCDQueue {
    return .serial("dummy", .background)
  }

  /// DummyConcurrent queue for comparison.
  private var dummyConcurrent: GCDQueue {
    return .concurrent("dummy", .background)
  }

  /// queue attribute.
  private var qos_attributes: DispatchQueueAttributes {
    switch self {
    case .initiated:
      return .qosUserInitiated
    case .interactive:
      return .qosUserInteractive
    case .utility:
      return .qosUtility
    case .background:
      return .qosBackground
    default:
      return .qosDefault
    }
  }

  /// global queue attribute.
  private var qos_global_attributes: DispatchQueue.GlobalAttributes {
    switch self {
    case .initiated:
      return .qosUserInitiated
    case .interactive:
      return .qosUserInteractive
    case .utility:
      return .qosUtility
    case .background:
      return .qosBackground
    default:
      return .qosDefault
    }
  }

  /// The DispatchQueue.
  public var queue: DispatchQueue {
    switch self {
    case .main:
      return .main
    case .interactive, .initiated, .background, .utility:
      return DispatchQueue.global(attributes: qos_global_attributes)
    case let .serial(name, qos) where qos < dummySerial:
      return DispatchQueue(label: name, attributes: [.serial, qos_attributes])
    case let .concurrent(name, qos) where qos < dummyConcurrent:
      return DispatchQueue(label: name, attributes: [.concurrent, qos_attributes])
    default:
      return .main
    }
  }

  // TODO(simonli): for now only support async with work block, the other potential
  // parameters use Default value.
  /**
    Async takes a block parameter and run asynchronously.
    
    - parameter execute: the block to be executed.
  */
  public func async(execute: () -> Void) {
    self.queue.async(execute: execute)
  }

  /**
   Sync takes a block parameter and run asynchronously.
   - NOTE: carefully use sync, do not sync on serial queue.
   
   - parameter execute: the block to be executed.
   */
  public func sync(execute: () -> Void) {
    self.queue.sync(execute: execute)
  }

  public func after(when: Double, execute: () -> Void) {
    let delayTime = DispatchTime.now() + when
    self.queue.after(when: delayTime, execute: execute)
  }

  /// Run the block if we are in main thread, or add this block to main queue 
  /// asynchronously.
  static public func runOrAddMainQueue(block: () -> Void) {
    if Thread.isMainThread() {
      block()
    } else {
      GCDQueue.main.async(execute: block)
    }
  }
}

public func <(lhs: GCDQueue, rhs: GCDQueue) -> Bool {
  switch (lhs, rhs) {
  case (.interactive, .serial),
       (.initiated, .serial),
       (.background, .serial),
       (.utility, .serial),
       (.`default`, .serial),
       (.interactive, .concurrent),
       (.initiated, .concurrent),
       (.background, .concurrent),
       (.utility, .concurrent),
       (.`default`, .concurrent):
    return true
  default:
    return false
  }
}

public func ==(lhs: GCDQueue, rhs: GCDQueue) -> Bool {
  switch (lhs, rhs) {
  case (.main, .main):
    return true
  case (.interactive, .interactive):
    return true
  case (.initiated, .initiated):
    return true
  case (.background, .background):
    return true
  case (.`default`, .`default`):
    return true
  case (.utility, .utility):
    return true
  case (.serial, .serial):
    return true
  case (.concurrent, .concurrent):
    return true
  default:
    return false
  }
}

