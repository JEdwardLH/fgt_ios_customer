//
//  SideBarViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 15/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import SWRevealViewController
import SCLAlertView
import AFNetworking

@available(iOS 11.0, *)
class SideBarViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var sideTable: UITableView!
    @IBOutlet weak var bgImgView: UIImageView!
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()
    var nameArray = [String]()
    var imageArray = [String]()
    var iPhoneUDIDString = String()
    var darkView = UIView()

    var window: UIWindow?
    let appColor:UIColor = UIColor(red: 234/255, green: 52/255, blue: 49/255, alpha: 1.0)

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideTable.delegate = self
        self.sideTable.dataSource = self
        blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        iPhoneUDIDString = UIDevice.current.identifierForVendor!.uuidString

        
        if #available(iOS 13.0, *) {
                   let app = UIApplication.shared
                   let statusBarHeight: CGFloat = app.statusBarFrame.size.height
                   
                   let statusbarView = UIView()
                   statusbarView.backgroundColor = appColor
                   view.addSubview(statusbarView)
                 
                   statusbarView.translatesAutoresizingMaskIntoConstraints = false
                   statusbarView.heightAnchor
                       .constraint(equalToConstant: statusBarHeight).isActive = true
                   statusbarView.widthAnchor
                       .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
                   statusbarView.topAnchor
                       .constraint(equalTo: view.topAnchor).isActive = true
                   statusbarView.centerXAnchor
                       .constraint(equalTo: view.centerXAnchor).isActive = true
                 
               } else {
                   let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
                   statusBar?.backgroundColor = appColor
               }
               
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //UIApplication.shared.statusBarView?.backgroundColor = appColor
        
        imageArray.removeAll()
        imageArray.append("Side_fav")
        imageArray.append("Side_orderHistory")
        imageArray.append("Side_location")
        //imageArray.append("Side_location")
        imageArray.append("side_review")
        imageArray.append("redReward")
        imageArray.append("wallett120")
        imageArray.append("side_ReferFriend_icon")
        imageArray.append("Side_help")
        imageArray.append("Side_signOut")
        
        nameArray.removeAll()
        nameArray.append("\(GlobalLanguageDictionary.object(forKey: "favourites") as! String)")
        nameArray.append("\(GlobalLanguageDictionary.object(forKey: "orderhistory") as! String)")
        nameArray.append("\(GlobalLanguageDictionary.object(forKey: "my_locations") as! String)")
       // nameArray.append("\(GlobalLanguageDictionary.object(forKey: "nav_item_manage_address") as! String)")
        nameArray.append("\(GlobalLanguageDictionary.object(forKey: "myreviews") as! String)")
        nameArray.append("\(GlobalLanguageDictionary.object(forKey: "myrewards") as! String)")
        //nameArray.append("My Offers")
        nameArray.append("\(GlobalLanguageDictionary.object(forKey: "mywallet") as! String)")
        nameArray.append("\(GlobalLanguageDictionary.object(forKey: "referfriend") as! String)")
        nameArray.append("\(GlobalLanguageDictionary.object(forKey: "support") as! String)")
        nameArray.append("\(GlobalLanguageDictionary.object(forKey: "signout") as! String)")
        
        self.getProfileData()

        darkView.addGestureRecognizer(revealViewController().tapGestureRecognizer())
        darkView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        darkView.frame = self.revealViewController().frontViewController.view.bounds
        self.revealViewController().frontViewController.view.addSubview(darkView)
        revealViewController().tapGestureRecognizer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        UIView.transition(with: self.view.superview!, duration: 1.0, options: [.curveEaseOut], animations: {
        self.darkView.removeFromSuperview()
       }, completion: nil)
        
    }
    
    //MARK:- Calling API methods
    func getProfileData()
    {
         let Parse = CommomParsing()
        Parse.userProfileInfo(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"), onSuccess: {
            response in
            if (response.value(forKey: "code")as! Int == 200){
             let mod = CustomerProfile(fromDictionary: response as! [String : Any])
                Singleton.sharedInstance.CustomerProfileModel = mod
                let user_name = Singleton.sharedInstance.CustomerProfileModel.data.userName
                login_session.setValue(user_name, forKey: "user_name")
                login_session.synchronize()

                self.sideTable.reloadData()
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            
        }, onFailure: {errorResponse in})
    }
    
    
    
     @objc func orderBtnTapped()
     {
        let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "OrderHistoryPage") as! OrderHistoryPage
        let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
        self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)
    }
    

    //MARK:- TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 180
        }else if indexPath.row == 1{
            return 65
        }else if indexPath.row == 9{
            return 110
        }else{
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "sideBarTopCell") as? sideBarTopCell
            cell?.selectionStyle = .none
            //add blur Effects
            cell?.userImgView.layer.cornerRadius = 35.0
            cell?.userImgView.clipsToBounds = true
            blurEffectView.frame = (cell?.bgImgView!.bounds)!
            
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
            cell?.bgImgView?.addSubview(blurEffectView)

            if Singleton.sharedInstance.CustomerProfileModel != nil{
                let userImg = URL(string: Singleton.sharedInstance.CustomerProfileModel.data.userAvatar)
                cell?.bgImgView.kf.setImage(with: userImg)
                //cell?.bgImgView.kf.setImage(with: userImg, placeholder: UIImage(named: "Profile_placeholder"), options: nil, progressBlock: nil, completionHandler: ())
                
                cell?.userImgView.kf.setImage(with: userImg)
                cell?.userNameLbl.text = Singleton.sharedInstance.CustomerProfileModel.data.userName
                cell?.userEmailLbl.text = Singleton.sharedInstance.CustomerProfileModel.data.userEmail
                
                cell?.settingsBtn.addTarget(self, action: #selector(settingsBtnTapped), for: .touchUpInside)
            }
            return cell!
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideBarMidCell") as? SideBarMidCell
            cell?.selectionStyle = .none
            cell?.favLbl.text = nameArray[indexPath.row-1]
            cell?.fav_Icon.image  = UIImage(named: "\(imageArray[indexPath.row-1])")
            cell?.fav_dotImg.layer.cornerRadius = 4.0
            return cell!
        }else if indexPath.row == 9{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideBarBottomCell") as? SideBarBottomCell
            cell?.selectionStyle = .none
            cell?.nameLbl.text = nameArray[indexPath.row-1]
            cell?.iconImg.image  = UIImage(named: "\(imageArray[indexPath.row-1])")
            cell?.dotImg.layer.cornerRadius = 4.0
            return cell!
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideBarTileCell") as? SideBarTileCell
            cell?.selectionStyle = .none
            cell?.nameLbl.text = nameArray[indexPath.row-1]
            cell?.iconImg.image  = UIImage(named: "\(imageArray[indexPath.row-1])")
            cell?.dotImg.layer.cornerRadius = 4.0
            return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            profilepageComesFrom = "sideBar"
            let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
            self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)
        }else if indexPath.row == 1 {
            let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
            let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
            NotificationVC.navigationType = "sidebar"
            self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)
        }else if indexPath.row == 2 {
            let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "OrderHistoryPage") as! OrderHistoryPage
            let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
            self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)
        }else if indexPath.row == 3 {
            let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "AddressViewController") as! AddressViewController
            NotificationVC.navigationType = "sidebar"
            isFromManagedidSelectAddressPage = false
            let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
            self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)
        }
