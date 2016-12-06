//
//  AppDelegate.swift
//  001 iOS10本地通知演示（Swift版本）
//
//  Created by 曾文志 on 06/12/2016.
//  Copyright © 2016 Lebron. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // 请求用户授权
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("granted")
            }
            if error != nil {
                print(error!)
            }
        }
        
        // 创建通用类别
        let generalCategory = UNNotificationCategory(identifier: Identifiers.GeneralCategory, actions: [], intentIdentifiers: [], options: .customDismissAction)
        
        // 创建TIMER_EXPIRED类别的自定义行为
        let snoozeAction = UNNotificationAction(identifier: Identifiers.SnoozeAction, title: "Snooze", options: UNNotificationActionOptions(rawValue: 0))
        let stopAction = UNNotificationAction(identifier: Identifiers.StopAction, title: "Stop", options: .foreground)
        let expiredCategory = UNNotificationCategory(identifier: Identifiers.ExpriedTimerCategory, actions: [snoozeAction, stopAction], intentIdentifiers: [], options: UNNotificationCategoryOptions(rawValue: 0))
        
        // 注册通知类别
        center.setNotificationCategories([generalCategory, expiredCategory])
        
        // 配置本地通知
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = Identifiers.ExpriedTimerCategory
        //        content.categoryIdentifier = Identifiers.GeneralCategory
        content.sound = UNNotificationSound.default()
        content.title = NSString.localizedUserNotificationString(forKey: "Wake up!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Raise and shine! It's morning time!", arguments: nil)
        
        // 配置上午7点起床的trigger
        var dateInfo = DateComponents()
        dateInfo.hour = 21
        dateInfo.minute = 52
        //        dateInfo.second = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        
        // 创建请求对象
        let request = UNNotificationRequest(identifier: "MorningAlarm", content: content, trigger: trigger)
        center.add(request) { (error: Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    // MARK: UNUserNotificationCenter 代理
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("当接收到通知时，应用在前台运行(当应用在后台或者没有运行的时候，系统不会调用这个方法)")
        completionHandler(UNNotificationPresentationOptions.sound)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // 处理自定义行为
        if response.notification.request.content.categoryIdentifier == Identifiers.ExpriedTimerCategory {
            if response.actionIdentifier == "SNOOZE_ACTION" {
                print("取消之前那个定时器，并创建一个新的计时器")
            }
            else if response.actionIdentifier == "STOP_ACTION" {
                print("取消之前的定时器")
            }
        }
        
        // 处理系统默认的行为
        if response.actionIdentifier == UNNotificationDismissActionIdentifier {
            print("用户没有选择其他行为，而是直接移除通知")
        }
        else if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            print("用户启动了应用")
        }
    }
    
    struct Identifiers {
        static let GeneralCategory = "GENERAL"
        static let ExpriedTimerCategory = "TIMER_EXPIRED"
        static let SnoozeAction = "SNOOZE_ACTION"
        static let StopAction = "STOP_ACTION"
        static let CancelAction = "CANCEL_ACTION"
    }
}
