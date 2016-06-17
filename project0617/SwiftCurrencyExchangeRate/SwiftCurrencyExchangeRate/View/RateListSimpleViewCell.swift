//
//  RateListSimpleViewCell.swift
//  SwiftCurrencyExchangeRate
//
//  Created by 周际航 on 16/6/16.
//  Copyright © 2016年 zjh. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class RateListSimpleViewCell: UITableViewCell {
    var currencyModel: CurrencyCodeModel? {
        didSet {
            if let model_s = currencyModel {
                self.nameCodeLbl?.text = "\(model_s.name!)(\(model_s.code!))"
            }else{
                self.nameCodeLbl?.text = ""
            }
        }
    }
    var nameCodeLbl: UILabel?
    
    
    class func cellIdentifier() -> String {
        return NSStringFromClass(self.classForCoder())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpViews()
        self.setUpConstraints()
    }
    
    func setUpViews() {
        let nameCodeLbl = UILabel()
        nameCodeLbl.font = UIFont.systemFontOfSize(16)
        nameCodeLbl.textColor = UIColor.init(white: 0.3, alpha: 1)
        self.contentView.addSubview(nameCodeLbl)
        self.nameCodeLbl = nameCodeLbl
    }
    func setUpConstraints() {
        self.nameCodeLbl?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(self.contentView).offset(16)
            make.right.equalTo(self.contentView).offset(-16)
            make.top.bottom.equalTo(self.contentView)
        })
    }
    func cellHeight() -> CGFloat {
        return 60
    }
    
    
}