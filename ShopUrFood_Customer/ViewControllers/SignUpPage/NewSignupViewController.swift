//
//  NewSignupViewController.swift
//  ShopUrFood_Customer
//
//  Created by dineshkumarr on 23/12/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import DropDown
import SCLAlertView
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import GoogleSignIn
let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
@available(iOS 11.0, *)
class NewSignupViewController: BaseViewController,UIGestureRecognizerDelegate,GIDSignInDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var baseview: UIView!
    @IBOutlet weak var signupTableView: UITableView!

    var firstCountryCodeStr : String = "+63"
    
    var usernameStr = String()
    var emailStr = String()
    var countryCodeStr = String()
    var mobileNumberStr = String()
    var pwdStr = String()

    
    //dropDown
    let countryCodeDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.countryCodeDropDown
        ]
    }()
    let loginManager = LoginManager()
    var iPhoneUDIDString = String()
    var countryListDict = NSMutableDictionary()
    
    @IBOutlet weak var transpertantView: UIView!
    @IBOutlet weak var referralApplyBtn: UIButton!
    @IBOutlet weak var referralCodeTxt: UITextField!
    @IBOutlet weak var referralCodeHeadingLbl: UILabel!
    @IBOutlet weak var referralView: UIView!
    
   var countryDropDown = UIButton()
    
    var referralCodeStr = String()
    var countryListArr1 = NSMutableArray()
    var countryListArr2 = NSMutableArray()

    @IBOutlet weak var OTPGrayView: UIView!
    @IBOutlet weak var OTPPopupView: UIView!
    @IBOutlet weak var OTPHeadingLbl: UILabel!
    @IBOutlet weak var OTPBottomLineView: UIView!
    @IBOutlet weak var OTPokButton: UIButton!
    @IBOutlet weak var OTPTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        iPhoneUDIDString = UIDevice.current.identifierForVendor!.uuidString
        //getCountryListData()
        referralCodeStr = ""
        appDelegate?.ConnectToFCM()
        //alloc data to dropdown
        
        OTPokButton.layer.cornerRadius = 20.0
        OTPPopupView.layer.cornerRadius = 8.0
        OTPPopupView.clipsToBounds = false
        
        OTPBottomLineView.clipsToBounds = true
        OTPBottomLineView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        OTPBottomLineView.layer.cornerRadius = 6
        OTPBottomLineView.layer.masksToBounds = true

        referralApplyBtn.layer.cornerRadius = 20.0
