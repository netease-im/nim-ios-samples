//
//  ExecutionViewModels.swift
//  nim-ios-samples
//
//  Created by 陈吉力 on 2025/6/22.
//

import Foundation

class ExecutionViewModels {
    static func getAPIDefinition(item: FunctionViewListItem) -> APIDefinition? {
        switch item.tabType {
        case .login:
            return ExecutionLoginViewModels.apiDefinitionDict[item.itemContent]
        case .localConversation:
            return ExecutionLocalConversationViewModels.apiDefinitionDict[item.itemContent]
        case .friend:
            return ExecutionFriendViewModels.apiDefinitionDict[item.itemContent]
        case .user:
            return ExecutionUserViewModels.apiDefinitionDict[item.itemContent]
        case .message:
            return ExecutionMessageViewModels.apiDefinitionDict[item.itemContent]
        case .team:
            return ExecutionTeamViewModels.apiDefinitionDict[item.itemContent]
        default:
            return nil
        }
    }
}
