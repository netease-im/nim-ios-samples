//
//  ExecutionUserViewModels.swift
//  nim-ios-samples
//
//  Created by 陈吉力 on 2025/6/22.
//

import Foundation

class V2UserListener: NSObject, V2NIMUserListener {
  
  func onUserProfileChanged(_ users: [V2NIMUser]) {
      Logger.log("onUserProfileChanged users:\(users)")
  }
  
  func onBlockListAdded(_ user: V2NIMUser) {
      Logger.log("onBlockListAdded user:\(user)")
  }
  
  func onBlockListRemoved(_ accountId: String) {
      Logger.log("onBlockListRemoved accountId:\(accountId)")
  }
}

class ExecutionUserViewModels {
  static  let listener: V2NIMUserListener = V2UserListener()
  
  static let apiDefinitionDict: [String: APIDefinition] = [
    "addUserListener:": APIDefinition(
      name: "addUserListener:",
      parameters:[],
      executeFunction: { (params, callback) in
        NIMSDK.shared().v2UserService.add(ExecutionUserViewModels.listener)
        callback("addUserListener success.")
      }
    ),
    "removeUserListener:": APIDefinition(
      name: "removeUserListener:",
      parameters:[],
      executeFunction: { (params, callback) in
        NIMSDK.shared().v2UserService.remove(ExecutionUserViewModels.listener)
        callback("removeUserListener success.")
      }
    ),
    
    "getUserList:success:failure:": APIDefinition(
      name: "getUserList:success:failure:",
      parameters: [
        APIParameter(name: "accountIds", type: .string, isOptional: false, description: "需要获取用户资料的账号列表 List为空， 或者size==0， 返回参数错误", customTypeFields: nil),
      ],
      executeFunction: { (params, callback) in
        guard let accountIdsStr = params["accountIds"] as? String else {
          callback("Error: accountIds is required.")
          return
        }
        
        let accountIds: [String] = accountIdsStr.split(separator: ",").compactMap { String($0) }
        NIMSDK.shared().v2UserService.getUserList(accountIds) { users in
          callback("getUserList success. \(users)")
        } failure: { error in
          callback("getUserList failed. \(error)")
        }
      }
    ), 
    "getUserList:error:": APIDefinition(
      name: "getUserList:error:",
      parameters: [
        APIParameter(name: "accountIds", type: .string, isOptional: false, description: "需要获取用户资料的账号列表 List为空， 或者size==0， 返回参数错误", customTypeFields: nil),
      ],
      executeFunction: { (params, callback) in
        guard let accountIdsStr = params["accountIds"] as? String else {
          callback("Error: accountIds is required.")
          return
        }
        
        var error: V2NIMError?
        let accountIds: [String] = accountIdsStr.split(separator: ",").compactMap { String($0) }
        let users = NIMSDK.shared().v2UserService.getUserList(accountIds, error: &error)
        if let error = error {
          callback("getUserList failed. \(error)")
        } else {
          callback("getUserList success. \(String(describing: users))")
        }
      }
    ), 
    "getUserInfo:error:": APIDefinition(
      name: "getUserInfo:error:",
      parameters: [
        APIParameter(name: "accountId", type: .string, isOptional: false, description: "需要获取用户资料的账号", customTypeFields: nil),
      ],
      executeFunction: { (params, callback) in
        guard let accountId = params["accountId"] as? String else {
          callback("Error: accountId is required.")
          return
        }
        
        var error: V2NIMError?
        let users = NIMSDK.shared().v2UserService.getUserInfo(accountId, error: &error)
        if let error = error {
          callback("getUserInfo failed. \(error)")
        } else {
          callback("getUserInfo success. \(String(describing: users))")
        }
      }
    ), 
    "getUserListFromCloud:success:failure:": APIDefinition(
      name: "getUserListFromCloud:success:failure:",
      parameters: [
        APIParameter(name: "accountIds", type: .string, isOptional: false, description: "需要获取用户资料的账号列表 List为空， 或者size==0， 返回参数错误", customTypeFields: nil),
      ],
      executeFunction: { (params, callback) in
        guard let accountIdsStr = params["accountIds"] as? String else {
          callback("Error: accountIds is required.")
          return
        }
        
        let accountIds: [String] = accountIdsStr.split(separator: ",").compactMap { String($0) }
        NIMSDK.shared().v2UserService.getUserList(fromCloud: accountIds) { users in
          callback("getUserListFromCloud:success:failure: success. \(users)")
        } failure: { error in
          callback("getUserListFromCloud:success:failure: failed. \(error)")
        }
      }
    ), 
    "searchUserByOption:success:failure:": APIDefinition(
      name: "searchUserByOption:success:failure:",
      parameters: [
        APIParameter(name: "userSearchOption", type: .custom("V2NIMUserSearchOption"), isOptional: true, description: "用户搜索相关参数", customTypeFields: [
          APIParameter(name: "keyword", type: .string, isOptional: true, description: "搜索关键字， 默认搜索用户昵称， 可以指定是否同时搜索用户账号， 手机号", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "searchName", type: .bool, isOptional: true, description: "是否搜索用户昵称", customTypeFields: nil, defaultValue: false),
          APIParameter(name: "searchAccountId", type: .bool, isOptional: true, description: "是否搜索用户账号", customTypeFields: nil, defaultValue: false),
          APIParameter(name: "searchMobile", type: .bool, isOptional: true, description: "是否搜索手机号", customTypeFields: nil, defaultValue: false),
        ]),
      ],
      executeFunction: { (params, callback) in
        let userSearchOption = V2NIMUserSearchOption.fromDic(params)
        NIMSDK.shared().v2UserService.searchUser(by: userSearchOption) { users in
          callback("searchUserByOption:success:failure: success. \(users)")
        } failure: { error in
          callback("searchUserByOption:success:failure: failed. \(error)")
        }
      }
    ), 
    "updateSelfUserProfile:success:failure:": APIDefinition(
      name: "updateSelfUserProfile:success:failure:",
      parameters: [
        APIParameter(name: "updateParams", type: .custom("V2NIMUserUpdateParams"), isOptional: true, description: "更新自己的用户资料参数", customTypeFields: [
          APIParameter(name: "name", type: .string, isOptional: true, description: "用户昵称", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "avatar", type: .string, isOptional: true, description: "用户头像图片地址", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "sign", type: .string, isOptional: true, description: "用户签名", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "email", type: .string, isOptional: true, description: "用户邮箱", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "birthday", type: .string, isOptional: true, description: "用户生日", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "mobile", type: .string, isOptional: true, description: "电话号码", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "gender", type: .int, isOptional: true, description: "用户性别", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "serverExtension", type: .string, isOptional: true, description: "用户扩展字段，建议使用json格式", customTypeFields: nil, defaultValue: ""),
        ]),
      ],
      executeFunction: { (params, callback) in
        let updateParams = V2NIMUserUpdateParams.fromDic(params)
        NIMSDK.shared().v2UserService.updateSelfUserProfile(updateParams) { 
          callback("updateSelfUserProfile:success:failure: success.")
        } failure: { error in
          callback("updateSelfUserProfile:success:failure: failed. \(error)")
        }
      }
    ), 
    "addUserToBlockList:success:failure:": APIDefinition(
      name: "addUserToBlockList:success:failure:",
      parameters: [
        APIParameter(name: "accountId", type: .string, isOptional: false, description: "需要添加进黑名单的用户ID", customTypeFields: nil),
      ],
      executeFunction: { (params, callback) in
        guard let accountId = params["accountId"] as? String else {
          callback("Error: accountId is required.")
          return
        }
        
        NIMSDK.shared().v2UserService.addUser(toBlockList: accountId) {
          callback("addUserToBlockList:success:failure: success.")
        } failure: { error in
          callback("addUserToBlockList:success:failure: failed. \(error)")
        }
      }
    ), 
    "removeUserFromBlockList:success:failure:": APIDefinition(
      name: "removeUserFromBlockList:success:failure:",
      parameters: [
        APIParameter(name: "accountId", type: .string, isOptional: false, description: "需要移除黑名单的用户ID", customTypeFields: nil),
      ],
      executeFunction: { (params, callback) in
        guard let accountId = params["accountId"] as? String else {
          callback("Error: accountId is required.")
          return
        }
        
        NIMSDK.shared().v2UserService.removeUser(fromBlockList: accountId) {
          callback("removeUserFromBlockList:success:failure: success.")
        } failure: { error in
          callback("removeUserFromBlockList:success:failure: failed. \(error)")
        }
      }
    ), 
    "getBlockList:failure:": APIDefinition(
      name: "getBlockList:failure:",
      parameters: [
      ],
      executeFunction: { (params, callback) in
        NIMSDK.shared().v2UserService.getBlockList() { users in
          callback("getBlockList:failure: success. \(users)")
        } failure: { error in
          callback("getBlockList:failure: failed. \(error)")
        }
      }
    ), 
    "checkBlock:success:failure:": APIDefinition(
      name: "checkBlock:success:failure:",
      parameters: [
        APIParameter(name: "accountIds", type: .string, isOptional: false, description: " 检查黑名单状态的账号ID列表", customTypeFields: nil),
      ],
      executeFunction: { (params, callback) in
        guard let accountIdsStr = params["accountIds"] as? String else {
          callback("Error: accountIds is required.")
          return
        }
        
        let accountIds: [String] = accountIdsStr.split(separator: ",").compactMap { String($0) }
        NIMSDK.shared().v2UserService.checkBlock(accountIds) { result in
          callback("checkBlock:success:failure: success. \(result)")
        } failure: { error in
          callback("checkBlock:success:failure: failed. \(error)")
        }
      }
    ), 
    "checkBlock:": APIDefinition(
      name: "checkBlock:",
      parameters: [
        APIParameter(name: "accountIds", type: .string, isOptional: false, description: "检查黑名单状态的账号ID列表", customTypeFields: nil),
      ],
      executeFunction: { (params, callback) in
        guard let accountIdsStr = params["accountIds"] as? String else {
          callback("Error: accountIds is required.")
          return
        }
        
        let accountIds: [String] = accountIdsStr.split(separator: ",").compactMap { String($0) }
        let result = NIMSDK.shared().v2UserService.checkBlock(accountIds)
        callback("checkBlock success. \(String(describing: result))")
      }
    ), 
  ]
}
