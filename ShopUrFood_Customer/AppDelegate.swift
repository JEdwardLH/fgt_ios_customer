//
//  AppDelegate.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 05/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import FacebookCore
import FBSDKCoreKit
import GoogleSignIn
import GoogleMaps
import GooglePlaces
import SWRevealViewController
import Firebase
import IQKeyboardManager
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    let gcmOrderIDKey = "gcm.notification.transaction_id"
    let appColor:UIColor = UIColor(red: 234/255, green: 52/255, blue: 49/255, alpha: 1.0)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Init FaceBook login
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        //Init Google
        GIDSignIn.sharedInstance().clientID = GOOGLE_CLIENT_ID
        

        //key for Mikael App
        GMSServices.provideAPIKey("AIzaSyBOJLYvW5jj_TfkLfQ9OfhFDfZijuWMbWI")
        GMSPlacesClient.provideAPIKey("AIzaSyBOJLYvW5jj_TfkLfQ9OfhFDfZijuWMbWI")
        IQKeyboardManager.shared().isEnabled = true
        
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "TruenoRg", size: 17)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "TruenoRg", size: 17)!], for: .selected)
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
        //UITabBarItem.appearance().setTitleTextAttributes(NSAttributedString.Key.foregroundColor: UIColor.gray, for:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.gray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.gray], for: .selected)
        
        // Init Paypal
       
        application.applicationIconBadgeNumber = 0 
        
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        application.registerForRemoteNotifications()
        
        
        let locale = NSLocale.preferredLanguages.first
        print("locale", locale!)
        getPhoneLanguageString = locale!
        
        Messaging.messaging().delegate = self
        FirebaseApp.configure()
        if let token = Messaging.messaging().fcmToken {
            print("FCM token: \(token )")
            self.ConnectToFCM()
        }
        self.ConnectToFCM()
        self.languageUpdate1()
        return true
    }
    
    func languageUpdate()
    {
        if let path = Bundle.main.path(forResource: "English", ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                let myJSON = try String(contentsOf: fileUrl, encoding: .utf8)
                let dict = convertToDictionary(text: myJSON)! as NSDictionary
                print("JSONLoad : \(dict)")
                GlobalLanguageDictionary.removeAllObjects()
                GlobalLanguageDictionary.addEntries(from: dict as! [AnyHashable : Any])
               print("GlobalLanguageDictionary::::::","\(GlobalLanguageDictionary.object(forKey: "Good_morning") as! String)")
                self.checkRootView()

            }
            catch {print("Error")}
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    
    func languageUpdate1()
    {
            if getPhoneLanguageString.contains("th")
            {
                login_session.setValue("th", forKey: "Language")
                if let path = Bundle.main.path(forResource: "Thai", ofType: "json") {
                    do {
                        let fileUrl = URL(fileURLWithPath: path)
                        let myJSON = try String(contentsOf: fileUrl, encoding: .utf8)
                        let dict = convertToDictionary(text: myJSON)! as NSDictionary
                        print("JSONLoad : \(dict)")
                        GlobalLanguageDictionary.removeAllObjects()
                        GlobalLanguageDictionary.addEntries(from: dict as! [AnyHashable : Any])
                       print("GlobalLanguageDictionary::::::","\(GlobalLanguageDictionary.object(forKey: "Good_morning") as! String)")
                        self.checkRootView()

                    }
                    catch {print("Error")}
                }
            }
            else
            {
                login_session.setValue("en", forKey: "Language")
                if let path = Bundle.main.path(forResource: "English", ofType: "json") {
                    do {
                        let fileUrl = URL(fileURLWithPath: path)
                        let myJSON = try String(contentsOf: fileUrl, encoding: .utf8)
                        let dict = convertToDictionary(text: myJSON)! as NSDictionary
                        print("JSONLoad : \(dict)")
                        GlobalLanguageDictionary.removeAllObjects()
                        GlobalLanguageDictionary.addEntries(from: dict as! [AnyHashable : Any])
                       print("GlobalLanguageDictionary::::::","\(GlobalLanguageDictionary.object(forKey: "Good_morning") as! String)")
                        self.checkRootView()

                    }
                    catch {print("Error")}
                }
            }
            
   getAddressFromMapLocationPage = "\(GlobalLanguageDictionary.object(forKey: "enter_location") as! String)"
        }
    
    
    func ConnectToFCM() {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                let token = "\(result.token)"
                print("DCS: " + token)
                UserDefaults.standard.set(token, forKey: "fcmToken")
            }
        }
        if let token = Messaging.messaging().fcmToken {
            print("FCM token: \(token )")
            UserDefaults.standard.set(token, forKey: "fcmToken")
        }
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    func ManualLogoutOption(){
        let domain = Bundle.main.bundleIdentifier!
        login_session.persistentDomain(forName: domain)
        login_session.synchronize()
        print(login_session)
        for key in login_session.dictionaryRepresentation().keys{
            login_session.removeObject(forKey: key.description)
        }
        login_session.synchronize()
        self.checkRootView()
    }
    
    
    func checkRootView()
    {
        if login_session.object(forKey: "user_id") == nil
        {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "NewLoginViewController")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }else{
            if login_session.object(forKey: "user_longitude") != nil{
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "RevealRootView") as! SWRevealViewController
                tabBarSelectedIndex = 2
                self.window?.rootViewController = mainViewController
                self.window?.makeKeyAndVisible()
            }else{
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "LocationOptionPage")
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
        }
    }
    
    
   
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if (ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation))
        {
            return true
        }else if(GIDSignIn.sharedInstance().handle(url)){
            return true
        }
        return false
    }
  
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
    {
        return ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
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

  

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    //MARK: FCM Token Refreshed
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        // FCM token updated, update it on Backend Server
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("remoteMessage: \(remoteMessage)")
        print("remoteMessage: \(remoteMessage.appData)")
        print("remoteMessage: \(remoteMessage)")
        
        let pushDict:NSDictionary = remoteMessage.appData as NSDictionary
        print(pushDict)
        //let titleStr : String = pushDict.value(forKey: "title") as! String
        //let bodyStr : String = pushDict.value(forKey: "body") as! String
        let titleStr : String = (pushDict.value(forKey: "notification") as AnyObject).value(forKey: "title") as! String
        let bodyStr : String = (pushDict.value(forKey: "notification") as AnyObject).value(forKey: "body") as! String
        print(titleStr)
        print(bodyStr)
    }
    func application(received remoteMessage: MessagingRemoteMessage) {
        print("remoteMessage: \(remoteMessage)")
        print("remoteMessage: \(remoteMessage.appData)")
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        print(fcmToken)
        let dataDict:[String: String] = ["token": fcmToken]
        print(dataDict)
        //NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    //MARK: UNUserNotificationCenterDelegate Method
    //Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        UIApplication.shared.applicationIconBadgeNumber += 1
        // custom code to handle push while app is in the foreground
        print("Handle push from foreground\(notification.request.content.userInfo)")
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        
        print("NOTIFY ALERT FOREGROUND : ",(userInfo["aps"] as! NSDictionary).value(forKey: "alert") as Any)
        let alertStr = ((userInfo["aps"] as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "title") as? String
        let alertStr1 = ((userInfo["aps"] as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as? String

        
        let alertController = UIAlertController(title: "FoodToGo!", message: alertStr1, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
        alertController.addAction(okAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        
        
        print("Final foreground: ", alertStr as Any)
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        if alertStr1 == "We have offered you Promotional offer"
        {
            let storyboard:UIStoryboard
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyboard.instantiateViewController(withIdentifier: "MyOffersViewController") as! MyOffersViewController
            nextViewController.isfromNotificationClick = true
            self.window?.rootViewController = nextViewController
            self.window?.makeKeyAndVisible()
        }
        else if alertStr1 == "We have offered you wallet amount"
        {
            let storyboard:UIStoryboard
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyboard.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
            nextViewController.isfromSideBarOrNotifyPage = true
            self.window?.rootViewController = nextViewController
            self.window?.makeKeyAndVisible()
        }
        
        if alertStr == "Order Accept Notification" || alertStr == "Order Accepted Notification" || alertStr == "Order Preparing for Deliver"
        {
//            let storyboard:UIStoryboard
//            storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let nextViewController = storyboard.instantiateViewController(withIdentifier: "OrderDetailsPage") as! OrderDetailsPage
//            nextViewController.orderId = userInfo[gcmOrderIDKey] as! String
//            nextViewController.navigationTypeStr = "present"
//            nextViewController.isfromNotificationClick = true
//            nextViewController.orderisRejected = false
//            self.window?.rootViewController = nextViewController
//            self.window?.makeKeyAndVisible()
        }
        else if alertStr == "Order Rejected Notification"
        {
            let storyboard:UIStoryboard
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyboard.instantiateViewController(withIdentifier: "OrderDetailsPage") as! OrderDetailsPage
            nextViewController.orderId = userInfo[gcmOrderIDKey] as! String
            nextViewController.isfromNotificationClick = true
            nextViewController.orderisRejected = true
            nextViewController.navigationTypeStr = "present"
            self.window?.rootViewController = nextViewController
            self.window?.makeKeyAndVisible()
            
        }
        
        completionHandler([.alert, .badge, .sound])
    }
    //Called to let your app know which action was selected by the user for a given notification.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User Info = \(response.notification.request.content.userInfo)")
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        
        print("NOTIFY ALERT CLICKED FROM NOTIFICATION : ",(userInfo["aps"] as! NSDictionary).value(forKey: "alert") as Any)
        
        let alertStr = ((userInfo["aps"] as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "title") as? String
        let alertStr1 = ((userInfo["aps"] as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as? String
        print("Final background : ", alertStr as Any)

        
        if alertStr1 == "We have offered you Promotional offer"
        {
            let storyboard:UIStoryboard
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyboard.instantiateViewController(withIdentifier: "MyOffersViewController") as! MyOffersViewController
            nextViewController.isfromNotificationClick = true
            self.window?.rootViewController = nextViewController
            self.window?.makeKeyAndVisible()
        }
        else if alertStr1 == "We have offered you wallet amount"
        {
            let storyboard:UIStoryboard
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyboard.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
            nextViewController.isfromSideBarOrNotifyPage = true
            self.window?.rootViewController = nextViewController
            self.window?.makeKeyAndVisible()
        }
        
        if alertStr == "Order Accept Notification" || alertStr == "Order Accepted Notification" || alertStr == "Order Preparing for Deliver"
        {
//            let storyboard:UIStoryboard
//            storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let nextViewController = storyboard.instantiateViewController(withIdentifier: "OrderDetailsPage") as! OrderDetailsPage
//            nextViewController.orderId = userInfo[gcmOrderIDKey] as! String
//            nextViewController.isfromNotificationClick = true
//            nextViewController.navigationTypeStr = "present"
//            nextViewController.orderisRejected = false
//            self.window?.rootViewController = nextViewController
//            self.window?.makeKeyAndVisible()
        }
        else if alertStr == "Order Rejected Notification"
        {
            let storyboard:UIStoryboard
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyboard.instantiateViewController(withIdentifier: "OrderDetailsPage") as! OrderDetailsPage
            nextViewController.orderId = userInfo[gcmOrderIDKey] as! String
            nextViewController.isfromNotificationClick = true
            nextViewController.orderisRejected = true
            nextViewController.navigationTypeStr = "present"
            self.window?.rootViewController = nextViewController
            self.window?.makeKeyAndVisible()
            
        }
        
        
        let state = UIApplication.shared.applicationState
        if state == .background {
            print("background")
        }
        else if state == .active {
            print("foreground")
        }
        else if state == .inactive {
            print("not active")
        }
        completionHandler()
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        //        // If you are receiving a notification message while your app is in the background,
        //        // this callback will not be fired till the user taps on the notification launching the application.
        //        // TODO: Handle data of notification
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        //        // Print full message.
        let state = UIApplication.shared.applicationState
        if state == .background {
            print("background")
        }
        else if state == .active {
            print("foreground")
        }
        else if state == .inactive {
            print("not active")
        }
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //        // If you are receiving a notification message while your app is in the background,
        //        // this callback will not be fired till the user taps on the notification launching the application.
        //        // TODO: Handle data of notification
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        //        // Print full message.
        let state = UIApplication.shared.applicationState
        if state == .background {
            print("background")
        }
        else if state == .active {
            print("foreground")
        }
        else if state == .inactive {
            print("not active")
        }
        print(userInfo)
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
}


extension UIApplication {

    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }

}








