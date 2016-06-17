//
//  NetworkManager.swift
//  SwiftCurrencyExchangeRate
//
//  Created by 周际航 on 16/6/14.
//  Copyright © 2016年 zjh. All rights reserved.
//

import Foundation
import Alamofire

let kAPIStoreAPIKey = "842538bada1ca2d61d697fb65dc9deb3"
class NetworkManager{
    
    class func requestRateListData(completionHandler: Response<AnyObject, NSError> -> Void) {
        
        let urlString = "http://apis.baidu.com/apistore/currencyservice/type"
        let headers = ["apikey" : kAPIStoreAPIKey]
        Alamofire.request(.GET, urlString, parameters: nil, encoding: .URL, headers: headers).responseJSON {  (response) in
            completionHandler(response)
        }
    }
    
    class func requestRateDetail(fromCurrency: CurrencyCodeModel, toCurrency: CurrencyCodeModel, completionHandler: Response<AnyObject, NSError> -> Void) {
        guard fromCurrency.code != nil && toCurrency.code != nil else {
            return
        }
        
        let urlString = "http://apis.baidu.com/apistore/currencyservice/currency"
        let headers = ["apikey" : kAPIStoreAPIKey]
        let parameters: [String: AnyObject] = ["fromCurrency" : fromCurrency.code!, "toCurrency" : toCurrency.code!, "amount" : 100]
        Alamofire.request(.GET, urlString, parameters: parameters, encoding: .URL, headers: headers).responseJSON { (response) in
            completionHandler(response)
        }
    }
    
}
