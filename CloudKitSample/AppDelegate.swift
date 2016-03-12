//
//  AppDelegate.swift
//  CloudKitSample
//
//  Created by 鈴木 航 on 2016/03/12.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        print(__FUNCTION__)
        //TODO
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print(__FUNCTION__)
        
        registCloudKitSubscription(deviceToken)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        print(__FUNCTION__)
        
        let notificationInfo = userInfo as! [String : NSObject]
        let myCKNotification = CKNotification(fromRemoteNotificationDictionary: notificationInfo)
        if myCKNotification.notificationType == .Query {
            
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(__FUNCTION__)
        //TODO
    }
    
    func registerNotifications(application: UIApplication) {
        let userNotificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
    }
    
    func registCloudKitSubscription(deviceToken: NSData) {
        print(__FUNCTION__)
        print("deviceToken : \(deviceToken)")
        
        // 条件の指定
        let predicate = NSPredicate(format: "SampleCloudKitPush == 'SampleCloudKitPush'")
        
        // Subscription の作成
        let subscription = CKSubscription(recordType: "SampleCloudKitPush", predicate: predicate, options: [.FiresOnRecordCreation, .FiresOnRecordDeletion, .FiresOnRecordUpdate])
        subscription.notificationInfo = CKNotificationInfo()
        subscription.notificationInfo!.alertActionLocalizationKey = "SampleCloudKitPush"
        subscription.notificationInfo!.alertBody = "SampleCloudKitPush"
        
        // Subscription の登録
        let db = CKContainer.defaultContainer().publicCloudDatabase
        db.saveSubscription(subscription, completionHandler: {
            subscription, error in
            if error != nil {
                // エラー
                print("error : \(error)")
            } else {
                // 登録完了
                print("subscription : \(subscription)")
            }
        })
    }
}

