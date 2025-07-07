//
//  ExecutionFriendViewModels.swift
//  nim-ios-samples
//
//  Created by 陈吉力 on 2025/6/22.
//

import Foundation

class V2FriendListener: NSObject, V2NIMFriendListener {
  
  func onFriendAdded(_ friendInfo: V2NIMFriend) {
      Logger.log("onFriendAdded friendInfo:\(friendInfo)")
  }
  
  func onFriendDeleted(_ accountId: String, deletionType: V2NIMFriendDeletionType) {
      Logger.log("onFriendDeleted accountId:\(accountId) deletionType:\(deletionType.rawValue)")
  }
  
  func onFriendAddApplication(_ application: V2NIMFriendAddApplication) {
      Logger.log("onFriendAddApplication application:\(application)")
  }
  
  func onFriendAddRejected(_ rejectionInfo: V2NIMFriendAddApplication) {
      Logger.log("onFriendAddRejected rejectionInfo:\(rejectionInfo)")
  }
  
  func onFriendInfoChanged(_ friendInfo: V2NIMFriend) {
      Logger.log("onFriendInfoChanged friendInfo:\(friendInfo)")
  }
}

class ExecutionFriendViewModels {
  static  let listener: V2NIMFriendListener = V2FriendListener()
  
  static let apiDefinitionDict: [String: APIDefinition] = [
    "addFriendListener:": APIDefinition(
      name: "addFriendListener:",
      parameters:[],
      executeFunction: { (params, callback) in
        NIMSDK.shared().v2FriendService.add(ExecutionFriendViewModels.listener)
        callback("addFriendListener success.")
      }
    ),
    "removeFriendListener:": APIDefinition(
      name: "removeFriendListener:",
      parameters:[],
      executeFunction: { (params, callback) in
        NIMSDK.shared().v2FriendService.remove(ExecutionFriendViewModels.listener)
        callback("removeFriendListener success.")
      }
    ),
    
    "addFriend:params:success:failure:": APIDefinition(
      name: "addFriend:params:success:failure:",
      parameters: [
        APIParameter(name: "accountId", type: .string, isOptional: false, description: "被添加为好友的账号ID", customTypeFields: nil),
        APIParameter(name: "params", type: .custom("V2NIMFriendAddParams"), isOptional: true, description: "添加好友参数", customTypeFields: [
          APIParameter(name: "addMode", type: .int, isOptional: true, description: "添加好友模式", customTypeFields: nil, defaultValue: 1),
          APIParameter(name: "postscript", type: .string, isOptional: true, description: "添加/申请添加好友的附言", customTypeFields: nil, defaultValue: ""),
        ]),
      ],
      executeFunction: { (params, callback) in
        guard let accountId = params["accountId"] as? String else {
          callback("Error: accountId is required.")
          return
        }
        
        let params = V2NIMFriendAddParams.fromDic(params)
        NIMSDK.shared().v2FriendService.addFriend(accountId, params: params) {
          callback("addFriend success.")
        } failure: { error in
          callback("addFriend failed. \(error)")
        }
      }
    ), 
    
    "deleteFriend:params:success:failure:": APIDefinition(
      name: "deleteFriend:params:success:failure:",
      parameters: [
        APIParameter(name: "accountId", type: .string, isOptional: false, description: "删除好友的账号ID", customTypeFields: nil),
        APIParameter(name: "params", type: .custom("V2NIMFriendDeleteParams"), isOptional: true, description: "删除好友参数", customTypeFields: [
          APIParameter(name: "deleteAlias", type: .bool, isOptional: true, description: "是否同步删除前置设置的备注", customTypeFields: nil, defaultValue: false),
        ]),
      ],
      executeFunction: { (params, callback) in
        guard let accountId = params["accountId"] as? String else {
          callback("Error: accountId is required.")
          return
        }
        
        let params = V2NIMFriendDeleteParams.fromDic(params)
        NIMSDK.shared().v2FriendService.deleteFriend(accountId, params: params) {
          callback("deleteFriend success.")
        } failure: { error in
          callback("deleteFriend failed. \(error)")
        }
      }
    ),
    "getFriendList:failure:": APIDefinition(
      name: "getFriendList:failure:",
      parameters: [
      ],
      executeFunction: { (params, callback) in
        let params = V2NIMFriendAddParams.fromDic(params)
        NIMSDK.shared().v2FriendService.getFriendList { friends in
          callback("getFriendByIds success. \(friends)")
        } failure: { error in
          callback("getFriendByIds failed. \(error)")
        }
      }
    ),
    "getFriendByIds:success:failure:": APIDefinition(
      name: "getFriendByIds:success:failure:",
      parameters: [
        APIParameter(name: "accountIds", type: .string, isOptional: false, description: "获取好友信息的账号ID列表", customTypeFields: nil),
      ],
      executeFunction: { (params, callback) in
        guard let accountIdsStr = params["accountIds"] as? String else {
          callback("Error: accountIds is required.")
          return
        }
        
        let accountIds: [String] = accountIdsStr.split(separator: ",").compactMap { String($0) }
        NIMSDK.shared().v2FriendService.getFriendByIds(accountIds) { friends in
          callback("getFriendByIds success. \(friends)")
        } failure: { error in
          callback("getFriendByIds failed. \(error)")
        }
      }
    ),
    "searchFriendByOption:success:failure:": APIDefinition(
      name: "searchFriendByOption:success:failure:",
      parameters: [
        APIParameter(name: "friendSearchOption", type: .custom("V2NIMFriendSearchOption"), isOptional: true, description: "搜索好友参数", customTypeFields: [
          APIParameter(name: "keyword", type: .string, isOptional: true, description: "搜索关键字， 默认搜索好友备注， 可以指定是否同时搜索用户账号", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "searchAlias", type: .bool, isOptional: true, description: "是否搜索好友备注", customTypeFields: nil, defaultValue: false),
          APIParameter(name: "searchAccountId", type: .bool, isOptional: true, description: "是否搜索用户账号", customTypeFields: nil, defaultValue: false),
        ]),
      ],
      executeFunction: { (params, callback) in
        let friendSearchOption = V2NIMFriendSearchOption.fromDic(params)
        NIMSDK.shared().v2FriendService.searchFriend(by: friendSearchOption) { friends in
          callback("searchFriendByOption success. \(friends)")
        } failure: { error in
          callback("searchFriendByOption failed. \(error)")
        }
      }
    ),
    "checkFriend:success:failure:": APIDefinition(
      name: "checkFriend:success:failure:",
      parameters: [
        APIParameter(name: "accountIds", type: .string, isOptional: false, description: "检查好友状态的账号ID列表", customTypeFields: nil),
      ],
      executeFunction: { (params, callback) in
        guard let accountIdsStr = params["accountIds"] as? String else {
          callback("Error: accountIds is required.")
          return
        }
        
        let accountIds: [String] = accountIdsStr.split(separator: ",").compactMap { String($0) }
        
        NIMSDK.shared().v2FriendService.checkFriend(accountIds) { result in
          callback("checkFriend success. \(result)")
        } failure: { error in
          callback("checkFriend failed. \(error)")
        }
      }
    ),
    "setFriendInfo:params:success:failure:": APIDefinition(
      name: "setFriendInfo:params:success:failure:",
      parameters: [
        APIParameter(name: "accountId", type: .string, isOptional: false, description: "好友的账号ID", customTypeFields: nil),
        APIParameter(name: "params", type: .custom("V2NIMFriendSetParams"), isOptional: true, description: "设置好友信息参数", customTypeFields: [
          APIParameter(name: "alias", type: .string, isOptional: true, description: "设置的别名,不传表示不设置,为空表示清空别名", customTypeFields: nil, defaultValue: nil),
          APIParameter(name: "serverExtension", type: .string, isOptional: true, description: "设置的扩展字段,不传表示不设置,为空表示清空扩展字段", customTypeFields: nil, defaultValue: nil),
        ]),
      ],
      executeFunction: { (params, callback) in
        guard let accountId = params["accountId"] as? String else {
          callback("Error: accountId is required.")
          return
        }
        
        let params = V2NIMFriendSetParams.fromDic(params)
        NIMSDK.shared().v2FriendService.setFriendInfo(accountId, params: params) {
          callback("setFriendInfo success.")
        } failure: { error in
          callback("setFriendInfo failed. \(error)")
        }
      }
    ),
    "acceptAddApplication:success:failure:": APIDefinition(
      name: "acceptAddApplication:success:failure:",
      parameters: [
        APIParameter(name: "application", type: .custom("V2NIMFriendAddApplication"), isOptional: true, description: "好友申请", customTypeFields: [
          APIParameter(name: "applicantAccountId", type: .string, isOptional: false, description: "申请者账号", customTypeFields: nil),
          APIParameter(name: "recipientAccountId", type: .string, isOptional: false, description: "被申请者账号", customTypeFields: nil),
          APIParameter(name: "operatorAccountId", type: .string, isOptional: false, description: "操作者账号", customTypeFields: nil),
          APIParameter(name: "postscript", type: .string, isOptional: true, description: "申请添加好友的附言", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "status", type: .int, isOptional: true, description: "操作的状态", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "timestamp", type: .int, isOptional: true, description: "操作的时间", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "read", type: .bool, isOptional: true, description: "是否已读", customTypeFields: nil, defaultValue: false),
        ]),
      ],
      executeFunction: { (params, callback) in
        let application = V2NIMFriendAddApplication.fromDic(params)
        NIMSDK.shared().v2FriendService.accept(application) {
          callback("acceptAddApplication success.")
        } failure: { error in
          callback("acceptAddApplication failed. \(error)")
        }
      }
    ),
    "rejectAddApplication:postscript:success:failure:": APIDefinition(
      name: "rejectAddApplication:postscript:success:failure:",
      parameters: [
        APIParameter(name: "application", type: .custom("V2NIMFriendAddApplication"), isOptional: true, description: "好友申请", customTypeFields: [
          APIParameter(name: "applicantAccountId", type: .string, isOptional: false, description: "申请者账号", customTypeFields: nil),
          APIParameter(name: "recipientAccountId", type: .string, isOptional: false, description: "被申请者账号", customTypeFields: nil),
          APIParameter(name: "operatorAccountId", type: .string, isOptional: false, description: "操作者账号", customTypeFields: nil),
          APIParameter(name: "postscript", type: .string, isOptional: true, description: "申请添加好友的附言", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "status", type: .int, isOptional: true, description: "操作的状态", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "timestamp", type: .int, isOptional: true, description: "操作的时间", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "read", type: .bool, isOptional: true, description: "是否已读", customTypeFields: nil, defaultValue: false),
        ]),
        APIParameter(name: "postscript", type: .string, isOptional: true, description: "拒绝申请的附言", customTypeFields: nil, defaultValue: ""),
      ],
      executeFunction: { (params, callback) in
        let postscript = params["postscript"] as? String ?? ""
        
        let application = V2NIMFriendAddApplication.fromDic(params)
        NIMSDK.shared().v2FriendService.reject(application, postscript: postscript) {
          callback("rejectAddApplication success.")
        } failure: { error in
          callback("rejectAddApplication failed. \(error)")
        }
      }
    ),
    "getAddApplicationList:success:failure:": APIDefinition(
      name: "getAddApplicationList:success:failure:",
      parameters: [
        APIParameter(name: "option", type: .custom("V2NIMFriendAddApplicationQueryOption"), isOptional: true, description: "获取申请添加好友列表通知参数", customTypeFields: [
          APIParameter(name: "offset", type: .int, isOptional: true, description: "首次传0， 下一次传上一次返回的offset，不包含offset", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "limit", type: .int, isOptional: true, description: "每次查询的数量", customTypeFields: nil, defaultValue: 50),
          APIParameter(name: "status", type: .int, isOptional: true, description: "V2NIMFriendAddApplicationStatus 枚举值， 或者size为0， 表示查询所有状态否则按输入状态查询", customTypeFields: nil, defaultValue: []),
        ]),
      ],
      executeFunction: { (params, callback) in
        let option = V2NIMFriendAddApplicationQueryOption.fromDic(params)
        NIMSDK.shared().v2FriendService.getAddApplicationList(option) { result in
          callback("getAddApplicationList success. \(result)")
        } failure: { error in
          callback("getAddApplicationList failed. \(error)")
        }
      }
    ),
    "getAddApplicationUnreadCount:failure:": APIDefinition(
      name: "getAddApplicationUnreadCount:failure:",
      parameters: [
      ],
      executeFunction: { (params, callback) in
        NIMSDK.shared().v2FriendService.getAddApplicationUnreadCount { count in
          callback("getAddApplicationUnreadCount success. \(count)")
        } failure: { error in
          callback("getAddApplicationUnreadCount failed. \(error)")
        }
      }
    ),
    "setAddApplicationRead:failure:": APIDefinition(
      name: "setAddApplicationRead:failure:",
      parameters: [
      ],
      executeFunction: { (params, callback) in
        NIMSDK.shared().v2FriendService.setAddApplicationRead { success in
          callback("setAddApplicationRead success. \(success)")
        } failure: { error in
          callback("setAddApplicationRead failed. \(error)")
        }
      }
    ),
    "clearAllAddApplication:failure:": APIDefinition(
      name: "clearAllAddApplication:failure:",
      parameters: [
      ],
      executeFunction: { (params, callback) in
        NIMSDK.shared().v2FriendService.clearAllAddApplication {
          callback("clearAllAddApplication success.")
        } failure: { error in
          callback("clearAllAddApplication failed. \(error)")
        }
      }
    ),
    "deleteAddApplication:success:failure:": APIDefinition(
      name: "deleteAddApplication:success:failure:",
      parameters: [
        APIParameter(name: "application", type: .custom("V2NIMFriendAddApplication"), isOptional: true, description: "好友申请", customTypeFields: [
          APIParameter(name: "applicantAccountId", type: .string, isOptional: false, description: "申请者账号", customTypeFields: nil),
          APIParameter(name: "recipientAccountId", type: .string, isOptional: false, description: "被申请者账号", customTypeFields: nil),
          APIParameter(name: "operatorAccountId", type: .string, isOptional: false, description: "操作者账号", customTypeFields: nil),
          APIParameter(name: "postscript", type: .string, isOptional: true, description: "申请添加好友的附言", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "status", type: .int, isOptional: true, description: "操作的状态", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "timestamp", type: .int, isOptional: true, description: "操作的时间", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "read", type: .bool, isOptional: true, description: "是否已读", customTypeFields: nil, defaultValue: false),
        ]),
      ],
      executeFunction: { (params, callback) in
        let application = V2NIMFriendAddApplication.fromDic(params)
        NIMSDK.shared().v2FriendService.delete(application) {
          callback("deleteAddApplication success.")
        } failure: { error in
          callback("deleteAddApplication failed. \(error)")
        }
      }
    ),
  ]
}
