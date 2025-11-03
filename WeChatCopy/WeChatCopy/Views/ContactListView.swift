//
//  ContactListView.swift
//  WeChatCopy
//
//  Created by admin on 2025/11/3.
//

import SwiftUI

/// 通讯录列表视图
struct ContactListView: View {
    @StateObject private var viewModel = ContactViewModel()
    
    var body: some View {
        NavigationView {
            List {
                // 顶部功能入口
                Section {
                    NavigationLink(destination: Text("新的朋友")) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.orange)
                                    .frame(width: 40, height: 40)
                                Image(systemName: "person.badge.plus")
                                    .foregroundColor(.white)
                            }
                            Text("新的朋友")
                        }
                    }
                    
                    NavigationLink(destination: Text("群聊")) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.green)
                                    .frame(width: 40, height: 40)
                                Image(systemName: "person.3")
                                    .foregroundColor(.white)
                            }
                            Text("群聊")
                        }
                    }
                    
                    NavigationLink(destination: Text("标签")) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.blue)
                                    .frame(width: 40, height: 40)
                                Image(systemName: "tag")
                                    .foregroundColor(.white)
                            }
                            Text("标签")
                        }
                    }
                }
                
                // 联系人列表（按字母分组）
                ForEach(viewModel.groupedContacts) { section in
                    Section(header: Text(section.letter)) {
                        ForEach(section.contacts) { contact in
                            NavigationLink(destination: ContactDetailView(contact: contact)) {
                                ContactRowView(contact: contact, viewModel: viewModel)
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("通讯录")
            .searchable(text: $viewModel.searchText, prompt: "搜索")
        }
    }
}

/// 联系人行视图
struct ContactRowView: View {
    let contact: Contact
    let viewModel: ContactViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            // 头像
            if let user = viewModel.getUser(for: contact) {
                Image(systemName: user.avatar)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            
            // 名称
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.getDisplayName(for: contact))
                    .font(.system(size: 16))
                
                if contact.isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 12))
                }
            }
        }
        .padding(.vertical, 4)
    }
}

/// 联系人详情视图
struct ContactDetailView: View {
    let contact: Contact
    @StateObject private var dataService = DataService.shared
    @State private var showingChat = false
    @State private var showDeleteAlert = false
    @State private var showBlockAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var user: User? {
        dataService.getUser(byID: contact.userID)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 头像和基本信息
                VStack(spacing: 16) {
                    if let user = user {
                        Image(systemName: user.avatar)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Text(contact.remark ?? user.name)
                            .font(.system(size: 24, weight: .semibold))
                        
                        Text("微信号：\(user.weChatID)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 30)
                
                // 详细信息
                VStack(spacing: 0) {
                    if let user = user {
                        InfoRow(title: "备注和标签", value: contact.remark ?? "")
                        Divider().padding(.leading, 60)
                        
                        InfoRow(title: "个性签名", value: user.signature)
                        Divider().padding(.leading, 60)
                        
                        if let region = user.region {
                            InfoRow(title: "地区", value: region)
                            Divider().padding(.leading, 60)
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal)
                
                // 操作按钮
                VStack(spacing: 12) {
                    Button(action: {
                        showingChat = true
                    }) {
                        HStack {
                            Image(systemName: "message.fill")
                            Text("发消息")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.weChatGreen)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    
                    Button(action: {
                        // 音视频通话
                    }) {
                        HStack {
                            Image(systemName: "video.fill")
                            Text("音视频通话")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .background(Color.weChatBackground)
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
                        // 设置备注和标签
                    }) {
                        Label("设置备注和标签", systemImage: "tag")
                    }
                    
                    Button(action: {
                        DataService.shared.toggleContactFavorite(contactID: contact.id)
                    }) {
                        Label(contact.isFavorite ? "取消星标" : "设为星标", 
                              systemImage: contact.isFavorite ? "star.slash.fill" : "star.fill")
                    }
                    
                    Divider()
                    
                    Button(role: .destructive, action: {
                        showBlockAlert = true
                    }) {
                        Label("拉黑", systemImage: "hand.raised.fill")
                    }
                    
                    Button(role: .destructive, action: {
                        showDeleteAlert = true
                    }) {
                        Label("删除联系人", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .alert("删除联系人", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) { }
            Button("删除", role: .destructive) {
                // 删除联系人逻辑
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("确定要删除这个联系人吗？")
        }
        .alert("拉黑联系人", isPresented: $showBlockAlert) {
            Button("取消", role: .cancel) { }
            Button("拉黑", role: .destructive) {
                // 拉黑联系人逻辑
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("拉黑后将不再接收对方的消息")
        }
        .fullScreenCover(isPresented: $showingChat) {
            if let user = user,
               let chat = dataService.getChat(withParticipantID: user.id) {
                NavigationView {
                    ChatDetailView(chat: chat, user: user)
                        .navigationBarItems(trailing: Button("关闭") {
                            showingChat = false
                        })
                }
            }
        }
    }
}

/// 信息行视图
struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.black)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .lineLimit(2)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.system(size: 14))
        }
        .padding()
    }
}

#Preview {
    ContactListView()
}
