// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMLocalConversationFilter {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(conversationTypes)] = conversationTypes
    keyPaths[#keyPath(ignoreMuted)] = ignoreMuted
    return keyPaths
  }

  /// 从字典中解析出对象
  /// - Parameter dict: 字典
  /// - Returns: 对象
  static func fromDic(_ dict: [String: Any]) -> V2NIMLocalConversationFilter {
      let instance = V2NIMLocalConversationFilter.init()
      if let conversationTypesStr = dict["filter.conversationTypes"] as? String {
          let conversationTypeNums:[NSNumber] = conversationTypesStr.split(separator: ",").compactMap { Int($0) }.map { NSNumber(value: $0) }
          instance.conversationTypes = conversationTypeNums
      }
      if let ignoreMuted = dict["filter.ignoreMuted"] as? Bool{
          instance.ignoreMuted = ignoreMuted
      }
      return instance
  }
}
