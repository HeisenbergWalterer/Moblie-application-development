//
//  Chat.swift
//  WeChatCopy
//
//  Created by admin on 2025/11/3.
//

import Foundation

/// 聊天会话模型
struct Chat: Identifiable, Codable {
    let id: String
    let participantID: String   // 聊天对象的用户ID
    var messages: [Message]     // 消息列表
    var lastMessage: Message?   // 最后一条消息
    var unreadCount: Int        // 未读消息数
    var isPinned: Bool          // 是否置顶
    
    init(id: String = UUID().uuidString,
         participantID: String,
         messages: [Message] = [],
         unreadCount: Int = 0,
         isPinned: Bool = false) {
        self.id = id
        self.participantID = participantID
        self.messages = messages
        self.lastMessage = messages.last
        self.unreadCount = unreadCount
        self.isPinned = isPinned
    }
    
    /// 更新最后一条消息
    mutating func updateLastMessage() {
        self.lastMessage = messages.last
    }
    
    /// 添加新消息
    mutating func addMessage(_ message: Message) {
        messages.append(message)
        updateLastMessage()
        if !message.isSentByMe && !message.isRead {
            unreadCount += 1
        }
    }
    
    /// 标记所有消息为已读
    mutating func markAllAsRead() {
        unreadCount = 0
        for index in messages.indices {
            messages[index].isRead = true
        }
    }
}

// MARK: - 示例数据
extension Chat {
    static func createSampleChats(users: [User]) -> [Chat] {
        var chats: [Chat] = []
        
        // 为每个用户创建一个聊天会话
        for (index, user) in users.enumerated() {
            let messageCount = Int.random(in: 1...10)
            var messages: [Message] = []
            
            for i in 0..<messageCount {
                let isSentByMe = Bool.random()
                let messageTypes: [MessageType] = [.text, .text, .text, .emoji, .image]
                let randomType = messageTypes.randomElement() ?? .text
                
                var content = ""
                switch randomType {
                case .text:
                    content = ["你好", "在吗？", "好的", "收到", "明天见", "哈哈哈", "知道了", "没问题"].randomElement() ?? "你好"
                case .emoji:
                    content = ["😊", "👍", "❤️", "😂", "🎉", "💪", "🌟", "👏"].randomElement() ?? "😊"
                case .image:
                    content = "photo.fill"
                default:
                    content = "消息内容"
                }
                
                let message = Message(
                    chatID: user.id,
                    senderID: isSentByMe ? User.currentUser.id : user.id,
                    content: content,
                    type: randomType,
                    timestamp: Date().addingTimeInterval(TimeInterval(-86400 * index - 3600 * i)),
                    isRead: Bool.random(),
                    isSentByMe: isSentByMe
                )
                messages.append(message)
            }
            
            let unreadCount = Int.random(in: 0...5)
            let chat = Chat(
                participantID: user.id,
                messages: messages.sorted(by: { $0.timestamp < $1.timestamp }),
                unreadCount: unreadCount,
                isPinned: index < 2
            )
            chats.append(chat)
        }
        
        return chats.sorted(by: { chat1, chat2 in
            if chat1.isPinned != chat2.isPinned {
                return chat1.isPinned
            }
            return (chat1.lastMessage?.timestamp ?? Date()) > (chat2.lastMessage?.timestamp ?? Date())
        })
    }
}
