//
//  Value1Cell.swift
//  SiYuanKit
//
//  Created by yansong li on 2016-07-31.
//
//

import Foundation

public class Value1Cell: UITableViewCell, StaticCellType {
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
