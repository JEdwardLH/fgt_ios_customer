//
//  LoginViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 05/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import GoogleSignIn

@available(iOS 11.0, *)
class LoginViewController: BaseViewController,GIDSignInDelegate,UITextFieldDelegate {

    @IBOutlet weak var newUserLbl: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var socialLoginLbl: UILabel!
    @IBOutlet weak var goBtn: UIButton!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var loginTitleLbl: UILabel!
    @IBOutlet weak var userLoginDataView: UIView!
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!

    var iPhoneUDIDString = String()
    let loginManager = LoginManager()
    let appColor:UIColor = UIColor(red: 234/255, green: 52/255, blue: 49/255, alpha: 1.0)
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate?.ConnectToFCM()
//        userNameTxt.attributedPlaceholder = NSAttributedString(string:"Name", attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.font :UIFont(name: "Arial", size: 16)!])
//
//        passwordTxt.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.font :UIFont(name: "Arial", size: 16)!])
        
        
        userLoginDataView.layer.cornerRadius = 8.0
        userLoginDataView = self.setCornorShadowEffects(sender: userLoginDataView)
        goBtn.layer.cornerRadius = 25.0
        iPhoneUDIDString = UIDevice.current.identifierForVendor!.uuidString
        userNameTxt.delegate = self
        passwordTxt.delegate = self
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.ConnectToFCM()
        //self.logoImg.image = UIImage(named: "SUFLogo.png")
        self.getIconsFromAPI()
        
    }
    
    func getIconsFromAPI()
    {
    let Parse = CommomParsing()
    Parse.getSplash(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"), onSuccess: {
    response in
    if (response.value(forKey: "code")as! Int == 200){
    print(response)
    let tempDict = NSMutableDictionary()
    tempDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
    login_session.setValue(tempDict.object(forKey: "signup_logo_ios"), forKey: "logo")
    login_session.synchronize()
        let logoURL = URL(string: login_session.object(forKey: "logo")as! String)
        //self.logoImg.kf.setImage(with: logoURL)
        //self.logoImg.image = UIImage(named: "SUFLogo.png")
    }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
    }
    
    }, onFailure: {errorResponse in})
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        loginTitleLbl.text = "\(GlobalLanguageDictionary.object(forKey: "login") as! String)"
        newUserLbl.text = "\(GlobalLanguageDictionary.object(forKey: "neewuser") as! String)"
        userNameTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "email") as! String)"
        passwordTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "password") as! String)"
        goBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "login") as! String)", for: .normal)
        socialLoginLbl.text = "\(GlobalLanguageDictionary.object(forKey: "sociallogin") as! String)"
        forgetPasswordBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "forgotpassword") as! String)", for: .normal)
        signupBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "signup") as! String)", for: .normal)
    }
    
    
    //MARK:- TextFiled delegate Meethods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    //MARK:- Button Actions
    @IBAction func forgetBtnAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ForgetPasswordPage") as! ForgetPasswordPage
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func goBtnAction(_ sender: Any)
    {
         if (Reachability()?.isReachable)!
         {
            self.view.endEditing(true)
            let emailStr = userNameTxt.text
            let passwordStr = passwordTxt.text
            
            if emailStr == "" || emailStr?.count == 0{
                self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "pleaseenteremail") as! String)")
            }else if passwordStr == "" || passwordStr?.count == 0{
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
                Parse.NormalEmailLoginParse(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"), login_id: emailStr!, cus_password: passwordStr!,ios_fcm_id: fcmToken,type: device_type, ios_device_id: iPhoneUDIDString, onSuccess: {
                    response in
                    print(response)
                    if response.object(forKey: "code") as! Int == 200{
                    let dataDict = NSMutableDictionary()
                    dataDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                    let user_email = dataDict.object(forKey: "user_email")as! String
                    let user_id = dataDict.object(forKey: "user_id")
                    let user_name = dataDict.object(forKey: "user_name")as! String
                        let phone = (dataDict.object(forKey: "user_phone") as? String ?? "")
                        //phone = phone.replacingOccurrences(of: "+91", with: "")
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
         }
         else
         {
            
        }
    }
    
    @IBAction func signUpBtnAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
    //MARK:Google SignIn Delegate
    @IBAction func googleBtnAction(_ sender: Any) {
        if (Reachability()?.isReachable)!
        {
        self.showLoadingIndicator(senderVC: self)
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        }
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
                //phone = phone.replacingOccurrences(of: "+91", with: "")
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
    @IBAction func fbBtnAction(_ sender: Any)
    {
        if (Reachability()?.isReachable)!
        {
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
        }
       
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
                            //phone = phone.replacingOccurrences(of: "+91", with: "")
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
    
    
    
}
