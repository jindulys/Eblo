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
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .white
    contentView.addAutoLayoutSubView(companyLabel)
    contentView.addAutoLayoutSubView(divider)
    self.buildConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func buildConstraints() {
    companyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true
    companyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
    companyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24).isActive = true
    companyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
    divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
  }
  
  func populate(company: EbloCompany) {
    companyLabel.text = company.companyName
  }
  
  static func cellSize(width: CGFloat, company: EbloCompany) -> CGSize {
    let size = TextSize.size(company.companyName,
                             font: UIFont.systemFont(ofSize: 18),
                             width: width,
                             insets: UIEdgeInsetsMake(12, 24, 12, 24))
    return size.size
  }
}
