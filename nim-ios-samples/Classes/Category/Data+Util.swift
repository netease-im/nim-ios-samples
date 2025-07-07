//
//  Data+Util.swift
//  NIMTool
//
//  Created by amao on 2016/10/9.
//  Copyright © 2016年 Netease. All rights reserved.
//

import Foundation
import CommonCrypto

extension Data {
    func ntes_md5() -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        
        CC_MD5((self as NSData).bytes, CC_LONG(self.count), &digest)
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex

    }
}
