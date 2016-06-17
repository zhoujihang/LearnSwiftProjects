//
//  RateListViewCell.swift
//  SwiftCurrencyExchangeRate
//
//  Created by 周际航 on 16/6/15.
//  Copyright © 2016年 zjh. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class RateListDetailViewCell: UITableViewCell {
    
    var rateModel: ExchangeRateReturnModel? {
        didSet {
            if let model_s = rateModel {
                guard model_s.fromCurrencyModel != nil && model_s.toCurrencyModel != nil else {
                    return
                }
                
                let fromCurrency = model_s.fromCurrencyModel!
                let toCurrency = model_s.toCurrencyModel!
                let currency = model_s.currency!
                let dateTime = model_s.date! + " " + model_s.time!
                
                self.rateLbl?.text = "汇率:" + String(format: "%.06f", currency)
                self.timeLbl?.text = dateTime
                self.expressionLbl?.text = "\(toCurrency.name!)(\(toCurrency.code!)) : \(fromCurrency.name!)(\(fromCurrency.code!)) = \(String(format:"%.02f", model_s.convertedamount!)) : \(String(format:"%d", model_s.amount!))"
            }else {
                // 空值
                self.rateLbl?.text = ""
                self.timeLbl?.text = ""
                self.expressionLbl?.text = ""
                return
            }
        }
    }
    var rateLbl: UILabel?
    var timeLbl: UILabel?
    var expressionLbl: UILabel?
    
    
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
        let rateLbl = UILabel()
        rateLbl.font = UIFont.systemFontOfSize(12)
        rateLbl.textColor = UIColor.grayColor()
        self.contentView.addSubview(rateLbl)
        self.rateLbl = rateLbl
        
        let timeLbl = UILabel()
        timeLbl.font = UIFont.systemFontOfSize(12)
        timeLbl.textColor = UIColor.grayColor()
        self.contentView.addSubview(timeLbl)
        self.timeLbl = timeLbl
        
        let expressionLbl = UILabel()
        expressionLbl.font = UIFont.systemFontOfSize(16)
        expressionLbl.textColor = UIColor.blueColor()
        expressionLbl.numberOfLines = 0;
        expressionLbl.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.size.width - 32
        self.contentView.addSubview(expressionLbl)
        self.expressionLbl = expressionLbl
    }
    func setUpConstraints() {
        self.rateLbl?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(self.contentView).offset(16)
            make.top.equalTo(self.contentView).offset(8)
            make.right.equalTo(self.timeLbl!.snp_left).offset(2)
        })
        // 优先压缩time
        self.timeLbl?.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: UILayoutConstraintAxis.Horizontal)
        self.timeLbl?.snp_makeConstraints(closure: { (make) in
            make.right.equalTo(self.contentView).offset(-16)
            make.top.equalTo(self.contentView).offset(8)
        })
        self.expressionLbl?.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(self.rateLbl!.snp_bottom).offset(8)
            make.left.equalTo(self.contentView).offset(16)
            make.right.equalTo(self.contentView).offset(-16)
        })
    }
    func cellHeight() -> CGFloat {
        if self.expressionLbl!.text==nil || self.expressionLbl!.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)==0 {
            self.expressionLbl?.text = " "
        }
        // 计算行高1
        let text = self.expressionLbl!.text!
        let preferredWidth = self.expressionLbl!.preferredMaxLayoutWidth
        let size = text.ext_stringContentSize(preferredWidth, font: self.expressionLbl!.font)
        let expressionHeight: CGFloat = size.height;
        // 计算行高2
//        let expressionHeight: CGFloat = self.expressionLbl!.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        
        var height: CGFloat = 8 + self.rateLbl!.font.lineHeight + 8 + expressionHeight + 8
        height = ceil(height)
        return height
    }
}