//        mobileTxt.keyboardType = .numberPad

        
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {

        referralCodeHeadingLbl.text = "\(GlobalLanguageDictionary.object(forKey: "referral") as! String)"
        referralCodeTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "enterreferralcode") as! String)"
        referralApplyBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "apply") as! String)", for: .normal)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignupTopCell") as? SignupTopCell
          cell?.selectionStyle = .none
        
        cell?.BGView.layer.cornerRadius = 5.0
        cell?.BGView = self.setCornorShadowEffects(sender: cell!.BGView)

        self.countryDropDown.frame = cell!.countryCodeBtn.frame
        print("self.countryDropDown.frame:::", self.countryDropDown.frame)
        
                cell?.registerTitleLbl.text = "\(GlobalLanguageDictionary.object(forKey: "register") as! String)"
                cell?.socialLoginTxtLbl.text = "\(GlobalLanguageDictionary.object(forKey: "sociallogin") as! String)"
                cell?.NameTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "name") as! String)"
                cell?.emailTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "email") as! String)"
                cell?.mobileTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "mobilenumber") as! String)"
                cell?.codeTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "code") as! String)"
                cell?.codeTxt.text = self.firstCountryCodeStr
                cell?.passwordTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "password") as! String)"
        
        if self.referralCodeStr == ""
        {
        cell?.referralCodeBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "referrel_code") as! String)", for: .normal)
        }
        else
        {
          cell?.referralCodeBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "referrel_code_applied") as! String)", for: .normal)
        }
        cell?.goBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "go") as! String)", for: .normal)

        
        
        cell?.orangeLineView.clipsToBounds = true
        cell?.orangeLineView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        cell?.orangeLineView.layer.cornerRadius = 6
        cell?.orangeLineView.layer.masksToBounds = true
        
        cell?.goBtn.layer.cornerRadius = 20.0

        cell?.NameTxt.tag = 101
        cell?.emailTxt.tag = 102
        cell?.codeTxt.tag = 103
        cell?.mobileTxt.tag = 104
        cell?.passwordTxt.tag = 105
        
        cell?.referralCodeBtn.tag = indexPath.row
        cell?.referralCodeBtn.addTarget(self,action:#selector(showCouponView(sender:)), for: .touchUpInside)

        cell?.countryCodeBtn.tag = indexPath.row
        //cell?.countryCodeBtn.addTarget(self,action:#selector(codeBtn(sender:)), for: .touchUpInside)


        cell?.goBtn.tag = indexPath.row
        cell?.goBtn.addTarget(self,action:#selector(goBtnAction(sender:)), for: .touchUpInside)

        cell?.fbBtn.tag = indexPath.row
        cell?.fbBtn.addTarget(self,action:#selector(fbBtnAction(sender:)), for: .touchUpInside)

        cell?.googleBtn.tag = indexPath.row
        cell?.googleBtn.addTarget(self,action:#selector(googleBtnAction(sender:)), for: .touchUpInside)
        
        cell?.backBtn.tag = indexPath.row
        cell?.backBtn.addTarget(self,action:#selector(backBtnAction(sender:)), for: .touchUpInside)

        
        return cell!
    }
    
    //MARK: - TextFields Setup
//    func addLineToView(view : UIView, position : LINE_POSITION, color: UIColor, width: Double) {
//        let lineView = UIView()
//        lineView.backgroundColor = color
//        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
//        view.addSubview(lineView)
//
//        let metrics = ["width" : NSNumber(value: width)]
//        let views = ["lineView" : lineView]
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
//
//        switch position {
//        case .LINE_POSITION_TOP:
//            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
//            break
//        case .LINE_POSITION_BOTTOM:
//            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
//            break
//        default:
//            break
//        }
//    }
    
 
    @IBAction func applyReferralCodeBtnAction(_ sender: Any) {
           self.view.endEditing(true)
           if referralCodeTxt.text == "" {
               self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "enterreferralcode") as! String)")
           }else{
               referralCodeStr  = referralCodeTxt.text!
               transpertantView.isHidden = true
            let indexPosition = IndexPath(row: 0, section: 0)
            UIView.performWithoutAnimation
            {
            self.signupTableView.reloadRows(at: [indexPosition], with: .none)
            self.signupTableView.isHidden = false
            }

           }
        
       }
    
      @objc func backBtnAction(sender:UIButton) {
           self.dismiss(animated: true, completion: nil)
       }
    
    
    func getCountryListData()
        {
            let Parse = CommomParsing()
            Parse.getCountryList(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"), onSuccess: {
                response in
                print (response)
                if response.object(forKey: "code") as! Int == 200
                {
                    
                    self.countryListArr1.removeAllObjects()
                    self.countryListArr2.removeAllObjects()

                    self.countryListArr1.addObjects(from: (((response.object(forKey: "data") as? NSDictionary)?.value(forKey: "country_code_list") as! NSArray) as! [Any]))
                    
                    print("self.countryListArr1:",self.countryListArr1)
                    
                    for i in 0..<self.countryListArr1.count-1
                    {
                        self.countryListArr2.insert(((self.countryListArr1.object(at: i) as? NSDictionary)?.value(forKey: "country_dial") as! String) + " - " + ((self.countryListArr1.object(at: i) as? NSDictionary)?.value(forKey: "country_name") as! String), at: i)

                    }
                    print("self.countryListArr2:",self.countryListArr2)
                    
                    
                }
                else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                }
                else{
                }
            }, onFailure: {errorResponse in})
        }
    
    
    //MARK:- TextFiled delegate Meethods
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField.tag == 101
        {
            self.usernameStr = textField.text!
        }
        else if textField.tag == 102
        {
            self.emailStr = textField.text!
        }
        else if textField.tag == 103
        {
            self.countryCodeStr = textField.text!
        }
        else if textField.tag == 104
        {
            self.mobileNumberStr = textField.text!
        }
        else if textField.tag == 105
        {
            self.pwdStr = textField.text!
        }
    }
    
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
    
    
    @objc func codeBtn(sender:UIButton) {
        
         self.countryCodeDropDown.anchorView = sender
         self.countryCodeDropDown.direction = .bottom
         self.countryCodeDropDown.bottomOffset = CGPoint(x: 0, y: self.countryDropDown.bounds.height)
        self.countryCodeDropDown.dataSource = self.countryListArr2 as! [String]
          // Action triggered on selection
          self.countryCodeDropDown.selectionAction = { [weak self] (index, item) in
          self?.countryCodeStr  = ((self!.countryListArr1.object(at: index) as? NSDictionary)?.value(forKey: "country_dial") as! String)
           self?.firstCountryCodeStr = ((self!.countryListArr1.object(at: index) as? NSDictionary)?.value(forKey: "country_dial") as! String)
            
            let indexPosition = IndexPath(row: 0, section: 0)
            UIView.performWithoutAnimation
            {
            self!.signupTableView.reloadRows(at: [indexPosition], with: .none)
            self!.signupTableView.isHidden = false
            }
        }
        
        countryCodeDropDown.show()
        

    }
    
    @objc func showCouponView(sender:UIButton) {
        referralCodeTxt.text = referralCodeStr
        transpertantView.backgroundColor = BlackTranspertantColor
        transpertantView.isHidden = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.delegate = self // This is not required
        transpertantView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
           transpertantView.isHidden = true
       }
    
    @objc func goBtnAction(sender:UIButton)
    {
       if (usernameStr == "" || usernameStr.count == 0)
       {
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "pleaseenterusername") as! String)")
        }else if emailStr == "" || emailStr.count == 0{
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "pleaseenteremail") as! String)")
        }else if (!isValidEmail(testStr: emailStr)){
           self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "pleaseentervalidmail") as! String)")
        }
        else if firstCountryCodeStr == "" {
           self.showToastAlert(senderVC: self, messageStr: "Please select country code")
        }else if mobileNumberStr == "" || mobileNumberStr.count == 0{
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "pleaseentermobilenumber") as! String)")
        }else if pwdStr == "" || pwdStr.count == 0{
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "pleaseenteryourpassword") as! String)")
        }else{
            referralCodeStr  = referralCodeTxt.text!
            self.showLoadingIndicator(senderVC: self)
            let mobileNoStr = firstCountryCodeStr+mobileNumberStr
            let Parse = CommomParsing()
        Parse.userRegister(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"), cus_fname: self.usernameStr,cus_email: self.emailStr,cus_password: self.pwdStr,cus_phone1: mobileNoStr,referral_code: referralCodeStr,ios_device_id: iPhoneUDIDString, ios_fcm_id: login_session.object(forKey: "fcmToken") as! String, cus_phone1_code: firstCountryCodeStr, onSuccess: {
                response in
                print (response)
                if response.object(forKey: "code") as! Int == 200{
                    self.stopLoadingIndicator(senderVC: self)
                    let dataDict = NSMutableDictionary()
                    dataDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                    let user_email = dataDict.object(forKey: "user_email")as! String
                    let user_id = dataDict.object(forKey: "user_id")
                    let user_name = dataDict.object(forKey: "user_name")as! String
                    let token = dataDict.object(forKey: "token")as! String
                    login_session.setValue(user_email, forKey: "user_email")
                    login_session.setValue("0", forKey: "userCartCount")
                    login_session.setValue(user_id, forKey: "user_id")
                    login_session.setValue(user_name, forKey: "user_name")
                    login_session.setValue(token, forKey: "user_token")
                    login_session.synchronize()
                    self.showSuccessPopUp(msgStr: response.object(forKey: "message")as! String)
                }
                else if response.object(forKey: "code") as! Int == 201
                {
                    self.stopLoadingIndicator(senderVC: self)
                    let dataDict = NSMutableDictionary()
                    dataDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                    self.OTPTxtField.text! = ((dataDict.object(forKey: "otp") as! NSNumber).stringValue)
                    self.OTPGrayView.isHidden = false
                    self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message") as! String)
                }
                else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                    self.stopLoadingIndicator(senderVC: self)
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                }else{
                    self.stopLoadingIndicator(senderVC: self)
                    print(response.object(forKey: "message") as Any)
                    self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message") as! String)
                }
                self.stopLoadingIndicator(senderVC: self)
            }, onFailure: {errorResponse in})
        }
    }
    
    func showSuccessPopUp(msgStr:String){
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "TruenoBd", size: 20.0)!,
            kTextFont: UIFont(name: "TruenoRg", size: 14.0)!,
            kButtonFont: UIFont(name: "TruenoBd", size: 16.0)!,
            showCloseButton: false,
            dynamicAnimatorActive: true,
            buttonsLayout: .horizontal
        )
        let alert = SCLAlertView(appearance: appearance)
        _ = alert.addButton("Ok") {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LocationOptionPage") as! LocationOptionPage
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:true, completion:nil)
        }
        
        let icon = UIImage(named:"success_tick")
        let color = SuccessGreenColor
        
        _ = alert.showCustom("", subTitle: msgStr, color: color, icon: icon!, circleIconImage: icon!)
    }
    
    
    @IBAction func otpCodeOkButtonAction(_ sender: Any)
    {
        if self.OTPTxtField.text! == ""
        {
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "otp_msg") as! String)")
        }
        else
        {
        referralCodeStr  = referralCodeTxt.text!
        self.showLoadingIndicator(senderVC: self)
        let mobileNoStr = firstCountryCodeStr+mobileNumberStr
        let Parse = CommomParsing()
            Parse.customerOTP(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"), cus_fname: usernameStr, cus_email: emailStr, cus_password: pwdStr, cus_phone1: mobileNoStr, otp: self.OTPTxtField.text!, current_otp: self.OTPTxtField.text!, referral_code: referralCodeStr,ios_device_id: iPhoneUDIDString, ios_fcm_id: login_session.object(forKey: "fcmToken") as! String, cus_phone1_code: firstCountryCodeStr, onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.stopLoadingIndicator(senderVC: self)
                let dataDict = NSMutableDictionary()
                dataDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                let user_email = dataDict.object(forKey: "user_email")as! String
                let user_id = dataDict.object(forKey: "user_id")
                let user_name = dataDict.object(forKey: "user_name")as! String
                let token = dataDict.object(forKey: "token")as! String
                login_session.setValue(user_email, forKey: "user_email")
                login_session.setValue("0", forKey: "userCartCount")
                login_session.setValue(user_id, forKey: "user_id")
                login_session.setValue(user_name, forKey: "user_name")
                login_session.setValue(token, forKey: "user_token")
                login_session.synchronize()
                self.OTPGrayView.isHidden = true
                self.showSuccessPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.stopLoadingIndicator(senderVC: self)
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
                self.stopLoadingIndicator(senderVC: self)
                print(response.object(forKey: "message") as Any)
                self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message") as! String)
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    }
    
    
    //MARK:Google SignIn Delegate
    @objc func googleBtnAction(sender:UIButton) {
//        if (Reachability()?.isReachable)!
//        {
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
