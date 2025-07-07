//
//  Logger.swift
//  nim-ios-samples
//
//  Created by 陈吉力 on 2024/11/25.
//

import Foundation

let formatter = DateFormatter()

class Logger: NSObject {
    @objc static func log(_ message: @autoclosure () -> Any) {
        formatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm:ss.SSS Z")
        let dataStr = formatter.string(from: Date())

        let threadInfo = Thread.isMainThread ? "MT" : "BT"
        let infoString = "[\(dataStr) \(threadInfo)] \(message())\n"
        print(infoString)
    }
}
