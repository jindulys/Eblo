//
//  BlogCell.swift
//  Eblo
//
//  Created by yansong li on 2017-05-29.
//  Copyright © 2017 YANSONG LI. All rights reserved.
//

import SiYuanKit
import UIKit

/// The cell for blog.
final class EbloBlogCell: UICollectionViewCell {
  
  static let heightCalculationCell = EbloBlogCell()
  
  private let blogNameLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()
  
  private let companyLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .right
    label.font = UIFont.systemFont(ofSize: 18)
    return label
  }()
  
  private let publishDateLabel: UILabel = UILabel()
  
  private let authorNameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .right
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .white
    contentView.addAutoLayoutSubView(blogNameLabel)
    contentView.addAutoLayoutSubView(companyLabel)
    contentView.addAutoLayoutSubView(publishDateLabel)
    contentView.addAutoLayoutSubView(authorNameLabel)
    self.buildConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func buildConstraints() {
    blogNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
    blogNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
    companyLabel.leadingAnchor.constraint(equalTo: blogNameLabel.trailingAnchor, constant: 24).isActive = true
    companyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
    companyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
    publishDateLabel.topAnchor.constraint(equalTo: blogNameLabel.bottomAnchor, constant: 12).isActive = true
    publishDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
    publishDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
    authorNameLabel.leadingAnchor.constraint(equalTo: publishDateLabel.trailingAnchor, constant: 24).isActive = true
    authorNameLabel.topAnchor.constraint(greaterThanOrEqualTo: companyLabel.bottomAnchor, constant: 16).isActive = true
    authorNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
    authorNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true

    blogNameLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
    companyLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)

    blogNameLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)
    companyLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)

    blogNameLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
    publishDateLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .vertical)

    publishDateLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
    authorNameLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)

    publishDateLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
    authorNameLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)

    blogNameLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
    publishDateLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
  }
  
  func populate(blog: EbloBlog) {
    blogNameLabel.text = blog.title
    companyLabel.text = blog.companyName
    publishDateLabel.text = blog.publishDate
    authorNameLabel.text = blog.authorName
  }
  
  static func cellSize(width: CGFloat, blog: EbloBlog) -> CGSize {
    EbloBlogCell.heightCalculationCell.populate(blog: blog)
    // We still need to set label's preferredMaxLayoutWidth to correct calculate the size.
    let companyNameWidth = TextSize.size(blog.companyName, font: UIFont.systemFont(ofSize: 18), width: width).size.width
    EbloBlogCell.heightCalculationCell.companyLabel.preferredMaxLayoutWidth = companyNameWidth
    EbloBlogCell.heightCalculationCell.blogNameLabel.preferredMaxLayoutWidth = width - 12 - 24 - 12 - companyNameWidth
    let size = EbloBlogCell.heightCalculationCell.systemLayoutSizeFitting(CGSize(width: width, height:999))
    print(size)
    return size
  }
}
