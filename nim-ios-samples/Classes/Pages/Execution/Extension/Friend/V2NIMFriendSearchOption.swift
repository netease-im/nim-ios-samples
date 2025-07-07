// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMFriendSearchOption {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMFriendSearchOption {
    let option = V2NIMFriendSearchOption()

    if let keyword = arguments["friendSearchOption.keyword"] as? String {
      option.keyword = keyword
    }

    if let searchAlias = arguments["friendSearchOption.searchAlias"] as? Bool {
      option.searchAlias = searchAlias
    }

    if let searchAccountId = arguments["friendSearchOption.searchAccountId"] as? Bool {
      option.searchAccountId = searchAccountId
    }

    return option
  }
}
