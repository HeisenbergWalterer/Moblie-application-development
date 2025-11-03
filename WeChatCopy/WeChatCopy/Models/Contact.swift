//
//  Contact.swift
//  WeChatCopy
//
//  Created by admin on 2025/11/3.
//

import Foundation

/// 联系人模型
struct Contact: Identifiable, Codable {
    let id: String
    let userID: String      // 关联的用户ID
    var remark: String?     // 备注名
    var tags: [String]      // 标签
    var isFavorite: Bool    // 是否星标好友
    var addTime: Date       // 添加时间
    
    init(id: String = UUID().uuidString,
         userID: String,
         remark: String? = nil,
         tags: [String] = [],
         isFavorite: Bool = false,
         addTime: Date = Date()) {
        self.id = id
        self.userID = userID
        self.remark = remark
        self.tags = tags
        self.isFavorite = isFavorite
        self.addTime = addTime
    }
}

/// 联系人分组（按字母）
struct ContactSection: Identifiable {
    let id = UUID()
    let letter: String
    var contacts: [Contact]
}

// MARK: - 示例数据
extension Contact {
    static func createSampleContacts(from users: [User]) -> [Contact] {
        return users.map { user in
            Contact(
                userID: user.id,
                remark: nil,
                tags: [],
                isFavorite: Bool.random(),
                addTime: Date().addingTimeInterval(TimeInterval(-86400 * Int.random(in: 1...365)))
            )
        }
    }
}
