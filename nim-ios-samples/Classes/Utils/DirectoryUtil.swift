//
//  DirectoryUtil.swift
//  nim-ios-samples
//
//  Created by 陈吉力 on 2025/6/25.
//

import Foundation
import AVFoundation

struct DirectoryUtil {
    // Bundle资源目录（只读）
    static var bundleResourcePath: String? {
        return Bundle.main.resourcePath
    }
    
    // Documents目录（可读写）
    static var documentsDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory,
                                      in: .userDomainMask).first!
    }
    
    // 临时目录
    static var temporaryDirectory: URL {
        return FileManager.default.temporaryDirectory
    }
    
    // 缓存目录
    static var cachesDirectory: URL {
        return FileManager.default.urls(for: .cachesDirectory,
                                      in: .userDomainMask).first!
    }
    
    // 应用支持目录
    static var applicationSupportDirectory: URL {
        let url = FileManager.default.urls(for: .applicationSupportDirectory,
                                         in: .userDomainMask).first!
        // 确保目录存在
        try? FileManager.default.createDirectory(at: url,
                                               withIntermediateDirectories: true)
        return url
    }
    
    // 打印所有目录信息
    static func printDirectoryInfo() {
        print("=== iOS目录信息 ===")
        print("Bundle路径: \(Bundle.main.bundlePath)")
        print("资源路径: \(bundleResourcePath ?? "nil")")
        print("Documents: \(documentsDirectory.path)")
        print("临时目录: \(temporaryDirectory.path)")
        print("缓存目录: \(cachesDirectory.path)")
        print("应用支持: \(applicationSupportDirectory.path)")
    }
}
