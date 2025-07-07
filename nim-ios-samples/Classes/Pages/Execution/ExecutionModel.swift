//
//  ExecutionModel.swift
//  nim-ios-samples
//
//  Created by 陈吉力 on 2025/6/22.
//

import Foundation

// API参数类型定义
enum APIParameterType {
    case string
    case int
    case double
    case bool
    case custom(String) // 自定义类型名称
    case button
}

// API参数定义
struct APIParameter {
    let name: String
    let type: APIParameterType
    let isOptional: Bool
    let description: String?
    let customTypeFields: [APIParameter]? // 如果是自定义类型，包含其字段
    var defaultValue: Any? // 默认值，用于可选参数
    var onClick: (()->Void)? // 点击事件
}

// API定义
struct APIDefinition {
    let name: String
    let parameters: [APIParameter]
    let executeFunction: ([String: Any], @escaping (String) -> Void) -> Void
}

// 参数值存储
class ParameterValues: ObservableObject {
    @Published var values: [String: Any] = [:]
    
    func setValue<T>(_ value: T, forKey key: String) {
        values[key] = value
    }
    
    func getValue<T>(forKey key: String, as type: T.Type) -> T? {
        return values[key] as? T
    }
}
