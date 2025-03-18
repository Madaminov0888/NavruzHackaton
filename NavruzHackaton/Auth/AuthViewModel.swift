//
//  AuthViewModel.swift
//  NavruzHackaton
//
//  Created by Muhammadjon Madaminov on 18/03/25.
//

import SwiftUI


final class AuthViewModel: ObservableObject {
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    //sign in with google
    func signInWithGoogleFunc() async {
        do {
            let tokens = try await GoogleSignInHelper().singIn()
            let user = try await AuthManager.shared.signInWithGoogle(tokens: tokens)
            try await networkManager.postData(for: .postUser, data: user)
        } catch {
            print(#function, error)
        }
    }
}
