// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMFriendAddApplication {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMFriendAddApplication.applicantAccountId)] = applicantAccountId
    keyPaths[#keyPath(V2NIMFriendAddApplication.recipientAccountId)] = recipientAccountId
    keyPaths[#keyPath(V2NIMFriendAddApplication.operatorAccountId)] = operatorAccountId
    keyPaths[#keyPath(V2NIMFriendAddApplication.postscript)] = postscript
    keyPaths[#keyPath(V2NIMFriendAddApplication.status)] = status.rawValue
    keyPaths[#keyPath(V2NIMFriendAddApplication.timestamp)] = timestamp * 1000.0
    keyPaths[#keyPath(V2NIMFriendAddApplication.read)] = read

    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMFriendAddApplication {
    let application = V2NIMFriendAddApplication()

    if let applicantAccountId = arguments["application.applicantAccountId"] as? String {
      application.setValue(applicantAccountId, forKey: #keyPath(V2NIMFriendAddApplication.applicantAccountId))
    }

    if let recipientAccountId = arguments["application.recipientAccountId"] as? String {
      application.setValue(recipientAccountId, forKey: #keyPath(V2NIMFriendAddApplication.recipientAccountId))
    }

    if let operatorAccountId = arguments["application.operatorAccountId"] as? String {
      application.setValue(operatorAccountId, forKey: #keyPath(V2NIMFriendAddApplication.operatorAccountId))
    }

    if let postscript = arguments["application.postscript"] as? String {
      application.setValue(postscript, forKey: #keyPath(V2NIMFriendAddApplication.postscript))
    }

    if let statusInt = arguments["application.status"] as? Int,
       let status = V2NIMFriendAddApplicationStatus(rawValue: statusInt) {
      application.status = status
    }

    if let timestamp = arguments["application.timestamp"] as? Double {
      application.timestamp = TimeInterval(timestamp / 1000)
    }

    if let read = arguments["application.read"] as? Bool {
      application.read = read
    }

    return application
  }
}
