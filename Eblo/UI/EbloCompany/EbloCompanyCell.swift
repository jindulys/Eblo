//
//  EbloCompanyCell.swift
//  Eblo
//
//  Created by yansong li on 2017-05-31.
//  Copyright © 2017 YANSONG LI. All rights reserved.
//

import SiYuanKit
import UIKit

/// The cell for eblo company.
final class EbloCompanyCell: UICollectionViewCell {
  
  static let heightCalculationCell = EbloCompanyCell()
  
  private let companyLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 18)
    label.numberOfLines = 0
    return label
  }()
  
  private let divider: UIView = {
    let view = UIView()
    view.backgroundColor = .gray
    return view
  }()
  
  private let newDotView: UIView = {
    let view = UIView()
    view.backgroundColor = .red
    view.layer.cornerRadius = 6
    view.isHidden = true
    return view
  }()
  
  private let firstBlogTitleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.numberOfLines = 0
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .white
    contentView.addAutoLayoutSubView(companyLabel)
    contentView.addAutoLayoutSubView(divider)
    contentView.addAutoLayoutSubView(firstBlogTitleLabel)
    contentView.addAutoLayoutSubView(newDotView)
    self.buildConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func buildConstraints() {
    companyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true
    companyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
    companyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24).isActive = true
    companyLabel.bottomAnchor.constraint(equalTo: firstBlogTitleLabel.topAnchor, constant: -12).isActive = true

    firstBlogTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true
    firstBlogTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24).isActive = true
    firstBlogTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true

    newDotView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6.0).isActive = true
    newDotView.widthAnchor.constraint(equalToConstant: 12.0).isActive = true
    newDotView.heightAnchor.constraint(equalToConstant: 12.0).isActive = true
    newDotView.centerYAnchor.constraint(equalTo: companyLabel.centerYAnchor).isActive = true

    divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
  }
  
  func populate(company: EbloCompany) {
    companyLabel.text = company.companyName
    firstBlogTitleLabel.text = company.firstBlogTitle
    newDotView.isHidden = !company.hasUpdated
  }
  
  static func cellSize(width: CGFloat, company: EbloCompany) -> CGSize {
    EbloCompanyCell.heightCalculationCell.populate(company: company)
    EbloCompanyCell.heightCalculationCell.companyLabel.preferredMaxLayoutWidth = width - 24
    EbloCompanyCell.heightCalculationCell.firstBlogTitleLabel.preferredMaxLayoutWidth = width - 24
    let size = EbloCompanyCell.heightCalculationCell.systemLayoutSizeFitting(CGSize(width: width, height: 999))
    return size
  }
}
