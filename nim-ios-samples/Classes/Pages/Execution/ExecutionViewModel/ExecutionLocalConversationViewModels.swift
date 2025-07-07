//
//  ExecutionLocalConversationViewModels.swift
//  nim-ios-samples
//
//  Created by 陈吉力 on 2025/6/22.
//

import Foundation

class V2LocalConversationListener: NSObject, V2NIMLocalConversationListener {
  
  func onSyncStarted() {
      Logger.log("onSyncStarted")
  }
  
  func onSyncFinished() {
      Logger.log("onSyncFinished")
  }
  
  func onSyncFailed(_ error: V2NIMError) {
      Logger.log("onSyncFailed error.code:\(error.code) error.description:\(error.description)")
  }
  
  func onConversationCreated(_ conversation: V2NIMLocalConversation) {
      Logger.log("onConversationCreated: \(conversation)")
  }
  
  func onConversationDeleted(_ conversationIds: [String]) {
      Logger.log("onConversationDeleted: \(conversationIds)")
  }
  
  func onConversationChanged(_ conversationList: [V2NIMLocalConversation]) {
      Logger.log("onConversationChanged: \(conversationList)")
  }
  
  func onTotalUnreadCountChanged(_ unreadCount: Int) {
      Logger.log("onTotalUnreadCountChanged: \(unreadCount)")
  }
  
  func onUnreadCountChanged(by filter: V2NIMLocalConversationFilter, unreadCount: Int) {
      Logger.log("onUnreadCountChanged filter:\(filter) unreadCount:\(unreadCount)")
  }
  
  func onConversationReadTimeUpdated(_ conversationId: String, readTime: TimeInterval) {
      Logger.log("onConversationReadTimeUpdated conversationId:\(conversationId) readTime:\(readTime)")
  }
}

class ExecutionLocalConversationViewModels {
  static  let listener: V2NIMLocalConversationListener = V2LocalConversationListener()
  
