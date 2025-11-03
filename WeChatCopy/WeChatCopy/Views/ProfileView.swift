//
//  ProfileView.swift
//  WeChatCopy
//
//  Created by admin on 2025/11/3.
//

import SwiftUI

/// 个人中心视图（我的界面）
struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            List {
                // 个人信息卡片
                Section {
                    Button(action: {
                        viewModel.showEditProfile = true
                    }) {
                        HStack(spacing: 15) {
                            // 头像
                            Image(systemName: viewModel.currentUser.avatar)
                                .resizable()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.gray)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            VStack(alignment: .leading, spacing: 8) {
                                // 昵称
                                HStack {
                                    Text(viewModel.currentUser.name)
                                        .font(.system(size: 22, weight: .semibold))
                                        .foregroundColor(.primary)
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 14))
                                }
                                
                                // 微信号
                                Text("微信号：\(viewModel.currentUser.weChatID)")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                
                                // 个性签名
                                if !viewModel.currentUser.signature.isEmpty {
                                    Text(viewModel.currentUser.signature)
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // 功能列表
                Section {
                    NavigationLink(destination: Text("服务")) {
                        MenuRow(icon: "creditcard.fill", iconColor: .orange, title: "服务")
                    }
                }
                
                Section {
                    NavigationLink(destination: Text("收藏")) {
                        MenuRow(icon: "star.fill", iconColor: .orange, title: "收藏")
                    }
                    
                    NavigationLink(destination: MomentsView()) {
                        MenuRow(icon: "photo.on.rectangle", iconColor: .blue, title: "朋友圈")
                    }
                    
                    NavigationLink(destination: Text("卡包")) {
                        MenuRow(icon: "wallet.pass.fill", iconColor: .orange, title: "卡包")
                    }
                    
                    NavigationLink(destination: Text("表情")) {
                        MenuRow(icon: "face.smiling.fill", iconColor: .yellow, title: "表情")
                    }
                }
                
                Section {
                    NavigationLink(destination: SettingsView()) {
                        MenuRow(icon: "gearshape.fill", iconColor: .gray, title: "设置")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("我")
            .sheet(isPresented: $viewModel.showQRCode) {
                QRCodeView(user: viewModel.currentUser)
            }
            .sheet(isPresented: $viewModel.showEditProfile) {
                EditProfileView(viewModel: viewModel)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.showQRCode = true
                    }) {
                        Image(systemName: "qrcode")
                    }
                }
            }
        }
    }
}

/// 菜单行视图
struct MenuRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(.system(size: 16))
        }
    }
}

/// 二维码视图
struct QRCodeView: View {
    let user: User
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                // 用户信息
                VStack(spacing: 15) {
                    Image(systemName: user.avatar)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Text(user.name)
                        .font(.system(size: 20, weight: .semibold))
                    
                    if !user.signature.isEmpty {
                        Text(user.signature)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
                
                // 二维码占位
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .frame(width: 250, height: 250)
                        .shadow(radius: 5)
                    
                    VStack(spacing: 10) {
                        Image(systemName: "qrcode")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .foregroundColor(.black)
                        
                        Text("扫描二维码添加我为好友")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                // 操作按钮
                HStack(spacing: 20) {
                    Button(action: {
                        // 保存到相册
                    }) {
                        VStack {
                            Image(systemName: "square.and.arrow.down")
                                .font(.system(size: 24))
                            Text("保存图片")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(.gray)
                    }
                    
                    Button(action: {
                        // 扫描二维码
                    }) {
                        VStack {
                            Image(systemName: "qrcode.viewfinder")
                                .font(.system(size: 24))
                            Text("扫一扫")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 40)
            }
            .navigationTitle("我的二维码")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

/// 编辑个人资料视图
struct EditProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var signature: String
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        _name = State(initialValue: viewModel.currentUser.name)
        _signature = State(initialValue: viewModel.currentUser.signature)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    HStack {
                        Text("头像")
                        Spacer()
                        Image(systemName: viewModel.currentUser.avatar)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    
                    HStack {
                        Text("昵称")
                        TextField("请输入昵称", text: $name)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("微信号")
                        Spacer()
                        Text(viewModel.currentUser.weChatID)
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("个性签名")) {
                    TextEditor(text: $signature)
                        .frame(height: 100)
                }
                
                Section(header: Text("其他信息")) {
                    HStack {
                        Text("地区")
                        Spacer()
                        Text(viewModel.currentUser.region ?? "未设置")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("性别")
                        Spacer()
                        Text("未设置")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("个人信息")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        viewModel.updateProfile(name: name, signature: signature)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

/// 设置视图
struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var soundEnabled = true
    @State private var vibrationEnabled = true
    
    var body: some View {
        List {
            Section(header: Text("账号设置")) {
                NavigationLink(destination: Text("账号与安全")) {
                    Text("账号与安全")
                }
                
                NavigationLink(destination: Text("新消息通知")) {
                    Text("新消息通知")
                }
                
                NavigationLink(destination: Text("隐私")) {
                    Text("隐私")
                }
            }
            
            Section(header: Text("通用")) {
                Toggle("消息通知", isOn: $notificationsEnabled)
                Toggle("声音", isOn: $soundEnabled)
                Toggle("振动", isOn: $vibrationEnabled)
                
                NavigationLink(destination: Text("聊天")) {
                    Text("聊天")
                }
                
                NavigationLink(destination: Text("通用")) {
                    Text("通用")
                }
            }
            
            Section(header: Text("其他")) {
                NavigationLink(destination: Text("帮助与反馈")) {
                    Text("帮助与反馈")
                }
                
                NavigationLink(destination: Text("关于微信")) {
                    Text("关于微信")
                }
            }
            
            Section {
                Button(action: {
                    // 退出登录
                }) {
                    Text("退出登录")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .navigationTitle("设置")
    }
}

#Preview {
    ProfileView()
}
