// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMTeamInviteParams {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(inviteeAccountIds)] = inviteeAccountIds
    keyPaths[#keyPath(postscript)] = postscript
    keyPaths[#keyPath(serverExtension)] = serverExtension

    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMTeamInviteParams {
    let params = V2NIMTeamInviteParams()
    if let inviteeAccountIdsStr = arguments["inviteeParams.inviteeAccountIds"] as? String {
      let inviteeAccountIds:[String] = inviteeAccountIdsStr.split(separator: ",").compactMap { String($0) }
      params.inviteeAccountIds = inviteeAccountIds
    }
    if let postscript = arguments["inviteeParams.postscript"] as? String {
      params.postscript = postscript
    }
    if let serverExtension = arguments["inviteeParams.serverExtension"] as? String {
      params.serverExtension = serverExtension
    }
    return params
  }
}
