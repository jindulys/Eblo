//
//  EBCompanyArticleFetchOperation.swift
//  Eblo
//
//  Created by yansong li on 2016-10-21.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import Foundation
import SiYuanKit
import Ji

/// A subclass of YSOperation, which is responsible for fetch article updates.
class EBCompanyArticleFetchOperation: YSOperation {
  let xPathArticleTitle: String
  let companyName: String
  let companyBlogURL: String
  var xPathArticleURL: String

  init(companyName: String,
       companyBlogURL: String,
       xPathArticleTitle: String,
       xPathArticleURL: String) {
    self.companyName = companyName
    self.companyBlogURL = companyBlogURL
    self.xPathArticleURL = xPathArticleURL
    self.xPathArticleTitle = xPathArticleTitle
  }

  override func execute() {
    // TODO(simonli): according to the info we have to fetch the article titles && urls
    let blogDoc = Ji(htmlURL: URL(string: companyBlogURL)!)
    let titleNodes = blogDoc?.xPath(xPathArticleTitle)
    let urlNodes = blogDoc?.xPath(xPathArticleURL)
    guard let resultNodes = titleNodes,
      let resultURLs = urlNodes,
      resultNodes.count == resultURLs.count else {
      return
    }

    // Remove nil.
    let freshTitles = resultNodes.flatMap { $0.content }
    let freshURLs = resultURLs.flatMap { $0.content }

    guard freshTitles.count == freshURLs.count else {
      return
    }

    var freshBlogs: [EBBlog] = []
    for i in 0..<freshTitles.count {
      let blog = EBBlog()
      blog.blogTitle = freshTitles[i]
      blog.blogURL = self.companyBlogURL + freshURLs[i]
      freshBlogs.append(blog)
    }
    print(freshBlogs.count)
    // TODO(simonli): update the object with the info we have
    EBRealmCompanyManager.sharedInstance.updateCompanyWith(UUID: companyName + companyBlogURL, blogInfos: freshBlogs) { 
      self.finish()
    }
  }
}
