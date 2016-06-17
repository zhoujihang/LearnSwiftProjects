//
//  String+Extension.swift
//  SwiftCurrencyExchangeRate
//
//  Created by 周际航 on 16/6/17.
//  Copyright © 2016年 zjh. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func ext_stringContentSize(maxWidth: CGFloat, font: UIFont) -> CGSize {
        let attributes = [NSFontAttributeName : font]
        let size = self.boundingRectWithSize(CGSizeMake(maxWidth, 0), options: .UsesLineFragmentOrigin, attributes: attributes, context: nil).size
        return size
    }
    
}
