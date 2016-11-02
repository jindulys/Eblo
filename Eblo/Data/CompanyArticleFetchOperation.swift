//
//  CompanyArticleFetchOperation.swift
//  Eblo
//
//  Created by yansong li on 2016-10-21.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import Foundation
import SiYuanKit
import Ji

/// A subclass of YSOperation, which is responsible for fetch article updates.
class CompanyArticleFetchOperation: YSOperation {
  let xPathArticleTitle: String
  let companyName: String
  let companyBlogURL: String
  var xPathArticleURL: String
  var needBlogBaseURL: Bool

  init(companyName: String,
       companyBlogURL: String,
       xPathArticleTitle: String,
       xPathArticleURL: String,
       needBlogBaseURL: Bool = false) {
    self.companyName = companyName
    self.companyBlogURL = companyBlogURL
    self.xPathArticleURL = xPathArticleURL
    self.xPathArticleTitle = xPathArticleTitle
    self.needBlogBaseURL = needBlogBaseURL
  }

  override func execute() {
    // TODO(simonli): according to the info we have to fetch the article titles && urls
    let blogDoc = Ji(htmlURL: URL(string: companyBlogURL)!)
    let titleNodes = blogDoc?.xPath(xPathArticleTitle)
    let urlNodes = blogDoc?.xPath(xPathArticleURL)
     
    guard let resultNodes = titleNodes,
      let resultURLs = urlNodes,
      resultNodes.count == resultURLs.count || xPathArticleURL == "ITN" else {
      return
    }

    // Remove nil.
    let freshTitles = resultNodes.flatMap { $0.content?.trimmingCharacters(in: .whitespacesAndNewlines) }
    let freshURLs = resultURLs.flatMap { $0.content }

    guard freshTitles.count == freshURLs.count || xPathArticleURL == "ITN" else {
      return
    }

    // NOTE: Before we generate URL, make it encoded first.
    let encodedURLs = freshURLs.map { url -> String in
      if xPathArticleURL != "ITN" {
        if let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
          return encoded
        }
      }
      return self.companyBlogURL
    }

    var freshBlogs: [CompanyBlog] = []
    for i in 0..<freshTitles.count {
      let blog = CompanyBlog()
      blog.blogTitle = freshTitles[i]
      if self.needBlogBaseURL {
        // TODO(simonli): find a more general way to do this.
//        if self.companyBlogURL.hasSuffix("/blog") && freshURLs[i].hasPrefix("/blog"),
//          let companyBlogRange = self.companyBlogURL.range(of: "/blog") {
//          var removedURL = self.companyBlogURL
//          removedURL.removeSubrange(companyBlogRange)
//          blog.blogURL = removedURL + encodedURLs[i]
//        } else if self.companyBlogURL.hasSuffix("/news") && freshURLs[i].hasPrefix("/news"),
//          let companyBlogRange = self.companyBlogURL.range(of: "/news") {
//            var removedURL = self.companyBlogURL
//            removedURL.removeSubrange(companyBlogRange)
//            blog.blogURL = removedURL + encodedURLs[i]
//        } else {
//          blog.blogURL = self.companyBlogURL + encodedURLs[i]
//        }
        let resultBlogURL = String.concatenateTwoStringWithoutRepeatedCharactersAtTheJointPoint(firstString: self.companyBlogURL, secondeString: encodedURLs[i])
        blog.blogURL = resultBlogURL
      } else {
        blog.blogURL = encodedURLs[i]
      }
      freshBlogs.append(blog)
    }
    //Test Add new blog
//    if self.companyName == "Facebook" {
//      let testBlog = CompanyBlog()
//      testBlog.blogTitle = "Right at here do you see me please see !!! "
//      testBlog.blogURL = "http://www.google.com"
//      freshBlogs.insert(testBlog, at: 0)
//    }

    // TODO(simonli): update the object with the info we have
    RealmCompanyManager.sharedInstance.updateCompanyWith(UUID: companyName + companyBlogURL, blogInfos: freshBlogs) { 
      self.finish()
    }
  }
}
