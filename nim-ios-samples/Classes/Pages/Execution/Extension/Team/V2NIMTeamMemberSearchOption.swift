// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMTeamMemberSearchOption {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(keyword)] = keyword
    keyPaths[#keyPath(teamType)] = teamType.rawValue
    keyPaths[#keyPath(teamId)] = teamId
    keyPaths[#keyPath(nextToken)] = nextToken
    keyPaths[#keyPath(order)] = order.rawValue
    keyPaths[#keyPath(limit)] = limit

    return keyPaths
  }
  
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMTeamMemberSearchOption {
    let option = V2NIMTeamMemberSearchOption()
    if let keyword = arguments["searchOption.keyword"] as? String {
      option.keyword = keyword
    }
    

    if let teamType = arguments["searchOption.teamType"] as? Int,
       let teamType = V2NIMTeamType(rawValue: teamType) {
      option.teamType = teamType
    }

    if let teamId = arguments["searchOption.teamId"] as? String {
      option.teamId = teamId
    }
    
    if let nextToken = arguments["searchOption.nextToken"] as? String {
      option.nextToken = nextToken
    }

    if let order = arguments["searchOption.order"] as? Int,
       let order = V2NIMSortOrder(rawValue: order) {
      option.order = order
    }

    

if let limit = arguments["searchOption.limit"] as? Int {
      option.limit = limit
    }
    
    if let initNextToken = arguments["searchOption.initNextToken"] as? String {
      V2NIMTeamMemberSearchOption.initNextToken = initNextToken
    }
    return option
  }
}
