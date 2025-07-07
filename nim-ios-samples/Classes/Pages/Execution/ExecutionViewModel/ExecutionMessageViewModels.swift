//
//  ExecutionMessageViewModels.swift
//  nim-ios-samples
//
//  Created by 陈吉力 on 2025/6/22.
//

import Foundation
class ExecutionMessageViewModels {
    static  let listener: V2NIMMessageListener = V2MessageListener()
    
    static let sendMessageParams = APIParameter(name: "params", type: .custom("V2NIMSendMessageParams"), isOptional: true, description: nil, customTypeFields: [
        //                    APIParameter(name: "messageConfig", type: .custom("V2NIMMessageConfig"), isOptional: true, description:nil, customTypeFields: [
        //                        APIParameter(name: "readReceiptEnabled", type: .bool, isOptional: true, description: nil, customTypeFields: nil, defaultValue: false),
        //                        APIParameter(name: "lastMessageUpdateEnabled", type: .bool, isOptional: true, description: nil, customTypeFields: nil, defaultValue: false),
        //                        APIParameter(name: "historyEnabled", type: .bool, isOptional: true, description: nil, customTypeFields: nil, defaultValue: false),
        //                        APIParameter(name: "roamingEnabled", type: .bool, isOptional: true, description: nil, customTypeFields: nil, defaultValue: false),
        //                        APIParameter(name: "onlineSyncEnabled", type: .bool, isOptional: true, description: nil, customTypeFields: nil, defaultValue: false),
        //                        APIParameter(name: "offlineEnabled", type: .bool, isOptional: true, description: nil, customTypeFields: nil, defaultValue: false),
        //                        APIParameter(name: "unreadEnabled", type: .bool, isOptional: true, description: nil, customTypeFields: nil, defaultValue: false),
        //                    ]),
        //                    APIParameter(name: "routeConfig", type: .custom("V2NIMMessageRouteConfig"), isOptional: true, description: nil, customTypeFields: [
        //                        APIParameter(name: "routeEnabled", type: .bool, isOptional: true, description: nil, customTypeFields: nil, defaultValue: true),
        //                        APIParameter(name: "routeEnvironment", type: .string, isOptional: true, description: nil, customTypeFields: nil),
        //                    ]),
                            APIParameter(name: "pushConfig", type: .custom("V2NIMMessagePushConfig"), isOptional: true, description: nil, customTypeFields: [
                                APIParameter(name: "pushEnabled", type: .bool, isOptional: true, description: nil, customTypeFields: nil, defaultValue: true),
                                APIParameter(name: "pushNickEnabled", type: .bool, isOptional: true, description: nil, customTypeFields: nil, defaultValue: true),
                                APIParameter(name: "pushContent", type: .string, isOptional: true, description: nil, customTypeFields: nil),
                                APIParameter(name: "pushPayload", type: .string, isOptional: true, description: nil, customTypeFields: nil),
                                APIParameter(name: "forcePush", type: .bool, isOptional: true, description: nil, customTypeFields: nil, defaultValue: false),
                                APIParameter(name: "forcePushContent", type: .string, isOptional: true, description: nil, customTypeFields: nil),
                                APIParameter(name: "forcePushAccountIds", type: .string, isOptional: true, description: nil, customTypeFields: nil),
                            ]),
        //                    APIParameter(name: "antispamConfig", type: .custom("V2NIMMessageAntispamConfig"), isOptional: true, description: nil, customTypeFields: [
        //                        APIParameter(name: "antispamEnabled", type: .bool, isOptional: true, description: nil, customTypeFields: nil, defaultValue: true),
        //                        APIParameter(name: "antispamBusinessId", type: .string, isOptional: true, description: nil, customTypeFields: nil),
        //                        APIParameter(name: "antispamCustomMessage", type: .string, isOptional: true, description: nil, customTypeFields: nil),
        //                        APIParameter(name: "antispamCheating", type: .string, isOptional: true, description: nil, customTypeFields: nil),
        //                        APIParameter(name: "antispamExtension", type: .string, isOptional: true, description: nil, customTypeFields: nil),
        //                    ]),
        //                    APIParameter(name: "robotConfig", type: .custom("V2NIMMessageRobotConfig"), isOptional: true, description: nil, customTypeFields: [
        //                        APIParameter(name: "accountId", type: .string, isOptional: true, description: nil, customTypeFields: nil),
        //                        APIParameter(name: "topic", type: .string, isOptional: true, description: nil, customTypeFields: nil),
        //                        APIParameter(name: "function", type: .string, isOptional: true, description: nil, customTypeFields: nil),
        //                        APIParameter(name: "customContent", type: .string, isOptional: true, description: nil, customTypeFields: nil),
        //                    ]),
        //                    APIParameter(name: "aiConfig", type: .custom("V2NIMMessageAIConfigParams"), isOptional: true, description: nil, customTypeFields: [
        //                        APIParameter(name: "accountId", type: .string, isOptional: true, description: nil, customTypeFields: nil),
        //                        APIParameter(name: "content", type: .custom("V2NIMAIModelCallContent *"), isOptional: true, description: nil, customTypeFields: nil),
        //                        APIParameter(name: "messages", type: .string, isOptional: true, description: nil, customTypeFields: nil),
        //                        APIParameter(name: "promptVariables", type: .string, isOptional: true, description: nil, customTypeFields: nil),
        //                        APIParameter(name: "modelConfigParams", type: .custom("V2NIMAIModelConfigParams *"), isOptional: true, description: nil, customTypeFields: nil),
        //                        APIParameter(name: "aiStream", type: .bool, isOptional: true, description: nil, customTypeFields: nil, defaultValue: false),
        //                    ]),
        //                    APIParameter(name: "targetConfig", type: .custom("V2NIMMessageTargetConfig"), isOptional: true, description: nil, customTypeFields: [
        //                        APIParameter(name: "inclusive", type: .bool, isOptional: true, description: nil, customTypeFields: nil, defaultValue: true),
        //                        APIParameter(name: "receiverIds", type: .string, isOptional: true, description: "接收者 ID 列表", customTypeFields: nil),
        //                        APIParameter(name: "newMemberVisible", type: .bool, isOptional: true, description: nil, customTypeFields: nil, defaultValue: false),
        //                    ]),
                            APIParameter(name: "clientAntispamEnabled", type: .bool, isOptional: true, description: nil, customTypeFields: nil, defaultValue: false),
                            APIParameter(name: "clientAntispamReplace", type: .string, isOptional: true, description: nil, customTypeFields: nil),
                        ])
    static let apiDefinitionDict: [String: APIDefinition] = [
        "text sendMessage:conversationId:params:success:failure:progress:": APIDefinition(
            name: "text sendMessage:conversationId:params:success:failure:progress:",
            parameters: [
                APIParameter(name: "message", type: .custom("V2NIMMessage"), isOptional: true, description: "通过V2NIMMessageCreator创建", customTypeFields: [
                    APIParameter(name: "text", type: .string, isOptional: false, description: "文本消息的内容", customTypeFields: nil),
                ]),
                APIParameter(name: "conversationId", type: .string, isOptional: false, description: nil, customTypeFields: nil),
                sendMessageParams,
            ],
            executeFunction: { (params, callback) in
                let text = params["message.text"] as? String ?? ""
                let message = V2NIMMessageCreator.createTextMessage(text)
                guard let conversationId = params["conversationId"] as? String else {
                    callback("Error: conversationId is required.")
                    return
                }
                let param = V2NIMSendMessageParams.init(params)
                NIMSDK.shared().v2MessageService.send(message, conversationId: conversationId, params: param) { result in
                    callback("sendTextMessage success. \(result)")
                } failure: { error in
                    callback("sendTextMessage failed. \(error)")
                } progress: { pro in
                    Logger.log("sendTextMessage progress: \(pro)")
                }
            }
        ),
        "audio sendMessage:conversationId:params:success:failure:progress:": APIDefinition(
            name: "audio sendMessage:conversationId:params:success:failure:progress:",
            parameters: [
                APIParameter(name: "message", type: .custom("V2NIMMessage"), isOptional: true, description: "通过V2NIMMessageCreator创建", customTypeFields: [
                    APIParameter(name: "audioPath", type: .string, isOptional: true, description: "音频文件路径，如果不填，将随机创建并传到SDK", customTypeFields: nil),
                    APIParameter(name: "name", type: .string, isOptional: true, description: "音频文件名称", customTypeFields: nil),
//                    APIParameter(name: "sceneName", type: .string, isOptional: true, description: "场景名", customTypeFields: nil),
                    APIParameter(name: "duration", type: .int, isOptional: true, description: "音频时长", customTypeFields: nil, defaultValue: 0),
                ]),
                APIParameter(name: "conversationId", type: .string, isOptional: false, description: nil, customTypeFields: nil),
                sendMessageParams,
            ],
            executeFunction: { (params, callback) in
                var audioPath = params["message.audioPath"] as? String ?? ""
                if audioPath.isEmpty {
                    audioPath = MediaUtil.randomAudioPath(targetSizeInBytes: 1 * 1024 * 1024) ?? ""
                }
                let audioName = params["message.name"] as? String ?? nil
                let sceneName: String? = nil
                let duration = params["message.duration"] as? Int ?? 0
                let message = V2NIMMessageCreator.createAudioMessage(audioPath, name: audioName, sceneName: sceneName, duration: Int32(duration))
                guard let conversationId = params["conversationId"] as? String else {
                    callback("Error: conversationId is required.")
                    return
                }
                let param = V2NIMSendMessageParams.init(params)
                NIMSDK.shared().v2MessageService.send(message, conversationId: conversationId, params: param) { result in
                    callback("sendAudioMessage success. \(result)")
                } failure: { error in
                    callback("sendAudioMessage failed. \(error)")
                } progress: { pro in
                    Logger.log("sendAudioMessage progress: \(pro)")
                }
            }
        ),
        "image sendMessage:conversationId:params:success:failure:progress:": APIDefinition(
            name: "image sendMessage:conversationId:params:success:failure:progress:",
            parameters: [
                APIParameter(name: "message", type: .custom("V2NIMMessage"), isOptional: true, description: "通过V2NIMMessageCreator创建", customTypeFields: [
                    APIParameter(name: "imagePath", type: .string, isOptional: true, description: "图片文件路径，如果不填，将随机创建并传到SDK", customTypeFields: nil),
                    APIParameter(name: "name", type: .string, isOptional: true, description: "图片文件名称", customTypeFields: nil),
                    APIParameter(name: "width", type: .int, isOptional: true, description: "图片文件宽度", customTypeFields: nil, defaultValue: 0),
                    APIParameter(name: "height", type: .int, isOptional: true, description: "图片文件高度", customTypeFields: nil, defaultValue: 0),
                ]),
                APIParameter(name: "conversationId", type: .string, isOptional: false, description: nil, customTypeFields: nil),
                sendMessageParams,
            ],
            executeFunction: { (params, callback) in
                var imagePath = params["message.imagePath"] as? String ?? ""
                if imagePath.isEmpty {
                    imagePath = MediaUtil.randomImagePath() ?? ""
                }
                let imageName = params["message.name"] as? String ?? nil
                let imagewidth = params["message.width"] as? Int ?? 0
                let imageheight = params["message.height"] as? Int ?? 0
                let message = V2NIMMessageCreator.createImageMessage(imagePath, name: imageName, sceneName: nil, width: Int32(imagewidth), height: Int32(imageheight))
                guard let conversationId = params["conversationId"] as? String else {
                    callback("Error: conversationId is required.")
                    return
                }
                let param = V2NIMSendMessageParams.init(params)
                NIMSDK.shared().v2MessageService.send(message, conversationId: conversationId, params: param) { result in
                    callback("sendImageMessage success. \(result)")
                } failure: { error in
                    callback("sendImageMessage failed. \(error)")
                } progress: { pro in
                    Logger.log("sendImageMessage progress: \(pro)")
                }
            }
        ),
        "video sendMessage:conversationId:params:success:failure:progress:": APIDefinition(
            name: "video sendMessage:conversationId:params:success:failure:progress:",
            parameters: [
                APIParameter(name: "message", type: .custom("V2NIMMessage"), isOptional: true, description: "通过V2NIMMessageCreator创建", customTypeFields: [
                    APIParameter(name: "videoPath", type: .string, isOptional: true, description: "视频文件路径，如果不填，将随机创建并传到SDK", customTypeFields: nil),
                    APIParameter(name: "name", type: .string, isOptional: true, description: "视频文件名称", customTypeFields: nil),
                    APIParameter(name: "duration", type: .int, isOptional: true, description: "视频时长", customTypeFields: nil, defaultValue: 0),
                    APIParameter(name: "width", type: .int, isOptional: true, description: "视频文件宽度", customTypeFields: nil, defaultValue: 0),
                    APIParameter(name: "height", type: .int, isOptional: true, description: "视频文件高度", customTypeFields: nil, defaultValue: 0),
                ]),
                APIParameter(name: "conversationId", type: .string, isOptional: false, description: nil, customTypeFields: nil),
                sendMessageParams,
            ],
            executeFunction: { (params, callback) in
                var videoPath = params["message.videoPath"] as? String ?? ""
                if videoPath.isEmpty {
                    videoPath = MediaUtil.randomVideoPath(targetSizeInBytes: 200 * 1024, fileName: nil) ?? ""
                }
                let videoName = params["message.name"] as? String ?? nil
                let duration = params["message.duration"] as? Int ?? 0
                let videoWidth = params["message.width"] as? Int ?? 0
                let videoHeight = params["message.height"] as? Int ?? 0
                let message = V2NIMMessageCreator.createVideoMessage(videoPath, name: videoName, sceneName: nil, duration: Int32(duration), width: Int32(videoWidth), height: Int32(videoHeight))
                guard let conversationId = params["conversationId"] as? String else {
                    callback("Error: conversationId is required.")
                    return
                }
                let param = V2NIMSendMessageParams.init(params)
                NIMSDK.shared().v2MessageService.send(message, conversationId: conversationId, params: param) { result in
                    callback("sendVideoMessage success. \(result)")
                } failure: { error in
                    callback("sendVideoMessage failed. \(error)")
                } progress: { pro in
                    Logger.log("sendVideoMessage progress: \(pro)")
                }
            }
        ),
        "file sendMessage:conversationId:params:success:failure:progress:": APIDefinition(
            name: "file sendMessage:conversationId:params:success:failure:progress:",
            parameters: [
                APIParameter(name: "message", type: .custom("V2NIMMessage"), isOptional: true, description: "通过V2NIMMessageCreator创建", customTypeFields: [
                    APIParameter(name: "filePath", type: .string, isOptional: true, description: "文件路径，如果不填，将随机创建并传到SDK", customTypeFields: nil),
                    APIParameter(name: "name", type: .string, isOptional: true, description: "文件名称", customTypeFields: nil),
                ]),
                APIParameter(name: "conversationId", type: .string, isOptional: false, description: nil, customTypeFields: nil),
                sendMessageParams,
            ],
            executeFunction: { (params, callback) in
                var filePath = params["message.filePath"] as? String ?? ""
                if filePath.isEmpty {
                    filePath = MediaUtil.randomTextFilePath(targetSizeInBytes: 1024, fileName: nil) ?? ""
                }
                let fileName = params["message.name"] as? String ?? nil
                let message = V2NIMMessageCreator.createFileMessage(filePath, name: fileName, sceneName: nil)
                guard let conversationId = params["conversationId"] as? String else {
                    callback("Error: conversationId is required.")
                    return
                }
                let param = V2NIMSendMessageParams.init(params)
                NIMSDK.shared().v2MessageService.send(message, conversationId: conversationId, params: param) { result in
                    callback("sendFileMessage success. \(result)")
                } failure: { error in
                    callback("sendFileMessage failed. \(error)")
                } progress: { pro in
                    Logger.log("sendFileMessage progress: \(pro)")
                }
            }
        ),
        "location sendMessage:conversationId:params:success:failure:progress:": APIDefinition(
            name: "location sendMessage:conversationId:params:success:failure:progress:",
            parameters: [
                APIParameter(name: "message", type: .custom("V2NIMMessage"), isOptional: true, description: "通过V2NIMMessageCreator创建", customTypeFields: [
                    APIParameter(name: "latitude", type: .double, isOptional: false, description: "纬度", customTypeFields: nil),
                    APIParameter(name: "longitude", type: .double, isOptional: false, description: "经度", customTypeFields: nil),
                    APIParameter(name: "address", type: .string, isOptional: false, description: "详细位置信息", customTypeFields: nil),
                ]),
                APIParameter(name: "conversationId", type: .string, isOptional: false, description: nil, customTypeFields: nil),
                sendMessageParams,
            ],
            executeFunction: { (params, callback) in
                let latitude = params["message.latitude"] as? Double ?? 0.0
                let longitude = params["message.longitude"] as? Double ?? 0.0
                let address = params["message.address"] as? String ?? ""
                let message = V2NIMMessageCreator.createLocationMessage(latitude, longitude: longitude, address: address)
                guard let conversationId = params["conversationId"] as? String else {
                    callback("Error: conversationId is required.")
                    return
                }
                let param = V2NIMSendMessageParams.init(params)
                NIMSDK.shared().v2MessageService.send(message, conversationId: conversationId, params: param) { result in
                    callback("sendLocationMessage success. \(result)")
                } failure: { error in
                    callback("sendLocationMessage failed. \(error)")
                } progress: { pro in
                    Logger.log("sendLocationMessage progress: \(pro)")
                }
            }
        ),
        "custom sendMessage:conversationId:params:success:failure:progress:": APIDefinition(
            name: "custom sendMessage:conversationId:params:success:failure:progress:",
            parameters: [
                APIParameter(name: "message", type: .custom("V2NIMMessage"), isOptional: true, description: "通过V2NIMMessageCreator创建", customTypeFields: [
                    APIParameter(name: "text", type: .string, isOptional: false, description: "需要发送的文本内容", customTypeFields: nil),
                    APIParameter(name: "rawAttachment", type: .string, isOptional: false, description: "需要发送的附件", customTypeFields: nil),
                ]),
                APIParameter(name: "conversationId", type: .string, isOptional: false, description: nil, customTypeFields: nil),
                sendMessageParams,
            ],
            executeFunction: { (params, callback) in
                let text = params["message.text"] as? String ?? ""
                let rawAttachment = params["message.rawAttachment"] as? String ?? ""
                let message = V2NIMMessageCreator.createCustomMessage(text, rawAttachment: rawAttachment)
                guard let conversationId = params["conversationId"] as? String else {
                    callback("Error: conversationId is required.")
                    return
                }
                let param = V2NIMSendMessageParams.init(params)
                NIMSDK.shared().v2MessageService.send(message, conversationId: conversationId, params: param) { result in
                    callback("sendCustomMessage success. \(result)")
                } failure: { error in
                    callback("sendCustomMessage failed. \(error)")
                } progress: { pro in
                    Logger.log("sendCustomMessage progress: \(pro)")
                }
            }
        ),
        "getMessageListEx:success:failure:": APIDefinition(
            name: "getMessageListEx:success:failure:",
            parameters: [
                APIParameter(name: "option", type: .custom("V2NIMMessageListOption"), isOptional: true, description: nil, customTypeFields: [
                    APIParameter(name: "conversationId", type: .string, isOptional: false, description: nil, customTypeFields: nil),
                    APIParameter(name: "messageTypes", type: .string, isOptional: true, description: "-1: INVALID;0: TEXT;1: IMAGE;2: AUDIO;3: VIDEO;4: LOCATION;5: NOTIFICATION;6: FILE;7: AVCHAT;10: TIP;11: ROBOT;12: CALL;100: CUSTOM;", customTypeFields: nil),
                    APIParameter(name: "beginTime", type: .double, isOptional: true, description: nil, customTypeFields: nil),
                    APIParameter(name: "endTime", type: .double, isOptional: true, description: nil, customTypeFields: nil),
                    APIParameter(name: "limit", type: .int, isOptional: true, description: nil, customTypeFields: nil),
                    APIParameter(name: "anchorMessage", type: .custom("V2NIMMessage"), isOptional: true, description: nil, customTypeFields: [
                        APIParameter(name: "messageClientId", type: .string, isOptional: true, description: nil, customTypeFields: nil),
                        APIParameter(name: "conversationId", type: .string, isOptional: true, description: nil, customTypeFields: nil),
                    ]),
                    APIParameter(name: "direction", type: .int, isOptional: true, description: "0: Desc; 1: Asc;", customTypeFields: nil),
                    APIParameter(name: "strictMode", type: .bool, isOptional: true, description: nil, customTypeFields: nil),
                    APIParameter(name: "onlyQueryLocal", type: .bool, isOptional: true, description: nil, customTypeFields: nil)
                ]),
            ],
            executeFunction: { (params, callback) in
                let option = V2NIMMessageListOption.init(params)
                NIMSDK.shared().v2MessageService.getMessageListEx(option) { result in
                    callback("getMessageListEx success. \(result)")
                } failure: { error in
                    callback("getMessageListEx failed. \(error)")
                }
            }
        ),
        "getMessageListByIds:success:failure:": APIDefinition(
            name: "getMessageListByIds:success:failure:",
            parameters: [
                APIParameter(name: "messageClientIds", type: .string, isOptional: false, description: "消息ClientId列表", customTypeFields: nil),
            ],
            executeFunction: { (params, callback) in
                guard let messageClientIdsStr = params["messageClientIds"] as? String else {
                    callback("Error: messageClientIds is required.")
                    return
                }
                let messageClientIds = messageClientIdsStr.split(separator: ",").map { String($0) }
                NIMSDK.shared().v2MessageService.getMessageList(byIds: messageClientIds) { result in
                    callback("getMessageListByIds success. \(result)")
                } failure: { error in
                    callback("getMessageListByIds failed. \(error)")
                }
            }
        ),
        "deleteMessages:serverExtension:onlyDeleteLocal:success:failure:": APIDefinition(
            name: "deleteMessages:serverExtension:onlyDeleteLocal:success:failure:",
            parameters: [
                APIParameter(name: "messageClientIds", type: .string, isOptional: false, description: "要删除的消息的端侧ID列表", customTypeFields: nil),
                APIParameter(name: "serverExtension", type: .string, isOptional: true, description: "服务器扩展字段", customTypeFields: nil),
                APIParameter(name: "onlyDeleteLocal", type: .bool, isOptional: true, description: "是否仅删除本地消息", customTypeFields: nil)
            ],
            executeFunction: { (params, callback) in
                var messages: [V2NIMMessage] = []
                if let messageClientIdsStr = params["messageClientIds"] as? String
                {
                    let messageClientIds = messageClientIdsStr.split(separator: ",").map({ String($0) })
                    var error: V2NIMError?
                    messages = NIMSDK.shared().v2MessageService.getMessageList(byIds: messageClientIds, conversationId: nil, error: &error) ?? []
                }
                var serverExtension: String = ""
                if let serverExtensionStr = params["serverExtension"] as? String {
                    serverExtension = serverExtensionStr
                }
                let onlyDeleteLocal = params["onlyDeleteLocal"] as? Bool ?? false
                NIMSDK.shared().v2MessageService.delete(messages, serverExtension: serverExtension, onlyDeleteLocal: onlyDeleteLocal) {
                    callback("deleteMessages success.")
                } failure: { error in
                    callback("deleteMessages failed. \(error)")
                }
            }
        ),
        "addMessageListener:": APIDefinition(
            name: "addMessageListener:",
            parameters:[],
            executeFunction: { (params, callback) in
                NIMSDK.shared().v2MessageService.add(ExecutionMessageViewModels.listener)
                callback("addMessageListener success.")
            }
        ),
        "removeMessageListener:": APIDefinition(
            name: "removeMessageListener:",
            parameters:[],
            executeFunction: { (params, callback) in
                NIMSDK.shared().v2MessageService.remove(ExecutionMessageViewModels.listener)
                callback("removeMessageListener success.")
            }
        ),
    ]
}

