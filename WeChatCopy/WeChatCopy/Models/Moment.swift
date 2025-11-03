//
//  Moment.swift
//  WeChatCopy
//
//  Created by admin on 2025/11/3.
//

import Foundation

/// 朋友圈动态模型
struct Moment: Identifiable, Codable {
    let id: String
    let userID: String          // 发布者ID
    var content: String         // 文本内容
    var images: [String]        // 图片列表（最多9张）
    var videoURL: String?       // 视频URL
    let timestamp: Date         // 发布时间
    var likes: [String]         // 点赞的用户ID列表
    var comments: [MomentComment] // 评论列表
    var location: String?       // 位置信息
    
    init(id: String = UUID().uuidString,
         userID: String,
         content: String,
         images: [String] = [],
         videoURL: String? = nil,
         timestamp: Date = Date(),
         likes: [String] = [],
         comments: [MomentComment] = [],
         location: String? = nil) {
        self.id = id
        self.userID = userID
        self.content = content
        self.images = images
        self.videoURL = videoURL
        self.timestamp = timestamp
        self.likes = likes
        self.comments = comments
        self.location = location
    }
    
    /// 切换点赞状态
    mutating func toggleLike(userID: String) {
        if let index = likes.firstIndex(of: userID) {
            likes.remove(at: index)
        } else {
            likes.append(userID)
        }
    }
    
    /// 添加评论
    mutating func addComment(_ comment: MomentComment) {
        comments.append(comment)
    }
}

/// 朋友圈评论模型
struct MomentComment: Identifiable, Codable {
    let id: String
    let userID: String          // 评论者ID
    var content: String         // 评论内容
    let timestamp: Date         // 评论时间
    var replyToUserID: String?  // 回复的用户ID（可选）
    
    init(id: String = UUID().uuidString,
         userID: String,
         content: String,
         timestamp: Date = Date(),
         replyToUserID: String? = nil) {
        self.id = id
        self.userID = userID
        self.content = content
        self.timestamp = timestamp
        self.replyToUserID = replyToUserID
    }
}

// MARK: - 时间格式化
extension Moment {
    var formattedTime: String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(timestamp) {
            formatter.dateFormat = "HH:mm"
        } else if calendar.isDateInYesterday(timestamp) {
            return "昨天"
        } else if calendar.isDate(timestamp, equalTo: Date(), toGranularity: .weekOfYear) {
            formatter.dateFormat = "EEEE HH:mm"
        } else {
            formatter.dateFormat = "MM月dd日 HH:mm"
        }
        
        return formatter.string(from: timestamp)
    }
}

// MARK: - 示例数据
extension Moment {
    static func createSampleMoments(users: [User]) -> [Moment] {
        let contents = [
            "今天天气真好！☀️",
            "分享一下今天的美食 🍜",
            "周末出去玩啦～",
            "工作中💪",
            "读完了一本好书📚",
            "健身打卡第30天 💪",
            "夕阳真美 🌅",
            "和朋友们的聚会 🎉",
            "新买的咖啡 ☕️",
            "学习新技能中... 💻"
        ]
        
        let locations = ["北京·朝阳区", "上海·浦东新区", "深圳·南山区", "杭州·西湖区", nil, nil]
        
        var moments: [Moment] = []
        
        for (index, user) in users.enumerated() {
            let imageCount = Int.random(in: 0...9)
            let images = (0..<imageCount).map { _ in "photo.fill" }
            
            let likeCount = Int.random(in: 0...10)
            let likeUserIDs = users.prefix(likeCount).map { $0.id }
            
            let commentCount = Int.random(in: 0...5)
            let comments = (0..<commentCount).map { i in
                MomentComment(
                    userID: users.randomElement()?.id ?? "",
                    content: ["真不错！", "👍", "羡慕", "哈哈哈", "赞同"].randomElement() ?? "👍",
                    timestamp: Date().addingTimeInterval(TimeInterval(-3600 * i))
                )
            }
            
            let moment = Moment(
                userID: user.id,
                content: contents.randomElement() ?? "分享生活",
                images: images,
                videoURL: nil,
                timestamp: Date().addingTimeInterval(TimeInterval(-86400 * index - 3600 * Int.random(in: 0...23))),
                likes: likeUserIDs,
                comments: comments,
                location: locations.randomElement() ?? nil
            )
            
            moments.append(moment)
        }
        
        return moments.sorted(by: { $0.timestamp > $1.timestamp })
    }
}
