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
  
  /// The company id for this blog view controller.
  let companyID: String
  
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return collectionView
  }()
  
  var adapter: ListAdapter?
  
  var blogs: [EbloBlog]?
  
  /// The blog service.
  let blogsService = EbloBlogRealmService()
  
  init(companyID: String) {
    self.companyID = companyID
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.init(companyID: "1")
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    collectionView.frame = view.bounds
    collectionView.backgroundColor = .white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Eng Blogs"
    self.view.backgroundColor = UIColor.white
    self.view.addSubview(self.collectionView)
    
    let updater = ListAdapterUpdater()
    self.adapter = ListAdapter(updater: updater, viewController: self, workingRangeSize: 0)
    adapter?.collectionView = self.collectionView
    adapter?.dataSource = self
    
    self.blogs = self.blogsService.blogsWith(companyID: self.companyID)
    self.adapter?.performUpdates(animated: true)
    
    self.blogsService.fetchNewBlogs(companyID: self.companyID) { [weak self] blogs in
      DispatchQueue.main.async {
        self?.blogs = blogs
        self?.adapter?.performUpdates(animated: true)
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
