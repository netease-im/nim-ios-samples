//
//  String+Util.swift
//  NIMTool
//
//  Created by chris on 16/5/4.
//  Copyright © 2016年 Netease. All rights reserved.
//

import Foundation


extension String {
    
    func ntes_md5() -> String {
        
        if let data = self.data(using: String.Encoding.utf8) {
            return data.ntes_md5()
        }
        return ""
    }
    
    func ntes_filemd5() -> String {
        if let data = FileManager.default.contents(atPath: self) {
            return data.ntes_md5()
        }
        return ""
    }
    
    // MARK: 字符串转字典
    func toDictionary() -> [String : Any] {
        
        var result = [String : Any]()
        guard !self.isEmpty else { return result }
        
        guard let dataSelf = self.data(using: .utf8) else {
            return result
        }
        
        if let dic = try? JSONSerialization.jsonObject(with: dataSelf,
                           options: .mutableContainers) as? [String : Any] {
            result = dic
        }
        return result
    
    }

}
