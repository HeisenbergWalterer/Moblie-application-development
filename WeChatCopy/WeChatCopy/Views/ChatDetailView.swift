//
//  ChatDetailView.swift
//  WeChatCopy
//
//  Created by admin on 2025/11/3.
//

import SwiftUI

/// 聊天详情视图
struct ChatDetailView: View {
    @StateObject private var viewModel: ChatDetailViewModel
    @State private var selectedImage: UIImage?
    
    init(chat: Chat, user: User) {
        _viewModel = StateObject(wrappedValue: ChatDetailViewModel(chat: chat, user: user))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 消息列表
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageBubbleView(message: message, user: viewModel.user)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .background(Color(UIColor.systemGroupedBackground))
                .onTapGesture {
                    // 点击消息区域收起键盘
                    hideKeyboard()
                }
                .onChange(of: viewModel.messages.count) { _ in
                    // 自动滚动到最新消息
                    if let lastMessage = viewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                .onAppear {
                    // 初始滚动到底部
                    if let lastMessage = viewModel.messages.last {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            Divider()
            
            // 输入工具栏
            inputToolbar
        }
        .navigationTitle(viewModel.user.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.3)) {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    scene.windows.first?.allSubviews.forEach { subview in
                        if let tabBar = subview as? UITabBar {
                            tabBar.isHidden = true
                        }
                    }
                }
            }
        }
        .onDisappear {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                scene.windows.first?.allSubviews.forEach { subview in
                    if let tabBar = subview as? UITabBar {
                        tabBar.isHidden = false
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {
                        viewModel.togglePin()
                    }) {
                        Label(viewModel.isPinned ? "取消置顶" : "置顶聊天", 
                              systemImage: viewModel.isPinned ? "pin.slash.fill" : "pin.fill")
                    }
                    
                    Button(role: .destructive, action: {
                        // 删除聊天
                        DataService.shared.deleteChat(chatID: viewModel.chat.id)
                    }) {
                        Label("删除聊天", systemImage: "trash")
                    }
                    
                    Button(role: .destructive, action: {
                        // 拉黑
                    }) {
                        Label("拉黑", systemImage: "hand.raised.fill")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .onChange(of: selectedImage) { image in
            if image != nil {
                viewModel.sendImageMessage(imageName: "photo.fill")
                selectedImage = nil
            }
        }
    }
    
    private var inputToolbar: some View {
        VStack(spacing: 0) {
            // Emoji选择器
            if viewModel.showEmojiPicker {
                EmojiPickerView { emoji in
                    viewModel.insertEmoji(emoji)
                }
                .frame(height: 200)
                .background(Color.weChatBackground)
            }
            
            // 输入栏
            HStack(spacing: 12) {
                // 语音按钮
                Button(action: {
                    // 语音输入
                }) {
                    Image(systemName: "mic.fill")
                        .foregroundColor(.gray)
                }
                
                // 文本输入框
                HStack {
                    TextField("输入消息", text: $viewModel.inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onTapGesture {
                            // 点击文本框时关闭emoji面板
                            viewModel.showEmojiPicker = false
                        }
                    
                    // Emoji按钮
                    Button(action: {
                        hideKeyboard()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            viewModel.showEmojiPicker.toggle()
                        }
                    }) {
                        Image(systemName: viewModel.showEmojiPicker ? "keyboard" : "face.smiling")
                            .foregroundColor(.gray)
                    }
                }
                
                // 更多按钮/发送按钮
                if viewModel.inputText.isEmpty {
                    Button(action: {
                        hideKeyboard()
                        viewModel.showEmojiPicker = false
                        viewModel.showImagePicker = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 28))
                    }
                } else {
                    Button(action: {
                        viewModel.sendTextMessage()
                        viewModel.showEmojiPicker = false
                        hideKeyboard()
                    }) {
                        Text("发送")
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Color.weChatGreen)
                            .cornerRadius(4)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(UIColor.systemBackground))
        }
    }
}

/// 消息气泡视图
struct MessageBubbleView: View {
    let message: Message
    let user: User
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if message.isSentByMe {
                Spacer()
                messageBubble
                avatar
            } else {
                avatar
                messageBubble
                Spacer()
            }
        }
    }
    
    private var avatar: some View {
        Image(systemName: message.isSentByMe ? "person.circle.fill" : user.avatar)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.gray)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
    
    @ViewBuilder
    private var messageBubble: some View {
        switch message.type {
        case .text, .emoji:
            Text(message.content)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(message.isSentByMe ? Color.chatBubbleSent : Color.chatBubbleReceived)
                .cornerRadius(8)
                .foregroundColor(.black)
        
        case .image:
            Image(systemName: message.content)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        
        case .video, .voice:
            Text("[不支持的消息类型]")
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
    }
}

/// Emoji选择器视图
struct EmojiPickerView: View {
    let onSelect: (String) -> Void
    
    let emojis = [
        "😀", "😃", "😄", "😁", "😆", "😅", "🤣", "😂",
        "😊", "😇", "🙂", "🙃", "😉", "😌", "😍", "🥰",
        "😘", "😗", "😙", "😚", "😋", "😛", "😝", "😜",
        "🤪", "🤨", "🧐", "🤓", "😎", "🤩", "🥳", "😏",
        "👍", "👎", "👏", "🙌", "👐", "🤝", "🙏", "✌️",
        "🤞", "🤟", "🤘", "🤙", "👈", "👉", "👆", "👇",
        "❤️", "🧡", "💛", "💚", "💙", "💜", "🖤", "🤍",
        "💯", "💢", "💥", "💫", "💦", "💨", "🕳️", "💬"
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 8), spacing: 10) {
                ForEach(emojis, id: \.self) { emoji in
                    Button(action: {
                        onSelect(emoji)
                    }) {
                        Text(emoji)
                            .font(.system(size: 30))
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    NavigationView {
        ChatDetailView(
            chat: Chat(participantID: User.sampleUsers[0].id),
            user: User.sampleUsers[0]
        )
    }
}
