//
//  AuthView.swift
//  NavruzHackaton
//
//  Created by Muhammadjon Madaminov on 18/03/25.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import _AuthenticationServices_SwiftUI


struct AuthView: View {
    @StateObject private var vm = AuthViewModel()
    @AppStorage("isAuthed") private var isAuthed: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Image("authImage")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.main.bounds.height/3)
                    .ignoresSafeArea(edges: .top)
                
                Spacer()
            }
            
            VStack() {
                Spacer()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Let's")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .fontDesign(.rounded)
                        
                        
                        Text("GoGreen")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .fontDesign(.rounded)
                            .foregroundStyle(Color.accentColor)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 30)
                    
                    Spacer()
                    
                    SignInWithAppleButton(.signIn, onRequest: { request in
                        
                    }, onCompletion: { result in
                        
                    })
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .padding()
                    .signInWithAppleButtonStyle(.white)
                    

                    GoogleSignInButton(scheme: .dark, style: .wide, state: .normal) {
                        Task {
                            await vm.signInWithGoogleFunc()
                            await MainActor.run {
                                self.isAuthed = true
                            }
                        }
                    }
                    .padding()
                    
                    
                }
                .ignoresSafeArea(edges: .bottom)
                .padding()
                .padding(.bottom, 100)
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height * 0.575)
                .background(Color(uiColor: UIColor.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 30))
            }
        }
    }
}

#Preview {
    AuthView()
}
