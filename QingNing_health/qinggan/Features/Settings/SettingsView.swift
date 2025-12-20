import SwiftUI

struct SettingsView: View {
    @StateObject var vm = SettingsViewModel()
    @State var apiKeyInput: String = ""
    @State var targetWeightText: String = ""
    @State var calorieTargetText: String = ""
    @State var heightText: String = ""
    @State private var showTargetSheet = false
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Button(action: { syncTargetFields(); showTargetSheet = true }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(LinearGradient(colors: [AppTheme.brand, AppTheme.brand.opacity(0.85)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        HStack(spacing: 16) {
                            ZStack {
                                Circle().fill(Color.white).frame(width: 64, height: 64)
                                Image(systemName: "person.fill").foregroundColor(AppTheme.brand)
                            }
                            VStack(alignment: .leading, spacing: 8) {
                                Text("个人目标").foregroundColor(.white).font(.title2).fontWeight(.semibold)
                                Text("当前体重: \(vm.currentWeight.map{ String(format: "%.1f", $0) } ?? "-") kg  目标体重: \(vm.config.targetWeight.map{ String(format: "%.1f", $0) } ?? "-") kg  需要减: \(vm.weightLost.map{ String(format: "%.1f", $0) } ?? "-") kg  BMI: \(vm.bmi.map{ String(format: "%.1f", $0) } ?? "-")")
                                    .foregroundColor(.white.opacity(0.95)).font(.title3)
                                Text("点击调整目标与身高/步数").foregroundColor(.white.opacity(0.9)).font(.subheadline)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.white).font(.headline)
                        }
                        .padding(20)
                    }
                }
                .buttonStyle(.plain)
                .frame(height: 150)
                Card {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("AI 配置").font(.headline)
                        HStack { Text("API Host").frame(width: 100, alignment: .leading); TextField("https://api.example.com", text: $vm.config.host).textFieldStyle(.roundedBorder).textInputAutocapitalization(.never).disableAutocorrection(true).keyboardType(.URL) }
                        HStack { Text("API Key").frame(width: 100, alignment: .leading); SecureField("sk-...", text: $apiKeyInput).textFieldStyle(.roundedBorder) }
                        HStack { Text("文本模型").frame(width: 100, alignment: .leading); TextField("gpt-4", text: $vm.config.textModel).textFieldStyle(.roundedBorder).textInputAutocapitalization(.never).disableAutocorrection(true) }
                        HStack { Text("视觉模型").frame(width: 100, alignment: .leading); TextField("gpt-4-vision", text: $vm.config.visionModel).textFieldStyle(.roundedBorder).textInputAutocapitalization(.never).disableAutocorrection(true) }
                    }
                }
                Card {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("隐私与权限").font(.headline)
                        Toggle("允许上传食物照片", isOn: $vm.config.allowVision)
                        Toggle("允许发送历史统计", isOn: $vm.config.allowSummary)
                        Text("你的 API Key 仅存储在本地设备，不会上传到任何服务器。").foregroundColor(.secondary).font(.footnote)
                    }
                }
                Card {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("外观").font(.headline)
                        Picker("外观", selection: Binding(get: { vm.config.appearance ?? "system" }, set: { vm.config.appearance = $0 })) {
                            Text("跟随系统").tag("system")
                            Text("浅色").tag("light")
                            Text("深色").tag("dark")
                        }.pickerStyle(.segmented)
                        Text("你可以在此切换 App 的浅色/深色模式，或跟随系统设置。").foregroundColor(.secondary).font(.footnote)
                    }
                }
                Card {
                    VStack(spacing: 12) {
                        PrimaryButton(title: "保存Key") { vm.updateKeychain(apiKey: apiKeyInput); apiKeyInput = "" }
                        SecondaryButton(title: "保存配置") {
                            if let tw = Double(targetWeightText) { vm.config.targetWeight = tw }
                            if let ct = Int(calorieTargetText) { vm.config.dailyCalorieTarget = ct }
                            vm.save()
                            vm.loadData(context: viewContext)
                        }
                        if !vm.apiKeyMasked.isEmpty {
                            Text("API Key: \(vm.apiKeyMasked)").font(.footnote).foregroundColor(.secondary)
                        }
                    }
                }
            }.padding(16)
        }
        .task {
            vm.load()
            vm.loadData(context: viewContext)
            targetWeightText = vm.config.targetWeight.map { String(format: "%.1f", $0) } ?? ""
            calorieTargetText = String(vm.config.dailyCalorieTarget)
            heightText = vm.config.heightCm.map { String(format: "%.0f", $0) } ?? ""
        }
        .onChange(of: vm.config.appearance) { _ in vm.save() }
        .sheet(isPresented: $showTargetSheet) {
            TargetSettingsView(
                targetWeightText: $targetWeightText,
                calorieTargetText: $calorieTargetText,
                heightText: $heightText,
                dailyStepGoal: $vm.config.dailyStepGoal,
                onSave: {
                    if let tw = Double(targetWeightText) { vm.config.targetWeight = tw }
                    if let ct = Int(calorieTargetText) { vm.config.dailyCalorieTarget = ct }
                    vm.config.heightCm = Double(heightText.replacingOccurrences(of: ",", with: ".").trimmingCharacters(in: .whitespacesAndNewlines))
                    vm.save()
                    vm.loadData(context: viewContext)
                    showTargetSheet = false
                },
                onCancel: { showTargetSheet = false }
            )
        }
    }
}

private extension SettingsView {
    func syncTargetFields() {
        targetWeightText = vm.config.targetWeight.map { String(format: "%.1f", $0) } ?? ""
        calorieTargetText = String(vm.config.dailyCalorieTarget)
        heightText = vm.config.heightCm.map { String(format: "%.0f", $0) } ?? ""
    }
}

struct TargetSettingsView: View {
    @Binding var targetWeightText: String
    @Binding var calorieTargetText: String
    @Binding var heightText: String
    @Binding var dailyStepGoal: Int
    let onSave: () -> Void
    let onCancel: () -> Void
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("目标")) {
                    TextField("目标体重 (kg)", text: $targetWeightText)
                        .keyboardType(.decimalPad)
                    TextField("每日热量 (kcal)", text: $calorieTargetText)
                        .keyboardType(.numberPad)
                    Stepper("每日步数目标: \(dailyStepGoal)", value: $dailyStepGoal, in: 1000...30000, step: 100)
                }
                Section(header: Text("身体参数")) {
                    TextField("身高 (cm)", text: $heightText)
                        .keyboardType(.decimalPad)
                    Text("用于计算 BMI，帮助给出更精准的建议").font(.footnote).foregroundColor(.secondary)
                }
            }
            .navigationTitle("目标设置")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("取消", action: onCancel) }
                ToolbarItem(placement: .confirmationAction) { Button("保存", action: onSave) }
            }
        }
    }
}
