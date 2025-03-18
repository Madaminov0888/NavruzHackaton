//
//  NavruzHackatonApp.swift
//  NavruzHackaton
//
//  Created by Muhammadjon Madaminov on 18/03/25.
//

//import SwiftUI
//
//@main
//struct NavruzHackatonApp: App {
//    var body: some Scene {
//        WindowGroup {
//            MainTabBar()
//        }
//    }
//}


import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      print("Firebase configured")
    return true
  }
}

@main
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
        MainTabBar()
            .preferredColorScheme(.dark)
    }
  }
}
