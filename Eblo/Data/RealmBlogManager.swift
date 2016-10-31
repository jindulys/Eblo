//
//  EBRealmBlogManager.swift
//  Eblo
//
//  Created by yansong li on 2016-10-22.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import RealmSwift
import SiYuanKit

/// The realm manager which is responsible for read/write management of Blog Object.
class RealmBlogManager {

  static let sharedInstance = RealmBlogManager()

  /// Next Blog Model's ID, this one once set will be used in memory. This way to reduce
  /// the time of query nextBlogID everytime, which means in this lifecycle, if you want to
  /// save BlogID, you must guarantee you did not modify this one in a thread-unsafe way.
  /// E.g use serial queue to query and modify this every time.
  private var blogNextBlogID: Int

  /// Use a serial Queue as the write queue.
  private let realmQueue = GCDQueue.serial("RealmBlog", .initiated)

  init() {
    do {
      let realm = try Realm()
      let id =
          realm.objects(CompanyBlog.self).sorted(byProperty: "blogID", ascending: true).last?.blogID ?? 0
      blogNextBlogID = id + 1
    } catch {
      // Error
      blogNextBlogID = -1
    }
  }

  static func nextBlogID() -> Int {
    let retVal = self.sharedInstance.blogNextBlogID
    self.sharedInstance.blogNextBlogID += 1
    return retVal
  }
}
