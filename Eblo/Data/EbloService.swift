//
//  EbloService.swift
//  Eblo
//
//  Created by yansong li on 2017-05-28.
//  Copyright © 2017 YANSONG LI. All rights reserved.
//

import Foundation

/// The class that provides eblo data.
class EbloService {
  
  /// The blogs URL string.
  static let blogsURLString = "https://ebloserver.herokuapp.com/blog/test"
  
  /// Fetch blogs with a completion handler.
  func fetchBlogs(completion: @escaping (Bool, [EbloBlog]?) -> ()) {
    guard let requestURL = URL(string: EbloService.blogsURLString) else {
      print("URLString is not valid")
      completion(false, nil)
      return
    }
    let request = URLRequest(url: requestURL)
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in
      guard let res = response as? HTTPURLResponse,
        res.statusCode == 200,
        let validData = data else {
        print("Did not get valid response")
        return
      }
      do {
        let json = try JSONSerialization.jsonObject(with: validData, options: .allowFragments)
        if let blogs = json as? [[String: Any]] {
          var parsedBlogs = [EbloBlog]()
          for blog in blogs {
            if let title = blog["title"] as? String,
              let urlString = blog["urlstring"] as? String,
              let company = blog["company"] as? String {
              let parsedBlog = EbloBlog(title: title, urlString: urlString, companyName: company)
              if let publishDateString = blog["publishdate"] as? String {
                parsedBlog.publishDate = publishDateString
              }
              if let publishDateInterval = blog["publishdateinterval"] as? Double {
                parsedBlog.publishDateInterval = publishDateInterval
              }
              if let authorName = blog["authorname"] as? String {
                parsedBlog.authorName = authorName
              }
              if let authorAvatarURLString = blog["authoravatar"] as? String {
                parsedBlog.authorAvatar = authorAvatarURLString
              }
              parsedBlogs.append(parsedBlog)
            }
          }
          completion(true, parsedBlogs)
        }
      } catch {
        print("Could not properly parse data")
        completion(false, nil)
      }
    }
    task.resume()
  }
}
