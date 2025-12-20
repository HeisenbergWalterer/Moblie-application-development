import SwiftUI

struct AppTheme {
    static let brand = Color(hex: 0x22A06B)
    static let brandDark = Color(hex: 0x0F7D52)
    static let brandLight = Color(hex: 0xE6F6EF)
    static let mint = Color(hex: 0x34D399)
    static let cardShadow = Color.black.opacity(0.05)
    
    // 深色模式优化的颜色
    static func cardBorder(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color.white.opacity(0.12) : Color.gray.opacity(0.15)
    }
    
    static func divider(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.2)
    }
    
    static func secondaryBorder(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? AppTheme.brand.opacity(0.4) : AppTheme.brand.opacity(0.25)
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xff) / 255.0
        let g = Double((hex >> 8) & 0xff) / 255.0
        let b = Double(hex & 0xff) / 255.0
        self = Color(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}
