// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMLocalConversationOption {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(conversationTypes)] = conversationTypes
    keyPaths[#keyPath(onlyUnread)] = onlyUnread
    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ dict: [String: Any]) -> V2NIMLocalConversationOption {
      let instance = V2NIMLocalConversationOption.init()
      if let conversationTypesStr = dict["option.conversationTypes"] as? String {
          let conversationTypeNums:[NSNumber] = conversationTypesStr.split(separator: ",").compactMap { Int($0) }.map { NSNumber(value: $0) }
          instance.conversationTypes = conversationTypeNums
      }
      if let onlyUnread = dict["option.onlyUnread"] as? Bool{
          instance.onlyUnread = onlyUnread
      }
      return instance
  }
}