class V2MessageListener: NSObject, V2NIMMessageListener
{
    func onSend(_ message: V2NIMMessage) {
        Logger.log("onSend: \(message)")
    }
    func onReceive(_ messages: [V2NIMMessage]) {
        Logger.log("onReceive: \(messages)")
    }
}

extension V2NIMMessageListOption {
    convenience init(_ dict: [String: Any]) {
        self.init()
        if let conversationId = dict["option.conversationId"] as? String {
            self.conversationId = conversationId
        }
        if let messageTypesStr = dict["option.messageTypes"] as? String {
            let messageTypesArray = messageTypesStr.split(separator: ",").compactMap { Int($0) }
            self.messageTypes = messageTypesArray
        }
        if let beginTime = dict["option.beginTime"] as? Double {
            self.beginTime = beginTime
        }
        if let endTime = dict["option.endTime"] as? Double {
            self.endTime = endTime
        }
        if let limit = dict["option.limit"] as? Int {
            self.limit = limit
        }
        if let anchorClientId = dict["option.anchorMessage.messageClientId"] as? String,
           let anchorConversationId = dict["option.anchorMessage.conversationId"] as? String {
            var error: V2NIMError?
            let messages = NIMSDK.shared().v2MessageService.getMessageList(byIds: [anchorClientId], conversationId: anchorConversationId, error: &error)
            if let message = messages?.first {
                self.anchorMessage = message
            }
        }
        if let directionInt = dict["option.direction"] as? Int,
            let direction = V2NIMQueryDirection(rawValue: directionInt) {
            self.direction = direction
        }
        if let strictMode = dict["option.strictMode"] as? Bool {
            self.strictMode = strictMode
        }
        if let onlyQueryLocal = dict["option.onlyQueryLocal"] as? Bool {
            self.onlyQueryLocal = onlyQueryLocal
        }
    }
}

