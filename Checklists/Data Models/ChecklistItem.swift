//
//  ChecklistItem.swift
//  Checklists
//
//  Created by user206341 on 10/18/21.
//

import Foundation
import UserNotifications

class ChecklistItem :NSObject, Codable{
    var text = ""
    var checked = false
    
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1
    
    override init() {
        super.init()
        
        // notification ID always the same with checklist item ID
        itemID = DataModel.nextChecklistItemID()
    }
    
    func scheduleNotification(){
        removeNotification()
        
        if shouldRemind && dueDate > Date() {
            print("We should schedule a notification")
            
            // 1
            let center = UNUserNotificationCenter.current()
            
            // 2
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = .default

            // 3.2
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: dueDate)
            // 3.1
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            // 4
            // note: change itemID to a string
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            
            // 5
            center.add(request)
            
            print("Scheduled: \(request) for itemID: \(itemID)")
        }
    }
    
    func scheduleNotification(after seconds: Int) {
        if shouldRemind {
            let center = UNUserNotificationCenter.current()
            
            // build notification
            let content = UNMutableNotificationContent()
            content.title = "Awsome"
            content.body = "You've done a great job!"
            content.sound = .default
    //        content.sound = UNNotificationSound.default   // the same with use .default only

            // time interval notification
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)    // TimeInterval is alias for Double
            
            let request = UNNotificationRequest(identifier: "My Notification", content: content, trigger: trigger)
            center.add(request)

        }
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    
    // is called when the object be deleted
    // why there's no override? maybe only because there's no super.deinit
    deinit {
        removeNotification()
    }
}
