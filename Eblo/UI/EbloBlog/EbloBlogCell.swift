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
    label.font = UIFont.systemFont(ofSize: 14)
    return label
  }()
  
  private let publishDateLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    return label
  }()
  
  private let authorNameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .right
    label.font = UIFont.systemFont(ofSize: 14)
    return label
  }()
  
  private let divider: UIView = {
    let view = UIView()
    view.backgroundColor = .gray
    return view
  }()
  
  public let favouriteButton: InsetButton = {
    let button = InsetButton(image: UIImage.heartOff,
                             contentInset: UIEdgeInsetsMake(12, 12, 12, 12),
                             imageSize: CGSize(width: 18, height: 18))
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .white
    contentView.addAutoLayoutSubView(blogNameLabel)
    contentView.addAutoLayoutSubView(companyLabel)
    contentView.addAutoLayoutSubView(publishDateLabel)
    contentView.addAutoLayoutSubView(authorNameLabel)
    contentView.addAutoLayoutSubView(divider)
    contentView.addAutoLayoutSubView(favouriteButton)
    self.buildConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func buildConstraints() {
    blogNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
    blogNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
    blogNameLabel.trailingAnchor.constraint(equalTo: favouriteButton.leadingAnchor, constant: 0).isActive = true

    favouriteButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    favouriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
    favouriteButton.widthAnchor.constraint(equalToConstant: 42).isActive = true
    favouriteButton.heightAnchor.constraint(equalToConstant: 42).isActive = true

    companyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
    companyLabel.topAnchor.constraint(equalTo: blogNameLabel.bottomAnchor, constant: 12).isActive = true
    companyLabel.trailingAnchor.constraint(equalTo: publishDateLabel.leadingAnchor, constant: -12).isActive = true
    companyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true

    publishDateLabel.topAnchor.constraint(equalTo: companyLabel.topAnchor).isActive = true
    publishDateLabel.bottomAnchor.constraint(equalTo: companyLabel.bottomAnchor).isActive = true

    authorNameLabel.leadingAnchor.constraint(equalTo: publishDateLabel.trailingAnchor, constant: 24).isActive = true
    authorNameLabel.topAnchor.constraint(greaterThanOrEqualTo: companyLabel.topAnchor).isActive = true
    authorNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
    authorNameLabel.bottomAnchor.constraint(equalTo: companyLabel.bottomAnchor).isActive = true

    divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    divider.heightAnchor.constraint(equalToConstant: 1).isActive = true

    companyLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
    publishDateLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
    authorNameLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)

    companyLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
    publishDateLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
    authorNameLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)
  }
  
  func populate(blog: EbloBlog) {
    blogNameLabel.text = blog.title
    companyLabel.text = blog.companyName
    publishDateLabel.text = blog.publishDate
    authorNameLabel.text = blog.authorName
    favouriteButton.changeImageWithImage(blog.favourite ? UIImage.heartOn : UIImage.heartOff)
  }
  
  static func cellSize(width: CGFloat, blog: EbloBlog) -> CGSize {
    EbloBlogCell.heightCalculationCell.populate(blog: blog)
    EbloBlogCell.heightCalculationCell.blogNameLabel.preferredMaxLayoutWidth = width - 12 - 42 - 12
    EbloBlogCell.heightCalculationCell.companyLabel.preferredMaxLayoutWidth = width
    let size = EbloBlogCell.heightCalculationCell.systemLayoutSizeFitting(CGSize(width: width, height:999))
    return size
  }
}
