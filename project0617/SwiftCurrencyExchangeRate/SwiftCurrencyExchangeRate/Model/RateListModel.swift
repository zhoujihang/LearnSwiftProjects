//
//  RateListModel.swift
//  SwiftCurrencyExchangeRate
//
//  Created by 周际航 on 16/6/16.
//  Copyright © 2016年 zjh. All rights reserved.
//

import Foundation
import ObjectMapper

class RateListModel: BaseModel {
    var errNum: Int?
    var errMsg: String?
    var retData: [String]? {
        didSet {
            if let retData_s = retData {
                self.existCurrencyModelArr = []
                let sharedModelList = CurrencyCodeModel.sharedModelList()
                for code in retData_s {
                    for currencyModel in sharedModelList {
                        if code == currencyModel.code {
                            self.existCurrencyModelArr?.append(currencyModel)
                            break
                        }
                    }
                }
            }else{
                self.existCurrencyModelArr = []
            }
        }
    }
    var existCurrencyModelArr: [CurrencyCodeModel]? = []
    
    override func mapping(map: Map) {
        errNum <- map["errNum"]
        errMsg <- map["errMsg"]
        retData <- map["retData"]
    }
    
    // 移除没有匹配国家名称的code
    func removeUnExistCode() {
        guard self.retData != nil else {
            return
        }
        let sharedList = CurrencyCodeModel.sharedModelList()
        var existCodeList: [String] = []
        for code in self.retData! {
            for codeModel in sharedList {
                
                if code.lowercaseString == codeModel.code?.lowercaseString {
                    existCodeList.append(code)
                    break
                }
            }
        }
        self.retData = existCodeList
    }
}

