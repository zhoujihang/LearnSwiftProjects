//
//  BaseModel.swift
//  SwiftCurrencyExchangeRate
//
//  Created by 周际航 on 16/6/15.
//  Copyright © 2016年 zjh. All rights reserved.
//

import Foundation
import ObjectMapper


class BaseModel: NSObject, Mappable{
    
    override init(){
        super.init()
    }
    required init?(_ map: Map) {
        
    }
    func mapping(map: Map) {
        
    }
}
