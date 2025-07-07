//
//  FunctionViewModel.swift
//  nim-ios-samples
//
//  Created by 陈吉力 on 2024/12/4.
//

import Foundation
import Combine

class FunctionViewListViewModel: ObservableObject
{
    @Published var items: [FunctionViewListItem] = []
    @Published var selectedTab: FunctionViewTabType = .localConversation
    @Published var selectedItem: FunctionViewListItem?
    
    // 登录
    private var loginItems: [FunctionViewListItem] = [
        FunctionViewListItem(.login, itemType: FunctionViewLoginItemType.loginAction.rawValue, itemContent: "login:token:option:success:failure:"),
        FunctionViewListItem(.login, itemType: FunctionViewLoginItemType.loginAction.rawValue, itemContent: "logout:failure:"),
        FunctionViewListItem(.login, itemType: FunctionViewLoginItemType.loginInfo.rawValue, itemContent: "getLoginUser"),
        FunctionViewListItem(.login, itemType: FunctionViewLoginItemType.loginInfo.rawValue, itemContent: "getLoginStatus"),
        FunctionViewListItem(.login, itemType: FunctionViewLoginItemType.loginListener.rawValue, itemContent: "addLoginDetailListener:"),
        FunctionViewListItem(.login, itemType: FunctionViewLoginItemType.loginListener.rawValue, itemContent: "removeLoginDetailListener:"),
    ]

    // 本地回话
    private var localConversationItems: [FunctionViewListItem] = [
        FunctionViewListItem(.localConversation, itemType: FunctionViewLocalConversationItemType.localListener.rawValue, itemContent: "addConversationListener"),
        FunctionViewListItem(.localConversation, itemType: FunctionViewLocalConversationItemType.localListener.rawValue, itemContent: "removeConversationListener"),

        FunctionViewListItem(.localConversation, itemType: FunctionViewLocalConversationItemType.localConversation.rawValue, itemContent: "getConversationList:limit:success:failure:"),
        FunctionViewListItem(.localConversation, itemType: FunctionViewLocalConversationItemType.localConversation.rawValue, itemContent: "getConversationList:limit:error:"),
        FunctionViewListItem(.localConversation, itemType: FunctionViewLocalConversationItemType.localConversation.rawValue, itemContent: "getConversationListByOption:limit:option:success:failure:"),
        FunctionViewListItem(.localConversation, itemType: FunctionViewLocalConversationItemType.localConversation.rawValue, itemContent: "getConversation:success:failure:"),
        FunctionViewListItem(.localConversation, itemType: FunctionViewLocalConversationItemType.localConversation.rawValue, itemContent: "getConversation:error:"),
        FunctionViewListItem(.localConversation, itemType: FunctionViewLocalConversationItemType.localConversation.rawValue, itemContent: "getConversationListByIds:success:failure:"),
        FunctionViewListItem(.localConversation, itemType: FunctionViewLocalConversationItemType.localConversation.rawValue, itemContent: "createConversation:success:failure:"),
        FunctionViewListItem(.localConversation, itemType: FunctionViewLocalConversationItemType.localConversation.rawValue, itemContent: "deleteConversation:clearMessage:success:failure:"),
        FunctionViewListItem(.localConversation, itemType: FunctionViewLocalConversationItemType.localConversation.rawValue, itemContent: "deleteConversationListByIds:clearMessage:success:failure:"),
        FunctionViewListItem(.localConversation, itemType: FunctionViewLocalConversationItemType.stickTop.rawValue, itemContent: "getStickTopConversationList:success:failure:"),
        FunctionViewListItem(.localConversation, itemType: FunctionViewLocalConversationItemType.stickTop.rawValue, itemContent: "stickTopConversation:stickTop:success:failure:"),
        FunctionViewListItem(.localConversation, itemType: FunctionViewLocalConversationItemType.stickTop.rawValue, itemContent: "updateConversationLocalExtension:localExtension:success:failure:"),
        FunctionViewListItem(.localConversation, itemType: FunctionViewLocalConversationItemType.localUnread.rawValue, itemContent: "getTotalUnreadCount"),
        FunctionViewListItem(.localConversation, itemType: FunctionViewLocalConversationItemType.localUnread.rawValue, itemContent: "getUnreadCountByIds:success:failure:"),
        FunctionViewListItem(.localConversation, itemType: FunctionViewLocalConversationItemType.localUnread.rawValue, itemContent: "getUnreadCountByFilter:success:failure:"),
        FunctionViewListItem(.localConversation, itemType: FunctionViewLocalConversationItemType.localUnread.rawValue, itemContent: "clearTotalUnreadCount:failure:"),
        FunctionViewListItem(.localConversation, itemType: FunctionViewLocalConversationItemType.localUnread.rawValue, itemContent: "clearUnreadCountByIds:success:failure:"),
        FunctionViewListItem(.localConversation, itemType: FunctionViewLocalConversationItemType.localUnread.rawValue, itemContent: "clearUnreadCountByTypes:success:failure:"),
        FunctionViewListItem(.localConversation, itemType: FunctionViewLocalConversationItemType.localUnread.rawValue, itemContent: "subscribeUnreadCountByFilter:"),
        FunctionViewListItem(.localConversation, itemType: FunctionViewLocalConversationItemType.localUnread.rawValue, itemContent: "unsubscribeUnreadCountByFilter:"),
        FunctionViewListItem(.localConversation, itemType: FunctionViewLocalConversationItemType.localConversation.rawValue, itemContent: "getConversationReadTime:success:failure:"),
        FunctionViewListItem(.localConversation, itemType: FunctionViewLocalConversationItemType.localConversation.rawValue, itemContent: "markConversationRead:success:failure:"),
    ]

