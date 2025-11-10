//
//  DiscoverView.swift
//  WeChatCopy
//
//  Created by admin on 2025/11/3.
//

import SwiftUI

/// 发现视图
struct DiscoverView: View {
    var body: some View {
        NavigationView {
            List {
                // 朋友圈
                Section {
                    NavigationLink(destination: MomentsView()) {
                        HStack(spacing: 12) {
                            Image(systemName: "camera.circle.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 28))
                            Text("朋友圈")
                                .font(.system(size: 16))
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                // 其他功能
                Section {
                    NavigationLink(destination: Text("扫一扫")) {
                        HStack(spacing: 12) {
                            Image(systemName: "qrcode.viewfinder")
                                .foregroundColor(.orange)
                                .font(.system(size: 28))
                            Text("扫一扫")
                                .font(.system(size: 16))
                        }
                        .padding(.vertical, 4)
                    }
                    
                    NavigationLink(destination: Text("摇一摇")) {
                        HStack(spacing: 12) {
                            Image(systemName: "apps.iphone")
                                .foregroundColor(.blue)
                                .font(.system(size: 28))
                            Text("摇一摇")
                                .font(.system(size: 16))
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section {
                    NavigationLink(destination: Text("看一看")) {
                        HStack(spacing: 12) {
                            Image(systemName: "eye.circle.fill")
                                .foregroundColor(.purple)
                                .font(.system(size: 28))
                            Text("看一看")
                                .font(.system(size: 16))
                        }
                        .padding(.vertical, 4)
                    }
                    
                    NavigationLink(destination: Text("搜一搜")) {
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass.circle.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 28))
                            Text("搜一搜")
                                .font(.system(size: 16))
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section {
                    NavigationLink(destination: Text("直播和附近")) {
                        HStack(spacing: 12) {
                            Image(systemName: "video.circle.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 28))
                            Text("直播和附近")
                                .font(.system(size: 16))
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section {
                    NavigationLink(destination: Text("购物")) {
                        HStack(spacing: 12) {
                            Image(systemName: "cart.circle.fill")
                                .foregroundColor(.orange)
                                .font(.system(size: 28))
                            Text("购物")
                                .font(.system(size: 16))
                        }
                        .padding(.vertical, 4)
                    }
                    
                    NavigationLink(destination: Text("游戏")) {
                        HStack(spacing: 12) {
                            Image(systemName: "gamecontroller.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 28))
                            Text("游戏")
                                .font(.system(size: 16))
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("发现")
        }
    }
}

/// 朋友圈视图
struct MomentsView: View {
    @StateObject private var viewModel = MomentViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                // 顶部封面
                coverHeader
                
                // 朋友圈动态列表
                ForEach(viewModel.moments) { moment in
                    MomentCardView(moment: moment, viewModel: viewModel)
                        .background(Color.white)
                    
                    Divider()
                        .padding(.leading, 60)
                }
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("朋友圈")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // 发布朋友圈
                }) {
                    Image(systemName: "camera.fill")
                }
            }
        }
        .sheet(isPresented: $viewModel.showCommentInput) {
            CommentInputView(
                commentText: $viewModel.commentText,
                onSubmit: viewModel.submitComment
            )
        }
    }
    
    private var coverHeader: some View {
        ZStack(alignment: .bottomTrailing) {
            // 封面图 - 使用更美观的渐变
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.4, green: 0.6, blue: 0.9),
                    Color(red: 0.6, green: 0.4, blue: 0.8),
                    Color(red: 0.8, green: 0.5, blue: 0.7)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 280)
            .overlay(
                // 添加半透明遮罩增加层次感
                Color.black.opacity(0.1)
            )
            
            // 当前用户头像和名称
            HStack(spacing: 12) {
                VStack(alignment: .trailing, spacing: 6) {
                    Text(DataService.shared.currentUser.name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    
                    if !DataService.shared.currentUser.signature.isEmpty {
                        Text(DataService.shared.currentUser.signature)
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.9))
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    }
                }
                
                Image(systemName: DataService.shared.currentUser.avatar)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.white)
                    .background(Color.white.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.5), lineWidth: 2)
                    )
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
            }
            .padding(20)
        }
    }
}

/// 朋友圈卡片视图
struct MomentCardView: View {
    let moment: Moment
    @ObservedObject var viewModel: MomentViewModel
    
    var user: User? {
        viewModel.getUser(for: moment)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 头部：头像和用户名
            HStack(alignment: .top, spacing: 12) {
                // 头像
                if let user = user {
                    Image(systemName: user.avatar)
                        .resizable()
                        .frame(width: 48, height: 48)
                        .foregroundColor(.white)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                        )
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    // 用户名
                    Text(user?.name ?? "未知用户")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color(red: 0.35, green: 0.55, blue: 0.85))
                    
                    // 文本内容
                    Text(moment.content)
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // 图片九宫格 - 已禁用
                    // if !moment.images.isEmpty {
                    //     ImageGridView(images: moment.images)
                    //         .padding(.top, 6)
                    // }
                    
                    // 位置和时间
                    HStack(spacing: 12) {
                        // 位置
                        if let location = moment.location {
                            HStack(spacing: 4) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 11))
                                Text(location)
                                    .font(.system(size: 13))
                            }
                            .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.9))
                        }
                        
                        // 时间
                        Text(moment.formattedTime)
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 4)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // 点赞和评论区域
            if !moment.likes.isEmpty || !moment.comments.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    // 点赞列表
                    if !moment.likes.isEmpty {
                        HStack(alignment: .top, spacing: 6) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 13))
                            
