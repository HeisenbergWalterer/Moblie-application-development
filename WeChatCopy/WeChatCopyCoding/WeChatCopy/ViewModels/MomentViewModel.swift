//
//  MomentViewModel.swift
//  WeChatCopy
//
//  Created by admin on 2025/11/3.
//

import Foundation
import Combine

/// 朋友圈ViewModel
class MomentViewModel: ObservableObject {
    @Published var moments: [Moment] = []
    @Published var showCommentInput: Bool = false
    @Published var selectedMomentID: String?
    @Published var commentText: String = ""
    
    private var dataService = DataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        dataService.$moments
            .assign(to: &$moments)
    }
    
    func getUser(for moment: Moment) -> User? {
        return dataService.getUser(byID: moment.userID)
    }
    
    func getUser(byID id: String) -> User? {
        return dataService.getUser(byID: id)
    }
    
    func toggleLike(moment: Moment) {
        dataService.toggleLike(momentID: moment.id)
    }
    
    func isLikedByCurrentUser(moment: Moment) -> Bool {
        return moment.likes.contains(dataService.currentUser.id)
    }
    
    func showCommentInput(for momentID: String) {
        selectedMomentID = momentID
        showCommentInput = true
    }
    
    func submitComment() {
        guard let momentID = selectedMomentID,
              !commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        dataService.addComment(to: momentID, content: commentText)
        commentText = ""
        showCommentInput = false
        selectedMomentID = nil
    }
    
    func getLikeUsers(for moment: Moment) -> [User] {
        return moment.likes.compactMap { dataService.getUser(byID: $0) }
    }
}
