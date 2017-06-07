//
//  EbloFavBlogViewController.swift
//  Eblo
//
//  Created by yansong li on 2017-06-05.
//  Copyright © 2017 YANSONG LI. All rights reserved.
//

import IGListKit
import UIKit

/// The view controller for favourite blogs.
class EbloFavBlogViewController: UIViewController {
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return collectionView
  }()
  
  var adapter: ListAdapter?
  
  var blogs: [EbloBlog]?
  
  /// refresh control.
  var refreshControl: UIRefreshControl!
  
  /// The blog service.
  let blogsService = EbloBlogRealmService()
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    collectionView.frame = view.bounds
    collectionView.backgroundColor = .white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Favourite Blogs"
    self.view.backgroundColor = UIColor.white
    self.view.addSubview(self.collectionView)
    let refresher = UIRefreshControl()
    refresher.tintColor = UIColor.gray
    refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
    self.refreshControl = refresher
    self.collectionView.addSubview(refresher)
    
    let updater = ListAdapterUpdater()
    self.adapter = ListAdapter(updater: updater, viewController: self, workingRangeSize: 0)
    adapter?.collectionView = self.collectionView
    adapter?.dataSource = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    self.blogs = self.blogsService.favouriteBlogs()
    self.adapter?.performUpdates(animated: true)
  }
  
  func loadData() {
    self.blogs = self.blogsService.favouriteBlogs()
    self.adapter?.performUpdates(animated: true) { _ in
      self.refreshControl.endRefreshing()
    }
  }
}

extension EbloFavBlogViewController: ListAdapterDataSource {
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
