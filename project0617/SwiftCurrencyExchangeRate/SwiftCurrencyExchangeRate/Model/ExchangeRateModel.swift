//
//  ExchangeRateModel.swift
//  SwiftCurrencyExchangeRate
//
//  Created by 周际航 on 16/6/15.
//  Copyright © 2016年 zjh. All rights reserved.
//

import Foundation
import ObjectMapper

class ExchangeRateModel: BaseModel, NSCoding{
    var errNum: Int?
    var errMsg: String?
    var retData: ExchangeRateReturnModel?
    
    
    required init?(_ map: Map) {
        super.init(map)
    }
    override func mapping(map: Map) {
        super.mapping(map)
        errNum <- map["errNum"]
        errMsg <- map["errMsg"]
        retData <- map["retData"]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.errNum = aDecoder.decodeObjectForKey("errNum") as? Int
        self.errMsg = aDecoder.decodeObjectForKey("errMsg") as? String
        self.retData = aDecoder.decodeObjectForKey("retData") as? ExchangeRateReturnModel
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.errNum, forKey: "errNum")
        aCoder.encodeObject(self.errMsg, forKey: "errMsg")
        aCoder.encodeObject(self.retData, forKey: "retData")
    }
    
}
class ExchangeRateReturnModel: BaseModel, NSCoding{
    var date: String?
    var time: String?
    var fromCurrency: String?
    var toCurrency: String?
    // 转化金额
    var amount: Int?
    // 转化后的金额
    var convertedamount: Double?
    // 当前汇率
    var currency: Double?
    
    // 货币中文名称
    var fromCurrencyName: String?
    var toCurrencyName: String?
    
    // 中文货币名称
    var fromCurrencyModel: CurrencyCodeModel?
    var toCurrencyModel: CurrencyCodeModel?
    
    required init?(_ map: Map) {
        super.init(map)
    }
    override func mapping(map: Map) {
        date <- map["date"]
        time <- map["time"]
        fromCurrency <- map["fromCurrency"]
        toCurrency <- map["toCurrency"]
        amount <- map["amount"]
        convertedamount <- map["convertedamount"]
        currency <- map["currency"]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.date = aDecoder.decodeObjectForKey("date") as? String
        self.time = aDecoder.decodeObjectForKey("time") as? String
        self.fromCurrency = aDecoder.decodeObjectForKey("fromCurrency") as? String
        self.toCurrency = aDecoder.decodeObjectForKey("toCurrency") as? String
        self.amount = aDecoder.decodeObjectForKey("amount") as? Int
        self.convertedamount = aDecoder.decodeObjectForKey("convertedamount") as? Double
        self.currency = aDecoder.decodeObjectForKey("fromCurrency") as? Double
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.date, forKey: "date")
        aCoder.encodeObject(self.time, forKey: "time")
        aCoder.encodeObject(self.fromCurrency, forKey: "fromCurrency")
        aCoder.encodeObject(self.toCurrency, forKey: "toCurrency")
        aCoder.encodeObject(self.amount, forKey: "amount")
        aCoder.encodeObject(self.convertedamount, forKey: "convertedamount")
        aCoder.encodeObject(self.currency, forKey: "currency")
    }
}
