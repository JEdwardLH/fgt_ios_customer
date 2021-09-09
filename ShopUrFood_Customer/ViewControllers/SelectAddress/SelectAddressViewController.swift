//
//  SelectAddressViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 15/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import CoreLocation
import SCLAlertView
import DropDown

@available(iOS 11.0, *)
class SelectAddressViewController: BaseViewController,UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var headingLbl: UILabel!

    @IBOutlet weak var sameShippingBtn: UIButton!
    @IBOutlet weak var pickUpYesBtn: UIButton!
    @IBOutlet weak var pickUpNoBtn: UIButton!
    
    @IBOutlet weak var pickUpYesImageView: UIImageView!
    @IBOutlet weak var pickUpNoImageView: UIImageView!

    var locManager = CLLocationManager()
    @IBOutlet weak var pickUpNotAvailableLbl: UILabel!

    @IBOutlet weak var selfPickUpTitleLbl: UILabel!
    @IBOutlet weak var firstNameTxt: UITextField!
    
    @IBOutlet weak var baseContentView: UIView!
    @IBOutlet weak var firstNameLine: UIView!
    @IBOutlet weak var lastNameTxt: UITextField!
        @IBOutlet weak var lastNameLine: UIView!
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var emailLine: UIView!
    
    @IBOutlet weak var mobileNumberTxt: UITextField!
    @IBOutlet weak var mobileNoCountryCodeBtn: UIButton!
    @IBOutlet weak var alternateNumberTxt: UITextField!
    @IBOutlet weak var alterNoCountryCodeBtn: UIButton!

    @IBOutlet weak var customerAddressTxt: UITextField!
    @IBOutlet weak var customerAddressImageView: UIImageView!
    @IBOutlet weak var customerAddressHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var customerAddressImageViewHeightConstraints: NSLayoutConstraint!

    @IBOutlet weak var customerAddressTxtView2: UILabel!
    @IBOutlet weak var customerlandmark: UITextView!
    
    @IBOutlet weak var manageAddressButton: UIButton!

    @IBOutlet weak var alterLine: UIView!
    @IBOutlet weak var mobileLine: UIView!
    
    @IBOutlet weak var pickUpView: UIView!
    @IBOutlet weak var selfPickupView: UIView!
    @IBOutlet weak var continueBtn: UIButton!
    
    
    @IBOutlet weak var OTPGrayView: UIView!
    @IBOutlet weak var OTPPopupView: UIView!
    @IBOutlet weak var OTPHeadingLbl: UILabel!
    @IBOutlet weak var OTPBottomLineView: UIView!
    @IBOutlet weak var OTPokButton: UIButton!
    @IBOutlet weak var OTPTxtField: UITextField!
    @IBOutlet weak var OTPMessageStrLbl: UILabel!
    @IBOutlet weak var EmailOTPMessageStrLbl: UILabel!

    
       @IBOutlet weak var EmailOTPGrayView: UIView!
       @IBOutlet weak var EmailOTPPopupView: UIView!
       @IBOutlet weak var EmailOTPHeadingLbl: UILabel!
       @IBOutlet weak var EmailOTPBottomLineView: UIView!
       @IBOutlet weak var EmailOTPokButton: UIButton!
       @IBOutlet weak var EmailOTPTxtField: UITextField!
      
    //dropDown
    let countryCodeDropDown = DropDown()
    let AltercountryCodeDropDown = DropDown()
    var firstCountryCodeStr : String = "+66"
    var secondCountryCodeStr : String = ""

    
    var resultDict = NSMutableDictionary()
    var sameShippingFlag = Bool()
    var selfPickupStatus = Int()
    var emailVerificationStatus = Int()
    var countryListArr1 = NSMutableArray()
    var countryListArr2 = NSMutableArray()

    var iPhoneUDIDString = String()

    @IBOutlet weak var restaurantLocationLbl: UILabel!
    @IBOutlet weak var restaurantNameLbl: UILabel!
    var storeName = String()
    var storeLocation = String()
    @IBOutlet weak var skipAndContinueBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        iPhoneUDIDString = UIDevice.current.identifierForVendor!.uuidString
        print("iPhoneUDIDString UUID is : \(iPhoneUDIDString)")
        //getCountryListData()
        baseContentView.layer.cornerRadius = 5.0
        baseContentView = self.setCornorShadowEffects(sender: baseContentView)
        continueBtn.layer.cornerRadius = 20.0
        skipAndContinueBtn.layer.cornerRadius = 20.0
        self.getData()
        sameShippingFlag = true
        restaurantNameLbl.text = "  " + storeName
        restaurantLocationLbl.text = storeLocation
        pickUpView.layer.cornerRadius = 5.0
        pickUpView = self.setCornorShadowEffects(sender: pickUpView)
        // Do any additional setup after loading the view.
        
        
        
        OTPokButton.layer.cornerRadius = 20.0
        OTPPopupView.layer.cornerRadius = 8.0
        OTPPopupView.clipsToBounds = false
        
        
        OTPBottomLineView.clipsToBounds = true
        OTPBottomLineView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        OTPBottomLineView.layer.cornerRadius = 6
        OTPBottomLineView.layer.masksToBounds = true

        
        EmailOTPokButton.layer.cornerRadius = 20.0
        EmailOTPPopupView.layer.cornerRadius = 8.0
        EmailOTPPopupView.clipsToBounds = false
        
        EmailOTPBottomLineView.clipsToBounds = true
        EmailOTPBottomLineView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        EmailOTPBottomLineView.layer.cornerRadius = 6
        EmailOTPBottomLineView.layer.masksToBounds = true

        
        customerlandmark.delegate = self
        customerlandmark.text = "\(GlobalLanguageDictionary.object(forKey: "flatlandmark") as! String)"
        customerlandmark.textColor = UIColor.lightGray

        
        //customerAddressTxt.isHidden = true
        //customerAddressImageView.isHidden = true