    // 好友
    private var friendItems: [FunctionViewListItem] = [
        FunctionViewListItem(.friend, itemType: FunctionViewFriendItemType.listener.rawValue, itemContent: "addFriendListener"),
        FunctionViewListItem(.friend, itemType: FunctionViewFriendItemType.listener.rawValue, itemContent: "removeFriendListener"),

        FunctionViewListItem(.friend, itemType: FunctionViewFriendItemType.add.rawValue, itemContent: "addFriend:params:success:failure:"),

        FunctionViewListItem(.friend, itemType: FunctionViewFriendItemType.delete.rawValue, itemContent: "deleteFriend:params:success:failure:"),

        FunctionViewListItem(.friend, itemType: FunctionViewFriendItemType.get.rawValue, itemContent: "getFriendList:failure:"),
        FunctionViewListItem(.friend, itemType: FunctionViewFriendItemType.get.rawValue, itemContent: "getFriendByIds:success:failure:"),
        FunctionViewListItem(.friend, itemType: FunctionViewFriendItemType.get.rawValue, itemContent: "searchFriendByOption:success:failure:"),
        FunctionViewListItem(.friend, itemType: FunctionViewFriendItemType.get.rawValue, itemContent: "checkFriend:success:failure:"),
        FunctionViewListItem(.friend, itemType: FunctionViewFriendItemType.get.rawValue, itemContent: "setFriendInfo:params:success:failure:"),

        FunctionViewListItem(.friend, itemType: FunctionViewFriendItemType.application.rawValue, itemContent: "acceptAddApplication:success:failure:"),
        FunctionViewListItem(.friend, itemType: FunctionViewFriendItemType.application.rawValue, itemContent: "rejectAddApplication:postscript:success:failure:"),
        FunctionViewListItem(.friend, itemType: FunctionViewFriendItemType.application.rawValue, itemContent: "getAddApplicationList:success:failure:"),
        FunctionViewListItem(.friend, itemType: FunctionViewFriendItemType.application.rawValue, itemContent: "getAddApplicationUnreadCount:failure:"),
        FunctionViewListItem(.friend, itemType: FunctionViewFriendItemType.application.rawValue, itemContent: "setAddApplicationRead:failure:"),
        FunctionViewListItem(.friend, itemType: FunctionViewFriendItemType.application.rawValue, itemContent: "clearAllAddApplication:failure:"),
        FunctionViewListItem(.friend, itemType: FunctionViewFriendItemType.application.rawValue, itemContent: "deleteAddApplication:success:failure:"),
    ]

    // 用户
    private var userItems: [FunctionViewListItem] = [
        FunctionViewListItem(.user, itemType: FunctionViewUserItemType.listener.rawValue, itemContent: "addUserListener"),
        FunctionViewListItem(.user, itemType: FunctionViewUserItemType.listener.rawValue, itemContent: "removeUserListener"),

        FunctionViewListItem(.user, itemType: FunctionViewUserItemType.get.rawValue, itemContent: "getUserList:success:failure:"),
        FunctionViewListItem(.user, itemType: FunctionViewUserItemType.get.rawValue, itemContent: "getUserList:error:"),
        FunctionViewListItem(.user, itemType: FunctionViewUserItemType.get.rawValue, itemContent: "getUserInfo:error:"),
        FunctionViewListItem(.user, itemType: FunctionViewUserItemType.get.rawValue, itemContent: "getUserListFromCloud:success:failure:"),
        FunctionViewListItem(.user, itemType: FunctionViewUserItemType.get.rawValue, itemContent: "searchUserByOption:success:failure:"),

        FunctionViewListItem(.user, itemType: FunctionViewUserItemType.udpate.rawValue, itemContent: "updateSelfUserProfile:success:failure:"),

        FunctionViewListItem(.user, itemType: FunctionViewUserItemType.blackList.rawValue, itemContent: "addUserToBlockList:success:failure:"),
        FunctionViewListItem(.user, itemType: FunctionViewUserItemType.blackList.rawValue, itemContent: "removeUserFromBlockList:success:failure:"),
        FunctionViewListItem(.user, itemType: FunctionViewUserItemType.blackList.rawValue, itemContent: "getBlockList:failure:"),
        FunctionViewListItem(.user, itemType: FunctionViewUserItemType.blackList.rawValue, itemContent: "checkBlock:success:failure:"),
        FunctionViewListItem(.user, itemType: FunctionViewUserItemType.blackList.rawValue, itemContent: "checkBlock:"),
    ]

