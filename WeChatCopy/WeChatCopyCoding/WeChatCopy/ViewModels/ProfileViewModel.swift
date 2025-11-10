//
//  ProfileViewModel.swift
//  WeChatCopy
//
//  Created by admin on 2025/11/3.
//

import Foundation
import Combine

/// 个人资料ViewModel
class ProfileViewModel: ObservableObject {
    @Published var currentUser: User
    @Published var showQRCode: Bool = false
    @Published var showSettings: Bool = false
    @Published var showEditProfile: Bool = false
    
    private var dataService = DataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.currentUser = dataService.currentUser
        
        dataService.$currentUser
            .assign(to: &$currentUser)
    }
    
    func updateProfile(name: String? = nil, signature: String? = nil) {
        var updatedUser = currentUser
        
        if let name = name {
            updatedUser.name = name
        }
        
        if let signature = signature {
            updatedUser.signature = signature
        }
        
        dataService.updateCurrentUser(updatedUser)
    }
}
