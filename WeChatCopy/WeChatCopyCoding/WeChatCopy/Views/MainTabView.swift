//
//  MainTabView.swift
//  WeChatCopy
//
//  Created by admin on 2025/11/3.
//

import SwiftUI

/// 主标签栏视图
struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // 微信（聊天列表）
            ChatListView()
                .tabItem {
                    Label("微信", systemImage: selectedTab == 0 ? "message.fill" : "message")
                }
                .tag(0)
            
            // 通讯录
            ContactListView()
                .tabItem {
                    Label("通讯录", systemImage: selectedTab == 1 ? "person.2.fill" : "person.2")
                }
                .tag(1)
            
            // 发现（朋友圈）
            DiscoverView()
                .tabItem {
                    Label("发现", systemImage: selectedTab == 2 ? "safari.fill" : "safari")
                }
                .tag(2)
            
            // 我
            ProfileView()
                .tabItem {
                    Label("我", systemImage: selectedTab == 3 ? "person.fill" : "person")
                }
                .tag(3)
        }
        .accentColor(.weChatGreen)
    }
}

#Preview {
    MainTabView()
}
