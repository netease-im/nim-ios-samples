//
//  FunctionModel.swift
//  nim-ios-samples
//
//  Created by 陈吉力 on 2024/12/4.
//

// Models/ListItem.swift
import Foundation

struct FunctionViewListItem: Identifiable, Hashable {
    let id: UUID
    let tabType: FunctionViewTabType
    let itemType: Int // FunctionViewItemType
    let itemContent: String
    
    init(_ tabType: FunctionViewTabType, itemType: Int, itemContent: String) {
        self.id = UUID()
        self.tabType = tabType
        self.itemType = itemType
        self.itemContent = itemContent
    }
    
    var itemTypeTitle: String? {
        switch self.tabType {
        case .unknown:
            "未知"
        case .login:
            FunctionViewLoginItemType(rawValue: self.itemType)?.title
        case .localConversation:
            FunctionViewLocalConversationItemType(rawValue: self.itemType)?.title
        case .friend:
            FunctionViewFriendItemType(rawValue: self.itemType)?.title
        case .user:
            FunctionViewUserItemType(rawValue: self.itemType)?.title
        case .message:
            FunctionViewMessageItemType(rawValue: self.itemType)?.title
        case .team:
            FunctionViewTeamItemType(rawValue: self.itemType)?.title
        }
    }
}


enum FunctionViewTabType: Int, CaseIterable {
    case unknown = 0
    case login
    case localConversation
    case friend
    case user
    case message
    case team
    
    var title: String {
        switch self {
        case .unknown: return "未知"
        case .login: return "登录"
        case .localConversation: return "本地会话"
        case .friend: return "好友"
        case .user: return "用户"
        case .message: return "消息"
        case .team: return "群"
        }
    }
    
    var icon: String {
        switch self {
        case .unknown: return "rectangle.grid.2x2"
        case .login: return "rectangle.grid.2x2"
        case .localConversation: return "rectangle.grid.2x2"
        case .friend: return "rectangle.grid.2x2"
        case .user: return "rectangle.grid.2x2"
        case .message: return "rectangle.grid.2x2"
        case .team: return "rectangle.grid.2x2"
        }
    }
}

// “登录”类列表项类型
enum FunctionViewLoginItemType: Int, CaseIterable {
    case loginListener = 1
    case loginAction
    case loginInfo

    var title: String {
        switch self {
        case .loginListener: return "登录 监听"
        case .loginAction: return "登录数 登录登出"
        case .loginInfo: return "登录 账号和状态"
        }
    }
}

// “本地会话”类列表项类型
enum FunctionViewLocalConversationItemType: Int, CaseIterable {
  case localListener = 1
    case localConversation
    case localUnread
    case stickTop

    var title: String {
        switch self {
        case .localConversation: return "本地会话 功能"
        case .localUnread: return "本地未读数 功能"
        case .localListener: return "本地会话 监听"
        case .stickTop: return "会话置顶"
        }
    }
}

// “好友”类列表项类型
enum FunctionViewFriendItemType: Int, CaseIterable {
    case add = 1
    case delete
    case get
    case listener
    case application
    
    var title: String {
        switch self {
        case .add: return "添加好友"
        case .delete: return "删除好友"
        case .get: return "查询好友"
        case .listener: return "监听"
        case .application: return "申请"
        }
    }
}

// “用户”类列表项类型
enum FunctionViewUserItemType: Int, CaseIterable {
    case get = 1
    case udpate
    case blackList
    case listener
    
    var title: String {
        switch self {
        case .get: return "获取用户信息"
        case .udpate: return "更新用户信息"
        case .blackList: return "黑名单操作"
        case .listener: return "监听"
        }
    }
}

// “消息”类列表项类型
enum FunctionViewMessageItemType: Int, CaseIterable {
    case collection = 1
    case pin
    case revoke
    case reply
    case get
    case delete
    case receipt
    case comment
    case send
    case persist
    case notification
    case modify
    case converter
    case listener
    
    var title: String {
        switch self {
        case .collection: return "收藏Collection"
        case .pin: return "Pin 功能"
        case .revoke: return "revoke 功能"
        case .reply: return "Reply 功能"
        case .get: return "get 消息"
        case .delete: return "delete 消息"
        case .receipt: return "receipt 消息"
        case .comment: return "comment 消息"
        case .send: return "send message"
        case .persist: return "本地存储"
        case .notification: return "自定义通知"
        case .modify: return "消息更新"
        case .converter: return "消息序列化"
        case .listener: return "消息监听"
        }
    }
}

// “群”类列表项类型
enum FunctionViewTeamItemType: Int, CaseIterable {
    case team = 1
    case teamMember

    var title: String {
        switch self {
        case .team: return "群"
        case .teamMember: return "群成员"
        }
    }
}