    // 消息
    private var messageItems: [FunctionViewListItem] = [
        // 创建并发送
        FunctionViewListItem(.message, itemType: FunctionViewMessageItemType.send.rawValue, itemContent: "text sendMessage:conversationId:params:success:failure:progress:"),
        FunctionViewListItem(.message, itemType: FunctionViewMessageItemType.send.rawValue, itemContent: "audio sendMessage:conversationId:params:success:failure:progress:"),
        FunctionViewListItem(.message, itemType: FunctionViewMessageItemType.send.rawValue, itemContent: "image sendMessage:conversationId:params:success:failure:progress:"),
        FunctionViewListItem(.message, itemType: FunctionViewMessageItemType.send.rawValue, itemContent: "video sendMessage:conversationId:params:success:failure:progress:"),
        FunctionViewListItem(.message, itemType: FunctionViewMessageItemType.send.rawValue, itemContent: "file sendMessage:conversationId:params:success:failure:progress:"),
        FunctionViewListItem(.message, itemType: FunctionViewMessageItemType.send.rawValue, itemContent: "location sendMessage:conversationId:params:success:failure:progress:"),
        FunctionViewListItem(.message, itemType: FunctionViewMessageItemType.send.rawValue, itemContent: "custom sendMessage:conversationId:params:success:failure:progress:"),
        // 查
        FunctionViewListItem(.message, itemType: FunctionViewMessageItemType.get.rawValue, itemContent: "getMessageListEx:success:failure:"),
        FunctionViewListItem(.message, itemType: FunctionViewMessageItemType.get.rawValue, itemContent: "getMessageListByIds:success:failure:"),
        // 删
        FunctionViewListItem(.message, itemType: FunctionViewMessageItemType.delete.rawValue, itemContent: "deleteMessages:serverExtension:onlyDeleteLocal:success:failure:"),
        // 监听
        FunctionViewListItem(.message, itemType: FunctionViewMessageItemType.listener.rawValue, itemContent: "addMessageListener:"),
        FunctionViewListItem(.message, itemType: FunctionViewMessageItemType.listener.rawValue, itemContent: "removeMessageListener:"),
    ]

    // 群聊
    private var teamItems: [FunctionViewListItem] = [
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "addTeamListener"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "removeTeamListener"),

        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "createTeam:inviteeAccountIds:postscript:antispamConfig:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "updateTeamInfo:teamType:updateTeamInfoParams:antispamConfig:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "leaveTeam:teamType:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "getTeamInfo:teamType:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "getTeamInfo:teamType:error:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "getTeamInfoByIds:teamType:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "getTeamInfoByIds:teamType:error:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "dismissTeam:teamType:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "inviteMember:teamType:inviteeAccountIds:postscript:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "inviteMemberEx:teamType:inviteeParams:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "acceptInvitation:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "rejectInvitation:postscript:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "kickMember:teamType:memberAccountIds:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "applyJoinTeam:teamType:postscript:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "acceptJoinApplication:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "rejectJoinApplication:postscript:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "updateTeamMemberRole:teamType:memberAccountIds:memberRole:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "transferTeamOwner:teamType:accountId:leave:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "updateSelfTeamMemberInfo:teamType:memberInfoParams:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "updateTeamMemberNick:teamType:accountId:teamNick:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "setTeamChatBannedMode:teamType:chatBannedMode:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "setTeamMemberChatBannedStatus:teamType:accountId:chatBanned:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "getJoinedTeamList:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "getJoinedTeamList:error:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "getOwnerTeamList:error:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "getJoinedTeamCount:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "getJoinedTeamMembers:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "getTeamMemberList:teamType:queryOption:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "getTeamMemberListByIds:teamType:accountIds:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "getTeamMemberListByIds:teamType:accountIds:error:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "getTeamMemberInvitor:teamType:accountIds:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "getTeamJoinActionInfoList:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "searchTeamByKeyword:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "searchTeamMembers:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "addTeamMembersFollow:teamType:accountIds:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "removeTeamMembersFollow:teamType:accountIds:success:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "clearAllTeamJoinActionInfo:failure:"),
        FunctionViewListItem(.team, itemType: FunctionViewTeamItemType.team.rawValue, itemContent: "deleteTeamJoinActionInfo:success:failure:"),
    ]

    func filterItems(for tabType: FunctionViewTabType) -> [FunctionViewListItem]
    {
        switch tabType
        {
        case .unknown:
            return []
        case .login:
            return self.loginItems
        case .localConversation:
            return self.localConversationItems
        case .friend:
            return self.friendItems
        case .user:
            return self.userItems
        case .message:
            return self.messageItems
        case .team:
            return self.teamItems
        }
    }

    func groupItems(_ items: [FunctionViewListItem]) -> [String: [FunctionViewListItem]]
    {
        Dictionary(
                grouping: items,
                by: { $0.itemTypeTitle ?? "" }
        )
    }

    func updateSelectedTab(_ tab: FunctionViewTabType)
    {
        selectedTab = tab
        items = filterItems(for: tab)
    }

    func selectItem(_ item: FunctionViewListItem)
    {
        selectedItem = item
    }

    init()
    {
        items = self.localConversationItems
    }
}
