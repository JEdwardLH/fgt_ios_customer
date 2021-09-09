//
//  AddressViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 01/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import CoreLocation
import DropDown
import SCLAlertView

@available(iOS 11.0, *)
class AddressViewController: BaseViewController,UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var alter_codeBtn: UIButton!
    @IBOutlet weak var mobile_codeBtn: UIButton!
    @IBOutlet weak var baseContentView: UIView!
    @IBOutlet weak var navigationTitleLbl: UILabel!
    var locManager = CLLocationManager()
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var firstNameTxt: UITextField!
    
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var firstNameLine: UIView!
    @IBOutlet weak var lastNameLine: UIView!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var emailLine: UIView!
    
    @IBOutlet weak var mobileNumberTxt: UITextField!
    
    @IBOutlet weak var mobileLine: UIView!
    
    @IBOutlet weak var alternateNumTxt: UITextField!
    
    @IBOutlet weak var alterLine: UIView!
    
    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var addressLine: UIView!
    
    @IBOutlet weak var addressLine2: UITextView!
    @IBOutlet weak var addressLine2ImageView: UIImageView!

    @IBOutlet weak var addressLine2HeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var addressLine2ImageViewHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var saveLocationButton: UIButton!
    @IBOutlet weak var saveLocationTxtLbl: UILabel!

    @IBOutlet weak var OTPGrayView: UIView!
    @IBOutlet weak var OTPPopupView: UIView!
    @IBOutlet weak var OTPHeadingLbl: UILabel!
    @IBOutlet weak var OTPMessageStrLbl: UILabel!
    @IBOutlet weak var EmailOTPMessageStrLbl: UILabel!

    @IBOutlet weak var OTPBottomLineView: UIView!
    @IBOutlet weak var OTPokButton: UIButton!
    @IBOutlet weak var OTPTxtField: UITextField!
    
    
       @IBOutlet weak var EmailOTPGrayView: UIView!
       @IBOutlet weak var EmailOTPPopupView: UIView!
       @IBOutlet weak var EmailOTPHeadingLbl: UILabel!
       @IBOutlet weak var EmailOTPBottomLineView: UIView!
       @IBOutlet weak var EmailOTPokButton: UIButton!
       @IBOutlet weak var EmailOTPTxtField: UITextField!

    @IBOutlet weak var addressTypeTxtLbl: UILabel!
    var resultDict1 = NSMutableDictionary()

    
    var navigationType = String()
    var resultDict = NSMutableDictionary()
    
    //dropDown
    let countryCodeDropDown = DropDown()
    let AltercountryCodeDropDown = DropDown()
    var countryListDict = NSMutableDictionary()
    var countryListArr1 = NSMutableArray()
    var countryListArr2 = NSMutableArray()

    var firstCountryCodeStr : String = "+63"
    var secondCountryCodeStr : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideAllLines()
        self.getData()
        //self.getCountryListData()
        getCartData()
        
        if UserDefaults.standard.object(forKey: "GlobalAddressType") == nil
        {
            UserDefaults.standard.set("\(GlobalLanguageDictionary.object(forKey: "home") as! String)", forKey: "GlobalAddressType")
        }
        
        self.baseContentView = self.setCornorShadowEffects(sender: self.baseContentView)
        saveBtn.layer.cornerRadius = 20.0
        saveBtn.clipsToBounds = true
        baseContentView.layer.cornerRadius = 10.0
        ActAsSelectedAddress = ""
        ActAsSelectedLatitude = ""
        ActAsSelectedLongitude = ""
        ActAsSelectedZipCode = ""
        
        addressLine.isHidden = true
        addressLine2HeightConstraints.constant = 0
        addressLine2ImageViewHeightConstraints.constant = 0
        addressLine2.isHidden = true
        addressLine2ImageView.isHidden = true
        
        topNavigationView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topNavigationView.layer.shadowOpacity = 0.6
        topNavigationView.layer.shadowRadius = 3.0
        topNavigationView.layer.shadowColor = UIColor.lightGray.cgColor
        
        addressLine2.delegate = self
        addressLine2.text = "Flat No/Landmark"
        addressLine2.textColor = UIColor.lightGray
        
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationTitleLbl.text = "\(GlobalLanguageDictionary.object(forKey: "deliveryAddress") as! String)"
        saveLocationTxtLbl.text = "\(GlobalLanguageDictionary.object(forKey: "saved_locations") as! String)"
        firstNameTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "firstname") as! String)"
        lastNameTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "lastname") as! String)"
        emailTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "emailaddress") as! String)"
        mobileNumberTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "mobilenumber") as! String)"
        alternateNumTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "alternativenumber") as! String)"
        saveBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "save") as! String)", for: .normal)

        OTPHeadingLbl.text = "\(GlobalLanguageDictionary.object(forKey: "Enter_code") as! String)"
        EmailOTPHeadingLbl.text = "\(GlobalLanguageDictionary.object(forKey: "Enter_code") as! String)"
        
        OTPMessageStrLbl.text = "\(GlobalLanguageDictionary.object(forKey: "otp_msg") as! String)"
        OTPokButton.setTitle("\(GlobalLanguageDictionary.object(forKey: "verify") as! String)", for: .normal)

        EmailOTPMessageStrLbl.text = "\(GlobalLanguageDictionary.object(forKey: "email_otp_msg") as! String)"
        EmailOTPokButton.setTitle("\(GlobalLanguageDictionary.object(forKey: "verify") as! String)", for: .normal)

        
        self.navigationController?.navigationBar.isHidden = true
        if ActAsSelectedAddress != ""
        {
            addressLbl.text = ActAsSelectedAddress
        }
        if isFromManagedidSelectAddressPage == true
        {
          addressLbl.text = getAddressFromMapLocationPage
        }
        else
        {
          GlobalAddressType = ""
        }
        
        if GlobalAddressType.count == 0
        {
          addressTypeTxtLbl.text = (UserDefaults.standard.object(forKey: "GlobalAddressType") as! String)
        }
        else
        {
            addressTypeTxtLbl.text = (UserDefaults.standard.object(forKey: "GlobalAddressType") as! String)
        }
    }
    
    @IBAction func locationBtnTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MapLocationPage") as! MapLocationPage
        MapLocationPageFrom = "address"
        isFromManagedidSelectAddressPage = false
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
            let AltermobileNoStr = secondCountryCodeStr + alternateNumTxt.text!
            
            var latitude = String()
            var longitude = String()
            var zipCode = String()
            if  ActAsSelectedAddress != ""
            {
                latitude = ActAsSelectedLatitude
                longitude = ActAsSelectedLongitude
                zipCode = ActAsSelectedZipCode
            }else{
                latitude = resultDict.object(forKey: "sh_latitude")as? String ?? ""
                longitude = resultDict.object(forKey: "sh_longitude")as? String ?? ""
                zipCode = resultDict.object(forKey: "sh_zipcode")as? String ?? ""
            }
            
           let Parse = CommomParsing()
            
            Parse.updateUserShippingAddresswithotp(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"), sh_cus_fname: firstNameTxt.text!, sh_cus_lname: lastNameTxt.text!, sh_cus_email: emailTxt.text!, sh_phone1: mobileNoStr, sh_phone2: "", sh_location: addressLbl.text!, sh_latitude: latitude, sh_longitude: longitude, sh_zipcode: zipCode, sh_location1: "", otp: self.OTPTxtField.text!, current_otp: self.OTPTxtField.text!,sh_phone1_code: firstCountryCodeStr,sh_phone2_code: secondCountryCodeStr, onSuccess:
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
    
    
    func checkEmailVerificationCodeApiCall()
    {
        if self.EmailOTPTxtField.text! == ""
        {
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "email_otp_msg") as! String)")
        }
        else
        {
        self.showLoadingIndicator(senderVC: self)
            let mobileNoStr = firstCountryCodeStr + mobile_codeBtn.titleLabel!.text! + mobileNumberTxt.text!
            let AltermobileNoStr = secondCountryCodeStr + alter_codeBtn.titleLabel!.text! + alternateNumTxt.text!
            
            var latitude = String()
            var longitude = String()
            var zipCode = String()
            if  ActAsSelectedAddress != ""
            {
                latitude = ActAsSelectedLatitude
                longitude = ActAsSelectedLongitude
                zipCode = ActAsSelectedZipCode
            }else{
                latitude = resultDict.object(forKey: "sh_latitude")as? String ?? ""
                longitude = resultDict.object(forKey: "sh_longitude")as? String ?? ""
                zipCode = resultDict.object(forKey: "sh_zipcode")as? String ?? ""
            }
            
           let Parse = CommomParsing()
            
            Parse.updateUserShippingAddresswithotp(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"), sh_cus_fname: firstNameTxt.text!, sh_cus_lname: lastNameTxt.text!, sh_cus_email: emailTxt.text!, sh_phone1: mobileNoStr, sh_phone2: "", sh_location: addressLbl.text!, sh_latitude: latitude, sh_longitude: longitude, sh_zipcode: zipCode, sh_location1: "", otp: self.EmailOTPTxtField.text!, current_otp: self.EmailOTPTxtField.text!,sh_phone1_code: firstCountryCodeStr,sh_phone2_code: secondCountryCodeStr, onSuccess:
            {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.stopLoadingIndicator(senderVC: self)
                self.EmailOTPGrayView.isHidden = true
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
    
    
    //MARK:- API Methods
    func getData()
    {
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        Parse.getCustomerAddress(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"), onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                //self.resultDict.addEntries(from: (response.object(forKey: "data")as! NSDictionary) as! [AnyHashable : Any])
                self.resultDict.addEntries(from: (response.object(forKey: "data")as! NSDictionary).value(forKey: "shipping_address") as! [AnyHashable : Any])
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
        firstCountryCodeStr = "+63"
        }
        else
        {
        firstCountryCodeStr = (resultDict.object(forKey: "ship_ph1_cnty_code")as? String ?? "+63")
        }
        //firstCountryCodeStr = resultDict.object(forKey: "ship_ph1_cnty_code")as? String ?? "+63"
       secondCountryCodeStr = resultDict.object(forKey: "ship_ph2_cnty_code")as? String ?? ""
        
        mobile_codeBtn.setTitle(firstCountryCodeStr, for: .normal)
        alter_codeBtn.setTitle(secondCountryCodeStr, for: .normal)
        
//        mobileNumberTxt.text = String(numberOne.dropFirst(3))
//        alternateNumTxt.text = String(numberTwo.dropFirst(3))
        
       

        mobileNumberTxt.text = resultDict.object(forKey: "ship_ph1_no_only")as? String ?? ""
        alternateNumTxt.text = resultDict.object(forKey: "ship_ph2_no_only")as? String ?? ""
        
        addressLbl.text = (resultDict.object(forKey: "sh_location")as? String ?? "")
        
        if (resultDict.object(forKey: "sh_location1") as? String == "")
        {
            addressLine2.text = "Flat No/Landmark"
            addressLine2.textColor = UIColor.lightGray
        }
        else
        {
            addressLine2.text = (resultDict.object(forKey: "sh_location1")as? String ?? "")
            addressLine2.textColor = UIColor.darkText
        }
        

        
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
        //alloc data to dropdown
//        var ccArray = [String]()
//        ccArray.append((resultDict.object(forKey: "ship_cnty_code")as? String ?? ""))
//        countryCodeDropDown.dataSource = ccArray
//        countryCodeDropDown.anchorView = mobile_codeBtn
//        countryCodeDropDown.direction = .bottom
//        countryCodeDropDown.bottomOffset = CGPoint(x: 0, y: mobile_codeBtn.bounds.height)
//        // Action triggered on selection
//        countryCodeDropDown.selectionAction = { [weak self] (index, item) in
//            self?.mobile_codeBtn.setTitle(item, for: .normal)
//        }
//
//
//        AltercountryCodeDropDown.dataSource = ccArray
//        AltercountryCodeDropDown.anchorView = alter_codeBtn
//        AltercountryCodeDropDown.direction = .bottom
//        AltercountryCodeDropDown.bottomOffset = CGPoint(x: 0, y: alter_codeBtn.bounds.height)
//        // Action triggered on selection
//        AltercountryCodeDropDown.selectionAction = { [weak self] (index, item) in
//            self?.alter_codeBtn.setTitle(item, for: .normal)
//        }
//        mobile_codeBtn.addTarget(self, action: #selector(showMobileCCDropDown), for: .touchUpInside)
//        alter_codeBtn.addTarget(self, action: #selector(showMobileAlterCCDropDown), for: .touchUpInside)
        
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

                //self.dropDownCalling()
                
//                self.countryListDict.addEntries(from: ((response.object(forKey: "data") as? NSDictionary)?.value(forKey: "country_code_list") as! NSArray).object(at: 0) as! [AnyHashable : Any])
//                print("countryListDict : ",self.countryListDict)
//                var ccArray = [String]()
//                ccArray.append(self.countryListDict.value(forKey: "country_dial") as! String)
                
                
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
        self.countryCodeDropDown.anchorView = self.mobile_codeBtn
        self.countryCodeDropDown.direction = .bottom
        self.countryCodeDropDown.bottomOffset = CGPoint(x: 0, y: self.mobile_codeBtn.bounds.height)
        // Action triggered on selection
        self.countryCodeDropDown.selectionAction = { [weak self] (index, item) in
            //self?.mobile_codeBtn.setTitle(item, for: .normal)
            self?.mobile_codeBtn.setTitle(((self!.countryListArr1.object(at: index) as? NSDictionary)?.value(forKey: "country_dial") as! String), for: .normal)
            self?.firstCountryCodeStr = ((self!.countryListArr1.object(at: index) as? NSDictionary)?.value(forKey: "country_dial") as! String)
        }
        self.AltercountryCodeDropDown.dataSource = self.countryListArr2 as! [String]
        self.AltercountryCodeDropDown.anchorView = self.alter_codeBtn
        self.AltercountryCodeDropDown.direction = .bottom
        self.AltercountryCodeDropDown.bottomOffset = CGPoint(x: 0, y: self.alter_codeBtn.bounds.height)
            // Action triggered on selection
        self.AltercountryCodeDropDown.selectionAction = { [weak self] (index, item) in
                self?.alter_codeBtn.setTitle(((self!.countryListArr1.object(at: index) as? NSDictionary)?.value(forKey: "country_dial") as! String), for: .normal)
            self?.secondCountryCodeStr = ((self!.countryListArr1.object(at: index) as? NSDictionary)?.value(forKey: "country_dial") as! String)
        }
        self.mobile_codeBtn.addTarget(self, action: #selector(self.showMobileCCDropDown), for: .touchUpInside)
        self.alter_codeBtn.addTarget(self, action: #selector(self.showMobileAlterCCDropDown), for: .touchUpInside)
    }
    
    
    @objc func showMobileCCDropDown(sender:UIButton){
        countryCodeDropDown.show()
    }
    @objc func showMobileAlterCCDropDown(sender:UIButton){
        AltercountryCodeDropDown.show()
    }
    
    //MARK:- Button Actions
    
    @IBAction func savedLocationButtonClicked(_ sender: Any)
    {
       
        let lat = locManager.location?.coordinate.latitude
        let long = locManager.location?.coordinate.longitude
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MapLocationPage") as! MapLocationPage
       
        //changes done here
        //nextViewController.isfromMapLocationPage = true
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        isfromShippingAddressPage = true
        if navigationType == "sidebar"
        {
            self.revealViewController().pushFrontViewController(actAsBaseTabbar, animated: true)
        }
        else
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func hideAllLines(){
        firstNameLine.isHidden = true
        lastNameLine.isHidden = true
        emailLine.isHidden = true
        mobileLine.isHidden = true
        alterLine.isHidden = true
    }
    
    @IBAction func alter_codeBtnAction(_ sender: Any)
    {
        
    }
    
    @IBAction func mobile_codeBtnAction(_ sender: Any)
    {
        
    }
    
    @IBAction func saveBtnAction(_ sender: Any)
    {
        var addressStr = String()
        var latitude = String()
        var longitude = String()
        var zipCode = String()
        if  ActAsSelectedAddress != ""
        {
            addressStr = ActAsSelectedAddress
            latitude = ActAsSelectedLatitude
            longitude = ActAsSelectedLongitude
            zipCode = ActAsSelectedZipCode
        }else{
            addressStr = resultDict.object(forKey: "sh_location")as? String ?? ""
            latitude = resultDict.object(forKey: "sh_latitude")as? String ?? ""
            longitude = resultDict.object(forKey: "sh_longitude")as? String ?? ""
            zipCode = resultDict.object(forKey: "sh_zipcode")as? String ?? ""
        }
        
        if firstNameTxt.text?.count == 0 && firstNameTxt.text == "" {
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "Please enter the firstname to continue") as! String)")
        }else if lastNameTxt.text?.count == 0 && lastNameTxt.text == "" {
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "Please enter the Last name to continue") as! String)")
        }else if emailTxt.text?.count == 0 && emailTxt.text == "" {
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "Please enter the Email to continue") as! String)")
        }else if firstCountryCodeStr == "" {
            self.showToastAlert(senderVC: self, messageStr: "Please enter Mobile Country code")
        }else if mobileNumberTxt.text?.count == 0 && mobileNumberTxt.text == "" {
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "Please enter mobile number to continue") as! String)")
        }
