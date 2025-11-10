//
//  ChatDetailViewModel.swift
//  WeChatCopy
//
//  Created by admin on 2025/11/3.
//

import Foundation
import Combine
import SwiftUI

/// 聊天详情ViewModel
class ChatDetailViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var inputText: String = ""
    @Published var showImagePicker: Bool = false
    @Published var showEmojiPicker: Bool = false
    
    let chat: Chat
    let user: User
    private var dataService = DataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init(chat: Chat, user: User) {
        self.chat = chat
        self.user = user
        self.messages = chat.messages
        
        // 标记为已读
        dataService.markChatAsRead(chatID: chat.id)
        
        // 订阅聊天数据变化
        dataService.$chats
            .compactMap { chats in chats.first(where: { $0.id == chat.id }) }
            .map { $0.messages }
            .assign(to: &$messages)
    }
    
    func sendTextMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        let message = Message(
            chatID: chat.id,
            senderID: dataService.currentUser.id,
            content: inputText,
            type: .text,
            timestamp: Date(),
            isRead: false,
            isSentByMe: true
        )
        
        dataService.sendMessage(message, toChatID: chat.id)
        inputText = ""
    }
    
    func sendImageMessage(imageName: String) {
        let message = Message(
            chatID: chat.id,
            senderID: dataService.currentUser.id,
            content: imageName,
            type: .image,
            timestamp: Date(),
            isRead: false,
            isSentByMe: true
        )
        
        dataService.sendMessage(message, toChatID: chat.id)
    }
    
    func sendEmojiMessage(emoji: String) {
        let message = Message(
            chatID: chat.id,
            senderID: dataService.currentUser.id,
            content: emoji,
            type: .emoji,
            timestamp: Date(),
            isRead: false,
            isSentByMe: true
        )
        
        dataService.sendMessage(message, toChatID: chat.id)
    }
    
    func insertEmoji(_ emoji: String) {
        inputText += emoji
    }
    
    func togglePin() {
        dataService.toggleChatPin(chatID: chat.id)
    }
    
    var isPinned: Bool {
        dataService.chats.first(where: { $0.id == chat.id })?.isPinned ?? false
    }
}
