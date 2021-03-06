//
//  EbloDataFetchService.swift
//  Eblo
//
//  Created by yansong li on 2017-05-28.
//  Copyright © 2017 YANSONG LI. All rights reserved.
//

import Foundation

/// The class that provides eblo data.
class EbloDataFetchService {
  
  /// The blogs URL string.
  static let allCompanyURLString = "https://ebloserver.herokuapp.com/company/all"
  
  /// The company url string.
  static let companyBlogsURLString = "https://ebloserver.herokuapp.com/company"
  
  /// Fetch blogs with a completion handler.
  func fetchBlogs(companyID: String, completion: @escaping (Bool, [EbloBlog]?) -> ()) {
    guard let requestURL = URL(string: EbloDataFetchService.companyBlogsURLString+"/"+companyID+"/blogs") else {
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
              let company = blog["company"] as? String,
              let blogID = blog["id"] as? Int {
              let parsedBlog = EbloBlog()
              parsedBlog.title = title
              parsedBlog.urlString = urlString
              parsedBlog.companyName = company
              parsedBlog.blogID = blogID
              parsedBlog.companyID = companyID
              parsedBlog.favourite = false
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
  
  /// Fetch company list.
  func fetchCompanyList(completion: @escaping(Bool, [EbloCompany]?) -> ()) {
    guard let requestURL = URL(string: EbloDataFetchService.allCompanyURLString) else {
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
        if let companies = json as? [[String: Any]] {
          var parsedCompany = [EbloCompany]()
          for company in companies {
            if let companyName = company["companyname"] as? String,
              let companyURLString = company["companyurlstring"] as? String,
              let companyID = company["id"] as? Int {
              let newCompany = EbloCompany()
              newCompany.companyName = companyName
              newCompany.companyID = companyID
              newCompany.urlString = companyURLString
              newCompany.positionIndex = 0
              if let blogTitle = company["firstblogtitle"] as? String {
                newCompany.firstBlogTitle = blogTitle
              }
              newCompany.hasUpdated = false
              parsedCompany.append(newCompany)
            }
          }
          completion(true, parsedCompany)
        }
      } catch {
        print("Could not properly parse data")
        completion(false, nil)
      }
    }
    task.resume()
  }
}
