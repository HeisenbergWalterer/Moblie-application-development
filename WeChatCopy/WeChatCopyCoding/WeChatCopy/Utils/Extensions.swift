//
//  Extensions.swift
//  WeChatCopy
//
//  Created by admin on 2025/11/3.
//

import SwiftUI

// MARK: - Color Extensions
extension Color {
    static let weChatGreen = Color(red: 0.09, green: 0.72, blue: 0.38)
    static let weChatBackground = Color(red: 0.93, green: 0.93, blue: 0.93)
    static let chatBubbleReceived = Color.white
    static let chatBubbleSent = Color(red: 0.59, green: 0.84, blue: 0.47)
}

// MARK: - View Extensions
extension View {
    /// 添加键盘隐藏功能
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - UIView Extensions
extension UIView {
    var allSubviews: [UIView] {
        var subs = subviews
        for subview in subviews {
            subs.append(contentsOf: subview.allSubviews)
        }
        return subs
    }
}

// MARK: - String Extensions
extension String {
    /// 获取拼音首字母
    var firstPinyinLetter: String {
        let mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let pinyin = String(mutableString)
        return String(pinyin.prefix(1)).uppercased()
    }
}

// MARK: - Date Extensions
extension Date {
    /// 格式化为相对时间
    func relativeTimeString() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