//        else if alternateNumTxt.text != "" && secondCountryCodeStr == ""{
//            self.showToastAlert(senderVC: self, messageStr: "Please enter Alternative Mobile Country code")
//        }
        else if addressStr == "" {
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "pleaseenteraddress") as! String)")
        }
//        else if self.addressLine2.text.count == 0 {
//            self.showToastAlert(senderVC: self, messageStr: "Please enter your Flat No/Landmark")
//        }else if self.addressLine2.text == "Flat No/Landmark" {
//            self.showToastAlert(senderVC: self, messageStr: "Please enter your Flat No/Landmark")
//        }

        else
        {
            if globalCartCount != 0
            {
                let refreshAlert = UIAlertController(title: "Message from FoodToGo!", message: "\(GlobalLanguageDictionary.object(forKey: "Your cart will be emptied, if you change your address. Are you sure you want you to proceed ?") as! String)", preferredStyle: UIAlertController.Style.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
                    
//
//                    getAddressFromMapLocationPage = ((self.resultDict.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "loc_location") as! String)
//                    getLandmarkFromMapLocationPage = ((self.resultDict.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "loc_address") as! String)
//                    getLatitudeFromMapLocationPage = ((self.resultDict.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "loc_latitude") as! String)
//                    getLongitudeFromMapLocationPage = ((self.resultDict.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "loc_logitude") as! String)
//                    getZipcodeFromMapLocationPage = ((self.resultDict.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "loc_zipcode") as! String)

                    
                    
                   self.showLoadingIndicator(senderVC: self)
                   let Parse = CommomParsing()
                   Parse.saveShippingAddress(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"), search_latitude: getLatitudeFromMapLocationPage, search_longitude: getLongitudeFromMapLocationPage, zipcode: getZipcodeFromMapLocationPage, location: getAddressFromMapLocationPage, address: "", onSuccess: {
                       response in
                       print (response)
                       if response.object(forKey: "code") as! Int == 200
                       {
                        globalCartCount = 0
                        self.manuallySaveAddress()
                        //self.showSuccessPopUp(msgStr: response.object(forKey: "message")as! String)
                       }
                       else if response.object(forKey: "code")as! Int == 400
                       {
                           self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                       }
                       else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired"
                       {
                           self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                       }
                       else
                       {
                           print(response.object(forKey: "message") as Any)
                       }
                       self.stopLoadingIndicator(senderVC: self)
                   }, onFailure: {errorResponse in})
                    
                }))
                refreshAlert.addAction(UIAlertAction(title: "NO", style: .default, handler: { (action: UIAlertAction!) in
                    refreshAlert .dismiss(animated: true, completion: nil)
                }))
                
                self.present(refreshAlert, animated: true, completion: nil)
                
            }
            else
            {
            self.showLoadingIndicator(senderVC: self)
            let mobileNumber = firstCountryCodeStr + mobileNumberTxt.text!
            let alterMobileNumber = secondCountryCodeStr + alternateNumTxt.text!
            
            if isFromManagedidSelectAddressPage == true
            {
                isFromManagedidSelectAddressPage = false
                let Parse = CommomParsing()

                Parse.updateUserShippingAddress(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"),sh_cus_fname: firstNameTxt.text! ,sh_cus_lname: lastNameTxt.text!,sh_cus_email: emailTxt.text!,sh_phone1: mobileNumber,sh_phone2: "",sh_location: getAddressFromMapLocationPage,sh_latitude:getLatitudeFromMapLocationPage ,sh_longitude:getLongitudeFromMapLocationPage, sh_zipcode:getZipcodeFromMapLocationPage,sh_location1: "", sh_phone1_code: firstCountryCodeStr,sh_phone2_code: secondCountryCodeStr, onSuccess: {
                        response in
                        print (response)
                        if response.object(forKey: "code") as! Int == 200
                        {
                            login_session.setValue(getLatitudeFromMapLocationPage, forKey: "user_latitude")
                            login_session.setValue(getLongitudeFromMapLocationPage, forKey: "user_longitude")

                            isfromShippingAddressPage = true
                            self.showSuccessPopUp(msgStr: response.object(forKey: "message")as! String)
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
                        else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                            self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                        }else{
                            self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message")as! String)
                        }
                        self.stopLoadingIndicator(senderVC: self)
                    }, onFailure: {errorResponse in})
                }
            else
            {
                let Parse = CommomParsing()

                Parse.updateUserShippingAddress(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"),sh_cus_fname: firstNameTxt.text! ,sh_cus_lname: lastNameTxt.text!,sh_cus_email: emailTxt.text!,sh_phone1: mobileNumber,sh_phone2: "",sh_location: addressStr,sh_latitude:latitude ,sh_longitude:longitude, sh_zipcode:zipCode,sh_location1: "", sh_phone1_code: firstCountryCodeStr,sh_phone2_code: secondCountryCodeStr, onSuccess: {
                        response in
                        print (response)
                        if response.object(forKey: "code") as! Int == 200
                        {
                            login_session.setValue(latitude, forKey: "user_latitude")
                            login_session.setValue(longitude, forKey: "user_longitude")

                            isfromShippingAddressPage = true
                            self.showSuccessPopUp(msgStr: response.object(forKey: "message")as! String)
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
                        else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                            self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                        }else{
                            self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message")as! String)
                        }
                        self.stopLoadingIndicator(senderVC: self)
                    }, onFailure: {errorResponse in})
                }

            }
        }
            
    }
    
    
    
    func manuallySaveAddress()
    {
        //self.showLoadingIndicator(senderVC: self)
         var addressStr = String()
                var latitude = String()
                var longitude = String()
                var zipCode = String()
                if  ActAsSelectedAddress != ""
                {
                    addressStr = ActAsSelectedAddress
                    latitude = ActAsSelectedLatitude
                    longitude = ActAsSelectedLongitude
                    zipCode = ActAsSelectedZipCode
                }else{
                    addressStr = resultDict.object(forKey: "sh_location")as? String ?? ""
                    latitude = resultDict.object(forKey: "sh_latitude")as? String ?? ""
                    longitude = resultDict.object(forKey: "sh_longitude")as? String ?? ""
                    zipCode = resultDict.object(forKey: "sh_zipcode")as? String ?? ""
                }
                
                if firstNameTxt.text?.count == 0 && firstNameTxt.text == "" {
                    self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "Please enter the firstname to continue") as! String)")
                }else if lastNameTxt.text?.count == 0 && lastNameTxt.text == "" {
                    self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "Please enter the Last name to continue") as! String)")
                }else if emailTxt.text?.count == 0 && emailTxt.text == "" {
                    self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "Please enter the Email to continue") as! String)")
                }else if firstCountryCodeStr == "" {
                    self.showToastAlert(senderVC: self, messageStr: "Please enter Mobile Country code")
                }else if mobileNumberTxt.text?.count == 0 && mobileNumberTxt.text == "" {
                    self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "Please enter mobile number to continue") as! String)")
                }
       
                else if addressStr == "" {
                    self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "pleaseenteraddress") as! String)")
                }
        
        
        
        
        let mobileNumber = firstCountryCodeStr + mobileNumberTxt.text!
        //let alterMobileNumber = secondCountryCodeStr + alternateNumTxt.text!
        
        if isFromManagedidSelectAddressPage == true
        {
            isFromManagedidSelectAddressPage = false
            let Parse = CommomParsing()

            Parse.updateUserShippingAddress(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"),sh_cus_fname: firstNameTxt.text! ,sh_cus_lname: lastNameTxt.text!,sh_cus_email: emailTxt.text!,sh_phone1: mobileNumber,sh_phone2: "",sh_location: getAddressFromMapLocationPage,sh_latitude:getLatitudeFromMapLocationPage ,sh_longitude:getLongitudeFromMapLocationPage, sh_zipcode:getZipcodeFromMapLocationPage,sh_location1: "", sh_phone1_code: firstCountryCodeStr,sh_phone2_code: secondCountryCodeStr, onSuccess: {
                    response in
                    print (response)
                    if response.object(forKey: "code") as! Int == 200
                    {
                        login_session.setValue(getLatitudeFromMapLocationPage, forKey: "user_latitude")
                        login_session.setValue(getLongitudeFromMapLocationPage, forKey: "user_longitude")

                        isfromShippingAddressPage = true
                        self.showSuccessPopUp(msgStr: response.object(forKey: "message")as! String)
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
                    else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                        self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                    }else{
                        self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message")as! String)
                    }
                    self.stopLoadingIndicator(senderVC: self)
                }, onFailure: {errorResponse in})
            }
        else
        {
            let Parse = CommomParsing()

            Parse.updateUserShippingAddress(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"),sh_cus_fname: firstNameTxt.text! ,sh_cus_lname: lastNameTxt.text!,sh_cus_email: emailTxt.text!,sh_phone1: mobileNumber,sh_phone2: "",sh_location: addressStr,sh_latitude:latitude ,sh_longitude:longitude, sh_zipcode:zipCode,sh_location1: "", sh_phone1_code: firstCountryCodeStr,sh_phone2_code: secondCountryCodeStr, onSuccess: {
                    response in
                    print (response)
                    if response.object(forKey: "code") as! Int == 200
                    {
                        login_session.setValue(latitude, forKey: "user_latitude")
                        login_session.setValue(longitude, forKey: "user_longitude")

                        isfromShippingAddressPage = true
                        self.showSuccessPopUp(msgStr: response.object(forKey: "message")as! String)
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
                    else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                        self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                    }else{
                        self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message")as! String)
                    }
                    self.stopLoadingIndicator(senderVC: self)
                }, onFailure: {errorResponse in})
            }

        
    }
    
    func getCartData()
        {
            let Parse = CommomParsing()
            Parse.getMyCartData(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"), onSuccess: {
                response in
                if response.object(forKey: "code") as! Int == 200
                {
                    print (response)
                    let mod = MyCartModel(fromDictionary: response as! [String : Any])
                    Singleton.sharedInstance.MyCartModel = mod
                    self.resultDict1.addEntries(from: (response.object(forKey: "data")as! NSDictionary) as! [AnyHashable : Any])
                    globalCartCount = (((self.resultDict1.value(forKey: "cart_details") as? NSArray)?.object(at: 0) as? NSDictionary)?.value(forKey: "added_item_details") as? NSArray)!.count
                    
                }
                else if response.object(forKey: "code")as! Int == 400
                {
                 globalCartCount = 0
                }
                else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired"
                {
                    
                }
                else
                {
                    
                }
                self.stopLoadingIndicator(senderVC: self)
            }, onFailure: {errorResponse in})
        }
    
    
    
    func showSuccessPopUp(msgStr:String){
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "TruenoBd", size: 20.0)!,
            kTextFont: UIFont(name: "TruenoRg", size: 16.0)!,
            kButtonFont: UIFont(name: "TruenoRg", size: 16.0)!,
            showCloseButton: false,
            dynamicAnimatorActive: true,
            buttonsLayout: .horizontal
        )
        let alert = SCLAlertView(appearance: appearance)
        let icon = UIImage(named:"success_tick")
        let color = SuccessGreenColor
        
        let timeoutValue: TimeInterval = 2.0
        let timeoutAction: SCLAlertView.SCLTimeoutConfiguration.ActionType = {
            print("Timeout occurred")
        }
        
        _ = alert.showCustom("\(GlobalLanguageDictionary.object(forKey: "Success") as! String)", subTitle: msgStr, color: color, icon: icon!, timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: timeoutValue, timeoutAction: timeoutAction), circleIconImage: icon!)
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
            
            textView.text = "Flat No/Landmark"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.hideAllLines()
        if(textField == firstNameTxt){
            firstNameLine.isHidden = false
        }else if(textField == lastNameTxt){
            lastNameLine.isHidden = false
        }else if(textField == emailTxt){
            emailLine.isHidden = false
        }else if(textField == mobileNumberTxt){
            mobileLine.isHidden = false
        }else if(textField == alternateNumTxt){
            alterLine.isHidden = false
        }
    }

}
@available(iOS 11.0, *)
extension AddressViewController :  CLLocationManagerDelegate {
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
