//
//  ChatViewModel.swift
//  WeChatCopy
//
//  Created by admin on 2025/11/3.
//

import Foundation
import SwiftUI
import Combine

/// 聊天列表ViewModel
class ChatViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    @Published var searchText: String = ""
    
    private var dataService = DataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 订阅数据变化
        dataService.$chats
            .assign(to: &$chats)
    }
    
    var filteredChats: [Chat] {
        if searchText.isEmpty {
            return chats
        }
        return chats.filter { chat in
            guard let user = dataService.getUser(byID: chat.participantID) else {
                return false
            }
            return user.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func getUser(for chat: Chat) -> User? {
        return dataService.getUser(byID: chat.participantID)
    }
    
    func deleteChat(at offsets: IndexSet) {
        chats.remove(atOffsets: offsets)
    }
    
    func togglePin(chat: Chat) {
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            chats[index].isPinned.toggle()
        }
    }
}
