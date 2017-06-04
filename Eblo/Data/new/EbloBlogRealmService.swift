//
//  EbloBlogRealmService.swift
//  Eblo
//
//  Created by yansong li on 2017-06-04.
//  Copyright © 2017 YANSONG LI. All rights reserved.
//

import Foundation
import RealmSwift
import SiYuanKit

/// The class for blog object's realm interaction.
class EbloBlogRealmService {
  
  /// Return all blogs.
  func allBlogs() -> [EbloBlog] {
    let realm = try! Realm()
    let blogs = realm.objects(EbloBlog.self)
    return blogs.toArray()
  }
  
  /// Return blogs belong to a company.
  func blogsWith(companyID: String) -> [EbloBlog] {
    let fetchedBlogs = self.allBlogs()
    print("Fetched blogs \(fetchedBlogs)")
    let blogs = self.allBlogs().filter { blog -> Bool in
      blog.companyID == companyID
    }.sorted { (first, second) -> Bool in
      if first.publishDateInterval != 0 && second.publishDateInterval != 0 {
        return first.publishDateInterval > second.publishDateInterval
      } else {
        return first.blogID > second.blogID
      }
    }
    return blogs
  }
  
  /// Fetch new blogs with a companyID and store the update result to database.
  func fetchNewBlogs(companyID: String, completion: @escaping ([EbloBlog]) -> Void) {
    let blogFetchService = EbloDataFetchService()
    blogFetchService.fetchBlogs(companyID: companyID) { (success, blogs) in
      guard success, let fetchedBlogs = blogs else {
        return
      }
      let existingBlogs = self.blogsWith(companyID: companyID)
      let existingBlogsSet = Set(existingBlogs.map { $0.identifier() })
      let newBlogs = fetchedBlogs.filter { blog -> Bool in
        !existingBlogsSet.contains(blog.identifier())
      }
      do {
        let realm = try! Realm()
        let updatedBlogs = newBlogs + existingBlogs
        try realm.write {
          updatedBlogs.forEach { blog in
            realm.add(blog, update: true)
          }
        }
        GCDQueue.main.async {
          // NOTE: According to realm model's restriction, you can only use an object on
          // the thread which it was created, here since we have a thread switch, I create
          // a new set of fetched companies.
          completion(self.blogsWith(companyID: companyID))
        }
      } catch {
        print("Eblo Blog Realm Write Error")
      }
    }
  }
}
