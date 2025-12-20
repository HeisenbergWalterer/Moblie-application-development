import SwiftUI

struct Card<Content: View>: View {
    let content: () -> Content
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        content()
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(AppTheme.cardBorder(for: colorScheme), lineWidth: 1.2))
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.2 : 0.03), radius: 4, x: 0, y: 2)
    }
}
