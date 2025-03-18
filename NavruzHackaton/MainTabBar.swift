//
//  ContentView.swift
//  NavruzHackaton
//
//  Created by Muhammadjon Madaminov on 18/03/25.
//

import SwiftUI

struct MainTabBar: View {
    @AppStorage("isAuthed") var isAuthed: Bool = false
    @State var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
            if isAuthed {
                CustomTabView(selectedIndex: $selectedTab,
                              centerButton: CenterButton(icon: "plus", backgroundColor: .accent, iconColor: .white, action: {
                    print("plus button pressed")
                })) {
                    TabItemWithView(title: "Home", image: "house", selectedImage: "house.fill") {
                        NavigationStack {
                            HomeView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    
                    TabItemWithView(title: "Profile", image: "person", selectedImage: "person.fill") {
                        NavigationStack {
                            ProfileView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
            } else {
                AuthView()
            }
        }
        .onAppear(perform: {
            let user = try? AuthManager.shared.getAuthedUser()
            if user == nil {
                isAuthed = false
            }
        })
    }
}

#Preview {
    MainTabBar()
}
