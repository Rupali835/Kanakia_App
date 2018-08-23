
//
//  AppDelegate.swift
//  MMSApp
//
//  Created by user on 02/02/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate
{
    
    var window: UIWindow?
    var FCMToken: String = ""
    var NotificationCnt = Int(0)
    var categoryIdentifier : String = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        FirebaseApp.configure()
        NotificationCnt = 0
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            
                   Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        self.window!.backgroundColor = UIColor.clear
        
        UINavigationBar.appearance().barTintColor = UIColor(hex: 0x4CAF50, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
       
        let result = UserDefaults.standard.value(forKey: "userdata")
        if result != nil {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
            let yourViewController: HomeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            let navigationController = self.window?.rootViewController as! UINavigationController
            navigationController.setViewControllers([yourViewController], animated: true)
        }
        
        registerForPushNotifications()
        
        return true
        
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String)
    {
        print("Firebase registration token: \(fcmToken)")
      self.FCMToken = fcmToken
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication)
    {
          NotificationCnt += 1
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
       UIApplication.shared.applicationIconBadgeNumber = 0
        NotificationCnt = 0
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        NotificationCnt = 0
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MMSApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func instance() ->  AppDelegate{
        
        return AppDelegate()
    }
    
    func showAlert(strTitle:String,strMessage:String)
    {
        let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: .alert)
        let add = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(add)
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        let userInfo = notification.request.content.userInfo
        
        print(userInfo)
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        print(userInfo)
        
        let navigationController = self.window?.rootViewController as! UINavigationController
        
        let lcUserDefaults = UserDefaults.standard.object(forKey: "msg") as! [String: Any]
       
        let Up_id = lcUserDefaults["up_id"] as! String
        let upType = lcUserDefaults["up_type"] as! String
        
        guard

            let cat = (userInfo[AnyHashable("category")] as? String),
            
            let aps = userInfo[AnyHashable("aps")] as? NSDictionary,
            
            let alert = aps["alert"] as? NSDictionary,
            let body = alert["body"] as? String,
            let title = alert["title"] as? String,
            let subtitle = alert["subtitle"] as? String,
            let sound = aps["sound"] as? String
            
     //       self.categoryIdentifier = cat
            else {
                // handle any error here
                return
        }
            print("Category", self.categoryIdentifier)
        switch title
        {
        case "New Meeting", "Today's Meeting" :
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MyMeetingsVc") as! MyMeetingsVc
                navigationController.pushViewController(vc, animated: true);
                break

        case  "New Other Achievements", "Other Achievements Approved", "Other Achievements Rejected"  :
              let storyboard = UIStoryboard(name: "Pms", bundle: nil)
               let vc = storyboard.instantiateViewController(withIdentifier: "AchivementList") as! AchivementList
              vc.setupData(cId: Up_id)
              navigationController.pushViewController(vc, animated: true)
            break

        case "New Feedback", "Feedback Approved", "Feedback Rejected" :
            let storyboard = UIStoryboard(name: "Pms", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "GetFeedbackVc") as! GetFeedbackVc
         vc.setupData(cId: Up_id)
          navigationController.pushViewController(vc, animated: true)
            break

        case "New Training Needs", "Training Needs Approved", "Training Needs Rejected" :
            let storyboard = UIStoryboard(name: "Pms", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TrainListVc") as! TrainListVc
            vc.setupData(cId: Up_id)
            navigationController.pushViewController(vc, animated: true)
            break

        case "New Highlight", "Highlight Approved", "Highlight Rejected", "New Lowlight", "Lowlight Approved", "Lowlight Rejected" :
            let storyboard = UIStoryboard(name: "Pms", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HighLowlightsVc") as! HighLowlightsVc
            vc.setId(Kk_id: subtitle, upId: Up_id)
            navigationController.pushViewController(vc, animated: true)
           break

        case "New Approval/Rejection" :
            let storyboard = UIStoryboard(name: "Pms", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PendingApprovalVc") as! PendingApprovalVc
            
            navigationController.pushViewController(vc, animated: true)
            break

        case "KPI Target Updated", "KPI Target Approved", "KPI Target Rejected" :
            let storyboard = UIStoryboard(name: "Pms", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "KPI_ListVc") as! KPI_ListVc
            vc.setKid(Kk_id: subtitle, Kname: sound)
            navigationController.pushViewController(vc, animated: true)
            break

        case "New Visitor" :
            let Details = VisitorManagementVC.init(nibName: "VisitorManagementVC", bundle: nil)
            navigationController.pushViewController(Details, animated: true)
            break

        case "Feedback" :
              let storyboard = UIStoryboard(name: "Pms", bundle: nil)
              let vc = storyboard.instantiateViewController(withIdentifier: "GetFeedbackVc") as! GetFeedbackVc
              vc.setupData(cId: subtitle)
           //   navigationController.title = sound
             //   UINavigationItem.init(title: sound)
              navigationController.navigationItem.title = sound
              
              navigationController.pushViewController(vc, animated: true)
            break
            
        case "Training Needs" :
            let storyboard = UIStoryboard(name: "Pms", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TrainListVc") as! TrainListVc
            vc.setupData(cId: subtitle)
        //    navigationController.title = sound
            navigationController.pushViewController(vc, animated: true)
            break
            
        case "Other Achievements" :
            let storyboard = UIStoryboard(name: "Pms", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AchivementList") as! AchivementList
            vc.setupData(cId: subtitle)
            navigationController.title = sound
            navigationController.pushViewController(vc, animated: true)
            break
          
        case "Lowlight", "Highlight" :
            let storyboard = UIStoryboard(name: "Pms", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HighLowlightsVc") as! HighLowlightsVc
            vc.setId(Kk_id: subtitle, upId: Up_id)
            navigationController.pushViewController(vc, animated: true)
            break
            
        case "KPI Target" :
            let storyboard = UIStoryboard(name: "Pms", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "KPI_ListVc") as! KPI_ListVc
          
            vc.setKid(Kk_id: subtitle, Kname: sound)
            navigationController.pushViewController(vc, animated: true)
            break
            
            
        default:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            navigationController.pushViewController(vc, animated: true)
        
        }
       
        completionHandler()
    }


    
    func application(received remoteMessage: MessagingRemoteMessage)
    {
        print(remoteMessage.appData)
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        if let refreshToken = InstanceID.instanceID().token()
        {
            print("InstanceID token: \(refreshToken)")
            UserDefaults.standard.set(refreshToken, forKey: "data")
        }
        
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    

    
    func getNotificationSettings()
    {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
          //  UIApplication.shared.registerForRemoteNotifications()
        }
    }
 
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            
        let AcceptAction = UNNotificationAction(identifier: "viewActionIdentifier", title: "Reject", options: [])
            
            let CategoryIdentifier = UNNotificationCategory(identifier: self.categoryIdentifier, actions: [AcceptAction],
                intentIdentifiers: [], options: [])
           
            UNUserNotificationCenter.current().setNotificationCategories([CategoryIdentifier])
            
               self.getNotificationSettings()
        }
    }

    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // Print full message.
        print("message recived")
        NotificationCnt += 1
        UIApplication.shared.applicationIconBadgeNumber = NotificationCnt
        print(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
    }

    
}



