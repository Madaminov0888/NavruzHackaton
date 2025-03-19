//
//  ProfileViewModel.swift
//  NavruzHackaton
//
//  Created by Muhammadjon Madaminov on 19/03/25.
//

import Foundation


final class ProfileViewModel: ObservableObject {
    @Published var user: UserModel? = nil {
        didSet {
            getUser()
        }
    }
    
    @Published var name: String = ""
    @Published var surname: String = ""
    
    func fetchUser() {
        do {
            let user = try AuthManager.shared.getAuthedUser()
            self.user = user
        } catch {
            print(#function, error)
        }
    }
    
    func getUser() {
        guard let user else { return }
        let splitName = splitName(user.name ?? "")
        name = splitName.name
        surname = splitName.surname ?? ""
    }
    
    func splitName(_ fullName: String) -> (name: String, surname: String?) {
        let components = fullName.split(separator: " ", maxSplits: 1).map(String.init)
        if components.count == 2 {
            return (name: components[0], surname: components[1])
        } else {
            return (name: fullName, surname: nil)
        }
    }
}