                            let likeUsers = viewModel.getLikeUsers(for: moment)
                            Text(likeUsers.map { $0.name }.joined(separator: "，"))
                                .font(.system(size: 14))
                                .foregroundColor(Color(red: 0.35, green: 0.55, blue: 0.85))
                        }
                    }
                    
                    if !moment.likes.isEmpty && !moment.comments.isEmpty {
                        Divider()
                    }
                    
                    // 评论列表
                    if !moment.comments.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(moment.comments) { comment in
                                if let commentUser = viewModel.getUser(byID: comment.userID) {
                                    HStack(alignment: .top, spacing: 0) {
                                        Text(commentUser.name)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(Color(red: 0.35, green: 0.55, blue: 0.85))
                                        
                                        if let replyToUserID = comment.replyToUserID,
                                           let replyToUser = viewModel.getUser(byID: replyToUserID) {
                                            Text(" 回复 ")
                                                .font(.system(size: 14))
                                                .foregroundColor(.secondary)
                                            Text(replyToUser.name)
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(Color(red: 0.35, green: 0.55, blue: 0.85))
                                        }
                                        
                                        Text(": \(comment.content)")
                                            .font(.system(size: 14))
                                            .foregroundColor(.primary)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(UIColor.systemGray6))
                )
                .padding(.horizontal, 16)
            }
            
            // 操作按钮（点赞和评论）
            HStack(spacing: 16) {
                Spacer()
                
                Button(action: {
                    viewModel.toggleLike(moment: moment)
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: viewModel.isLikedByCurrentUser(moment: moment) ? "heart.fill" : "heart")
                            .font(.system(size: 13))
                        Text("赞")
                            .font(.system(size: 14))
                    }
                    .foregroundColor(viewModel.isLikedByCurrentUser(moment: moment) ? .red : .gray)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color(UIColor.systemGray6))
                    )
                }
                
                Button(action: {
                    viewModel.showCommentInput(for: moment.id)
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "bubble.right")
                            .font(.system(size: 13))
                        Text("评论")
                            .font(.system(size: 14))
                    }
                    .foregroundColor(.gray)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color(UIColor.systemGray6))
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}

/// 图片九宫格视图
struct ImageGridView: View {
    let images: [String]
    
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 4), count: min(images.count, 3))
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(images.prefix(9), id: \.self) { imageName in
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageSize, height: imageSize)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
        }
    }
    
    private var imageSize: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 24 + 45 + 12 // 左右padding + 头像宽度 + spacing
        let availableWidth = screenWidth - padding
        
        switch images.count {
        case 1:
            return min(availableWidth * 0.6, 200)
        case 2, 4:
            return (availableWidth - 4) / 2
        default:
            return (availableWidth - 8) / 3
        }
    }
}

/// 评论输入视图
struct CommentInputView: View {
    @Binding var commentText: String
    let onSubmit: () -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $commentText)
                    .padding()
                    .frame(height: 150)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding()
                
                Spacer()
            }
            .navigationTitle("写评论")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("发送") {
                        onSubmit()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

#Preview {
    DiscoverView()
}
