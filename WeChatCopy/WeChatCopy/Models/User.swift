//
//  User.swift
//  WeChatCopy
//
//  Created by admin on 2025/11/3.
//

import Foundation
import SwiftUI

/// 用户模型
struct User: Identifiable, Codable {
    let id: String
    var name: String
    var avatar: String // 头像图片名称或URL
    var signature: String // 个性签名
    var weChatID: String // 微信号
    var qrCode: String? // 二维码
    var phoneNumber: String?
    var region: String? // 地区
    
    init(id: String = UUID().uuidString,
         name: String,
         avatar: String,
         signature: String = "",
         weChatID: String,
         qrCode: String? = nil,
         phoneNumber: String? = nil,
         region: String? = nil) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.signature = signature
        self.weChatID = weChatID
        self.qrCode = qrCode
        self.phoneNumber = phoneNumber
        self.region = region
    }
}

// MARK: - 示例数据
extension User {
    static let currentUser = User(
        name: "我",
        avatar: "person.circle.fill",
        signature: "保持微笑，继续前行",
        weChatID: "wx_123456"
    )
    
    static let sampleUsers: [User] = [
        User(name: "张三", avatar: "person.fill", signature: "忙碌中...", weChatID: "zhangsan"),
        User(name: "李四", avatar: "person.fill", signature: "今天天气不错", weChatID: "lisi"),
        User(name: "王五", avatar: "person.fill", signature: "努力工作", weChatID: "wangwu"),
        User(name: "赵六", avatar: "person.fill", signature: "学习使我快乐", weChatID: "zhaoliu"),
        User(name: "钱七", avatar: "person.fill", signature: "代码改变世界", weChatID: "qianqi"),
        User(name: "孙八", avatar: "person.fill", signature: "健身打卡", weChatID: "sunba"),
        User(name: "周九", avatar: "person.fill", signature: "读书笔记", weChatID: "zhoujiu"),
        User(name: "吴十", avatar: "person.fill", signature: "旅行爱好者", weChatID: "wushi")
    ]
}
