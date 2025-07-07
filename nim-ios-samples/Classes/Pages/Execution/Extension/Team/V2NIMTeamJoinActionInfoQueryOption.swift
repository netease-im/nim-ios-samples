// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMTeamJoinActionInfoQueryOption {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(types)] = types
    keyPaths[#keyPath(offset)] = offset
    keyPaths[#keyPath(limit)] = limit
    keyPaths[#keyPath(status)] = status

    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMTeamJoinActionInfoQueryOption {
    let option = V2NIMTeamJoinActionInfoQueryOption()
    if let typesStr = arguments["option.types"] as? String {
        let typesNums:[NSNumber] = typesStr.split(separator: ",").compactMap { Int($0) }.map { NSNumber(value: $0) }
      option.types = typesNums
    }
    if let offset = arguments["option.offset"] as? Int {
      option.offset = offset
    }
    if let limit = arguments["option.limit"] as? Int {
      option.limit = limit
    }
    if let statusStr = arguments["option.status"] as? String {
        let statusNums:[NSNumber] = statusStr.split(separator: ",").compactMap { Int($0) }.map { NSNumber(value: $0) }
      option.status = statusNums
    }
    return option
  }
}
