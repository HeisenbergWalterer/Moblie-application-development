//
//  Message.swift
//  WeChatCopy
//
//  Created by admin on 2025/11/3.
//

import Foundation

/// 消息类型
enum MessageType: String, Codable {
    case text       // 文本消息
    case image      // 图片消息
    case emoji      // 表情消息
    case video      // 视频消息
    case voice      // 语音消息
}

/// 消息模型
struct Message: Identifiable, Codable {
    let id: String
    let chatID: String          // 所属聊天的ID
    let senderID: String        // 发送者ID
    let content: String         // 消息内容（文本/图片URL/表情符号等）
    let type: MessageType       // 消息类型
    let timestamp: Date         // 发送时间
    var isRead: Bool            // 是否已读
    var isSentByMe: Bool        // 是否是我发送的
    
    init(id: String = UUID().uuidString,
         chatID: String,
         senderID: String,
         content: String,
         type: MessageType = .text,
         timestamp: Date = Date(),
         isRead: Bool = false,
         isSentByMe: Bool = false) {
        self.id = id
        self.chatID = chatID
        self.senderID = senderID
        self.content = content
        self.type = type
        self.timestamp = timestamp
        self.isRead = isRead
        self.isSentByMe = isSentByMe
    }
}

// MARK: - 时间格式化
extension Message {
    var formattedTime: String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(timestamp) {
            formatter.dateFormat = "HH:mm"
        } else if calendar.isDateInYesterday(timestamp) {
            return "昨天"
        } else if calendar.isDate(timestamp, equalTo: Date(), toGranularity: .weekOfYear) {
            formatter.dateFormat = "EEEE"
        } else {
            formatter.dateFormat = "MM/dd"
        }
        
        return formatter.string(from: timestamp)
    }
}
