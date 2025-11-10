//
//  DataService.swift
//  WeChatCopy
//
//  Created by admin on 2025/11/3.
//

import Foundation
import Combine

/// 数据服务 - 模拟后端数据管理
class DataService: ObservableObject {
    static let shared = DataService()
    
    @Published var currentUser: User
    @Published var users: [User]
    @Published var chats: [Chat]
    @Published var contacts: [Contact]
    @Published var moments: [Moment]
    
    private init() {
        // 初始化当前用户
        self.currentUser = User.currentUser
        
        // 初始化示例用户
        self.users = User.sampleUsers
        
        // 初始化聊天
        self.chats = Chat.createSampleChats(users: User.sampleUsers)
        
        // 初始化联系人
        self.contacts = Contact.createSampleContacts(from: User.sampleUsers)
        
        // 初始化朋友圈
        self.moments = Moment.createSampleMoments(users: User.sampleUsers)
    }
    
    // MARK: - User Methods
    
    func getUser(byID id: String) -> User? {
        if id == currentUser.id {
            return currentUser
        }
        return users.first(where: { $0.id == id })
    }
    
    func updateCurrentUser(_ user: User) {
        currentUser = user
    }
    
    // MARK: - Chat Methods
    
    func getChat(byID id: String) -> Chat? {
        return chats.first(where: { $0.id == id })
    }
    
    func getChat(withParticipantID participantID: String) -> Chat? {
        return chats.first(where: { $0.participantID == participantID })
    }
    
    func sendMessage(_ message: Message, toChatID chatID: String) {
        if let index = chats.firstIndex(where: { $0.id == chatID }) {
            chats[index].addMessage(message)
            // 重新排序
            chats.sort { chat1, chat2 in
                if chat1.isPinned != chat2.isPinned {
                    return chat1.isPinned
                }
                return (chat1.lastMessage?.timestamp ?? Date()) > (chat2.lastMessage?.timestamp ?? Date())
            }
        }
    }
    
    func markChatAsRead(chatID: String) {
        if let index = chats.firstIndex(where: { $0.id == chatID }) {
            chats[index].markAllAsRead()
        }
    }
    
    func toggleChatPin(chatID: String) {
        if let index = chats.firstIndex(where: { $0.id == chatID }) {
            chats[index].isPinned.toggle()
            // 重新排序
            chats.sort { chat1, chat2 in
                if chat1.isPinned != chat2.isPinned {
                    return chat1.isPinned
                }
                return (chat1.lastMessage?.timestamp ?? Date()) > (chat2.lastMessage?.timestamp ?? Date())
            }
        }
    }
    
    func deleteChat(chatID: String) {
        chats.removeAll(where: { $0.id == chatID })
    }
    
    // MARK: - Contact Methods
    
    func getContact(byUserID userID: String) -> Contact? {
        return contacts.first(where: { $0.userID == userID })
    }
    
    func updateContact(_ contact: Contact) {
        if let index = contacts.firstIndex(where: { $0.id == contact.id }) {
            contacts[index] = contact
        }
    }
    
    // MARK: - Moment Methods
    
    func toggleLike(momentID: String) {
        if let index = moments.firstIndex(where: { $0.id == momentID }) {
            moments[index].toggleLike(userID: currentUser.id)
        }
    }
    
    func addComment(to momentID: String, content: String, replyToUserID: String? = nil) {
        if let index = moments.firstIndex(where: { $0.id == momentID }) {
            let comment = MomentComment(
                userID: currentUser.id,
                content: content,
                replyToUserID: replyToUserID
            )
            moments[index].addComment(comment)
        }
    }
    
    func postMoment(_ moment: Moment) {
        moments.insert(moment, at: 0)
    }
    
    // MARK: - Contact Methods
    func toggleContactFavorite(contactID: String) {
        if let index = contacts.firstIndex(where: { $0.id == contactID }) {
            contacts[index].isFavorite.toggle()
        }
    }
}
