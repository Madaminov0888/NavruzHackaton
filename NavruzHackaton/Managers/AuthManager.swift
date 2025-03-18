//
//  AuthManager.swift
//  NavruzHackaton
//
//  Created by Muhammadjon Madaminov on 18/03/25.
//



import Foundation
import Firebase
import FirebaseAuth



final class AuthManager {
    
    static let shared = AuthManager()
    private init() { }
    
    func deleteUser() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.userAuthenticationRequired)
        }
        
        try await user.delete()
    }
    
    
    @discardableResult
    func getAuthedUser() throws -> UserModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        return UserModel(user: user)
    }
    
    func logOut() throws {
        try Auth.auth().signOut()
    }
    
    
    //sign in-up with google
    func signInWithCredential(credential: AuthCredential) async throws -> UserModel {
        let data = try await Auth.auth().signIn(with: credential)
        return UserModel(user: data.user)
    }
    
    
    @discardableResult
    func signInWithGoogle(tokens: TokensModel) async throws -> UserModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accesToken)
        return try await signInWithCredential(credential: credential)
    }
}
