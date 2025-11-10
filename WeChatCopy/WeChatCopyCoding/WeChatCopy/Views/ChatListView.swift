//
//  ChatListView.swift
//  WeChatCopy
//
//  Created by admin on 2025/11/3.
//

import SwiftUI

/// 聊天列表视图（微信界面）
struct ChatListView: View {
    @StateObject private var viewModel = ChatViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.filteredChats) { chat in
                    NavigationLink(destination: destinationView(for: chat)) {
                        ChatListRowView(chat: chat, user: viewModel.getUser(for: chat))
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowBackground(chat.isPinned ? Color.weChatBackground.opacity(0.5) : Color.clear)
                }
                .onDelete(perform: viewModel.deleteChat)
            }
            .listStyle(.plain)
            .navigationTitle("微信")
            .searchable(text: $viewModel.searchText, prompt: "搜索")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // 添加新聊天
                    }) {
                        Image(systemName: "plus.circle")
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for chat: Chat) -> some View {
        if let user = viewModel.getUser(for: chat) {
            ChatDetailView(chat: chat, user: user)
        } else {
            Text("用户不存在")
        }
    }
}

/// 聊天列表行视图
struct ChatListRowView: View {
    let chat: Chat
    let user: User?
    
    var body: some View {
        HStack(spacing: 12) {
            // 头像
            Image(systemName: user?.avatar ?? "person.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    // 名称（置顶显示图标）
                    if chat.isPinned {
                        Image(systemName: "pin.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.orange)
                    }
                    
                    Text(user?.name ?? "未知用户")
                        .font(.system(size: 16, weight: .medium))
                    
                    Spacer()
                    
                    // 时间
                    if let lastMessage = chat.lastMessage {
                        Text(lastMessage.formattedTime)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                
                HStack {
                    // 最后一条消息
                    if let lastMessage = chat.lastMessage {
                        Text(messagePreview(for: lastMessage))
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    // 未读消息徽章
                    if chat.unreadCount > 0 {
                        ZStack {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 20, height: 20)
                            
                            Text("\(chat.unreadCount)")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private func messagePreview(for message: Message) -> String {
        switch message.type {
        case .text:
            return message.content
        case .image:
            return "[图片]"
        case .emoji:
            return message.content
        case .video:
            return "[视频]"
        case .voice:
            return "[语音]"
        }
    }
}

#Preview {
    ChatListView()
}
