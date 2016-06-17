//
//  CurrencyCodeModel.swift
//  SwiftCurrencyExchangeRate
//
//  Created by 周际航 on 16/6/16.
//  Copyright © 2016年 zjh. All rights reserved.
//

import Foundation
import ObjectMapper

class CurrencyCodeModel: BaseModel{
    var name: String?
    var code: String?
    
    override func mapping(map: Map) {
        name <- map["name"]
        code <- map["code"]
    }
    
    class func sharedModelList() -> Array<CurrencyCodeModel> {
        struct Singleton{
            static var predicate: dispatch_once_t = 0
            static var instance: [CurrencyCodeModel]? = nil
        }
        dispatch_once(&Singleton.predicate,{
            let path = NSBundle.mainBundle().pathForResource("Currency", ofType: "json")
            var jsonString: String = ""
            do {
                try jsonString = String.init(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
            } catch let error {
                print(error)
            }
            let modelList = Mapper<CurrencyCodeModel>().mapArray(jsonString)
            
            Singleton.instance = modelList
        })
        return Singleton.instance!
    }
    
    class func chineseModel() -> CurrencyCodeModel {
        let chineseModel = CurrencyCodeModel()
        chineseModel.code = "CNY"
        chineseModel.name = "人民币"
        return chineseModel
    }
}
    