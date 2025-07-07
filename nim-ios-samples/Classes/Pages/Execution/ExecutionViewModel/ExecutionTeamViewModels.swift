//
//  ExecutionTeamViewModels.swift
//  nim-ios-samples
//
//  Created by 陈吉力 on 2025/6/22.
//

import Foundation

class V2TeamListener: NSObject, V2NIMTeamListener {
  
  func onSyncStarted() {
      Logger.log("onSyncStarted")
  }
  
  func onSyncFinished() {
      Logger.log("onSyncFinished")
  }
  
  func onSyncFailed(_ error: V2NIMError) {
      Logger.log("onSyncFailed error.code:\(error.code) error.description:\(error.description)")
  }
  
  func onTeamCreated(_ team: V2NIMTeam) {
      Logger.log("onTeamCreated team:\(team)")
  }
  
  func onTeamDismissed(_ team: V2NIMTeam) {
      Logger.log("onTeamDismissed team:\(team)")
  }
  
  func onTeamJoined(_ team: V2NIMTeam) {
      Logger.log("onTeamJoined team:\(team)")
  }
  
  func onTeamLeft(_ team: V2NIMTeam, isKicked: Bool) {
      Logger.log("onTeamLeft team:\(team) isKicked\(isKicked)")
  }
  
  func onTeamInfoUpdated(_ team: V2NIMTeam) {
      Logger.log("onTeamInfoUpdated team:\(team)")
  }
  
  func onTeamMemberJoined(_ teamMembers: [V2NIMTeamMember]) {
      Logger.log("onTeamMemberJoined teamMembers:\(teamMembers)")
  }
  
  func onTeamMemberKicked(_ operatorAccountId: String, teamMembers: [V2NIMTeamMember]) {
      Logger.log("onTeamMemberKicked operatorAccountId:\(operatorAccountId) teamMembers\(teamMembers)")
  }
  
  func onTeamMemberLeft(_ teamMembers: [V2NIMTeamMember]) {
      Logger.log("onTeamMemberLeft teamMembers:\(teamMembers)")
  }
  
  func onTeamMemberInfoUpdated(_ teamMembers: [V2NIMTeamMember]) {
      Logger.log("onTeamMemberInfoUpdated teamMembers:\(teamMembers)")
  }
  
  func onReceive(_ joinActionInfo: V2NIMTeamJoinActionInfo) {
      Logger.log("onReceive joinActionInfo:\(joinActionInfo)")
  }
}

class ExecutionTeamViewModels {
  static  let listener: V2NIMTeamListener = V2TeamListener()
  
