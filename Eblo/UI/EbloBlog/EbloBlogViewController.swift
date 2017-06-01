//
//  EbloViewController.swift
//  Eblo
//
//  Created by yansong li on 2017-05-28.
//  Copyright © 2017 YANSONG LI. All rights reserved.
//

import IGListKit
import UIKit

/// The view controller for engineering blogs list.
class EbloBlogViewController: UIViewController {
  
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return collectionView
  }()
  
  var adapter: ListAdapter?
  
  var blogs: [EbloBlog]?
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    collectionView.frame = view.bounds
    collectionView.backgroundColor = .white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.white
    self.view.addSubview(self.collectionView)
    
    let updater = ListAdapterUpdater()
    self.adapter = ListAdapter(updater: updater, viewController: self, workingRangeSize: 0)
    adapter?.collectionView = self.collectionView
    adapter?.dataSource = self
    
    self.title = "Eng Blogs"
    let testFetch = EbloService()
    testFetch.fetchBlogs { [weak self](finished, blogs) in
      if let fetchedBlogs = blogs {
        self?.blogs = fetchedBlogs
        DispatchQueue.main.async {
          self?.adapter?.performUpdates(animated: true)
        }
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: false)
  }
}

extension EbloBlogViewController: ListAdapterDataSource {
  func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
    guard let blogs = self.blogs else {
      return []
    }
    return blogs
  }
  
  func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
    return BlogSectionController()
  }
  
  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    return nil
  }
}
