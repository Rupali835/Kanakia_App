
import UIKit
import CoreData
import Firebase
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging
import FirebaseDatabase
import GoogleMaps
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate, CLLocationManagerDelegate
{
    
    var window: UIWindow?
    var FCMToken: String = ""
    var NotificationCnt = Int(0)
    var categoryIdentifier : String = ""
    var ref : DatabaseReference?
    let googleApiKey = "AIzaSyAaRUNibWQZtpnRWBMhZatfj43X7VuL7kQ"
    let cHome : HomeVC! = nil
    var locationManager : CLLocationManager?
    var distanceStatus = Bool(true)
    var traveledDistance: Double = 0
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var PreviouseLocation : CLLocationCoordinate2D!
    var kUserDefaults = UserDefaults.standard
    var TotalDist : Double = 0
    var PreviousLat : Double = 0
    var PreviousLong : Double = 0
    var distToatl : Double = 10
 //   var date = NSDate()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        IQKeyboardManager.shared().isEnabled = true

        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
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
        
        ref = Database.database().reference()
        
      
        GMSServices.provideAPIKey(googleApiKey)
        application.setMinimumBackgroundFetchInterval(5)
        application.isIdleTimerDisabled = false
        
        locationManager?.delegate = self
        registerForPushNotifications()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
            self.startTimer()
        })
        
        let date = Date().addingTimeInterval(10)
        let timer = Timer(fireAt: date, interval: 1, target: self, selector: #selector(startTimer), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String

        print(appVersion)
        

       
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String)
    {
        print("Firebase registration token: \(fcmToken)")
      self.FCMToken = fcmToken
      
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication)
    {
          NotificationCnt += 1
         //startTimer()
        self.goBackground()


    }

    // MARK : LOCATION TRACKING DATA
    
    @objc func startTimer()
    {
        let timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: true)
    }
    
    @objc func updateLocation()
    {
        self.setupLocationManager()
    }
    
    func setupLocationManager()
    {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        self.locationManager?.requestAlwaysAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.startUpdatingLocation()
        locationManager?.activityType = .fitness
        locationManager?.startMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let Tdate = Date()
        let calendar = Calendar.current
        var hour = calendar.component(.hour, from: Tdate)
        var minutes = calendar.component(.minute, from: Tdate)
        
    if (9...19).contains(hour)
    {
         if let result = UserDefaults.standard.value(forKey: "userdata") as? NSDictionary
        {
            
            if result != nil
            {
                let userAccess = UserDefaults.standard.value(forKey: "userTrackAccess") as! String
                
                if userAccess == "1"
                {
                    let userRef = ref?.child((result["user_id"] as? String)!)
                    let dNamem = UIDevice.current.name
                    let dUdid = UIDevice.current.identifierForVendor?.uuidString
                    let str = dNamem + " : " + dUdid!
                    let aString = str
                    let child = userRef?.child(aString).childByAutoId()
                    
                    if distanceStatus == true
                    {
                        distanceStatus = false
                        
                        let lastLocation: CLLocation = locations[locations.count - 1]
                        
                        let clat = String(format: "%.6f", lastLocation.coordinate.latitude)
                        let clong = String(format: "%.6f", lastLocation.coordinate.longitude)
                        
                        let lat = Double(clat)!
                        PreviousLat = lat
                        
                        let long = Double(clong)!
                        PreviousLong = long
                        
                        child?.child("latitude").setValue(PreviousLat)
                        child?.child("longitude").setValue(PreviousLong)
                        traveledDistance = 0
                        TotalDist = 0
                        
                        
                        let currentTimeStamp = Date().toMillis()
                        child?.child("accuracy").setValue(kCLLocationAccuracyBestForNavigation)
                        child?.child("time").setValue(currentTimeStamp)
                        child?.child("distance").setValue(traveledDistance)
                        child?.child("totalDistance").setValue(TotalDist)
                        
                        print("called first location")
                        kUserDefaults.set(PreviousLat, forKey: "latitude")
                        kUserDefaults.set(PreviousLong, forKey: "longitude")
                        
                    }else if  let Location: CLLocation = locations[locations.count - 1]
                    {
                        
                        let LAT = String(format: "%.6f", Location.coordinate.latitude)
                        let LONG = String(format: "%.6f", Location.coordinate.longitude)
                        
                        let lat = Double(LAT)
                        let long = Double(LONG)
                        
                        let latval = kUserDefaults.value(forKey: "latitude") as? Double
                        
                        let longVal = kUserDefaults.value(forKey: "longitude") as? Double
                        
                        startLocation = CLLocation(latitude: latval!, longitude: longVal!)
                        
                        lastLocation = CLLocation(latitude: lat!, longitude: long!)
                        
                        traveledDistance = startLocation.distance(from: lastLocation)
                        
                        if traveledDistance > distToatl
                        {
                            print("traveledDistance= \(traveledDistance)")
                            TotalDist = TotalDist + traveledDistance
                            child?.child("latitude").setValue(lat)
                            child?.child("longitude").setValue(long)
                            let currentTimeStamp = Date().toMillis()
                            child?.child("accuracy").setValue(kCLLocationAccuracyNearestTenMeters)
                            child?.child("time").setValue(currentTimeStamp)
                            child?.child("distance").setValue(traveledDistance)
                            child?.child("totalDistance").setValue(TotalDist)
                            
                            
                            kUserDefaults.set(lat, forKey: "latitude")
                            kUserDefaults.set(long, forKey: "longitude")
                            
                            print("called next location")
                        }
                        
                    }
                    
                }else{
                    return
                }
            }
        }
    }
        
        
        
        
    }
    
    // Below Mehtod will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
        
        if (error as? CLError)?.code == .denied {
            manager.stopUpdatingLocation()
            manager.stopMonitoringSignificantLocationChanges()
        }
    }
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
       UIApplication.shared.applicationIconBadgeNumber = 0
        NotificationCnt = 0
    
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        NotificationCnt = 0
       
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    
        self.saveContext()
        startTimer()
        self.goBackground()

    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "MMSApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
              
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

           
            let aps = userInfo[AnyHashable("aps")] as? NSDictionary,
            
            let alert = aps["alert"] as? NSDictionary,
            let body = alert["body"] as? String,
            let title = alert["title"] as? String,
            let subtitle = alert["subtitle"] as? String,
            let sound = aps["sound"] as? String
            
     
            else {
                // handle any error here
                return
        }
        
        
        
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
              navigationController.navigationItem.title = sound
              
              navigationController.pushViewController(vc, animated: true)
            break
            
        case "Training Needs" :
            let storyboard = UIStoryboard(name: "Pms", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TrainListVc") as! TrainListVc
            vc.setupData(cId: subtitle)
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
            self.getNotificationSettings()
        }
    }

    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("message recived")
        NotificationCnt += 1
        UIApplication.shared.applicationIconBadgeNumber = NotificationCnt
        print(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
    }

    
    func goBackground() {
        let app = UIApplication.shared
        var bgTask: UIBackgroundTaskIdentifier = 0
        bgTask = app.beginBackgroundTask(expirationHandler:{
            NSLog("Expired: %lu", bgTask)
            app.endBackgroundTask(bgTask)
        })
        print("Background: %lu", bgTask)
       startTimer()
    }
    
}



