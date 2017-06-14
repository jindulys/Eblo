//
//  Time.swift
//  SiYuanKit
//
//  Created by yansong li on 2016-07-23.
//
//
// NOTE: No dependency

import Foundation

public struct Time {
  private static let wastingTimeGroup = DispatchGroup()
  
  /// This method will run a specific time until time expire, this will block your current thread.
  public static func longRun(duration: Double) {
    let localConcurrentQueue = DispatchQueue(label: "localConcurrent", attributes: .concurrent)
    localConcurrentQueue.sync {
      wastingTimeGroup.enter()
    }
    
    let delayTime = DispatchTime.now() + duration
    localConcurrentQueue.asyncAfter(deadline: delayTime) {
      wastingTimeGroup.leave()
    }
    wastingTimeGroup.wait()
  }
}
