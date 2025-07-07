//
//  Dictionary+Util.swift
//  NIMTool
//
//  Created by lihuang on 2022/6/19.
//  Copyright © 2022 Netease. All rights reserved.
//

import Foundation

// MARK: 字典转字符串
extension Dictionary {
    
    func toJsonString() -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self,
                                                     options: []) else {
            return nil
        }
        guard let str = String(data: data, encoding: .utf8) else {
            return nil
        }
        return str
     }
    
}