  static let apiDefinitionDict: [String: APIDefinition] = [
    "addTeamListener:": APIDefinition(
      name: "addTeamListener:",
      parameters:[],
      executeFunction: { (params, callback) in
        NIMSDK.shared().v2TeamService.add(ExecutionTeamViewModels.listener)
        callback("addTeamListener success.")
      }
    ),
    "removeTeamListener:": APIDefinition(
      name: "removeTeamListener:",
      parameters:[],
      executeFunction: { (params, callback) in
        NIMSDK.shared().v2TeamService.add(ExecutionTeamViewModels.listener)
        callback("removeTeamListener success.")
      }
    ),
    "createTeam:inviteeAccountIds:postscript:antispamConfig:success:failure:": APIDefinition(
      name: "createTeam:inviteeAccountIds:postscript:antispamConfig:success:failure:",
      parameters: [
        APIParameter(name: "createTeamParams", type: .custom("V2NIMCreateTeamParams"), isOptional: true, description: "创建参数", customTypeFields: [
          APIParameter(name: "name", type: .string, isOptional: true, description: "群组名称", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
          APIParameter(name: "memberLimit", type: .int, isOptional: true, description: "群组人数上限", customTypeFields: nil),
          APIParameter(name: "intro", type: .string, isOptional: true, description: "群组介绍", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "announcement", type: .string, isOptional: true, description: "群组公告", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "avatar", type: .string, isOptional: true, description: "群组头像", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "serverExtension", type: .string, isOptional: true, description: "服务端扩展字段", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "joinMode", type: .int, isOptional: true, description: "申请入群模式", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "agreeMode", type: .int, isOptional: true, description: "被邀请人同意入群模式", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "inviteMode", type: .int, isOptional: true, description: "邀请入群模式", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "updateInfoMode", type: .int, isOptional: true, description: "群组资料修改模式", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "updateExtensionMode", type: .int, isOptional: true, description: "群组扩展字段修改模式", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "chatBannedMode", type: .int, isOptional: true, description: "群组禁言模式", customTypeFields: nil, defaultValue: 0),
        ]),
        APIParameter(name: "inviteeAccountIds", type: .string, isOptional: true, description: "邀请加入账号id列表", customTypeFields: nil, defaultValue: []),
        APIParameter(name: "postscript", type: .string, isOptional: true, description: "附言", customTypeFields: nil, defaultValue: ""),
        APIParameter(name: "antispamConfig", type: .custom("V2NIMAntispamConfig"), isOptional: true, description: "反垃圾配置", customTypeFields: [
          APIParameter(name: "antispamBusinessId", type: .string, isOptional: true, description: "指定易盾业务ID，而不使用云信后台配置的安全通", customTypeFields: nil, defaultValue: ""),
        ]),
      ],
      executeFunction: { (params, callback) in
        var inviteeAccountIds: [String]? = nil
        if let inviteeAccountIdsStr = params["inviteeAccountIds"] as? String {
          inviteeAccountIds = inviteeAccountIdsStr.split(separator: ",").map { String($0) }
        }
        
        let createTeamParams = V2NIMCreateTeamParams.fromDic(params)
        let antispamConfig = V2NIMAntispamConfig.fromDic(params)
        let postscript = params["postscript"] as? String ?? ""
        NIMSDK.shared().v2TeamService.createTeam(createTeamParams, inviteeAccountIds: inviteeAccountIds, postscript: postscript, antispamConfig: antispamConfig) { result in
          callback("createTeam:inviteeAccountIds:postscript:antispamConfig:success:failure: success. \(result)")
        } failure: { error in
          callback("createTeam:inviteeAccountIds:postscript:antispamConfig:success:failure: failed. \(error)")
        }
      }
    ), 
    "updateTeamInfo:teamType:updateTeamInfoParams:antispamConfig:success:failure:": APIDefinition(
      name: "updateTeamInfo:teamType:updateTeamInfoParams:antispamConfig:success:failure:",
      parameters: [
        APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
        APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
        APIParameter(name: "updateTeamInfoParams", type: .custom("V2NIMUpdateTeamInfoParams"), isOptional: true, description: "更新参数", customTypeFields: [
          APIParameter(name: "name", type: .string, isOptional: true, description: "群组名称", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "memberLimit", type: .int, isOptional: true, description: "群组人数上限", customTypeFields: nil),
          APIParameter(name: "intro", type: .string, isOptional: true, description: "群组介绍", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "announcement", type: .string, isOptional: true, description: "群组公告", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "avatar", type: .string, isOptional: true, description: "群组头像", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "serverExtension", type: .string, isOptional: true, description: "服务端扩展字段", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "joinMode", type: .int, isOptional: true, description: "申请入群模式", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "agreeMode", type: .int, isOptional: true, description: "被邀请人同意入群模式", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "inviteMode", type: .int, isOptional: true, description: "邀请入群模式", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "updateInfoMode", type: .int, isOptional: true, description: "群组资料修改模式", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "updateExtensionMode", type: .int, isOptional: true, description: "群组扩展字段修改模式", customTypeFields: nil, defaultValue: 0),
        ]),
        APIParameter(name: "antispamConfig", type: .custom("V2NIMAntispamConfig"), isOptional: true, description: "反垃圾配置", customTypeFields: [
          APIParameter(name: "antispamBusinessId", type: .string, isOptional: true, description: "指定易盾业务ID，而不使用云信后台配置的安全通", customTypeFields: nil, defaultValue: ""),
        ]),
      ],
      executeFunction: { (params, callback) in
        guard let teamId = params["teamId"] as? String else {
          callback("Error: teamId is required.")
          return
        }
        
        let teamTypeInt = params["teamType"] as? Int ?? 1
        let teamType: V2NIMTeamType = V2NIMTeamType(rawValue: teamTypeInt) ?? .TEAM_TYPE_NORMAL
        
        let updateTeamInfoParams = V2NIMUpdateTeamInfoParams.fromDic(params)
        let antispamConfig = V2NIMAntispamConfig.fromDic(params)
        let postscript = params["postscript"] as? String ?? ""
        NIMSDK.shared().v2TeamService.updateTeamInfo(teamId, teamType: teamType, updateTeamInfoParams: updateTeamInfoParams, antispamConfig: antispamConfig) {
          callback("updateTeamInfo:teamType:updateTeamInfoParams:antispamConfig:success:failure: success.")
        } failure: { error in
          callback("updateTeamInfo:teamType:updateTeamInfoParams:antispamConfig:success:failure: failed. \(error)")
        }
      }
    ), 
    "leaveTeam:teamType:success:failure:": APIDefinition(
      name: "leaveTeam:teamType:success:failure:",
      parameters: [
        APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
        APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
      ],
      executeFunction: { (params, callback) in
        guard let teamId = params["teamId"] as? String else {
          callback("Error: teamId is required.")
          return
        }
        
        let teamTypeInt = params["teamType"] as? Int ?? 1
        let teamType: V2NIMTeamType = V2NIMTeamType(rawValue: teamTypeInt) ?? .TEAM_TYPE_NORMAL
        NIMSDK.shared().v2TeamService.leaveTeam(teamId, teamType: teamType) {
          callback("leaveTeam:teamType:success:failure: success.)")
        } failure: { error in
          callback("leaveTeam:teamType:success:failure: failed. \(error)")
        }
      }
    ), 
    "getTeamInfo:teamType:success:failure:": APIDefinition(
      name: "getTeamInfo:teamType:success:failure:",
      parameters: [
        APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
        APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
      ],
      executeFunction: { (params, callback) in
        guard let teamId = params["teamId"] as? String else {
          callback("Error: teamId is required.")
          return
        }
        
        let teamTypeInt = params["teamType"] as? Int ?? 1
        let teamType: V2NIMTeamType = V2NIMTeamType(rawValue: teamTypeInt) ?? .TEAM_TYPE_NORMAL
        NIMSDK.shared().v2TeamService.getTeamInfo(teamId, teamType: teamType) { result in
          callback("getTeamInfo:teamType:success:failure: success. \(result)")
        } failure: { error in
          callback("getTeamInfo:teamType:success:failure: failed. \(error)")
        }
      }
    ), 
    "getTeamInfo:teamType:error:": APIDefinition(
      name: "getTeamInfo:teamType:error:",
      parameters: [
        APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
        APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
      ],
      executeFunction: { (params, callback) in
        guard let teamId = params["teamId"] as? String else {
          callback("Error: teamId is required.")
          return
        }
        
        let teamTypeInt = params["teamType"] as? Int ?? 1
        let teamType: V2NIMTeamType = V2NIMTeamType(rawValue: teamTypeInt) ?? .TEAM_TYPE_NORMAL
        var error: V2NIMError?
        let result = NIMSDK.shared().v2TeamService.getTeamInfo(teamId, teamType: teamType, error: &error)
        if let err = error {
          callback("getTeamInfo:teamType:error: failed. \(err)")
        } else {
          callback("getTeamInfo:teamType:error: success. \(result)")
        }
      }
    ), 
    "getTeamInfoByIds:teamType:success:failure:": APIDefinition(
      name: "getTeamInfoByIds:teamType:success:failure:",
      parameters: [
        APIParameter(name: "teamIds", type: .string, isOptional: false, description: "群组Id列表", customTypeFields: nil),
        APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
      ],
      executeFunction: { (params, callback) in
        guard let teamIdsStr = params["teamIds"] as? String else {
          callback("Error: teamIds is required.")
          return
        }
        
        let teamIds: [String] = teamIdsStr.split(separator: ",").compactMap { String($0) }
        let teamTypeInt = params["teamType"] as? Int ?? 1
        let teamType: V2NIMTeamType = V2NIMTeamType(rawValue: teamTypeInt) ?? .TEAM_TYPE_NORMAL
        
        NIMSDK.shared().v2TeamService.getTeamInfo(byIds: teamIds, teamType: teamType) { result in
          callback("getTeamInfoByIds:teamType:success:failure: success. \(result)")
        } failure: { error in
          callback("getTeamInfoByIds:teamType:success:failure: failed. \(error)")
        }
      }
    ), 
    "getTeamInfoByIds:teamType:error:": APIDefinition(
      name: "getTeamInfoByIds:teamType:error:",
      parameters: [
        APIParameter(name: "teamIds", type: .string, isOptional: false, description: "群组Id列表", customTypeFields: nil),
        APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
      ],
      executeFunction: { (params, callback) in
        guard let teamIdsStr = params["teamIds"] as? String else {
          callback("Error: teamIds is required.")
          return
        }
        
        let teamIds: [String] = teamIdsStr.split(separator: ",").compactMap { String($0) }
        let teamTypeInt = params["teamType"] as? Int ?? 1
        let teamType: V2NIMTeamType = V2NIMTeamType(rawValue: teamTypeInt) ?? .TEAM_TYPE_NORMAL
        var error: V2NIMError?
        let result = NIMSDK.shared().v2TeamService.getTeamInfo(byIds: teamIds, teamType: teamType, error: &error)
        if let err = error {
          callback("getTeamInfoByIds:teamType:error: failed. \(err)")
        } else {
          callback("getTeamInfoByIds:teamType:error: success. \(result)")
        }
      }
    ), 
    "dismissTeam:teamType:success:failure:": APIDefinition(
      name: "dismissTeam:teamType:success:failure:",
      parameters: [
        APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
        APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
      ],
      executeFunction: { (params, callback) in
        guard let teamId = params["teamId"] as? String else {
          callback("Error: teamId is required.")
          return
        }
        
        let teamTypeInt = params["teamType"] as? Int ?? 1
        let teamType: V2NIMTeamType = V2NIMTeamType(rawValue: teamTypeInt) ?? .TEAM_TYPE_NORMAL
        NIMSDK.shared().v2TeamService.dismissTeam(teamId, teamType: teamType) {
          callback("dismissTeam:teamType:success:failure: success.")
        } failure: { error in
          callback("dismissTeam:teamType:success:failure: failed. \(error)")
        }
      }
    ), 
    "inviteMember:teamType:inviteeAccountIds:postscript:success:failure:": APIDefinition(
      name: "inviteMember:teamType:inviteeAccountIds:postscript:success:failure:",
      parameters: [
        APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
        APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
        APIParameter(name: "inviteeAccountIds", type: .string, isOptional: true, description: "邀请加入账号id列表", customTypeFields: nil, defaultValue: []),
        APIParameter(name: "postscript", type: .string, isOptional: true, description: "附言", customTypeFields: nil, defaultValue: ""),
      ],
      executeFunction: { (params, callback) in
        guard let teamId = params["teamId"] as? String else {
          callback("Error: teamId is required.")
          return
        }
        
        var inviteeAccountIds: [String] = []
        if let inviteeAccountIdsStr = params["inviteeAccountIds"] as? String {
          inviteeAccountIds = inviteeAccountIdsStr.split(separator: ",").map { String($0) }
        }
        
        let postscript = params["postscript"] as? String ?? ""
        let teamTypeInt = params["teamType"] as? Int ?? 1
        let teamType: V2NIMTeamType = V2NIMTeamType(rawValue: teamTypeInt) ?? .TEAM_TYPE_NORMAL
        
        NIMSDK.shared().v2TeamService.inviteMember(teamId, teamType: teamType, inviteeAccountIds: inviteeAccountIds, postscript: postscript) { failedList in
          callback("inviteMember:teamType:inviteeAccountIds:postscript:success:failure: success. \(failedList)")
        } failure: { error in
          callback("inviteMember:teamType:inviteeAccountIds:postscript:success:failure: failed. \(error)")
        }
      }
    ), 
    "inviteMemberEx:teamType:inviteeParams:success:failure:": APIDefinition(
      name: "inviteMemberEx:teamType:inviteeParams:success:failure:",
      parameters: [
        APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
        APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
        APIParameter(name: "inviteeParams", type: .custom("V2NIMTeamInviteParams"), isOptional: true, description: "邀请入群的参数", customTypeFields: [
          APIParameter(name: "inviteeAccountIds", type: .string, isOptional: true, description: "被邀请加入群的成员账号列表", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "postscript", type: .string, isOptional: true, description: "附言", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "serverExtension", type: .string, isOptional: true, description: "邀请入群的扩展字段，暂不支持超大群", customTypeFields: nil, defaultValue: ""),
        ]),
      ],
      executeFunction: { (params, callback) in
        guard let teamId = params["teamId"] as? String else {
          callback("Error: teamId is required.")
          return
        }
        
        let teamTypeInt = params["teamType"] as? Int ?? 1
        let teamType: V2NIMTeamType = V2NIMTeamType(rawValue: teamTypeInt) ?? .TEAM_TYPE_NORMAL
        let inviteeParams = V2NIMTeamInviteParams.fromDic(params)
        
        NIMSDK.shared().v2TeamService.inviteMemberEx(teamId, teamType: teamType, inviteeParams: inviteeParams) { failedList in
          callback("inviteMemberEx:teamType:inviteeParams:success:failure: success. \(failedList)")
        } failure: { error in
          callback("inviteMemberEx:teamType:inviteeParams:success:failure: failed. \(error)")
        }
      }
    ), 
    "acceptInvitation:success:failure:": APIDefinition(
      name: "acceptInvitation:success:failure:",
      parameters: [
        APIParameter(name: "applicationInfo", type: .custom("V2NIMTeamJoinActionInfo"), isOptional: true, description: "邀请信息", customTypeFields: [
          APIParameter(name: "actionType", type: .int, isOptional: true, description: "入群操作类型", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
          APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
          APIParameter(name: "operatorAccountId", type: .string, isOptional: true, description: "操作账号id", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "postscript", type: .string, isOptional: true, description: "附言", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "timestamp", type: .double, isOptional: true, description: "时间戳", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "actionStatus", type: .int, isOptional: true, description: "操作状态", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "serverExtension", type: .string, isOptional: true, description: " 邀请入群的扩展字段", customTypeFields: nil, defaultValue: ""),
        ]),
      ],
      executeFunction: { (params, callback) in
        let applicationInfo = V2NIMTeamJoinActionInfo.fromDic(params)
        NIMSDK.shared().v2TeamService.acceptInvitation(applicationInfo) { result in
          callback("acceptInvitation:success:failure: success. \(result)")
        } failure: { error in
          callback("acceptInvitation:success:failure: failed. \(error)")
        }
      }
    ), 
    "rejectInvitation:postscript:success:failure:": APIDefinition(
      name: "rejectInvitation:postscript:success:failure:",
      parameters: [
        APIParameter(name: "applicationInfo", type: .custom("V2NIMTeamJoinActionInfo"), isOptional: true, description: "邀请信息", customTypeFields: [
          APIParameter(name: "actionType", type: .int, isOptional: true, description: "入群操作类型", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
          APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
          APIParameter(name: "operatorAccountId", type: .string, isOptional: true, description: "操作账号id", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "postscript", type: .string, isOptional: true, description: "附言", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "timestamp", type: .double, isOptional: true, description: "时间戳", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "actionStatus", type: .int, isOptional: true, description: "操作状态", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "serverExtension", type: .string, isOptional: true, description: "邀请入群的扩展字段", customTypeFields: nil, defaultValue: ""),
        ]),
        APIParameter(name: "postscript", type: .string, isOptional: true, description: "拒绝邀请入群的附言", customTypeFields: nil, defaultValue: ""),
      ],
      executeFunction: { (params, callback) in
        let applicationInfo = V2NIMTeamJoinActionInfo.fromDic(params)
        let postscript = params["postscript"] as? String ?? ""
        NIMSDK.shared().v2TeamService.rejectInvitation(applicationInfo, postscript: postscript) {
          callback("rejectInvitation:postscript:success:failure: success.")
        } failure: { error in
          callback("rejectInvitation:postscript:success:failure: failed. \(error)")
        }
      }
    ), 
    "kickMember:teamType:memberAccountIds:success:failure:": APIDefinition(
      name: "kickMember:teamType:memberAccountIds:success:failure:",
      parameters: [
        APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
        APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
        APIParameter(name: "memberAccountIds", type: .string, isOptional: true, description: "踢出群组的成员账号列表", customTypeFields: nil, defaultValue: []),
      ],
      executeFunction: { (params, callback) in
        guard let teamId = params["teamId"] as? String else {
          callback("Error: teamId is required.")
          return
        }
        
        var memberAccountIds: [String] = []
        if let memberAccountIdsStr = params["memberAccountIds"] as? String {
          memberAccountIds = memberAccountIdsStr.split(separator: ",").map { String($0) }
        }
        
        let teamTypeInt = params["teamType"] as? Int ?? 1
        let teamType: V2NIMTeamType = V2NIMTeamType(rawValue: teamTypeInt) ?? .TEAM_TYPE_NORMAL
        NIMSDK.shared().v2TeamService.kickMember(teamId, teamType: teamType, memberAccountIds: memberAccountIds) {
          callback("kickMember:teamType:memberAccountIds:success:failure: success.")
        } failure: { error in
          callback("kickMember:teamType:memberAccountIds:success:failure: failed. \(error)")
        }
      }
    ), 
    "applyJoinTeam:teamType:postscript:success:failure:": APIDefinition(
      name: "applyJoinTeam:teamType:postscript:success:failure:",
      parameters: [
        APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
        APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
        APIParameter(name: "postscript", type: .string, isOptional: true, description: "申请入群的附言", customTypeFields: nil, defaultValue: ""),
      ],
      executeFunction: { (params, callback) in
        guard let teamId = params["teamId"] as? String else {
          callback("Error: teamId is required.")
          return
        }
        
        let teamTypeInt = params["teamType"] as? Int ?? 1
        let teamType: V2NIMTeamType = V2NIMTeamType(rawValue: teamTypeInt) ?? .TEAM_TYPE_NORMAL
        let postscript = params["postscript"] as? String ?? ""
        NIMSDK.shared().v2TeamService.applyJoinTeam(teamId, teamType: teamType, postscript: postscript) { result in
          callback("applyJoinTeam:teamType:postscript:success:failure: success. \(result)")
        } failure: { error in
          callback("applyJoinTeam:teamType:postscript:success:failure: failed. \(error)")
        }
      }
    ), 
    "acceptJoinApplication:success:failure:": APIDefinition(
      name: "acceptJoinApplication:success:failure:",
      parameters: [
        APIParameter(name: "applicationInfo", type: .custom("V2NIMTeamJoinActionInfo"), isOptional: true, description: "邀请信息", customTypeFields: [
          APIParameter(name: "actionType", type: .int, isOptional: true, description: "入群操作类型", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
          APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
          APIParameter(name: "operatorAccountId", type: .string, isOptional: true, description: "操作账号id", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "postscript", type: .string, isOptional: true, description: "附言", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "timestamp", type: .double, isOptional: true, description: "时间戳", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "actionStatus", type: .int, isOptional: true, description: "操作状态", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "serverExtension", type: .string, isOptional: true, description: "邀请入群的扩展字段", customTypeFields: nil, defaultValue: ""),
        ]),
      ],
      executeFunction: { (params, callback) in
        let applicationInfo = V2NIMTeamJoinActionInfo.fromDic(params)
        NIMSDK.shared().v2TeamService.acceptJoinApplication(applicationInfo) {
          callback("acceptJoinApplication:success:failure: success.")
        } failure: { error in
          callback("acceptJoinApplication:success:failure: failed. \(error)")
        }
      }
    ), 
    "rejectJoinApplication:postscript:success:failure:": APIDefinition(
      name: "rejectJoinApplication:postscript:success:failure:",
      parameters: [
        APIParameter(name: "applicationInfo", type: .custom("V2NIMTeamJoinActionInfo"), isOptional: true, description: "邀请信息", customTypeFields: [
          APIParameter(name: "actionType", type: .int, isOptional: true, description: "入群操作类型", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
          APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
          APIParameter(name: "operatorAccountId", type: .string, isOptional: true, description: "操作账号id", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "postscript", type: .string, isOptional: true, description: "附言", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "timestamp", type: .double, isOptional: true, description: "时间戳", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "actionStatus", type: .int, isOptional: true, description: "操作状态", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "serverExtension", type: .string, isOptional: true, description: "邀请入群的扩展字段", customTypeFields: nil, defaultValue: ""),
        ]),
        APIParameter(name: "postscript", type: .string, isOptional: true, description: "拒绝申请加入的附言", customTypeFields: nil, defaultValue: ""),
      ],
      executeFunction: { (params, callback) in
        let applicationInfo = V2NIMTeamJoinActionInfo.fromDic(params)
        let postscript = params["postscript"] as? String ?? ""
        NIMSDK.shared().v2TeamService.rejectJoinApplication(applicationInfo, postscript: postscript) {
          callback("rejectJoinApplication:postscript:success:failure: success. ")
        } failure: { error in
          callback("rejectJoinApplication:postscript:success:failure: failed. \(error)")
        }
      }
    ), 
    "updateTeamMemberRole:teamType:memberAccountIds:memberRole:success:failure:": APIDefinition(
      name: "updateTeamMemberRole:teamType:memberAccountIds:memberRole:success:failure:",
      parameters: [
        APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
        APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
        APIParameter(name: "memberAccountIds", type: .string, isOptional: true, description: "设置成员角色的账号id列表", customTypeFields: nil, defaultValue: []),
        APIParameter(name: "memberRole", type: .int, isOptional: true, description: "设置新的角色类型", customTypeFields: nil, defaultValue: 0),
      ],
      executeFunction: { (params, callback) in
        guard let teamId = params["teamId"] as? String else {
          callback("Error: teamId is required.")
          return
        }
        
        var memberAccountIds: [String] = []
        if let memberAccountIdsStr = params["memberAccountIds"] as? String {
          memberAccountIds = memberAccountIdsStr.split(separator: ",").map { String($0) }
        }
        
        let teamTypeInt = params["teamType"] as? Int ?? 1
        let teamType: V2NIMTeamType = V2NIMTeamType(rawValue: teamTypeInt) ?? .TEAM_TYPE_NORMAL
        let memberRoleInt = params["memberRole"] as? Int ?? 1
        let memberRole: V2NIMTeamMemberRole = V2NIMTeamMemberRole(rawValue: memberRoleInt) ?? .TEAM_MEMBER_ROLE_NORMAL
        
        NIMSDK.shared().v2TeamService.updateTeamMemberRole(teamId, teamType: teamType, memberAccountIds: memberAccountIds, memberRole: memberRole) {
          callback("updateTeamMemberRole:teamType:memberAccountIds:memberRole:success:failure: success.")
        } failure: { error in
          callback("updateTeamMemberRole:teamType:memberAccountIds:memberRole:success:failure: failed. \(error)")
        }
      }
    ), 
    "transferTeamOwner:teamType:accountId:leave:success:failure:": APIDefinition(
      name: "transferTeamOwner:teamType:accountId:leave:success:failure:",
      parameters: [
        APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
        APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
        APIParameter(name: "accountId", type: .string, isOptional: true, description: "新群主的账号id", customTypeFields: nil, defaultValue: ""),
        APIParameter(name: "leave", type: .bool, isOptional: true, description: "转让群主后，是否同时退出该群", customTypeFields: nil, defaultValue: false),
      ],
      executeFunction: { (params, callback) in
        guard let teamId = params["teamId"] as? String else {
          callback("Error: teamId is required.")
          return
        }
        
        let teamTypeInt = params["teamType"] as? Int ?? 1
        let teamType: V2NIMTeamType = V2NIMTeamType(rawValue: teamTypeInt) ?? .TEAM_TYPE_NORMAL
        let accountId = params["accountId"] as? String ?? ""
        let leave = params["leave"] as? Bool ?? false
        NIMSDK.shared().v2TeamService.transferTeamOwner(teamId, teamType: teamType, accountId: accountId, leave: leave) {
          callback("transferTeamOwner:teamType:accountId:leave:success:failure: success.")
        } failure: { error in
          callback("transferTeamOwner:teamType:accountId:leave:success:failure: failed. \(error)")
        }
      }
    ), 
    "updateSelfTeamMemberInfo:teamType:memberInfoParams:success:failure:": APIDefinition(
      name: "updateSelfTeamMemberInfo:teamType:memberInfoParams:success:failure:",
      parameters: [
        APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
        APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
        APIParameter(name: "memberInfoParams", type: .custom("V2NIMUpdateSelfMemberInfoParams"), isOptional: true, description: "更新参数", customTypeFields: [
          APIParameter(name: "teamNick", type: .string, isOptional: true, description: "群组昵称", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "serverExtension", type: .string, isOptional: true, description: "服务端扩展字段", customTypeFields: nil, defaultValue: ""),
        ]),
      ],
      executeFunction: { (params, callback) in
        guard let teamId = params["teamId"] as? String else {
          callback("Error: teamId is required.")
          return
        }
        
        let teamTypeInt = params["teamType"] as? Int ?? 1
        let teamType: V2NIMTeamType = V2NIMTeamType(rawValue: teamTypeInt) ?? .TEAM_TYPE_NORMAL
        let memberInfoParams = V2NIMUpdateSelfMemberInfoParams.fromDic(params)
        
        NIMSDK.shared().v2TeamService.updateSelfTeamMemberInfo(teamId, teamType: teamType, memberInfoParams: memberInfoParams) {
          callback("updateSelfTeamMemberInfo:teamType:memberInfoParams:success:failure: success.")
        } failure: { error in
          callback("updateSelfTeamMemberInfo:teamType:memberInfoParams:success:failure: failed. \(error)")
        }
      }
    ), 
    "updateTeamMemberNick:teamType:accountId:teamNick:success:failure:": APIDefinition(
      name: "updateTeamMemberNick:teamType:accountId:teamNick:success:failure:",
      parameters: [
        APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
        APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
        APIParameter(name: "accountId", type: .string, isOptional: false, description: "被修改成员的账号id", customTypeFields: nil, defaultValue: ""),
        APIParameter(name: "teamNick", type: .string, isOptional: true, description: "被修改成员新的昵称", customTypeFields: nil, defaultValue: ""),
      ],
      executeFunction: { (params, callback) in
        guard let teamId = params["teamId"] as? String,
              let accountId = params["accountId"] as? String else {
          callback("Error: teamId,accountId,teamNick is required.")
          return
        }
        
        let teamNick = params["teamNick"] as? String ?? ""
        let teamTypeInt = params["teamType"] as? Int ?? 1
        let teamType: V2NIMTeamType = V2NIMTeamType(rawValue: teamTypeInt) ?? .TEAM_TYPE_NORMAL
        NIMSDK.shared().v2TeamService.updateTeamMemberNick(teamId, teamType: teamType, accountId: accountId, teamNick: teamNick) {
          callback("updateTeamMemberNick:teamType:accountId:teamNick:success:failure: success.")
        } failure: { error in
          callback("updateTeamMemberNick:teamType:accountId:teamNick:success:failure: failed. \(error)")
        }
      }
    ), 
    "setTeamChatBannedMode:teamType:chatBannedMode:success:failure:": APIDefinition(
      name: "setTeamChatBannedMode:teamType:chatBannedMode:success:failure:",
      parameters: [
        APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
        APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
        APIParameter(name: "chatBannedMode", type: .int, isOptional: true, description: "群组禁言模式", customTypeFields: nil, defaultValue: 1),
      ],
      executeFunction: { (params, callback) in
        guard let teamId = params["teamId"] as? String else {
          callback("Error: teamId is required.")
          return
        }
        
        let teamTypeInt = params["teamType"] as? Int ?? 1
        let teamType: V2NIMTeamType = V2NIMTeamType(rawValue: teamTypeInt) ?? .TEAM_TYPE_NORMAL
        let chatBannedModeInt = params["chatBannedMode"] as? Int ?? 1
        let chatBannedMode: V2NIMTeamChatBannedMode = V2NIMTeamChatBannedMode(rawValue: chatBannedModeInt) ?? .TEAM_CHAT_BANNED_MODE_NONE
        
        NIMSDK.shared().v2TeamService.setTeamChatBannedMode(teamId, teamType: teamType, chatBannedMode: chatBannedMode) {
          callback("setTeamChatBannedMode:teamType:chatBannedMode:success:failure: success.")
        } failure: { error in
          callback("setTeamChatBannedMode:teamType:chatBannedMode:success:failure: failed. \(error)")
        }
      }
    ), 
    "setTeamMemberChatBannedStatus:teamType:accountId:chatBanned:success:failure:": APIDefinition(
      name: "setTeamMemberChatBannedStatus:teamType:accountId:chatBanned:success:failure:",
      parameters: [
        APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
        APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
        APIParameter(name: "accountId", type: .string, isOptional: false, description: "群成员账号id", customTypeFields: nil),
        APIParameter(name: "chatBanned", type: .bool, isOptional: true, description: "群组中聊天是否被禁言", customTypeFields: nil, defaultValue: false),
      ],
      executeFunction: { (params, callback) in
        guard let teamId = params["teamId"] as? String,
              let accountId = params["accountId"] as? String else {
          callback("Error: teamId,accountId is required.")
          return
        }
        
        let teamTypeInt = params["teamType"] as? Int ?? 1
        let teamType: V2NIMTeamType = V2NIMTeamType(rawValue: teamTypeInt) ?? .TEAM_TYPE_NORMAL
        let chatBanned = params["chatBanned"] as? Bool ?? false
        
        NIMSDK.shared().v2TeamService.setTeamMemberChatBannedStatus(teamId, teamType: teamType, accountId: accountId, chatBanned: chatBanned) {
          callback("setTeamMemberChatBannedStatus:teamType:accountId:chatBanned:success:failure: success.")
        } failure: { error in
          callback("setTeamMemberChatBannedStatus:teamType:accountId:chatBanned:success:failure: failed. \(error)")
        }
      }
    ), 
    "getJoinedTeamList:success:failure:": APIDefinition(
      name: "getJoinedTeamList:success:failure:",
      parameters: [
        APIParameter(name: "teamTypes", type: .string, isOptional: true, description: "群类型列表，nil或空列表表示获取所有", customTypeFields: nil, defaultValue: ""),
      ],
      executeFunction: { (params, callback) in
        let teamTypesStr = params["teamTypes"] as? String
        let teamTypesNums:[NSNumber] = (teamTypesStr?.split(separator: ",").compactMap { Int($0) }.map { NSNumber(value: $0) }) ?? []
        
        NIMSDK.shared().v2TeamService.getJoinedTeamList(teamTypesNums) { result in
          callback("getJoinedTeamList:success:failure: success. \(result)")
        } failure: { error in
          callback("getJoinedTeamList:success:failure: failed. \(error)")
        }
      }
    ), 
    "getJoinedTeamList:error:": APIDefinition(
      name: "getJoinedTeamList:error:",
      parameters: [
        APIParameter(name: "teamTypes", type: .string, isOptional: true, description: "群类型列表，nil或空列表表示获取所有", customTypeFields: nil, defaultValue: ""),
      ],
      executeFunction: { (params, callback) in
        let teamTypesStr = params["teamTypes"] as? String
        let teamTypesNums:[NSNumber] = (teamTypesStr?.split(separator: ",").compactMap { Int($0) }.map { NSNumber(value: $0) }) ?? []
        var error: V2NIMError?
        let result = NIMSDK.shared().v2TeamService.getJoinedTeamList(teamTypesNums, error: &error)
        if let err = error {
          callback("getJoinedTeamList:error: failed. \(err)")
        } else {
          callback("getJoinedTeamList:error: success. \(result)")
        }
      }
    ), 
    "getOwnerTeamList:error:": APIDefinition(
      name: "getOwnerTeamList:error:",
      parameters: [
        APIParameter(name: "teamTypes", type: .string, isOptional: true, description: "群类型列表，nil或空列表表示获取所有", customTypeFields: nil, defaultValue: ""),
      ],
      executeFunction: { (params, callback) in
        let teamTypesStr = params["teamTypes"] as? String
        let teamTypesNums:[NSNumber] = (teamTypesStr?.split(separator: ",").compactMap { Int($0) }.map { NSNumber(value: $0) }) ?? []
        
        var error: V2NIMError?
        let result = NIMSDK.shared().v2TeamService.getOwnerTeamList(teamTypesNums, error: &error)
        if let err = error {
          callback("getOwnerTeamList:error: failed. \(err)")
        } else {
          callback("getOwnerTeamList:error: success. \(result)")
        }
      }
    ), 
    "getJoinedTeamCount:": APIDefinition(
      name: "getJoinedTeamCount:",
      parameters: [
        APIParameter(name: "teamTypes", type: .string, isOptional: true, description: "群类型列表，nil或空列表表示获取所有", customTypeFields: nil, defaultValue: ""),
      ],
      executeFunction: { (params, callback) in
        let teamTypesStr = params["teamTypes"] as? String
        let teamTypesNums:[NSNumber] = (teamTypesStr?.split(separator: ",").compactMap { Int($0) }.map { NSNumber(value: $0) }) ?? []
        
        let result = NIMSDK.shared().v2TeamService.getJoinedTeamCount(teamTypesNums)
        callback("getOwnerTeamList:error: success. \(result)")
      }
    ), 
    "getJoinedTeamMembers:success:failure:": APIDefinition(
      name: "getJoinedTeamMembers:success:failure:",
      parameters: [
        APIParameter(name: "teamTypes", type: .string, isOptional: true, description: "群类型列表，nil或空列表表示获取所有", customTypeFields: nil, defaultValue: ""),
      ],
      executeFunction: { (params, callback) in
        let teamTypesStr = params["teamTypes"] as? String
        let teamTypesNums:[NSNumber] = (teamTypesStr?.split(separator: ",").compactMap { Int($0) }.map { NSNumber(value: $0) }) ?? []
        
        NIMSDK.shared().v2TeamService.getJoinedTeamMembers(teamTypesNums) { result in
          callback("getJoinedTeamMembers:success:failure: success. \(result)")
        } failure: { error in
          callback("getJoinedTeamMembers:success:failure: failed. \(error)")
        }
      }
    ), 
    "getTeamMemberList:teamType:queryOption:success:failure:": APIDefinition(
      name: "getTeamMemberList:teamType:queryOption:success:failure:",
      parameters: [
        APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
        APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
        APIParameter(name: "queryOption", type: .custom("V2NIMTeamMemberQueryOption"), isOptional: true, description: "群组成员查询选项", customTypeFields: [
          APIParameter(name: "roleQueryType", type: .int, isOptional: true, description: "查询成员类型", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "onlyChatBanned", type: .bool, isOptional: true, description: "是否只返回聊天禁言成员列表，YES true： 只返回聊天禁言成员列表，NO 全部成员列表", customTypeFields: nil, defaultValue: false),
          APIParameter(name: "direction", type: .int, isOptional: true, description: "查询方向", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "nextToken", type: .string, isOptional: true, description: "分页偏移，首次传\"\"，后续拉取采用上一次返回的nextToken", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "limit", type: .int, isOptional: true, description: "分页拉取数量，不建议超过100", customTypeFields: nil, defaultValue: 100),
        ]),
      ],
      executeFunction: { (params, callback) in
        guard let teamId = params["teamId"] as? String else {
          callback("Error: teamId is required.")
          return
        }
        
        let teamTypeInt = params["teamType"] as? Int ?? 1
        let teamType: V2NIMTeamType = V2NIMTeamType(rawValue: teamTypeInt) ?? .TEAM_TYPE_NORMAL
        let queryOption = V2NIMTeamMemberQueryOption.fromDic(params)
        
        NIMSDK.shared().v2TeamService.getTeamMemberList(teamId, teamType: teamType, queryOption: queryOption) { result in
          callback("getTeamMemberList:teamType:queryOption:success:failure: success. \(result)")
        } failure: { error in
          callback("getTeamMemberList:teamType:queryOption:success:failure: failed. \(error)")
        }
      }
    ), 
    "getTeamMemberListByIds:teamType:accountIds:success:failure:": APIDefinition(
      name: "getTeamMemberListByIds:teamType:accountIds:success:failure:",
      parameters: [
        APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
        APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
        APIParameter(name: "accountIds", type: .string, isOptional: true, description: "账号id列表", customTypeFields: nil, defaultValue: []),
      ],
      executeFunction: { (params, callback) in
        guard let teamId = params["teamId"] as? String else {
          callback("Error: teamId is required.")
          return
        }
        
        let teamTypeInt = params["teamType"] as? Int ?? 1
        let teamType: V2NIMTeamType = V2NIMTeamType(rawValue: teamTypeInt) ?? .TEAM_TYPE_NORMAL
        
        var accountIds = [String]()
        if let accountIdsStr = params["accountIds"] as? String {
          accountIds = accountIdsStr.split(separator: ",").map { String($0) }
        }
        
        NIMSDK.shared().v2TeamService.getTeamMemberList(byIds: teamId, teamType: teamType, accountIds: accountIds) { result in
          callback("getTeamMemberListByIds:teamType:accountIds:success:failure: success. \(result)")
        } failure: { error in
          callback("getTeamMemberListByIds:teamType:accountIds:success:failure: failed. \(error)")
        }
      }
    ), 
    "getTeamMemberListByIds:teamType:accountIds:error:": APIDefinition(
      name: "getTeamMemberListByIds:teamType:accountIds:error:",
      parameters: [
        APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
        APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
        APIParameter(name: "accountIds", type: .string, isOptional: true, description: "账号id列表", customTypeFields: nil, defaultValue: []),
      ],
      executeFunction: { (params, callback) in
        guard let teamId = params["teamId"] as? String else {
          callback("Error: teamId is required.")
          return
        }
        
        let teamTypeInt = params["teamType"] as? Int ?? 1
        let teamType: V2NIMTeamType = V2NIMTeamType(rawValue: teamTypeInt) ?? .TEAM_TYPE_NORMAL
        
        var accountIds = [String]()
        if let accountIdsStr = params["accountIds"] as? String {
          accountIds = accountIdsStr.split(separator: ",").map { String($0) }
        }
        
        var error: V2NIMError?
        let result = NIMSDK.shared().v2TeamService.getTeamMemberList(byIds: teamId, teamType: teamType, accountIds: accountIds, error: &error)
        if let err = error {
          callback("getTeamMemberListByIds:teamType:accountIds:error: failed. \(err)")
        } else {
          callback("ggetTeamMemberListByIds:teamType:accountIds:error: success. \(result)")
        }
      }
    ), 
    "getTeamMemberInvitor:teamType:accountIds:success:failure:": APIDefinition(
      name: "getTeamMemberInvitor:teamType:accountIds:success:failure:",
      parameters: [
        APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
        APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
        APIParameter(name: "accountIds", type: .string, isOptional: true, description: "账号id列表", customTypeFields: nil, defaultValue: []),
      ],
      executeFunction: { (params, callback) in
        guard let teamId = params["teamId"] as? String else {
          callback("Error: teamId is required.")
          return
        }
        
        let teamTypeInt = params["teamType"] as? Int ?? 1
        let teamType: V2NIMTeamType = V2NIMTeamType(rawValue: teamTypeInt) ?? .TEAM_TYPE_NORMAL
        
        var accountIds = [String]()
        if let accountIdsStr = params["accountIds"] as? String {
          accountIds = accountIdsStr.split(separator: ",").map { String($0) }
        }
        
        NIMSDK.shared().v2TeamService.getTeamMemberInvitor(teamId, teamType: teamType, accountIds: accountIds) { result in
          callback("getTeamMemberInvitor:teamType:accountIds:success:failure: success. \(result)")
        } failure: { error in
          callback("getTeamMemberInvitor:teamType:accountIds:success:failure: failed. \(error)")
        }
      }
    ), 
    "getTeamJoinActionInfoList:success:failure:": APIDefinition(
      name: "getTeamJoinActionInfoList:success:failure:",
      parameters: [
        APIParameter(name: "option", type: .custom("V2NIMTeamJoinActionInfoQueryOption"), isOptional: true, description: "查询参数", customTypeFields: [
          APIParameter(name: "types", type: .string, isOptional: true, description: "入群操作类型列表，输入类型为V2NIMTeamJoinActionType", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "offset", type: .int, isOptional: true, description: "查询偏移，首次传0， 下一次传上一次返回的offset，默认0", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "limit", type: .int, isOptional: true, description: "查询数量，默认50", customTypeFields: nil, defaultValue: 50),
          APIParameter(name: "status", type: .string, isOptional: true, description: "入群操作状态列表，输入类型为V2NIMTeamJoinActionStatus", customTypeFields: nil, defaultValue: ""),            
        ]),
      ],
      executeFunction: { (params, callback) in
        let option = V2NIMTeamJoinActionInfoQueryOption.fromDic(params)
        NIMSDK.shared().v2TeamService.getTeamJoinActionInfoList(option) { result in
          callback("getTeamJoinActionInfoList:success:failure: success. \(result)")
        } failure: { error in
          callback("getTeamJoinActionInfoList:success:failure: failed. \(error)")
        }
      }
    ), 
    "searchTeamByKeyword:success:failure:": APIDefinition(
      name: "searchTeamByKeyword:success:failure:",
      parameters: [
        APIParameter(name: "keyword", type: .string, isOptional: true, description: "关键字", customTypeFields: nil, defaultValue: ""),
      ],
      executeFunction: { (params, callback) in
        let keyword = params["keyword"] as? String ?? ""
        NIMSDK.shared().v2TeamService.searchTeam(byKeyword: keyword) { result in
          callback("searchTeamByKeyword:success:failure: success. \(result)")
        } failure: { error in
          callback("searchTeamByKeyword:success:failure: failed. \(error)")
        }
      }
    ), 
    "searchTeamMembers:success:failure:": APIDefinition(
      name: "searchTeamMembers:success:failure:",
      parameters: [
        APIParameter(name: "searchOption", type: .custom("V2NIMTeamMemberSearchOption"), isOptional: true, description: "搜索参数", customTypeFields: [
          APIParameter(name: "keyword", type: .string, isOptional: true, description: "搜索关键词，不为空", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "teamId", type: .string, isOptional: true, description: "群组id， 如果不传则检索所有群， 如果需要检索特定的群， 则需要同时传入teamId+teamType", customTypeFields: nil),
          APIParameter(name: "nextToken", type: .string, isOptional: true, description: "起始位置，首次传@\"\"， 后续传上次返回的nextToken", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "order", type: .bool, isOptional: true, description: "V2NIM_SORT_ORDER_DESC 按joinTime降序，V2NIM_SORT_ORDER_ASC 按joinTime升序", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "limit", type: .bool, isOptional: true, description: "查询成员的个数。 默认10", customTypeFields: nil, defaultValue: 10),
          APIParameter(name: "initNextToken", type: .string, isOptional: true, description: "初始传入的nextToken", customTypeFields: nil, defaultValue: ""),
        ]),
      ],
      executeFunction: { (params, callback) in
        let searchOption = V2NIMTeamMemberSearchOption.fromDic(params)
        
        NIMSDK.shared().v2TeamService.searchTeamMembers(searchOption) { result in
          callback("searchTeamMembers:success:failure: success. \(result)")
        } failure: { error in
          callback("searchTeamMembers:success:failure: failed. \(error)")
        }
      }
    ), 
    "addTeamMembersFollow:teamType:accountIds:success:failure:": APIDefinition(
      name: "addTeamMembersFollow:teamType:accountIds:success:failure:",
      parameters: [
        APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
        APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
        APIParameter(name: "accountIds", type: .string, isOptional: true, description: "账号id列表", customTypeFields: nil, defaultValue: []),
      ],
      executeFunction: { (params, callback) in
        guard let teamId = params["teamId"] as? String else {
          callback("Error: teamId is required.")
          return
        }
        
        let teamTypeInt = params["teamType"] as? Int ?? 1
        let teamType: V2NIMTeamType = V2NIMTeamType(rawValue: teamTypeInt) ?? .TEAM_TYPE_NORMAL
        
        var accountIds = [String]()
        if let accountIdsStr = params["accountIds"] as? String {
          accountIds = accountIdsStr.split(separator: ",").map { String($0) }
        }
        
        NIMSDK.shared().v2TeamService.addTeamMembersFollow(teamId, teamType: teamType, accountIds: accountIds) {
          callback("addTeamMembersFollow:teamType:accountIds:success:failure: success.")
        } failure: { error in
          callback("addTeamMembersFollow:teamType:accountIds:success:failure: failed. \(error)")
        }
      }
    ), 
    "removeTeamMembersFollow:teamType:accountIds:success:failure:": APIDefinition(
      name: "removeTeamMembersFollow:teamType:accountIds:success:failure:",
      parameters: [
        APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
        APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
        APIParameter(name: "accountIds", type: .string, isOptional: true, description: "账号id列表", customTypeFields: nil, defaultValue: []),
      ],
      executeFunction: { (params, callback) in
        guard let teamId = params["teamId"] as? String else {
          callback("Error: teamId is required.")
          return
        }
        
        let teamTypeInt = params["teamType"] as? Int ?? 1
        let teamType: V2NIMTeamType = V2NIMTeamType(rawValue: teamTypeInt) ?? .TEAM_TYPE_NORMAL
        
        var accountIds = [String]()
        if let accountIdsStr = params["accountIds"] as? String {
          accountIds = accountIdsStr.split(separator: ",").map { String($0) }
        }
        
        NIMSDK.shared().v2TeamService.removeTeamMembersFollow(teamId, teamType: teamType, accountIds: accountIds) {
          callback("removeTeamMembersFollow:teamType:accountIds:success:failure: success.")
        } failure: { error in
          callback("removeTeamMembersFollow:teamType:accountIds:success:failure: failed. \(error)")
        }
      }
    ), 
    "clearAllTeamJoinActionInfo:failure:": APIDefinition(
      name: "clearAllTeamJoinActionInfo:failure:",
      parameters: [
        
      ],
      executeFunction: { (params, callback) in
        NIMSDK.shared().v2TeamService.clearAllTeamJoinActionInfo() {
          callback("clearAllTeamJoinActionInfo:failure: success.")
        } failure: { error in
          callback("clearAllTeamJoinActionInfo:failure: failed. \(error)")
        }
      }
    ), 
    "deleteTeamJoinActionInfo:success:failure:": APIDefinition(
      name: "deleteTeamJoinActionInfo:success:failure:",
      parameters: [
        APIParameter(name: "applicationInfo", type: .custom("V2NIMTeamJoinActionInfo"), isOptional: true, description: "邀请信息", customTypeFields: [
          APIParameter(name: "actionType", type: .int, isOptional: true, description: "入群操作类型", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "teamId", type: .string, isOptional: false, description: "群组Id", customTypeFields: nil),
          APIParameter(name: "teamType", type: .int, isOptional: true, description: "群组类型", customTypeFields: nil, defaultValue: 1),
          APIParameter(name: "operatorAccountId", type: .string, isOptional: true, description: "操作账号id", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "postscript", type: .string, isOptional: true, description: "附言", customTypeFields: nil, defaultValue: ""),
          APIParameter(name: "timestamp", type: .double, isOptional: true, description: "时间戳", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "actionStatus", type: .int, isOptional: true, description: "操作状态", customTypeFields: nil, defaultValue: 0),
          APIParameter(name: "serverExtension", type: .string, isOptional: true, description: "邀请入群的扩展字段", customTypeFields: nil, defaultValue: ""),
        ]),
      ],
      executeFunction: { (params, callback) in
        let applicationInfo = V2NIMTeamJoinActionInfo.fromDic(params)
        NIMSDK.shared().v2TeamService.delete(applicationInfo) {
          callback("deleteTeamJoinActionInfo:success:failure: success.")
        } failure: { error in
          callback("deleteTeamJoinActionInfo:success:failure: failed. \(error)")
        }
      }
    ), 
  ]
}
