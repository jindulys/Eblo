//
//  EbloViewController.swift
//  Eblo
//
//  Created by yansong li on 2017-05-28.
//  Copyright © 2017 YANSONG LI. All rights reserved.
//

import UIKit

/// The view controller for engineering blogs list.
class EbloViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.white
    self.title = "Eng Blogs"
    let testFetch = EbloService()
    testFetch.fetchBlogs { (finished, blogs) in
      if let fetchedBlogs = blogs {
        print("Fetched blogs \(fetchedBlogs.count)")
        print("\(fetchedBlogs)")
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: false)
  }
  
}