  static let apiDefinitionDict: [String: APIDefinition] = [
    "addConversationListener:": APIDefinition(
      name: "addConversationListener:",
      parameters:[],
      executeFunction: { (params, callback) in
        NIMSDK.shared().v2LocalConversationService.add(ExecutionLocalConversationViewModels.listener)
        callback("addConversationListener success.")
      }
    ),
    "removeConversationListener:": APIDefinition(
      name: "removeConversationListener:",
      parameters:[],
      executeFunction: { (params, callback) in
        NIMSDK.shared().v2LocalConversationService.remove(ExecutionLocalConversationViewModels.listener)
        callback("removeConversationListener success.")
      }
    ),
    "getConversationList:limit:success:failure:": APIDefinition(
      name: "getConversationList:limit:success:failure:",
      parameters: [
        APIParameter(name: "offset", type: .int, isOptional: true, description: "分页偏移，首次传0，后续拉取采用上一次返回的offset", customTypeFields: nil, defaultValue: 0),
        APIParameter(name: "limit", type: .int, isOptional: true, description: "分页拉取数量，不建议超过100， 内部不做校验，但是数据太大会影响查询时间 小于等于0，默认为100", customTypeFields: nil, defaultValue: 0),
      ],
      executeFunction: { (params, callback) in
        let offset = params["offset"] as? Int ?? 0
        let limit = params["limit"] as? Int ?? 100
        NIMSDK.shared().v2LocalConversationService.getConversationList(offset, limit: limit) { localConversation in
          callback("getConversationList success. \(localConversation)")
        } failure: { error in
          callback("getConversationList failed. \(error)")
        }
      }
    ), 
    "getConversationList:limit:error:": APIDefinition(
      name: "getConversationList:limit:error:",
      parameters: [
        APIParameter(name: "offset", type: .int, isOptional: true, description: "分页偏移，首次传0，后续拉取采用上一次返回的offset", customTypeFields: nil, defaultValue: 0),
        APIParameter(name: "limit", type: .int, isOptional: true, description: "分页拉取数量，不建议超过100， 内部不做校验，但是数据太大会影响查询时间 小于等于0，默认为100", customTypeFields: nil, defaultValue: 0),
      ],
      executeFunction: { (params, callback) in
        let offset = params["offset"] as? Int ?? 0
        let limit = params["limit"] as? Int ?? 100
        var error: V2NIMError?
        let localConversation = NIMSDK.shared().v2LocalConversationService.getConversationList(offset, limit: limit, error: &error)
        if let error = error {
          callback("getConversationList failed. \(error)")
        } else {
          callback("getConversationList success. \(String(describing: localConversation))")
        }
      }
    ), 
    "getConversationListByOption:limit:option:success:failure:": APIDefinition(
      name: "getConversationListByOption:limit:option:success:failure:",
      parameters: [
        APIParameter(name: "offset", type: .int, isOptional: true, description: "分页偏移，首次传0，后续拉取采用上一次返回的offset", customTypeFields: nil, defaultValue: 0),
        APIParameter(name: "limit", type: .int, isOptional: true, description: "分页拉取数量，不建议超过100， 内部不做校验，但是数据太大会影响查询时间 小于等于0，默认为100", customTypeFields: nil, defaultValue: 0),
        APIParameter(name: "option", type: .custom("V2NIMLocalConversationOption"), isOptional: true, description: "查询参数，具体参见Option定义 所有参数为空则退化为getConversationList", customTypeFields: [
          APIParameter(name: "conversationTypes", type: .string, isOptional: true, description: "查询指定会话类型, empty: 不限制会话类型", customTypeFields: nil, defaultValue: []),
          APIParameter(name: "onlyUnread", type: .bool, isOptional: true, description: "NO：查询所有会话 YES：查询包含未读的会话", customTypeFields: nil, defaultValue: false),
        ]),
      ],
      executeFunction: { (params, callback) in
        let offset = params["offset"] as? Int ?? 0
        let limit = params["limit"] as? Int ?? 100
        let option = V2NIMLocalConversationOption.fromDic(params)
        NIMSDK.shared().v2LocalConversationService.getConversationList(byOption: offset, limit: limit, option: option) { localConversation in
          callback("getConversationListByOption success. \(localConversation)")
        } failure: { error in
          callback("getConversationListByOption failed. \(error)")
        }
      }
    ), 
    "getConversation:success:failure:": APIDefinition(
      name: "getConversation:success:failure:",
      parameters: [
        APIParameter(name: "conversationId", type: .string, isOptional: false, description: "会话ID", customTypeFields: nil),
      ],
      executeFunction: { (params, callback) in
        guard let conversationId = params["conversationId"] as? String else {
          callback("Error: conversationId is required.")
          return
        }
        NIMSDK.shared().v2LocalConversationService.getConversation(conversationId) { localConversation in
          callback("getConversation success. \(localConversation)")
        } failure: { error in
          callback("getConversation failed. \(error)")
        }
      }
    ), 
    "getConversation:error:": APIDefinition(
      name: "getConversation:error:",
      parameters: [
        APIParameter(name: "conversationId", type: .string, isOptional: false, description: "会话ID", customTypeFields: nil),
      ],
      executeFunction: { (params, callback) in
        guard let conversationId = params["conversationId"] as? String else {
          callback("Error: conversationId is required.")
          return
        }
        var error: V2NIMError?
        let localConversation = NIMSDK.shared().v2LocalConversationService.getConversation(conversationId, error: &error)
        if let error = error {
          callback("getConversation failed. \(error)")
        } else {
          callback("getConversation success. \(String(describing: localConversation))")
        }
      }
    ), 
    "getConversationListByIds:success:failure:": APIDefinition(
      name: "getConversationListByIds:success:failure:",
      parameters: [
        APIParameter(name: "conversationIds", type: .string, isOptional: false, description: "会话ID列表", customTypeFields: nil),
      ],
      executeFunction: { (params, callback) in
        guard let conversationId = params["conversationIds"] as? [String] else {
          callback("Error: conversationIds is required.")
          return
        }
        NIMSDK.shared().v2LocalConversationService.getConversationList(byIds: conversationId) { localConversation in
          callback("getConversationListByIds success. \(localConversation)")
        } failure: { error in
          callback("getConversationListByIds failed. \(error)")
        }
      }
    ), 
    "createConversation:success:failure:": APIDefinition(
      name: "createConversation:success:failure:",
      parameters: [
        APIParameter(name: "conversationId", type: .string, isOptional: false, description: "会话ID", customTypeFields: nil),
      ],
      executeFunction: { (params, callback) in
        guard let conversationId = params["conversationId"] as? String else {
          callback("Error: conversationId is required.")
          return
        }
        NIMSDK.shared().v2LocalConversationService.createConversation(conversationId) { localConversation in
          callback("createConversation success. \(localConversation)")
        } failure: { error in
          callback("createConversation failed. \(error)")
        }
      }
    ), 
    "deleteConversation:clearMessage:success:failure:": APIDefinition(
      name: "deleteConversation:clearMessage:success:failure:",
      parameters: [
        APIParameter(name: "conversationId", type: .string, isOptional: false, description: "会话ID", customTypeFields: nil),
        APIParameter(name: "clearMessage", type: .bool, isOptional: true, description: "是否删除本地会话对应的本地历史消息 true：清空本地历史消息 非云端，仅本地，此处是与云端会话的 deleteConversation 的差异点 注意：如果需要删除远端消息， 请调用消息模块的 clearHistoryMessage false：只删除会话，历史消息保留", customTypeFields: nil, defaultValue: false),
      ],
      executeFunction: { (params, callback) in
        guard let conversationId = params["conversationId"] as? String else {
          callback("Error: conversationId is required.")
          return
        }
        let clearMessage = params["clearMessage"] as? Bool ?? false
        NIMSDK.shared().v2LocalConversationService.deleteConversation(conversationId, clearMessage: clearMessage) {
          callback("deleteConversation success. ")
        } failure: { error in
          callback("deleteConversation failed. \(error)")
        }
      }
    ), 
    "deleteConversationListByIds:clearMessage:success:failure:": APIDefinition(
      name: "deleteConversationListByIds:clearMessage:success:failure:",
      parameters: [
        APIParameter(name: "conversationIds", type: .string, isOptional: false, description: "会话ID列表", customTypeFields: nil),
        APIParameter(name: "clearMessage", type: .bool, isOptional: true, description: "是否删除本地会话对应的本地历史消息 true：清空本地历史消息 非云端，仅本地，此处是与云端会话的 deleteConversation 的差异点 注意：如果需要删除远端消息， 请调用消息模块的 clearHistoryMessage false：只删除会话，历史消息保留", customTypeFields: nil, defaultValue: false),
      ],
      executeFunction: { (params, callback) in
        guard let conversationIds = params["conversationIds"] as? [String] else {
          callback("Error: conversationIds is required.")
          return
        }
        
        let clearMessage = params["clearMessage"] as? Bool ?? false
        NIMSDK.shared().v2LocalConversationService.deleteConversationList(byIds: conversationIds, clearMessage: clearMessage) { result in
          callback("deleteConversationListByIds success. \(result)")
        } failure: { error in
          callback("deleteConversationListByIds failed. \(error)")
        }
      }
    ), 
    "getStickTopConversationList:success:failure:": APIDefinition(
      name: "getStickTopConversationList:success:failure:",
      parameters: [
        
      ],
      executeFunction: { (params, callback) in
        NIMSDK.shared().v2LocalConversationService.getStickTopConversationList { localConversations in
          callback("getStickTopConversationList success. \(localConversations)")
        } failure: { error in
          callback("getStickTopConversationList failed. \(error)")
        }
      }
    ), 
    "stickTopConversation:stickTop:success:failure:": APIDefinition(
      name: "stickTopConversation:stickTop:success:failure:",
      parameters: [
        APIParameter(name: "conversationId", type: .string, isOptional: false, description: "会话ID", customTypeFields: nil),
        APIParameter(name: "stickTop", type: .bool, isOptional: true, description: "是否置顶会话", customTypeFields: nil, defaultValue: false),
      ],
      executeFunction: { (params, callback) in
        guard let conversationId = params["conversationId"] as? String else {
          callback("Error: conversationId is required.")
          return
        }
        
        let stickTop = params["stickTop"] as? Bool ?? false
        NIMSDK.shared().v2LocalConversationService.stickTopConversation(conversationId, stickTop: stickTop) { 
          callback("stickTopConversation success.")
        } failure: { error in
          callback("stickTopConversation failed. \(error)")
        }
      }
    ), 
    "updateConversationLocalExtension:localExtension:success:failure:": APIDefinition(
      name: "updateConversationLocalExtension:localExtension:success:failure:",
      parameters: [
        APIParameter(name: "conversationId", type: .string, isOptional: false, description: "会话ID", customTypeFields: nil),
        APIParameter(name: "localExtension", type: .string, isOptional: true, description: "更新会话本地扩展字段 参数为null， 表示不更新， 返回参数错误", customTypeFields: nil),
      ],
      executeFunction: { (params, callback) in
        guard let conversationId = params["conversationId"] as? String else {
          callback("Error: conversationId is required.")
          return
        }
        let localExtension = params["localExtension"] as? String ?? ""
        NIMSDK.shared().v2LocalConversationService.updateConversationLocalExtension(conversationId, localExtension: localExtension) { 
          callback("updateConversationLocalExtension success.")
        } failure: { error in
          callback("updateConversationLocalExtension failed. \(error)")
        }
      }
    ),
    "getTotalUnreadCount": APIDefinition(
      name: "getTotalUnreadCount",
      parameters: [
        
      ],
      executeFunction: { (params, callback) in
        let count = NIMSDK.shared().v2LocalConversationService.getTotalUnreadCount()
        callback("getTotalUnreadCount success. \(count)")
      }
    ),
    "getUnreadCountByIds:success:failure:": APIDefinition(
      name: "getUnreadCountByIds:success:failure:",
      parameters: [
        APIParameter(name: "conversationIds", type: .string, isOptional: false, description: "会话ID列表", customTypeFields: nil),
      ],
      executeFunction: { (params, callback) in
        guard let conversationIds = params["conversationIds"] as? [String] else {
          callback("Error: conversationIds is required.")
          return
        }
        NIMSDK.shared().v2LocalConversationService.getUnreadCount(byIds: conversationIds) { count in
          callback("getUnreadCountByIds success. \(count)")
        } failure: { error in
          callback("getUnreadCountByIds failed. \(error)")
        }
      }
    ),
    "getUnreadCountByFilter:success:failure:": APIDefinition(
      name: "getUnreadCountByFilter:success:failure:",
      parameters: [
        APIParameter(name: "filter", type: .custom("V2NIMLocalConversationFilter"), isOptional: true, description: "查询参数，具体参见Filter定义 所有参数均不填， 则返回参数错误，请直接调用getTotalUnreadCount方法", customTypeFields: [
          APIParameter(name: "conversationTypes", type: .string, isOptional: true, description: "查询指定会话类型, empty: 不限制会话类型", customTypeFields: nil, defaultValue: []),
          APIParameter(name: "ignoreMuted", type: .bool, isOptional: true, description: "过滤免打扰的会话类型", customTypeFields: nil, defaultValue: false),
        ]),
      ],
      executeFunction: { (params, callback) in
        let filter = V2NIMLocalConversationFilter.fromDic(params)
        NIMSDK.shared().v2LocalConversationService.getUnreadCount(by: filter) { count in
          callback("getUnreadCountByFilter success. \(count)")
        } failure: { error in
          callback("getUnreadCountByFilter failed. \(error)")
        }
      }
    ),
    "clearTotalUnreadCount:failure:": APIDefinition(
      name: "clearTotalUnreadCount:failure:",
      parameters: [
        
      ],
      executeFunction: { (params, callback) in
        NIMSDK.shared().v2LocalConversationService.clearTotalUnreadCount { 
          callback("clearTotalUnreadCount success.")
        } failure: { error in
          callback("clearTotalUnreadCount failed. \(error)")
        }
      }
    ),
    "clearUnreadCountByIds:success:failure:": APIDefinition(
      name: "clearUnreadCountByIds:success:failure:",
      parameters: [
        APIParameter(name: "conversationIds", type: .string, isOptional: false, description: "会话ID列表", customTypeFields: nil),
      ],
      executeFunction: { (params, callback) in
        guard let conversationIds = params["conversationIds"] as? [String] else {
          callback("Error: conversationIds is required.")
          return
        }
        NIMSDK.shared().v2LocalConversationService.clearUnreadCount(byIds: conversationIds) { result in
          callback("clearUnreadCountByIds success. \(result)")
        } failure: { error in
          callback("clearUnreadCountByIds failed. \(error)")
        }
      }
    ),
    "clearUnreadCountByTypes:success:failure:": APIDefinition(
      name: "clearUnreadCountByTypes:success:failure:",
      parameters: [
        APIParameter(name: "conversationTypes", type: .string, isOptional: true, description: "需要清理未读的会话类型列表", customTypeFields: nil, defaultValue: []),
      ],
      executeFunction: { (params, callback) in
        var conversationTypes = [NSNumber]()
        if let conversationTypesStr = params["conversationTypes"] as? String {
          let conversationTypeNums:[NSNumber] = conversationTypesStr.split(separator: ",").compactMap { Int($0) }.map { NSNumber(value: $0) }
          conversationTypes = conversationTypeNums
        }
        
        NIMSDK.shared().v2LocalConversationService.clearUnreadCount(byTypes: conversationTypes) { 
          callback("clearUnreadCountByTypes success.")
        } failure: { error in
          callback("clearUnreadCountByTypes failed. \(error)")
        }
      }
    ),
    "subscribeUnreadCountByFilter:": APIDefinition(
      name: "subscribeUnreadCountByFilter:",
      parameters: [
        APIParameter(name: "filter", type: .custom("V2NIMLocalConversationFilter"), isOptional: true, description: "过滤器", customTypeFields: [
          APIParameter(name: "conversationTypes", type: .string, isOptional: true, description: "查询指定会话类型, empty: 不限制会话类型", customTypeFields: nil, defaultValue: []),
          APIParameter(name: "ignoreMuted", type: .bool, isOptional: true, description: "过滤免打扰的会话类型", customTypeFields: nil, defaultValue: false),
        ]),
      ],
      executeFunction: { (params, callback) in
        let filter = V2NIMLocalConversationFilter.fromDic(params)
        let error = NIMSDK.shared().v2LocalConversationService.subscribeUnreadCount(by: filter)
        if let err = error {
          callback("subscribeUnreadCountByFilter failed. \(err)")
        } else {
          callback("subscribeUnreadCountByFilter success.")
        }
      }
    ),
    "unsubscribeUnreadCountByFilter:": APIDefinition(
      name: "unsubscribeUnreadCountByFilter:",
      parameters: [
        APIParameter(name: "filter", type: .custom("V2NIMLocalConversationFilter"), isOptional: true, description: "过滤器", customTypeFields: [
          APIParameter(name: "conversationTypes", type: .string, isOptional: true, description: "查询指定会话类型, empty: 不限制会话类型", customTypeFields: nil, defaultValue: []),
          APIParameter(name: "ignoreMuted", type: .bool, isOptional: true, description: "过滤免打扰的会话类型", customTypeFields: nil, defaultValue: false),
        ]),
      ],
      executeFunction: { (params, callback) in
        let filter = V2NIMLocalConversationFilter.fromDic(params)
        NIMSDK.shared().v2LocalConversationService.unsubscribeUnreadCount(by: filter)
        callback("unsubscribeUnreadCountByFilter success.")
      }
    ),
    "getConversationReadTime:success:failure:": APIDefinition(
      name: "getConversationReadTime:success:failure:",
      parameters: [
        APIParameter(name: "conversationId", type: .string, isOptional: false, description: "会话ID", customTypeFields: nil),
      ],
      executeFunction: { (params, callback) in
        guard let conversationId = params["conversationId"] as? String else {
          callback("Error: conversationId is required.")
          return
        }
        NIMSDK.shared().v2LocalConversationService.getConversationReadTime(conversationId) { readTime in
          callback("getConversationReadTime success. \(readTime)")
        } failure: { error in
          callback("getConversationReadTime failed. \(error)")
        }
      }
    ),
    "markConversationRead:success:failure:": APIDefinition(
      name: "markConversationRead:success:failure:",
      parameters: [
        APIParameter(name: "conversationId", type: .string, isOptional: false, description: "会话ID", customTypeFields: nil),
      ],
      executeFunction: { (params, callback) in
        guard let conversationId = params["conversationId"] as? String else {
          callback("Error: conversationId is required.")
          return
        }
        NIMSDK.shared().v2LocalConversationService.markConversationRead(conversationId) { readTime in
          callback("markConversationRead success. \(readTime)")
        } failure: { error in
          callback("markConversationRead failed. \(error)")
        }
      }
    ),
  ]
}
