//
//  PersonalityTestApp.swift
//  PersonalityTest
//
//  Created by Marius Dumitrascu on 04.01.2021.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("didFinishLaunching")
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken)
        //TODO: handle push notif register error
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
        //TODO: handle push notif device token
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //TODO: add push notification logic
    }
}

@main
struct BaseApp: App {
    
    // inject into SwiftUI life-cycle via adaptor
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var authHandler = AuthHandler.shared
    
    var body: some Scene {
        WindowGroup {
            //if authenticated got to Home View
            if !authHandler.token.isEmpty {
                TabView {
                    QuizzView()
                        .tabItem {
                            Image(systemName: "lasso.sparkles")
                            Text("Quizz Tab")
                        }
                    
                    HomeView()
                        .tabItem {
                            Image(systemName: "phone.fill")
                            Text("Second Tab")
                        }
                }
            } else {
                //else go to Login view
                LoginView()
            }
        }
    }
}
