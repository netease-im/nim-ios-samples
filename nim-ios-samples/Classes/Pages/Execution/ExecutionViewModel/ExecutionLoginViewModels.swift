//
//  ExecutionLoginViewModels.swift
//  nim-ios-samples
//
//  Created by 陈吉力 on 2025/7/3.
//

import Foundation

class ExecutionLoginViewModels {
    static  let listener: V2NIMLoginListener = V2LoginListener()
    
    static let apiDefinitionDict: [String: APIDefinition] = [
        "login:token:option:success:failure:": APIDefinition(
            name: "login:token:option:success:failure:",
            parameters: [
                APIParameter(name: "accountId", type: .string, isOptional: false, description: "账号", customTypeFields: nil),
                APIParameter(name: "token", type: .string, isOptional: true, description: nil, customTypeFields: nil),
                APIParameter(name: "option", type: .custom("V2NIMLoginOption"), isOptional: true, description: "登录选项", customTypeFields: [
                    APIParameter(name: "retryCount", type: .int, isOptional: true, description: "重试次数", customTypeFields: nil),
                    APIParameter(name: "timeout", type: .int, isOptional: true, description: "超时时间，毫秒", customTypeFields: nil),
                    APIParameter(name: "forceMode", type: .bool, isOptional: true, description: "强制登录模式", customTypeFields: nil, defaultValue: false),
                    APIParameter(name: "offlineMode", type: .bool, isOptional: true, description: "离线模式", customTypeFields: nil, defaultValue: false),
                    APIParameter(name: "syncLevel", type: .int, isOptional: true, description: "同步等级。0：全部；1：基础", customTypeFields: nil),
                ]),
            ],
            executeFunction: { (params: [String : Any], completion) in
                let accountId = params["accountId"] as? String ?? ""
                let token = params["token"] as? String ?? ""
                let option = V2NIMLoginOption.init(params)
                NIMSDK.shared().v2LoginService.login(accountId, token: token, option: option) {
                    completion("Login successful")
                } failure: { error in
                    completion("Login failed: \(error)")
                }
            }
        ),
        "logout:failure:": APIDefinition(
            name: "logout:failure:",
            parameters: [],
            executeFunction: { _, completion in
                NIMSDK.shared().v2LoginService.logout {
                    completion("Logout successful")
                } failure:  { error in
                    completion("Logout failed: \(error)")
                }
            }
        ),
        "getLoginUser": APIDefinition(
            name: "getLoginUser",
            parameters: [],
            executeFunction: { _, completion in
                let result = NIMSDK.shared().v2LoginService.getLoginUser()
                completion("getLoginUser done. result is \(String(describing: result))")
            }
        ),
        "getLoginStatus": APIDefinition(
            name: "getLoginStatus",
            parameters: [],
            executeFunction: { _, completion in
                let result = NIMSDK.shared().v2LoginService.getLoginStatus()
                completion("getLoginStatus done. result is \(result)")
            }
        ),
        "addLoginDetailListener:": APIDefinition(
            name: "addLoginDetailListener",
            parameters: [],
            executeFunction: { _, completion in
                NIMSDK.shared().v2LoginService.add(ExecutionLoginViewModels.listener)
                completion("addLoginDetailListener done")
            }
        ),
        "removeLoginDetailListener:": APIDefinition(
            name: "removeLoginDetailListener",
            parameters: [],
            executeFunction: { _, completion in
                NIMSDK.shared().v2LoginService.remove(ExecutionLoginViewModels.listener)
                completion("removeLoginDetailListener done")
            }
        ),
        
    ]
}

class V2LoginListener: NSObject, V2NIMLoginListener
{
    
    func onLoginStatus(_ status: V2NIMLoginStatus) {
        Logger.log("onLoginStatus: \(status)")
    }
    func onLoginFailed(_ error: V2NIMError) {
        Logger.log("onLoginFailed: \(error)")
    }
    
    func onKickedOffline(_ detail: V2NIMKickedOfflineDetail) {
        Logger.log("onKickedOffline: \(detail)")
    }
    
    func onLoginClientChanged(_ change: V2NIMLoginClientChange, clients: [V2NIMLoginClient]?) {
        Logger.log("onLoginClientChanged: \(change), clients: \(String(describing: clients))")
    }
}

extension V2NIMLoginOption {
    convenience init(_ dict: [String: Any]) {
        self.init()
        if let retryCount = dict["option.retryCount"] as? Int {
            self.retryCount = retryCount
        }
        if let timeout = dict["option.timeout"] as? Int {
            self.timeout = timeout
        }
        if let forceMode = dict["option.forceMode"] as? Bool {
            self.forceMode = forceMode
        }
        if let offlineMode = dict["option.offlineMode"] as? Bool {
            self.offlineMode = offlineMode
        }
        if let syncLevelInt = dict["option.syncLevel"] as? Int,
           let syncLevel = V2NIMDataSyncLevel(rawValue: syncLevelInt) {
            self.syncLevel = syncLevel
        }
    }
}
