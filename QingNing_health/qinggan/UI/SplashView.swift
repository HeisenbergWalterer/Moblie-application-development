import SwiftUI

struct SplashView: View {
    @State private var animate = false
    var body: some View {
        ZStack {
            LinearGradient(colors: [AppTheme.brandDark, AppTheme.brand], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            // 背景柔光气泡
            Circle()
                .fill(AppTheme.brandLight.opacity(0.35))
                .frame(width: 320, height: 320)
                .blur(radius: 40)
                .offset(x: -120, y: -140)
            Circle()
                .fill(Color.white.opacity(0.18))
                .frame(width: 260, height: 260)
                .blur(radius: 38)
                .offset(x: 140, y: 160)
            VStack(spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(Color.white.opacity(0.12))
                        .frame(width: 180, height: 180)
                        .overlay(
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .stroke(Color.white.opacity(0.18), lineWidth: 1.2)
                        )
                        .shadow(color: Color.black.opacity(0.18), radius: 18, x: 0, y: 8)
                    Circle()
                        .strokeBorder(Color.white.opacity(0.28), lineWidth: 10)
                        .frame(width: 150, height: 150)
                        .scaleEffect(animate ? 1.04 : 0.96)
                        .opacity(animate ? 0.9 : 0.75)
                        .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: animate)
                    Image(systemName: "heart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 4)
                }
                VStack(spacing: 8) {
                    Text("青柠健康")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    Text("AI 驱动的饮食 · 体重 · 步数教练")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                }
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.1)
                    .padding(.top, 8)
            }
            .padding(.horizontal, 24)
        }
        .onAppear { animate = true }
        .statusBarHidden(true)
    }
}
