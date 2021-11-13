//
//  NewLoginViewController.swift
//  ShopUrFood_Customer
//
//  Created by dineshkumarr on 10/12/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import GoogleSignIn
import AuthenticationServices
import AFNetworking
import SWRevealViewController

enum LINE_POSITION {
    case LINE_POSITION_TOP
    case LINE_POSITION_BOTTOM
}

@available(iOS 11.0, *)
class NewLoginViewController: BaseViewController,GIDSignInDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    @IBOutlet weak var BGView: UIView!
    @IBOutlet weak var loginTableView: UITableView!
    @IBOutlet weak var skipBtn: UIButton!

    var usernameStr = String()
    var pwdStr = String()
    var window: UIWindow?

    var iPhoneUDIDString = String()
    let loginManager = LoginManager()
   let appColor:UIColor = UIColor(red: 234/255, green: 52/255, blue: 49/255, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate?.ConnectToFCM()
        
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
        
        iPhoneUDIDString = UIDevice.current.identifierForVendor!.uuidString
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.ConnectToFCM()
        // Do any additional setup after loading the view.
        //UIApplication.shared.statusBarView?.backgroundColor = appColor
        
        //self.setupSOAppleSignIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    @objc func actionHandleAppleSignin() {

        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()

            request.requestedScopes = [.fullName, .email]

            let authorizationController = ASAuthorizationController(authorizationRequests: [request])

            authorizationController.delegate = self

            authorizationController.presentationContextProvider = self

            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }

    }
    
    
    func appleSignInDataAPI(emailStr:String,apple_id:String,nameStr:String)
       {
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()

        var fcmToken = String()
        if login_session.object(forKey: "fcmToken") != nil
        {
            fcmToken = login_session.object(forKey: "fcmToken") as! String
        }
        else
        {
            fcmToken = ""
        }
        
           let parameters:[String : Any] = [
                "lang" : ((login_session.value(forKey: "Language") as? String) ?? "th"),
               "apple_id":apple_id,
               "email":emailStr,
               "name":nameStr,
               "ios_fcm_id":fcmToken,
               "ios_device_id":iPhoneUDIDString,
               "type":"ios"
           ]
           print(parameters)
        
        Parse.appleLoginParse(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"), apple_id: apple_id, email: emailStr,name: nameStr,ios_fcm_id: fcmToken, ios_device_id: iPhoneUDIDString,type:"ios", onSuccess: {
                response in
                print(response)
                if response.object(forKey: "code") as! Int == 200{
                let dataDict = NSMutableDictionary()
                dataDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                let user_email = dataDict.object(forKey: "user_email")as! String
                let user_id = dataDict.object(forKey: "user_id")
                let user_name = dataDict.object(forKey: "user_name")as! String
                let phone = (dataDict.object(forKey: "user_phone") as? String ?? "")
                    //phone = phone.replacingOccurrences(of: "+63", with: "")
                let token = dataDict.object(forKey: "token")as! String
                login_session.setValue(user_email, forKey: "user_email")
                login_session.setValue("0", forKey: "userCartCount")
                login_session.setValue(user_id, forKey: "user_id")
                login_session.setValue(user_name, forKey: "user_name")
                login_session.setValue(phone, forKey: "user_mobileNo")
                login_session.setValue(token, forKey: "user_token")
                login_session.synchronize()
                self.stopLoadingIndicator(senderVC: self)
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LocationOptionPage") as! LocationOptionPage
                    nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated:true, completion:nil)
                }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                }else{
                    self.stopLoadingIndicator(senderVC: self)
                    self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message") as! String)
                }
            }, onFailure: {errorResponse in})
        }

        
    
       
       @available(iOS 13.0, *)
       func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {

           return self.view.window!

       }
       
       @available(iOS 13.0, *)
       func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {

           print(error.localizedDescription)

       }

          // ASAuthorizationControllerDelegate function for successful authorization

       @available(iOS 13.0, *)
       func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

           if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

               // Create an account as per your requirement

               var userIdentifier = String()
               var fullName  = String()
               var email = String()
               if appleIDCredential.fullName?.givenName != nil {
                   userIdentifier = appleIDCredential.user
                   fullName = appleIDCredential.fullName?.givenName! ?? ""
                   email = appleIDCredential.email!
                   login_session.setValue(userIdentifier, forKey: "user_apple_id")
                   login_session.setValue(email, forKey: "user_apple_mailid")
                   login_session.setValue(fullName, forKey: "user_apple_name")
                   login_session.synchronize()
               }else{
                   if login_session.object(forKey: "user_apple_id") != nil
                   {
                       userIdentifier = login_session.object(forKey: "user_apple_id") as! String
                       email = login_session.object(forKey: "user_apple_mailid") as! String
                       fullName = login_session.object(forKey: "user_apple_name") as! String
                   }
               }
               //print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
               if email != nil && userIdentifier != nil && fullName !=  nil
               {
                   self.appleSignInDataAPI(emailStr: email, apple_id: userIdentifier, nameStr: fullName)
               }
              
               //Write your code

           } else if let passwordCredential = authorization.credential as? ASPasswordCredential {

               let appleUsername = passwordCredential.user

               let applePassword = passwordCredential.password

               //Write your code

           }

       }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoginTopCell") as? LoginTopCell
          cell?.selectionStyle = .none
        
        if #available(iOS 13.0, *) {
            let btnAuthorization = ASAuthorizationAppleIDButton()
            btnAuthorization.frame = CGRect(x: 100, y: (cell?.baseView.frame.size.height)!-50, width: (self.view.frame.size.width) - 200, height: 40)
            //btnAuthorization.center = self.view.center
            btnAuthorization.addTarget(self, action: #selector(actionHandleAppleSignin), for: .touchUpInside)
            cell?.baseView.addSubview(btnAuthorization)
            
        } else {
            // Fallback on earlier versions
            cell?.googleBtn.isHidden = true
            cell?.fbBtn.isHidden = true
            
        }
        
        
        self.addLineToView(view: cell!.userNameTxt, position:.LINE_POSITION_BOTTOM, color: UIColor.lightGray, width: 0.8)
        self.addLineToView(view: cell!.passwordTxt, position:.LINE_POSITION_BOTTOM, color: UIColor.lightGray, width: 0.8)
        
        cell?.orangeLineView.clipsToBounds = true
        cell?.orangeLineView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        cell?.orangeLineView.layer.cornerRadius = 6
        cell?.orangeLineView.layer.masksToBounds = true

        cell?.userNameTxt.rightViewMode = UITextField.ViewMode.always
        let emailImgContainer1 = UIView(frame: CGRect(x: 3, y: 1, width: 30, height: 25))
        let emailImg1 = UIImageView(frame: CGRect(x: 3, y: 1, width: 24, height: 24))
        emailImg1.image = UIImage(named: "invoice_mail")
        emailImgContainer1.addSubview(emailImg1)
        cell?.userNameTxt.rightView = emailImgContainer1

        cell?.passwordTxt.rightViewMode = UITextField.ViewMode.always
        let emailImgContainer2 = UIView(frame: CGRect(x: 3, y: 1, width: 30, height: 25))
        let emailImg2 = UIImageView(frame: CGRect(x: 3, y: 1, width: 24, height: 24))
        emailImg2.image = UIImage(named: "login_password")
        emailImgContainer2.addSubview(emailImg2)
        cell?.passwordTxt.rightView = emailImgContainer2

        
        
        cell?.loginTitleLbl.text = "\(GlobalLanguageDictionary.object(forKey: "login") as! String)"
        //cell?.newUserLbl.text = "\(GlobalLanguageDictionary.object(forKey: "neewuser") as! String)"
        cell?.userNameTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "email") as! String)"
        cell?.passwordTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "password") as! String)"
        cell?.goBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "login") as! String)", for: .normal)
        cell?.socialLoginLbl.text = "\(GlobalLanguageDictionary.object(forKey: "sociallogin") as! String)"
        cell?.forgetPasswordBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "forgotpassword") as! String)", for: .normal)
        
        
        let string = "\(GlobalLanguageDictionary.object(forKey: "neewuser") as! String)\(" ")\(GlobalLanguageDictionary.object(forKey: "signup") as! String)"
        
        let attributedString = NSMutableAttributedString.init(string: string)
        let range = (string as NSString).range(of: "\(GlobalLanguageDictionary.object(forKey: "neewuser") as! String)")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray, range: range)
        cell?.signUpLbl.attributedText = attributedString
        
        //cell?.signupBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "signup") as! String)", for: .normal)
        
        cell?.goBtn.layer.cornerRadius = 20.0
        cell?.userLoginDataView.layer.cornerRadius = 8.0
        cell?.userLoginDataView = self.setCornorShadowEffects(sender: cell!.userLoginDataView)

        cell?.userNameTxt.tag = 101
        cell?.passwordTxt.tag = 102
        
        cell?.signupBtn.tag = indexPath.row
        cell?.signupBtn.addTarget(self,action:#selector(signUpBtnAction(sender:)), for: .touchUpInside)
        
        cell?.forgetPasswordBtn.tag = indexPath.row
        cell?.forgetPasswordBtn.addTarget(self,action:#selector(forgetPwdBtnAction(sender:)), for: .touchUpInside)

        cell?.goBtn.tag = indexPath.row
        cell?.goBtn.addTarget(self,action:#selector(goBtnAction(sender:)), for: .touchUpInside)

        cell?.fbBtn.tag = indexPath.row
        cell?.fbBtn.addTarget(self,action:#selector(fbBtnAction(sender:)), for: .touchUpInside)

        cell?.googleBtn.tag = indexPath.row
        cell?.googleBtn.addTarget(self,action:#selector(googleBtnAction(sender:)), for: .touchUpInside)
        
        cell?.skipBtn.layer.cornerRadius = 15.0
        cell?.skipBtn.layer.masksToBounds = true

        cell?.skipBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "skip") as! String)", for: .normal)
        cell?.skipBtn.tag = indexPath.row
        cell?.skipBtn.addTarget(self,action:#selector(skipBtnAction(sender:)), for: .touchUpInside)

        
        return cell!
    }
    
    @objc func fbBtnAction(sender:UIButton)
    {
//        if (Reachability()?.isReachable)!
//        {
        self.showLoadingIndicator(senderVC: self)
            let completion = {
                (result:LoginResult) in
                switch result
                {
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    print("YES! \n--- GRANTED PERMISSIONS ---\n\(grantedPermissions) \n--- DECLINED PERMISSIONS ---\n\(declinedPermissions) \n--- ACCESS TOKEN ---\n\(accessToken)")
                    print("check\(declinedPermissions.description)")
                    if(declinedPermissions.contains("email")){
                        print("correct\(declinedPermissions.description)")
                        let loginManager = LoginManager()
                        loginManager.logOut()
                        //Utility().showAlertWithTitle(alertTitle: APP_NAME as NSString, alertMsg:FB_PERMISSION_ALERT as NSString, viewController: self)
                    }else{
                        self.getFBUserData()
                    }
                case .failed(let error):
                    self.stopLoadingIndicator(senderVC: self)
                    print("No...\(error)")
                case .cancelled:
                    self.stopLoadingIndicator(senderVC: self)
                    print("Cancelled.")
                }
            }
            loginManager.logOut()
        loginManager.logIn(permissions: [.publicProfile,.email], viewController: self, completion: completion)
       // }
       
    }
    
    
    @objc func googleBtnAction(sender:UIButton)
    {
//        if (Reachability()?.isReachable)!
//        {
        self.showLoadingIndicator(senderVC: self)
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        //}
    }
    
    @objc func goBtnAction(sender:UIButton)
    {
//         if (Reachability()?.isReachable)!
//         {
            self.view.endEditing(true)
            let emailStr = usernameStr
            let passwordStr = pwdStr
            
            if emailStr == "" || emailStr.count == 0
            {
                self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "pleaseenteremail") as! String)")
            }else if passwordStr == "" || passwordStr.count == 0
            {
                self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "pleaseenteryourpassword") as! String)")
            }else{
                self.showLoadingIndicator(senderVC: self)

                let Parse = CommomParsing()
                var fcmToken = String()
                if login_session.object(forKey: "fcmToken") != nil
                {
                    fcmToken = login_session.object(forKey: "fcmToken") as! String
                }else{
                    fcmToken = ""
                }
                Parse.NormalEmailLoginParse(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"), login_id: emailStr, cus_password: passwordStr,ios_fcm_id: fcmToken,type: device_type, ios_device_id: iPhoneUDIDString, onSuccess: {
                    response in
                    print(response)
                    if response.object(forKey: "code") as! Int == 200{
                    let dataDict = NSMutableDictionary()
                    dataDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                    let user_email = dataDict.object(forKey: "user_email")as! String
                    let user_id = dataDict.object(forKey: "user_id")
                    let user_name = dataDict.object(forKey: "user_name")as! String
                        let phone = (dataDict.object(forKey: "user_phone") as? String ?? "")
                        //phone = phone.replacingOccurrences(of: "+63", with: "")
                    let token = dataDict.object(forKey: "token")as! String
                    login_session.setValue(user_email, forKey: "user_email")
                    login_session.setValue("0", forKey: "userCartCount")
                    login_session.setValue(user_id, forKey: "user_id")
                    login_session.setValue(user_name, forKey: "user_name")
                    login_session.setValue(phone, forKey: "user_mobileNo")
                    login_session.setValue(token, forKey: "user_token")
                    login_session.synchronize()
                    self.stopLoadingIndicator(senderVC: self)
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LocationOptionPage") as! LocationOptionPage
                        nextViewController.modalPresentationStyle = .fullScreen
                    self.present(nextViewController, animated:true, completion:nil)
                    }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                        self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                    }else{
                        self.stopLoadingIndicator(senderVC: self)
                        self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message") as! String)
                    }
                }, onFailure: {errorResponse in})
            }
