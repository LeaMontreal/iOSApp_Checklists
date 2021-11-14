//
//  AppDelegate.swift
//  Checklists
//
//  Created by user206341 on 10/18/21.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let center = UNUserNotificationCenter.current()
        // register as the delegate of UserNotificationCenter, in order to deal with the posted notification when the app is running; when the app is background, simply pop-up a standard notification
        center.delegate = self

        // move to proper file, here for test only
//        // Notification authorization
//        center.requestAuthorization(options: [.alert, .sound], completionHandler:
//                                        {granted, error in
//                                        if granted {
//                                            print("We have permission")
//                                        }else {
//                                            print("Permission denied")
//                                        }}
//        )
//
//        // build notification
//        let content = UNMutableNotificationContent()
//        content.title = "Awsome"
//        content.body = "You've done a great job!"
//        content.sound = .default
////        content.sound = UNNotificationSound.default   // the same with use .default only
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
//        let request = UNNotificationRequest(identifier: "My Notification", content: content, trigger: trigger)
//        center.add(request)
                
        return true
    }

    // MARK: - User Notification Center Delegates
//  note: this is the wrong func
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
//    }
    
    // is called when the local notification is posted and the app is running
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Received local notification \(notification)")
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