//        else if indexPath.row == 4 {
//            let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "ManageAddressViewController") as! ManageAddressViewController
//            NotificationVC.navigationType = "sidebar"
//            NotificationVC.isfromMapLocationPage = false
//            let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
//
//            self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)
//        }
        else if indexPath.row == 4 {
            let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "MyReviewPage") as! MyReviewPage
            let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
            NotificationVC.navigationType = "sidebar"
            self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)
        }
        else if indexPath.row == 5 {
            let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "MyRewardsViewController") as! MyRewardsViewController
            let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
            NotificationVC.navigationType = "sidebar"
            self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)
        }
//        else if indexPath.row == 7 {
//            let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "MyOffersViewController") as! MyOffersViewController
//            let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
//            NotificationVC.navigationType = "sidebar"
//            NotificationVC.isfromNotificationClick = false
//            self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)
//        }
        else if indexPath.row == 6
        {
            if login_session.object(forKey: "user_longitude") != nil{
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
                tabBarSelectedIndex = 4
                mainViewController.isfromSideBarOrNotifyPage = true
                self.window?.rootViewController = mainViewController
                self.window?.makeKeyAndVisible()
            }else{
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "SelectLocationPage")
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
        }
        else if indexPath.row == 7 {
            let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "ReferFriendsPageViewController") as! ReferFriendsPageViewController
            NotificationVC.navigationType = "sidebar"
            let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
            self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)
        }else if indexPath.row == 8 {
            let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "HelpPageViewController") as! HelpPageViewController
            NotificationVC.navigaionType = "sidebar"
            let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
            self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)
        }else if indexPath.row == 9 {
            self.logout1()
           
        }
    }
    
    func logOut()
    {
        self.showLoadingIndicator(senderVC: self)
        let tokenStr = login_session.object(forKey: "fcmToken") as! String
        let Parse = CommomParsing()
       Parse.userLogout(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"),token: tokenStr, ios_device_id: iPhoneUDIDString, onSuccess: {
            response in
            print(response)
            if (response.value(forKey: "code")as! Int == 200)
            {
                self.showSuccessPopUp(msgStr: "\(GlobalLanguageDictionary.object(forKey: "logged_out") as! String)")
                
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    
    func logout1()
    {
        let finalURL:String = BASEURL_CUSTOMER+USER_LOGOUT

        var tokenStr = String()
        if login_session.value(forKey: "user_token") != nil {
            if login_session.value(forKey: "user_token") as! String != "" {
                tokenStr = login_session.value(forKey: "user_token") as! String
            }
        }
        self.showLoadingIndicator(senderVC: self)
            var params = NSMutableDictionary()
            params = [
                "lang": ((login_session.value(forKey: "Language") as? String) ?? "th"),
                "token" : tokenStr,
                "ios_device_id" : iPhoneUDIDString,
                "cus_ios_fcm_id":login_session.object(forKey: "fcmToken") as! String,
                "type":"ios"
            ]
            print(params)
            let tokenString = "Bearer " + tokenStr
            let manager = AFHTTPSessionManager()
            manager.requestSerializer = AFJSONRequestSerializer()
            manager.responseSerializer = AFJSONResponseSerializer()
            manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/plain", "text/html", "application/json"]) as Set<NSObject> as? Set<String>
            manager.requestSerializer.setValue(tokenString, forHTTPHeaderField: "Authorization")
        manager.post(finalURL, parameters: params, headers: [:], progress: nil, success: { (operation, responseObject) -> Void in
                self.stopLoadingIndicator(senderVC: self)
                let responseDict:NSDictionary = responseObject as! NSDictionary
                print(responseDict)
                if responseDict.value(forKey: "code") as! NSNumber == 200
                {
                    self.stopLoadingIndicator(senderVC: self)
                    self.showSuccessPopUp(msgStr: "\(GlobalLanguageDictionary.object(forKey: "logged_out") as! String)")

                }
                else if responseDict.object(forKey: "code")as! Int == 400 && responseDict.object(forKey: "message")as! String == "Token is Expired" {
                    self.stopLoadingIndicator(senderVC: self)
                    self.showTokenExpiredPopUp(msgStr: responseDict.object(forKey: "message")as! String)
                }
                else
                {
                    self.stopLoadingIndicator(senderVC: self)
                    self.showTokenExpiredPopUp(msgStr: responseDict.object(forKey: "message")as! String)
                }
            }, failure: { (operation, error) -> Void in
                self.stopLoadingIndicator(senderVC: self)
                print(error)
                self.showTokenExpiredPopUp(msgStr: error.localizedDescription)
            })
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
                    }
                    catch {print("Error")}
                }
            }
        
        getAddressFromMapLocationPage = "\(GlobalLanguageDictionary.object(forKey: "enter_location") as! String)"

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
    
    func showSuccessPopUp(msgStr:String){
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "TruenoBd", size: 20.0)!,
            kTextFont: UIFont(name: "TruenoRg", size: 14.0)!,
            kButtonFont: UIFont(name: "TruenoBd", size: 16.0)!,
            showCloseButton: false,
            dynamicAnimatorActive: false,
            buttonsLayout: .horizontal
        )
        let alert = SCLAlertView(appearance: appearance)
        _ = alert.addButton("Ok")
        {
            let domain = Bundle.main.bundleIdentifier!
            login_session.persistentDomain(forName: domain)
            login_session.synchronize()
            print(login_session)
            
            for key in login_session.dictionaryRepresentation().keys{
                if key == "user_apple_id" || key == "user_apple_mailid" || key == "user_apple_name"{

                }else{

                    login_session.removeObject(forKey: key.description)

                }
            }
            login_session.synchronize()
            let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.checkRootView()
            let locale = NSLocale.preferredLanguages.first
            print("locale", locale!)
            getPhoneLanguageString = locale!
            self.languageUpdate1()

        }
        
        let icon = UIImage(named:"success_tick")
        let color = SuccessGreenColor
        
        _ = alert.showCustom("\(GlobalLanguageDictionary.object(forKey: "Success") as! String)", subTitle: msgStr, color: color, icon: icon!, circleIconImage: icon!)
    }
   
    
    @objc func settingsBtnTapped()
    {
        let NotificationVC = storyboard?.instantiateViewController(withIdentifier: "SettingsPageViewController") as! SettingsPageViewController
        let newFrontController = UINavigationController.init(rootViewController: NotificationVC)
        self.revealViewController()?.pushFrontViewController(newFrontController, animated: true)
    }
    

}

