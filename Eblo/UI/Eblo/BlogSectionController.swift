//
//  BlogSectionController.swift
//  Eblo
//
//  Created by yansong li on 2017-05-29.
//  Copyright © 2017 YANSONG LI. All rights reserved.
//

import UIKit
import IGListKit

/// Section controller for blog.
final class BlogSectionController: ListSectionController {
  
  var blog: EbloBlog!
  
  override func sizeForItem(at index: Int) -> CGSize {
    guard let context = collectionContext, let blog = blog else {
      return .zero
    }
    let width = context.containerSize.width
    var calculatedSize = EbloBlogCell.cellSize(width: width, blog: blog)
    calculatedSize.width = width
    return calculatedSize
  }
  
  override func cellForItem(at index: Int) -> UICollectionViewCell {
    let cell = collectionContext!.dequeueReusableCell(of: EbloBlogCell.self, for: self, at: index)
    if let blogCell = cell as? EbloBlogCell {
      blogCell.populate(blog: blog)
    }
    return cell
  }
  
  override func didUpdate(to object: Any) {
    blog = object as? EbloBlog
  }
  
  override func didSelectItem(at index: Int) {
    print("Currently select \(blog.title)")
  }
}