extension V2NIMMessagePushConfig {
    convenience init(_ dict: [String: Any]) {
        self.init()
        if let pushEnabled = dict["pushEnabled"] as? Bool {
            self.pushEnabled = pushEnabled
        }
        if let pushNickEnabled = dict["pushNickEnabled"] as? Bool {
            self.pushNickEnabled = pushNickEnabled
        }
        if let pushContent = dict["pushContent"] as? String {
            self.pushContent = pushContent
        }
        if let pushPayload = dict["pushPayload"] as? String {
            self.pushPayload = pushPayload
        }
        if let forcePush = dict["forcePush"] as? Bool {
            self.forcePush = forcePush
        }
        if let forcePushContent = dict["forcePushContent"] as? String {
            self.forcePushContent = forcePushContent
        }
        if let forcePushAccountIdsStr = dict["forcePushAccountIds"] as? String {
            let forcePushAccountIds = forcePushAccountIdsStr.split(separator: ",").map { String($0) }
            self.forcePushAccountIds = forcePushAccountIds
        }
    }
}

extension V2NIMSendMessageParams {
    convenience init(_ dict: [String: Any]) {
        self.init()
        if let pushConfigDict = dict["params.pushConfig"] as? [String: Any] {
            let pushConfig = V2NIMMessagePushConfig.init(pushConfigDict)
            self.pushConfig = pushConfig
        }
        if let clientAntispamEnabled = dict["params.clientAntispamEnabled"] as? Bool {
            self.clientAntispamEnabled = clientAntispamEnabled
        }
        if let clientAntispamReplace = dict["params.clientAntispamReplace"] as? String {
            self.clientAntispamReplace = clientAntispamReplace
        }
    }
}
