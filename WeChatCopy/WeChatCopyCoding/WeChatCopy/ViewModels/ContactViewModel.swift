//
//  ContactViewModel.swift
//  WeChatCopy
//
//  Created by admin on 2025/11/3.
//

import Foundation
import Combine

/// 通讯录ViewModel
class ContactViewModel: ObservableObject {
    @Published var contacts: [Contact] = []
    @Published var searchText: String = ""
    
    private var dataService = DataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        dataService.$contacts
            .assign(to: &$contacts)
    }
    
    var filteredContacts: [Contact] {
        if searchText.isEmpty {
            return contacts
        }
        return contacts.filter { contact in
            guard let user = dataService.getUser(byID: contact.userID) else {
                return false
            }
            let displayName = contact.remark ?? user.name
            return displayName.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var groupedContacts: [ContactSection] {
        let sortedContacts = filteredContacts.sorted { contact1, contact2 in
            let user1 = dataService.getUser(byID: contact1.userID)
            let user2 = dataService.getUser(byID: contact2.userID)
            let name1 = contact1.remark ?? user1?.name ?? ""
            let name2 = contact2.remark ?? user2?.name ?? ""
            return name1 < name2
        }
        
        var sections: [ContactSection] = []
        var currentLetter = ""
        var currentContacts: [Contact] = []
        
        for contact in sortedContacts {
            guard let user = dataService.getUser(byID: contact.userID) else { continue }
            let name = contact.remark ?? user.name
            let firstLetter = String(name.prefix(1)).uppercased()
            
            if firstLetter != currentLetter {
                if !currentContacts.isEmpty {
                    sections.append(ContactSection(letter: currentLetter, contacts: currentContacts))
                }
                currentLetter = firstLetter
                currentContacts = [contact]
            } else {
                currentContacts.append(contact)
            }
        }
        
        if !currentContacts.isEmpty {
            sections.append(ContactSection(letter: currentLetter, contacts: currentContacts))
        }
        
        return sections
    }
    
    var sectionIndexTitles: [String] {
        return groupedContacts.map { $0.letter }
    }
    
    func getUser(for contact: Contact) -> User? {
        return dataService.getUser(byID: contact.userID)
    }
    
    func getDisplayName(for contact: Contact) -> String {
        guard let user = getUser(for: contact) else {
            return ""
        }
        return contact.remark ?? user.name
    }
}