//        customerAddressHeightConstraints.constant = 0
//        customerAddressImageViewHeightConstraints.constant = 0
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        headingLbl.text = "\(GlobalLanguageDictionary.object(forKey: "shippingsddress") as! String)"
        
        selfPickUpTitleLbl.text = "\(GlobalLanguageDictionary.object(forKey: "chooseyouroption") as! String)"
        pickUpYesBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "selfpickup") as! String)", for: .normal)
        pickUpNoBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "delivery") as! String)", for: .normal)
        sameShippingBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "delivery") as! String)", for: .normal)
        pickUpNotAvailableLbl.text = "\(GlobalLanguageDictionary.object(forKey: "not_available") as! String)"
        skipAndContinueBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "skipcontinue") as! String)", for: .normal)
        manageAddressButton.setTitle("\(GlobalLanguageDictionary.object(forKey: "change_shipping_address") as! String)", for: .normal)

        
        firstNameTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "firstname") as! String)"
        lastNameTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "lastname") as! String)"
        emailTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "emailaddress") as! String)"
        mobileNumberTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "mobilenumber") as! String)"
       // alternateNumberTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "alternativenumber") as! String)"

        
         OTPHeadingLbl.text = "\(GlobalLanguageDictionary.object(forKey: "Enter_code") as! String)"
               EmailOTPHeadingLbl.text = "\(GlobalLanguageDictionary.object(forKey: "Enter_code") as! String)"
               
               OTPMessageStrLbl.text = "\(GlobalLanguageDictionary.object(forKey: "otp_msg") as! String)"
               OTPokButton.setTitle("\(GlobalLanguageDictionary.object(forKey: "verify") as! String)", for: .normal)

               EmailOTPMessageStrLbl.text = "\(GlobalLanguageDictionary.object(forKey: "email_otp_msg") as! String)"
               EmailOTPokButton.setTitle("\(GlobalLanguageDictionary.object(forKey: "verify") as! String)", for: .normal)
        
        if isFromManagedidSelectAddressPage == true
        {
          customerAddressTxtView2.text = getAddressFromMapLocationPage
          customerlandmark.text = getLandmarkFromMapLocationPage
          customerlandmark.textColor = UIColor.darkText
        }

        
    }
    
    
    @IBAction func manageAddressButtonTapped(_ sender: Any)
    {
        if CLLocationManager.locationServicesEnabled() {
                          //locationManager.allowsBackgroundLocationUpdates = true
          locManager.delegate = self
          locManager.desiredAccuracy = kCLLocationAccuracyBest
          locManager.startUpdatingLocation()
        }else{
         
        }
        let lat = locManager.location?.coordinate.latitude
        let long = locManager.location?.coordinate.longitude
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CustomerAddressManageViewController") as! CustomerAddressManageViewController
        nextViewController.st_latitude = "\(lat ?? 0)"
        nextViewController.st_longitude = "\(long ?? 0)"
        //changes done here
        //nextViewController.isfromMapLocationPage = true
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func otpCodeOkButtonAction(_ sender: Any)
    {
        if self.OTPTxtField.text! == ""
        {
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "otp_msg") as! String)")
        }
        else
        {
        self.showLoadingIndicator(senderVC: self)
            let mobileNoStr = firstCountryCodeStr + mobileNumberTxt.text!
            //let AltermobileNoStr = secondCountryCodeStr + alternateNumberTxt.text!
            let latitude = resultDict.object(forKey: "sh_latitude")as! String
            let longitute = resultDict.object(forKey: "sh_longitude")as! String
           let Parse = CommomParsing()
            
            Parse.updateUserShippingAddresswithotp(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"), sh_cus_fname: firstNameTxt.text!, sh_cus_lname: lastNameTxt.text!, sh_cus_email: emailTxt.text!, sh_phone1: mobileNoStr, sh_phone2: "", sh_location: customerAddressTxtView2.text!, sh_latitude: latitude, sh_longitude: longitute, sh_zipcode: (self.resultDict.object(forKey: "sh_zipcode") as! String), sh_location1: customerlandmark.text, otp: self.OTPTxtField.text!, current_otp: self.OTPTxtField.text!,sh_phone1_code: firstCountryCodeStr,sh_phone2_code: secondCountryCodeStr, onSuccess:
            {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.stopLoadingIndicator(senderVC: self)
                self.OTPGrayView.isHidden = true
                self.showSuccessPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.stopLoadingIndicator(senderVC: self)
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
                self.stopLoadingIndicator(senderVC: self)
                print(response.object(forKey: "message") as Any)
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    }
    
    
    @IBAction func EmailOtpVerifyButtonAction(_ sender: Any)
    {
        if self.EmailOTPTxtField.text! == ""
        {
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "email_otp_msg") as! String)")
        }
        else
        {
            self.checkEmailVerificationCodeApiCall()
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
            self.moveToPaymentPage()
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LocationOptionPage") as! LocationOptionPage
//            self.present(nextViewController, animated:true, completion:nil)
        }
        
        let icon = UIImage(named:"success_tick")
        let color = SuccessGreenColor
        
        _ = alert.showCustom("", subTitle: msgStr, color: color, icon: icon!, circleIconImage: icon!)
    }
    
    
    
    
    func updateCustomerShipAddress()
    {
        let mobileNumber = firstCountryCodeStr + mobileNumberTxt.text!
       // let alterMobileNumber = secondCountryCodeStr + alternateNumberTxt.text!
        var latitude = String()
        var longitute = String()

        if isFromManagedidSelectAddressPage == true
        {
            latitude = getLatitudeFromMapLocationPage
            longitute = getLongitudeFromMapLocationPage
        }
        else
        {
            latitude = resultDict.object(forKey: "sh_latitude")as! String
            longitute = resultDict.object(forKey: "sh_longitude")as! String
        }

        let Parse = CommomParsing()
        Parse.updateUserShippingAddress(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"),sh_cus_fname: firstNameTxt.text! ,sh_cus_lname: lastNameTxt.text!,sh_cus_email: emailTxt.text!,sh_phone1: mobileNumber,sh_phone2: "",sh_location: customerAddressTxtView2.text!,sh_latitude:latitude ,sh_longitude:longitute, sh_zipcode:(self.resultDict.object(forKey: "sh_zipcode") as! String), sh_location1: customerlandmark.text,sh_phone1_code: firstCountryCodeStr,sh_phone2_code: secondCountryCodeStr , onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200
            {
                login_session.setValue(latitude, forKey: "user_latitude")
                login_session.setValue(longitute, forKey: "user_longitude")
                self.moveToPaymentPage()
                //self.showSuccessPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else if response.object(forKey: "code") as! Int == 201
            {
              if response.object(forKey: "message")as! String == "OTP sent to your mobile. Please enter otp"
              {
                self.OTPTxtField.text = ((response.object(forKey: "data") as! NSDictionary).value(forKey: "otp") as? NSNumber)?.stringValue
                self.OTPGrayView.isHidden = false
              }
              else if response.object(forKey: "message")as! String == "Verification code sent to your email. Please enter verification code"
              {
                self.EmailOTPTxtField.text = ((response.object(forKey: "data") as! NSDictionary).value(forKey: "otp") as? NSNumber)?.stringValue
                self.EmailOTPGrayView.isHidden = false

              }
            }
            else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired"
            {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else
            {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    func moveToPaymentPage()
    {
        if self.sameShippingFlag {
                     if self.firstNameTxt.text == "" || self.firstNameTxt.text?.count == 0{
                         self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "Please enter the firstname to continue") as! String)")
                     }else if self.lastNameTxt.text == "" || self.lastNameTxt.text?.count == 0{
                         self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "Please enter the Last name to continue") as! String)")
                     }else if self.emailTxt.text == "" || self.emailTxt.text?.count == 0{
                         self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "Please enter the Email to continue") as! String)")
                     }else if self.mobileNumberTxt.text == "" || self.mobileNumberTxt.text?.count == 0{
                         self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "Please enter mobile number to continue") as! String)")
                     }
                     else{
                         self.resultDict.setValue(self.firstNameTxt.text, forKey: "sh_cus_fname")
                         self.resultDict.setValue(self.lastNameTxt.text, forKey: "sh_cus_lname")
                         self.resultDict.setValue(self.emailTxt.text, forKey: "sh_cus_email")
                         self.resultDict.setValue("\(self.mobileNoCountryCodeBtn.titleLabel?.text ?? "")\(self.mobileNumberTxt.text ?? "")", forKey: "sh_phone1")
                         //self.resultDict.setValue("\(self.alterNoCountryCodeBtn.titleLabel?.text ?? "")\(self.alternateNumberTxt.text ?? "")", forKey: "sh_phone2")
                         self.resultDict.setValue(self.customerAddressTxtView2.text, forKey: "sh_location")
                        self.resultDict.setValue(self.customerlandmark.text, forKey: "sh_location1")

                     let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                     let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SelectPaymetOptionPage") as! SelectPaymetOptionPage
                     nextViewController.addressDict = self.resultDict
                     nextViewController.pickUpType = "delivery"
                        nextViewController.modalPresentationStyle = .fullScreen
                     self.present(nextViewController, animated:true, completion:nil)
                     }
                 }else{
                     if self.firstNameTxt.text == "" || self.firstNameTxt.text?.count == 0{
                         self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "Please enter the firstname to continue") as! String)")
                     }else if self.lastNameTxt.text == "" || self.lastNameTxt.text?.count == 0{
                         self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "Please enter the Last name to continue") as! String)")
                     }else if self.emailTxt.text == "" || self.emailTxt.text?.count == 0{
                         self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "Please enter the Email to continue") as! String)")
                     }else if self.mobileNumberTxt.text == "" || self.mobileNumberTxt.text?.count == 0{
                         self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "Please enter mobile number to continue") as! String)")
                     }
        
                     else{
                         let addressDict = NSMutableDictionary()
                         addressDict.setValue(self.firstNameTxt.text, forKey: "sh_cus_fname")
                         addressDict.setValue(self.lastNameTxt.text, forKey: "sh_cus_lname")
                         addressDict.setValue(self.emailTxt.text, forKey: "sh_cus_email")
                         addressDict.setValue("\(self.mobileNoCountryCodeBtn.titleLabel?.text ?? "")\(self.mobileNumberTxt.text ?? "")", forKey: "sh_phone1")
                        // addressDict.setValue("\(self.alterNoCountryCodeBtn.titleLabel?.text ?? "")\(self.alternateNumberTxt.text ?? "")", forKey: "sh_phone2")
                         let landmarkStr = self.resultDict.object(forKey: "sh_location1")as! String
                         let locationStr = self.resultDict.object(forKey: "sh_location")as! String
                         let latitude = self.resultDict.object(forKey: "sh_latitude")as! String
                         let longitute = self.resultDict.object(forKey: "sh_longitude")as! String
                         addressDict.setValue(landmarkStr, forKey: "sh_location1")
                         addressDict.setValue(locationStr, forKey: "sh_location")
                         addressDict.setValue(latitude, forKey: "sh_latitude")
                         addressDict.setValue(longitute, forKey: "sh_longitude")


                         let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                         let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SelectPaymetOptionPage") as! SelectPaymetOptionPage
                         nextViewController.addressDict = addressDict
                         nextViewController.pickUpType = "delivery"
                        nextViewController.modalPresentationStyle = .fullScreen
                         self.present(nextViewController, animated:true, completion:nil)
                     }
                 }
         
    }
    
    
    //MARK:- API Methods
    func sendEmailVerificationCodeApiCall()
    {
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        Parse.sendEmailVerificationCode(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"),cus_email: emailTxt.text!, onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200 || response.object(forKey: "code") as! Int == 201
            {
                self.EmailOTPTxtField.text = ((response.object(forKey: "data") as! NSDictionary).value(forKey: "otp") as? NSNumber)?.stringValue
              self.EmailOTPGrayView.isHidden = false
            }
            else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else
            {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)

            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    
    func checkEmailVerificationCodeApiCall()
    {
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        Parse.checkEmailVerificationCode(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"), cus_email: emailTxt.text!, current_otp: self.EmailOTPTxtField.text!, otp: self.EmailOTPTxtField.text!, addr_type: "shipping_address", onSuccess:
            {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200
            {
              self.emailVerificationStatus = 0
              self.EmailOTPGrayView.isHidden = true
              self.continueBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "continue") as! String)", for: .normal)
              self.showSuccessPopUp(msgStr: response.object(forKey: "message")as! String)

            }
            else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else
            {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)

            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    func getData()
    {
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        Parse.getCustomerAddress(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"), onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.resultDict.addEntries(from: (response.object(forKey: "data")as! NSDictionary).value(forKey: "shipping_address") as! [AnyHashable : Any])
                
                self.selfPickupStatus = (self.resultDict.object(forKey: "self_pickup_status") as! Int)
                self.emailVerificationStatus = (self.resultDict.object(forKey: "email_verification_status") as! Int)

                if self.emailVerificationStatus == 1
                {
                    self.continueBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "verify_email") as! String)", for: .normal)
                }
                else
                {
                  self.continueBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "continue") as! String)", for: .normal)
                }
                
                if self.selfPickupStatus == 0
                {
                    self.pickUpYesBtn.isHidden = true
                    self.pickUpNoBtn.isHidden = true
                    self.pickUpYesImageView.isHidden = true
                    self.pickUpNoImageView.isHidden = true
                    self.pickUpNotAvailableLbl.isHidden = false
                }else{
                    self.pickUpYesBtn.isHidden = false
                    self.pickUpNoBtn.isHidden = false
                    self.pickUpYesImageView.isHidden = false
                    self.pickUpNoImageView.isHidden = false
                    self.pickUpNotAvailableLbl.isHidden = true
                }
                self.setData()
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    //MARK:- LOAD UI
    func setData(){
        firstNameTxt.text = (resultDict.object(forKey: "sh_cus_fname")as? String ?? "")
        lastNameTxt.text = (resultDict.object(forKey: "sh_cus_lname")as? String ?? "")
        emailTxt.text = (resultDict.object(forKey: "sh_cus_email")as? String ?? "")
        
        if (resultDict.object(forKey: "ship_ph1_cnty_code") as? String) == ""
        {
            firstCountryCodeStr = "+66"
        }
        else
        {
            firstCountryCodeStr = (resultDict.object(forKey: "ship_ph1_cnty_code")as? String ?? "+66")
        }
        
        secondCountryCodeStr = resultDict.object(forKey: "ship_ph2_cnty_code")as? String ?? ""
        
        //        mobileNumberTxt.text = String(numberOne.dropFirst(3))
        //        alternateNumberTxt.text = String(numberTwo.dropFirst(3))
        
        mobileNumberTxt.text = resultDict.object(forKey: "ship_ph1_no_only")as? String ?? ""
        //alternateNumberTxt.text = resultDict.object(forKey: "ship_ph2_no_only")as? String ?? ""
        mobileNoCountryCodeBtn.setTitle(firstCountryCodeStr, for: .normal)
        //alterNoCountryCodeBtn.setTitle(secondCountryCodeStr, for: .normal)
        
        customerAddressTxtView2.text = (resultDict.object(forKey: "sh_location")as? String ?? "")
        customerAddressTxtView2.textColor = UIColor.darkText
        customerAddressTxtView2.isUserInteractionEnabled = false
        
        if (resultDict.object(forKey: "sh_location1") as? String == "")
        {
            customerlandmark.text = "\(GlobalLanguageDictionary.object(forKey: "flatlandmark") as! String)"
            customerlandmark.textColor = UIColor.lightGray
        }
        else
        {
            customerlandmark.text = (resultDict.object(forKey: "sh_location1")as? String ?? "")
            customerlandmark.textColor = UIColor.darkText
        }
        
        customerlandmark.isUserInteractionEnabled = true
        
        
        //self.getAddressFromLatLon(pdblLatitude: resultDict.object(forKey: "sh_latitude")as! String, withLongitude: resultDict.object(forKey: "sh_latitude")as! String)
        
        if firstNameTxt.text == ""{
            firstNameTxt.text = (login_session.object(forKey: "user_name")as! String)
        }
        if emailTxt.text == ""{
            emailTxt.text = (login_session.object(forKey: "user_email")as! String)
        }
        if mobileNumberTxt.text == ""{
            mobileNumberTxt.text = ((login_session.object(forKey: "user_mobileNo") as? String) ?? "")
        }
        
    }
    
    
    //TextView Delegate Methods
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.darkText
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            
            textView.text = "\(GlobalLanguageDictionary.object(forKey: "flatlandmark") as! String)"
            textView.textColor = UIColor.lightGray
        }
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

                   // self.dropDownCalling()
                    
    
                }
                else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                }
                else{
                }
            }, onFailure: {errorResponse in})
        }
    
    func dropDownCalling()
    {
        self.countryCodeDropDown.dataSource = self.countryListArr2 as! [String]
        self.countryCodeDropDown.anchorView = self.mobileNoCountryCodeBtn
        self.countryCodeDropDown.direction = .bottom
        self.countryCodeDropDown.bottomOffset = CGPoint(x: 0, y: self.mobileNoCountryCodeBtn.bounds.height)
        // Action triggered on selection
        self.countryCodeDropDown.selectionAction = { [weak self] (index, item) in
            self?.mobileNoCountryCodeBtn.setTitle(((self!.countryListArr1.object(at: index) as? NSDictionary)?.value(forKey: "country_dial") as! String), for: .normal)
            self?.firstCountryCodeStr = ((self!.countryListArr1.object(at: index) as? NSDictionary)?.value(forKey: "country_dial") as! String)
        }
        self.AltercountryCodeDropDown.dataSource = self.countryListArr2 as! [String]
        self.AltercountryCodeDropDown.anchorView = self.alterNoCountryCodeBtn
        self.AltercountryCodeDropDown.direction = .bottom
        self.AltercountryCodeDropDown.bottomOffset = CGPoint(x: 0, y: self.alterNoCountryCodeBtn.bounds.height)
            // Action triggered on selection
        self.AltercountryCodeDropDown.selectionAction = { [weak self] (index, item) in
                self?.alterNoCountryCodeBtn.setTitle(((self!.countryListArr1.object(at: index) as? NSDictionary)?.value(forKey: "country_dial") as! String), for: .normal)
            self?.secondCountryCodeStr = ((self!.countryListArr1.object(at: index) as? NSDictionary)?.value(forKey: "country_dial") as! String)
        }
        //self.mobileNoCountryCodeBtn.addTarget(self, action: #selector(self.showMobileCCDropDown), for: .touchUpInside)
        self.alterNoCountryCodeBtn.addTarget(self, action: #selector(self.showMobileAlterCCDropDown), for: .touchUpInside)
    }
    
    @objc func showMobileCCDropDown(sender:UIButton){
        countryCodeDropDown.show()
    }
    @objc func showMobileAlterCCDropDown(sender:UIButton){
        AltercountryCodeDropDown.show()
    }
    
    func setEmptyData()
    {
        firstNameTxt.text = ""
        lastNameTxt.text = ""
        emailTxt.text = ""
        mobileNumberTxt.text = ""
        //alternateNumberTxt.text = ""
       
        
        firstNameTxt.isUserInteractionEnabled = true
        lastNameTxt.isUserInteractionEnabled = true
        emailTxt.isUserInteractionEnabled = true
        mobileNumberTxt.isUserInteractionEnabled = true
        //alternateNumberTxt.isUserInteractionEnabled = true
        customerlandmark.isUserInteractionEnabled = true
        customerAddressTxtView2.isUserInteractionEnabled = false
        mobileNumberTxt.keyboardType = .numberPad
       // alternateNumberTxt.keyboardType = .numberPad
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    print(addressString)
                    self.customerAddressTxtView2.text  = addressString
                }
        })
        
    }
    
    
    
    //MARK:- Button Actions
    @IBAction func skipAndContinueBtnAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SelectPaymetOptionPage") as! SelectPaymetOptionPage
        nextViewController.pickUpType = "self"
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continueBtnAction(_ sender: Any)
    {
        if self.emailVerificationStatus == 1
        {
            sendEmailVerificationCodeApiCall()
        }
        else
        {
            
        if customerlandmark.text == "\(GlobalLanguageDictionary.object(forKey: "flatlandmark") as! String)"
        {
            self.showTokenExpiredPopUp(msgStr: "\(GlobalLanguageDictionary.object(forKey: "flatlandmark_required") as! String)")

        }
        else
        {
        self.updateCustomerShipAddress()
        }
    }
        
        
       /* if sameShippingFlag {
            if firstNameTxt.text == "" || firstNameTxt.text?.count == 0{
                self.showToastAlert(senderVC: self, messageStr: "Please enter the firstname to continue!")
            }else if lastNameTxt.text == "" || lastNameTxt.text?.count == 0{
                self.showToastAlert(senderVC: self, messageStr: "Please enter the Last name to continue!")
            }else if emailTxt.text == "" || emailTxt.text?.count == 0{
                self.showToastAlert(senderVC: self, messageStr: "Please enter the Email to continue!")
            }else if mobileNumberTxt.text == "" || mobileNumberTxt.text?.count == 0{
                self.showToastAlert(senderVC: self, messageStr: "Please enter mobile number to continue!")
            }
//            else if customerAddressTxt.text == "" || customerAddressTxt.text?.count == 0{
//                    self.showToastAlert(senderVC: self, messageStr: "Please enter Flat No/Landmark")
//            }
            else{
                resultDict.setValue(firstNameTxt.text, forKey: "sh_cus_fname")
                resultDict.setValue(lastNameTxt.text, forKey: "sh_cus_lname")
                resultDict.setValue(emailTxt.text, forKey: "sh_cus_email")
                resultDict.setValue("\(mobileNoCountryCodeBtn.titleLabel?.text ?? "")\(mobileNumberTxt.text ?? "")", forKey: "sh_phone1")
                resultDict.setValue("\(alterNoCountryCodeBtn.titleLabel?.text ?? "")\(alternateNumberTxt.text ?? "")", forKey: "sh_phone2")
                resultDict.setValue("", forKey: "sh_location1")
                resultDict.setValue(customerAddressTxtView2.text, forKey: "sh_location")

            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SelectPaymetOptionPage") as! SelectPaymetOptionPage
            nextViewController.addressDict = resultDict
            nextViewController.pickUpType = "delivery"
            self.present(nextViewController, animated:true, completion:nil)
            }
        }else{
            if firstNameTxt.text == "" || firstNameTxt.text?.count == 0{
                self.showToastAlert(senderVC: self, messageStr: "Please enter the firstname to continue!")
            }else if lastNameTxt.text == "" || lastNameTxt.text?.count == 0{
                self.showToastAlert(senderVC: self, messageStr: "Please enter the Last name to continue!")
            }else if emailTxt.text == "" || emailTxt.text?.count == 0{
                self.showToastAlert(senderVC: self, messageStr: "Please enter the Email to continue!")
            }else if mobileNumberTxt.text == "" || mobileNumberTxt.text?.count == 0{
                self.showToastAlert(senderVC: self, messageStr: "Please enter mobile number to continue!")
            }
//            else if customerAddressTxt.text == "" || customerAddressTxt.text?.count == 0{
//                self.showToastAlert(senderVC: self, messageStr: "Please enter Flat No/Landmark")
//            }
            else{
                let addressDict = NSMutableDictionary()
                addressDict.setValue(firstNameTxt.text, forKey: "sh_cus_fname")
                addressDict.setValue(lastNameTxt.text, forKey: "sh_cus_lname")
                addressDict.setValue(emailTxt.text, forKey: "sh_cus_email")
                addressDict.setValue("\(mobileNoCountryCodeBtn.titleLabel?.text ?? "")\(mobileNumberTxt.text ?? "")", forKey: "sh_phone1")
                addressDict.setValue("\(alterNoCountryCodeBtn.titleLabel?.text ?? "")\(alternateNumberTxt.text ?? "")", forKey: "sh_phone2")
                let landmarkStr = resultDict.object(forKey: "sh_location1")as! String
                let locationStr = resultDict.object(forKey: "sh_location")as! String
                let latitude = resultDict.object(forKey: "sh_latitude")as! String
                let longitute = resultDict.object(forKey: "sh_longitude")as! String
                addressDict.setValue(landmarkStr, forKey: "sh_location1")
                addressDict.setValue(locationStr, forKey: "sh_location")
                addressDict.setValue(latitude, forKey: "sh_latitude")
                addressDict.setValue(longitute, forKey: "sh_longitude")


                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SelectPaymetOptionPage") as! SelectPaymetOptionPage
                nextViewController.addressDict = addressDict
                nextViewController.pickUpType = "delivery"
                self.present(nextViewController, animated:true, completion:nil)
            }
        }*/
    }
    
    @IBAction func alterCodeBtnAction(_ sender: Any) {
    }
    @IBAction func mobileCodeBtnAction(_ sender: Any) {
    }
    
    @IBAction func sameShippingBtnAction(_ sender: Any) {
        if sameShippingFlag{
            sameShippingFlag = false
            self.setEmptyData()
            sameShippingBtn.setImage(UIImage(named: "checkBox"), for: .normal)
        }else{
            sameShippingFlag = true
            self.setData()
            self.hideLines()
            sameShippingBtn.setImage(UIImage(named: "selectedCheckBox"), for: .normal)
        }
    }
    @IBAction func pickUpYesBtnAction(_ sender: Any) {
        pickUpYesImageView.image = UIImage(named: "self_pickup-orange")
        pickUpNoImageView.image = UIImage(named: "delivery_man-grey")
        selfPickupView.isHidden = false
    }
    
    @IBAction func pickUpNoBtnAction(_ sender: Any) {
        pickUpYesImageView.image = UIImage(named: "self_pickup-grey")
        pickUpNoImageView.image = UIImage(named: "delivery_man")
        selfPickupView.isHidden = true
    }
    
    
    //MARK:- TextFiled delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.hideLines()
        if textField == firstNameTxt{
            firstNameLine.isHidden = false
        }else if textField == lastNameTxt{
            lastNameLine.isHidden = false
        }else if textField == emailTxt{
            emailLine.isHidden = false
        }else if textField == mobileNumberTxt{
            mobileLine.isHidden = false
        }
//        else if textField == alternateNumberTxt{
//            alterLine.isHidden = false
//        }
    }
    
    func hideLines(){
        self.firstNameLine.isHidden = true
        self.lastNameLine.isHidden = true
        self.emailLine.isHidden = true
        self.mobileLine.isHidden = true
        //self.alterLine.isHidden = true

    }
    
    

}
@available(iOS 11.0, *)
extension SelectAddressViewController :  CLLocationManagerDelegate {
    func setupLocationManager()  {
        locManager = CLLocationManager()
        locManager.delegate = self
        locManager.requestAlwaysAuthorization()
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.startUpdatingLocation()
    }
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
    }
    // Below Mehtod will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error Location")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Access the last object from locations to get perfect current location
        if let location = locations.last {
            let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
            print("\(myLocation.latitude)")
            print("\(myLocation.longitude)")
            
        }
        //manager.stopUpdatingLocation()
    }
}