//         }
//         else
//         {
//
//         }
    }
    
    @objc func signUpBtnAction(sender:UIButton)
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewSignupViewController") as! NewSignupViewController
        //nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @objc func forgetPwdBtnAction(sender:UIButton)
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ForgetPasswordPage") as! ForgetPasswordPage
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    //MARK:- TextFiled delegate Meethods
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 101
        {
            self.usernameStr = textField.text!
        }
        else
        {
            self.pwdStr = textField.text!
        }
    }
    
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
    
    
    //MARK:Google SignIn Delegate
       @objc func googleBtnAction(_ sender: Any) {
//           if (Reachability()?.isReachable)!
//           {
           self.showLoadingIndicator(senderVC: self)
           GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance()?.presentingViewController = self
           GIDSignIn.sharedInstance().signIn()
           //}
       }
       
       func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
            appDelegate?.ConnectToFCM()
           if (error == nil) {
               // Perform any operations on signed in user here.
               let requestDict = NSMutableDictionary.init()
               requestDict.setValue("google", forKey: "type")
               requestDict.setValue(user.userID, forKey: "id")
               requestDict.setValue(user.profile.name, forKey: "full_name")
               requestDict.setValue(user.profile.email, forKey: "email")
               print(requestDict)
               let idStr = user.userID
               let emailStr = user.profile.email
               let  nameStr = user.profile.name
               
               let Parse = CommomParsing()
               Parse.GoogleLogin(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"), google_id:idStr!, email:emailStr!, name:nameStr!, type: device_type,ios_fcm_id:login_session.object(forKey: "fcmToken") as! String ,ios_device_id:iPhoneUDIDString, onSuccess: {
                   response in
                   print(response)
                   let dataDict = NSMutableDictionary()
                   dataDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                   let user_email = dataDict.object(forKey: "user_email")as! String
                   let user_id = String(dataDict.object(forKey: "user_id")as! Int)
                   let user_name = dataDict.object(forKey: "user_name")as! String
                   let phone = dataDict.object(forKey: "user_phone")as! String
                   //phone = phone.replacingOccurrences(of: "+63", with: "")
                   let token = dataDict.object(forKey: "token")as! String
                   login_session.setValue(user_email, forKey: "user_email")
                   login_session.setValue("0", forKey: "userCartCount")
                   login_session.setValue(user_id, forKey: "user_id")
                   login_session.setValue(user_name, forKey: "user_name")
                   login_session.setValue(phone, forKey: "user_mobileNo")
                   login_session.setValue(token, forKey: "user_token")
                   login_session.synchronize()
                   self.stopLoadingIndicator(senderVC: self)
                   let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                   let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LocationOptionPage") as! LocationOptionPage
                nextViewController.modalPresentationStyle = .fullScreen
                   self.present(nextViewController, animated:true, completion:nil)
               }, onFailure: {errorResponse in})
               
           } else {
              self.stopLoadingIndicator(senderVC: self)
               print("\(error.localizedDescription)")
           }
       }
       
       //MARK:FaceBook SignIn Delegate
       @objc func fbBtnAction(_ sender: Any)
       {
//           if (Reachability()?.isReachable)!
//           {
           self.showLoadingIndicator(senderVC: self)
               let completion = {
                   (result:LoginResult) in
                   switch result
                   {
                   case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                       print("YES! \n--- GRANTED PERMISSIONS ---\n\(grantedPermissions) \n--- DECLINED PERMISSIONS ---\n\(declinedPermissions) \n--- ACCESS TOKEN ---\n\(accessToken)")
                       print("check\(declinedPermissions.description)")
                       if(declinedPermissions.contains("email")){
                           print("correct\(declinedPermissions.description)")
                           let loginManager = LoginManager()
                           loginManager.logOut()
                           //Utility().showAlertWithTitle(alertTitle: APP_NAME as NSString, alertMsg:FB_PERMISSION_ALERT as NSString, viewController: self)
                       }else{
                           self.getFBUserData()
                       }
                   case .failed(let error):
                       self.stopLoadingIndicator(senderVC: self)
                       print("No...\(error)")
                   case .cancelled:
                       self.stopLoadingIndicator(senderVC: self)
                       print("Cancelled.")
                   }
               }
               loginManager.logOut()
        loginManager.logIn(permissions: [.publicProfile,.email], viewController: self, completion: completion)
           //}
          
       }
       
       func getFBUserData(){
        appDelegate?.ConnectToFCM()
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, last_name, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                   if (error == nil){
                       //    self.dict = result as! [String : AnyObject]
                       let responseDict = result as! NSDictionary
                       self.showLoadingIndicator(senderVC: self)
                       let Parse = CommomParsing()
                       let emailStr = responseDict.object(forKey: "email")as! String
                       let fb_idStr = responseDict.object(forKey: "id")as! String
                       let nameStr = responseDict.object(forKey: "name")as! String
                       Parse.faceBookLogin(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"), facebook_id: fb_idStr, email: emailStr, name: nameStr, type: device_type,ios_fcm_id: login_session.object(forKey: "fcmToken") as! String,ios_device_id:self.iPhoneUDIDString, onSuccess: {
                           response in
                           print(response)
                           if (response.value(forKey: "code")as! Int == 200){
                              let dataDict = NSMutableDictionary()
                               dataDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                               let user_email = dataDict.object(forKey: "user_email")as! String
                               let user_id = String(dataDict.object(forKey: "user_id")as! Int)
                               let user_name = dataDict.object(forKey: "user_name")as! String
                               let phone = dataDict.object(forKey: "user_phone")as! String
                               //phone = phone.replacingOccurrences(of: "+63", with: "")
                               let token = dataDict.object(forKey: "token")as! String
                               login_session.setValue(user_email, forKey: "user_email")
                               login_session.setValue("0", forKey: "userCartCount")
                               login_session.setValue(user_id, forKey: "user_id")
                               login_session.setValue(user_name, forKey: "user_name")
                               login_session.setValue(phone, forKey: "user_mobileNo")
                               login_session.setValue(token, forKey: "user_token")
                               login_session.synchronize()
                               let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                               let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LocationOptionPage") as! LocationOptionPage
                            nextViewController.modalPresentationStyle = .fullScreen
                               self.present(nextViewController, animated:true, completion:nil)
                           }else{
                               print("Failed")
                           }
                           self.stopLoadingIndicator(senderVC: self)
                       }, onFailure: {errorResponse in})
                      
                   }
                   
               })
           }
       }
    
    @objc func skipBtnAction(sender:UIButton)
    {
        if login_session.object(forKey: "user_longitude") != nil{
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "RevealRootView") as! SWRevealViewController
            tabBarSelectedIndex = 2
            self.window?.rootViewController = mainViewController
            self.window?.makeKeyAndVisible()
        }
        else
        {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LocationOptionPage")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
    }
    
    
    //MARK: - TextFields SetUp
    func addLineToView(view : UIView, position : LINE_POSITION, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        view.addSubview(lineView)
        
        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
        
        switch position {
        case .LINE_POSITION_TOP:
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .LINE_POSITION_BOTTOM:
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        default:
            break
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


