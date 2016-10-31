//
//  EBRealmBlogManager.swift
//  Eblo
//
//  Created by yansong li on 2016-10-22.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import RealmSwift
import SiYuanKit

/// Protocol used for notify UI delegate UI events.
protocol RealmBlogManagerUIDelegate: class {
  /// Tell the UI Delegate that row was tapped with necessary info.
  func tappedRow(blogURLString: String)

  /// The blogs.
  func blogs() -> List<CompanyBlog>?
}

/// The realm manager which is responsible for read/write management of Blog Object.
class RealmBlogManager: InitiatedDataManager {

  /// Singleton.
  static let sharedInstance = RealmBlogManager()

  /// A lock to guard reads and writes to the `blogNextBlogID` property.
  private static let nextIDLock = NSLock()

  /// Next Blog Model's ID, this one once set will be used in memory. This way to reduce
  /// the time of query nextBlogID everytime, which means in this lifecycle, if you want to
  /// save BlogID, you must guarantee you did not modify this one in a thread-unsafe way.
  /// E.g use serial queue to query and modify this every time.
  private var blogNextBlogID: Int

  /// The UI Delegate which is responsible for UI event.
  weak var uiDelegate: RealmBlogManagerUIDelegate?

  /// Use a serial Queue as the write queue.
  private let realmQueue = GCDQueue.serial("RealmBlog", .initiated)

  override init() {
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

  /// Static func to get the next Blog ID, thread safe.
  static func nextBlogID() -> Int {
    self.nextIDLock.lock()
    let retVal = self.sharedInstance.blogNextBlogID
    self.sharedInstance.blogNextBlogID += 1
    self.nextIDLock.unlock()
    return retVal
  }
}

extension RealmBlogManager: TableViewManagerDataSource {
  func fetchedData() -> TableViewData {
    var result: [Row] = []
    // TODO(simonli): move tableViewCell action logic out of this data model.
    if let delegate = self.uiDelegate, let blogs = delegate.blogs() {
      for blog in blogs {
        let rowAction = {
          delegate.tappedRow(blogURLString: blog.blogURL)
        }
        let currentRow =
          Row(title: blog.blogTitle,
              description: nil,
              image: nil,
              action: rowAction,
              cellType: BlogCell.self,
              cellIdentifier: "companyBlog",
              UUID: String(blog.blogID))
        result.append(currentRow)
      }
    }
    return .SingleSection(result)
  }
}
