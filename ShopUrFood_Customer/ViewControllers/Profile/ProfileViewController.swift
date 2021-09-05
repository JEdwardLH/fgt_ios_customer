//
//  ProfileViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 07/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import AFNetworking
import SCLAlertView
import DropDown




@available(iOS 11.0, *)
class ProfileViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var customerAddressLbl: UILabel!
    @IBOutlet weak var mobileNumberTxt: UITextField!
    @IBOutlet weak var mobileNumberLbl: UILabel!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var changePhotoLbl: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var baseView: UIView!
    var imagePicker = UIImagePickerController()
    var resultDict = NSMutableDictionary()
    var userLocationStr = String()
    var userLatitude = String()
    var userLongitude = String()
    var countryListArr1 = NSMutableArray()
    var countryListArr2 = NSMutableArray()
     var firstCountryCodeStr : String = "+63"
     let countryCodeDropDown = DropDown()
    
    @IBOutlet weak var transpertantView: UIView!
    
    @IBOutlet weak var otpVerifyBtn: UIButton!
    @IBOutlet weak var numberSixLbl: UILabel!
    @IBOutlet weak var numberFiveLbl: UILabel!
    @IBOutlet weak var numberFourLbl: UILabel!
    @IBOutlet weak var numerbThreeLbl: UILabel!
    @IBOutlet weak var numberTwoLbl: UILabel!
    @IBOutlet weak var numberoneLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var addressBtn: UIButton!
    @IBOutlet weak var mobileNumberBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var userNameBtn: UIButton!
    
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

    
    
    var gettingOtp = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoadingIndicator(senderVC: self)
        //self.getCountryListData()
        self.ProfileData()
//        self.baseView.layer.cornerRadius = 10.0
//        baseView = self.setCornorShadowEffects(sender: baseView)
       
        topNavigationView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topNavigationView.layer.shadowOpacity = 0.6
        topNavigationView.layer.shadowRadius = 3.0
        topNavigationView.layer.shadowColor = UIColor.lightGray.cgColor
        userImageView.layer.cornerRadius = 50.0
        userImageView.clipsToBounds = true
        saveBtn.layer.cornerRadius = 20.0
        mobileNumberTxt.keyboardType = .numberPad
        photoBtn.layer.cornerRadius = 50.0
        photoBtn.clipsToBounds = true
        photoBtn.backgroundColor = OrangeTransperantColor
        userNameBtn.addTarget(self, action: #selector(editBtnAction), for: .touchUpInside)
        emailBtn.addTarget(self, action: #selector(editBtnAction), for: .touchUpInside)
        mobileNumberBtn.addTarget(self, action: #selector(editBtnAction), for: .touchUpInside)
        addressBtn.addTarget(self, action: #selector(editBtnAction), for: .touchUpInside)
        ActAsSelectedAddress = ""
        ActAsSelectedLatitude = ""
        ActAsSelectedLongitude = ""
        ActAsSelectedZipCode = ""
        otpVerifyBtn.layer.cornerRadius = 20.0
        otpVerifyBtn.clipsToBounds = true
        
        
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

        self.dropDownBtn.addTarget(self, action: #selector(self.showMobileCCDropDown), for: .touchUpInside)
    }
    @objc func showMobileCCDropDown(sender:UIButton){
        countryCodeDropDown.show()
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

                    self.dropDownCalling()
                    
    
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
        self.countryCodeDropDown.anchorView = self.dropDownBtn
        self.countryCodeDropDown.direction = .bottom
        self.countryCodeDropDown.bottomOffset = CGPoint(x: 0, y: self.dropDownBtn.bounds.height)
        // Action triggered on selection
        self.countryCodeDropDown.selectionAction = { [weak self] (index, item) in
            self?.dropDownBtn.setTitle(((self!.countryListArr1.object(at: index) as? NSDictionary)?.value(forKey: "country_dial") as! String), for: .normal)
            self?.firstCountryCodeStr = ((self!.countryListArr1.object(at: index) as? NSDictionary)?.value(forKey: "country_dial") as! String)
        }
    }
    
    @objc func editBtnAction(sender:UIButton){
        userNameTxt.isUserInteractionEnabled = false
        emailTxt.isUserInteractionEnabled = false
        mobileNumberTxt.isUserInteractionEnabled = false
        if sender.tag == 0{
            userNameTxt.isUserInteractionEnabled = true
            userNameTxt.becomeFirstResponder()
        }else if sender.tag == 1{
            emailTxt.isUserInteractionEnabled = true
            emailTxt.becomeFirstResponder()
        }else if sender.tag == 2{
            mobileNumberTxt.isUserInteractionEnabled = true
            mobileNumberTxt.becomeFirstResponder()
        }else if sender.tag == 3{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MapLocationPage") as! MapLocationPage
            MapLocationPageFrom = "address"
            isFromManagedidSelectAddressPage = false
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:true, completion:nil)
        }

    
    }
    
    
    //MARK:- API Methods
    func ProfileData(){
        let Parse = CommomParsing()
        Parse.getCustomerProfileInfo(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"), onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.resultDict.addEntries(from: (response.object(forKey: "data")as! NSDictionary) as! [AnyHashable : Any])
                self.setData()
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    //MARK:- LoadData to UI
    func setData(){
//        var mobileTxt = self.resultDict.object(forKey: "user_phone")as? String ?? ""
//        mobileTxt = mobileTxt.replacingOccurrences(of: "+", with: "")
        userNameTxt.text = self.resultDict.object(forKey: "user_name")as? String ?? ""
        emailTxt.text = self.resultDict.object(forKey: "user_email")as? String ?? ""
        mobileNumberTxt.text = self.resultDict.object(forKey: "user_ph1_no_only")as? String ?? ""
        firstCountryCodeStr = self.resultDict.object(forKey: "user_ph1_cnty_code")as? String ?? "+63"
        if firstCountryCodeStr == ""
        {
          firstCountryCodeStr = "+63"
        }
        dropDownBtn.setTitle(firstCountryCodeStr, for: .normal)
        userLocationStr = self.resultDict.object(forKey: "user_address")as? String ?? ""
        if userLocationStr == ""{
            addressTxt.isHidden = false
        }else{
            locationLbl.text = userLocationStr
            addressTxt.isHidden = true
        }
        let userImgeURL = URL(string: self.resultDict.object(forKey: "user_avatar")as! String)
        userImageView.kf.setImage(with: userImgeURL)
        userLatitude = self.resultDict.object(forKey: "user_latitude")as? String ?? ""
        userLongitude = self.resultDict.object(forKey: "user_longitude")as? String ?? ""
    }

    @IBAction func backBtnAction(_ sender: Any) {
        if profilepageComesFrom == "settings"{
            self.dismiss(animated: true, completion: nil)
        }else{
            self.revealViewController().pushFrontViewController(actAsBaseTabbar, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationTitleLbl.text = "\(GlobalLanguageDictionary.object(forKey: "profile") as! String)"
        userNameLbl.text = "\(GlobalLanguageDictionary.object(forKey: "username") as! String)"
        emailLbl.text = "\(GlobalLanguageDictionary.object(forKey: "email") as! String)"
        mobileNumberLbl.text = "\(GlobalLanguageDictionary.object(forKey: "mobilenumber") as! String)"
        customerAddressLbl.text = "\(GlobalLanguageDictionary.object(forKey: "customeraddress") as! String)"
        changePhotoLbl.text = "\(GlobalLanguageDictionary.object(forKey: "changephoto") as! String)"
        saveBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "save") as! String)", for: .normal)

        userNameTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "username") as! String)"
        emailTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "email") as! String)"
        mobileNumberTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "mobilenumber") as! String)"
        addressTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "address") as! String)"

        OTPHeadingLbl.text = "\(GlobalLanguageDictionary.object(forKey: "Enter_code") as! String)"
               EmailOTPHeadingLbl.text = "\(GlobalLanguageDictionary.object(forKey: "Enter_code") as! String)"
               
               OTPMessageStrLbl.text = "\(GlobalLanguageDictionary.object(forKey: "otp_msg") as! String)"
               OTPokButton.setTitle("\(GlobalLanguageDictionary.object(forKey: "verify") as! String)", for: .normal)

               EmailOTPMessageStrLbl.text = "\(GlobalLanguageDictionary.object(forKey: "email_otp_msg") as! String)"
               EmailOTPokButton.setTitle("\(GlobalLanguageDictionary.object(forKey: "verify") as! String)", for: .normal)
        
        self.navigationController?.navigationBar.isHidden = true
        if ActAsSelectedAddress != "" {
            userLocationStr = ActAsSelectedAddress
            locationLbl.text = userLocationStr
            addressTxt.isHidden = true
        }
    }
    
    
    
    @IBAction func changePhotoBtnAction(_ sender: Any) {
        let actionSheet = UIAlertController(title: "FoodToGo!", message: "Choose Image", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: - Open the camera
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "\(GlobalLanguageDictionary.object(forKey: "warning") as! String)", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Choose image from Gallery
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    //MARK: - ImagePickerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            self.userImageView.image = editedImage
            picker.dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func saveBtnAction(_ sender: Any)
    {
        let mobilenNo2 = self.resultDict.object(forKey: "user_phone2")as? String ?? ""
        
        if ActAsSelectedAddress != ""{
            userLocationStr = ActAsSelectedAddress
            userLatitude = ActAsSelectedLatitude
            userLongitude = ActAsSelectedLongitude
        }
        
        if userNameTxt.text == ""{
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "pleaseenterusername") as! String)")
        }else if emailTxt.text == "" {
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "pleaseenteremail") as! String)")
        }else if !isValidEmail(testStr: emailTxt.text!){
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "pleaseentervalidmail") as! String)")
        }else if mobileNumberTxt.text == ""{
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "pleaseentermobilenumber") as! String)")
        }else if userLocationStr == "" && ActAsSelectedAddress == ""{
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "pleaseenteraddress") as! String)")
        }
        else{

            self.showLoadingIndicator(senderVC: self)
            let mobilerNumber = mobileNumberTxt.text
        var params = NSMutableDictionary()
        params = [
            "lang": ((login_session.value(forKey: "Language") as? String) ?? "th"),
            "cus_name": "\(self.userNameTxt.text!)",
            "cus_email": "\(self.emailTxt.text!)",
            "cus_phone1": firstCountryCodeStr + mobilerNumber!,
            "cus_phone2": mobilenNo2,
            "cus_address": userLocationStr,
            "cus_lat": userLatitude,
            "cus_long" : userLongitude,
            "cus_phone1_code":firstCountryCodeStr,
            "cus_phone2_code":""
        ]
        print(params)
        let tokenString = "Bearer \(login_session.object(forKey: "user_token") as! String)"
        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = Set(["text/plain", "text/html", "application/json"]) as Set<String>?
        let finalURL = BASEURL_CUSTOMER + UPDATE_PROFILE
        manager.requestSerializer.setValue(tokenString, forHTTPHeaderField: "Authorization")
            manager.post(finalURL, parameters: params, headers: [:], constructingBodyWith: {
            (data: AFMultipartFormData!) in
                //profileImageData = self.userImageView.image.jpegData(compressionQuality: 0.5)
                //profileImageData = self.profileImagefile?.jpegData(compressionQuality: 0.5)!
            data.appendPart(withFileData: (self.userImageView.image?.pngData())!, name: "cus_image", fileName: "profile.jpeg", mimeType: "image/jpeg")
            
        }, progress: nil, success: {
            (operation, responseObject) in
            let responseDict:NSDictionary = responseObject as! NSDictionary
            print(responseDict)
            if responseDict.value(forKey: "code") as! NSNumber == 200 {
                self.showSuccessPopUp(msgStr: responseDict.object(forKey: "message") as! String)
            }else if responseDict.value(forKey: "code") as! NSNumber == 201{
                let tempDict = NSMutableDictionary()
                tempDict.addEntries(from: responseDict.object(forKey: "data") as! [AnyHashable : Any])
                
                if responseDict.value(forKey: "message") as! String == "OTP sent to your mobile. Please enter otp"
                {
                    self.OTPGrayView.isHidden = false
                    self.OTPTxtField.text = (tempDict.object(forKey: "otp") as! NSNumber).stringValue
                }
                else if responseDict.value(forKey: "message") as! String == "Verification code sent to your email. Please enter verification code"
                {
                    self.EmailOTPGrayView.isHidden = false
                    self.EmailOTPTxtField.text = (tempDict.object(forKey: "otp") as! NSNumber).stringValue

                }
                //self.showOTPVerifyView(otpNumber: (tempDict.object(forKey: "otp") as! NSNumber).stringValue)
            }
            else if responseDict.value(forKey: "code") as! NSNumber == 400 {
                if responseDict.value(forKey: "message") as! String == "Token is Expired" {
                    self.showTokenExpiredPopUp(msgStr: "Token is Expired")
                }
            }
            else {
                self.showToastAlert(senderVC: self, messageStr: responseDict.object(forKey: "message")as! String)
            }
            self.stopLoadingIndicator(senderVC: self) 
        }, failure: {
            (operation, error) in
            DispatchQueue.main.async { self.stopLoadingIndicator(senderVC: self) }
            print(error.localizedDescription)
        })
    }
    }
    
    func showOTPVerifyView(otpNumber:String){
        gettingOtp = otpNumber
        self.transpertantView.isHidden = false
        self.transpertantView.backgroundColor = BlackTranspertantColor
        numberoneLbl.layer.cornerRadius = 3.0
        numberoneLbl.layer.borderWidth = 0.5
        numberoneLbl.layer.borderColor = AppDarkOrange.cgColor
        numberTwoLbl.layer.cornerRadius = 3.0
        numberTwoLbl.layer.borderWidth = 0.5
        numberTwoLbl.layer.borderColor = AppDarkOrange.cgColor
        numerbThreeLbl.layer.cornerRadius = 3.0
        numerbThreeLbl.layer.borderWidth = 0.5
        numerbThreeLbl.layer.borderColor = AppDarkOrange.cgColor
        numberFourLbl.layer.cornerRadius = 3.0
        numberFourLbl.layer.borderWidth = 0.5
        numberFourLbl.layer.borderColor = AppDarkOrange.cgColor
        numberFiveLbl.layer.cornerRadius = 3.0
        numberFiveLbl.layer.borderWidth = 0.5
        numberFiveLbl.layer.borderColor = AppDarkOrange.cgColor
        numberSixLbl.layer.cornerRadius = 3.0
        numberSixLbl.layer.borderWidth = 0.5
        numberSixLbl.layer.borderColor = AppDarkOrange.cgColor
        let numbers = Array(otpNumber)
        numberoneLbl.text = "\(numbers[0])"
        numberTwoLbl.text = "\(numbers[1])"
        numerbThreeLbl.text = "\(numbers[2])"
        numberFourLbl.text = "\(numbers[3])"
        numberFiveLbl.text = "\(numbers[4])"
        numberSixLbl.text = "\(numbers[5])"
    }
    
    func showSuccessPopUp(msgStr:String){
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "TruenoBd", size: 20.0)!,
            kTextFont: UIFont(name: "TruenoRg", size: 16.0)!,
            kButtonFont: UIFont(name: "TruenoRg", size: 16.0)!,
            showCloseButton: false,
            dynamicAnimatorActive: false,
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
    
    @IBAction func otpVerifyBtnAction(_ sender: Any) {
        transpertantView.isHidden = true
        let mobilenNo2 = self.resultDict.object(forKey: "user_phone2")as? String ?? ""

            self.showLoadingIndicator(senderVC: self)
            
            var params = NSMutableDictionary()
            params = [
                "lang": ((login_session.value(forKey: "Language") as? String) ?? "th"),
                "cus_name": "\(self.userNameTxt.text!)",
                "cus_email": "\(self.emailTxt.text!)",
                "cus_phone1": "\(self.mobileNumberTxt.text!)",
                "cus_phone2": mobilenNo2,
                "cus_address": userLocationStr,
                "cus_lat": userLatitude,
                "cus_long" : userLongitude,
                "otp": self.OTPTxtField.text as Any,
                "current_otp":self.OTPTxtField.text as Any,
                "cus_phone1_code":firstCountryCodeStr,
                "cus_phone2_code":""
            ]
            print(params)
            let tokenString = "Bearer \(login_session.object(forKey: "user_token") as! String)"
            let manager = AFHTTPSessionManager()
            manager.responseSerializer.acceptableContentTypes = Set(["text/plain", "text/html", "application/json"]) as Set<String>?
            let finalURL = BASEURL_CUSTOMER + PROFILE_UPDATE_OTP
            manager.requestSerializer.setValue(tokenString, forHTTPHeaderField: "Authorization")
        manager.post(finalURL, parameters: params, headers: [:], constructingBodyWith: {
                (data: AFMultipartFormData!) in
                //profileImageData = self.userImageView.image.jpegData(compressionQuality: 0.5)
                //profileImageData = self.profileImagefile?.jpegData(compressionQuality: 0.5)!
                data.appendPart(withFileData: (self.userImageView.image?.pngData())!, name: "cus_image", fileName: "profile.jpeg", mimeType: "image/jpeg")
                
            }, progress: nil, success: {
                (operation, responseObject) in
                let responseDict:NSDictionary = responseObject as! NSDictionary
                print(responseDict)
                if responseDict.value(forKey: "code") as! NSNumber == 200 {
                    self.OTPGrayView.isHidden = true
                    self.showSuccessPopUp(msgStr: responseDict.object(forKey: "message") as! String)
                }else if responseDict.value(forKey: "code") as! NSNumber == 201{
                    let tempDict = NSMutableDictionary()
                    tempDict.addEntries(from: responseDict.object(forKey: "data") as! [AnyHashable : Any])
                    
                    if responseDict.value(forKey: "message") as! String == "OTP sent to your mobile. Please enter otp"
                    {
                        self.OTPGrayView.isHidden = false
                        self.OTPTxtField.text = (tempDict.object(forKey: "otp") as! NSNumber).stringValue
                    }
                    else if responseDict.value(forKey: "message") as! String == "Verification code sent to your email. Please enter verification code"
                    {
                        self.EmailOTPGrayView.isHidden = false
                        self.EmailOTPTxtField.text = (tempDict.object(forKey: "otp") as! NSNumber).stringValue

                    }
                    
                    //self.showOTPVerifyView(otpNumber: (tempDict.object(forKey: "otp") as! NSNumber).stringValue)
                }
                else if responseDict.value(forKey: "code") as! NSNumber == 400 {
                    if responseDict.value(forKey: "message") as! String == "Token is Expired" {
                        self.showTokenExpiredPopUp(msgStr: "Token is Expired")
                    }
                }
                else {
                    self.showToastAlert(senderVC: self, messageStr: responseDict.object(forKey: "message")as! String)
                }
                self.stopLoadingIndicator(senderVC: self)
            }, failure: {
                (operation, error) in
                DispatchQueue.main.async { self.stopLoadingIndicator(senderVC: self) }
                print(error.localizedDescription)
            })
    }
    
    
    
    @IBAction func emailOtpVerifyBtnAction(_ sender: Any) {
        transpertantView.isHidden = true
        let mobilenNo2 = self.resultDict.object(forKey: "user_phone2")as? String ?? ""

            self.showLoadingIndicator(senderVC: self)
            
            var params = NSMutableDictionary()
            params = [
                "lang": ((login_session.value(forKey: "Language") as? String) ?? "th"),
                "cus_name": "\(self.userNameTxt.text!)",
                "cus_email": "\(self.emailTxt.text!)",
                "cus_phone1": "\(self.mobileNumberTxt.text!)",
                "cus_phone2": mobilenNo2,
                "cus_address": userLocationStr,
                "cus_lat": userLatitude,
                "cus_long" : userLongitude,
                "otp": self.EmailOTPTxtField.text as Any,
                "current_otp":self.EmailOTPTxtField.text as Any,
                "cus_phone1_code":firstCountryCodeStr,
                "cus_phone2_code":""
            ]
            print(params)
            let tokenString = "Bearer \(login_session.object(forKey: "user_token") as! String)"
            let manager = AFHTTPSessionManager()
            manager.responseSerializer.acceptableContentTypes = Set(["text/plain", "text/html", "application/json"]) as Set<String>?
            let finalURL = BASEURL_CUSTOMER + PROFILE_UPDATE_OTP
            manager.requestSerializer.setValue(tokenString, forHTTPHeaderField: "Authorization")
        manager.post(finalURL, parameters: params, headers: [:], constructingBodyWith: {
                (data: AFMultipartFormData!) in
                //profileImageData = self.userImageView.image.jpegData(compressionQuality: 0.5)
                //profileImageData = self.profileImagefile?.jpegData(compressionQuality: 0.5)!
                data.appendPart(withFileData: (self.userImageView.image?.pngData())!, name: "cus_image", fileName: "profile.jpeg", mimeType: "image/jpeg")
                
            }, progress: nil, success: {
                (operation, responseObject) in
                let responseDict:NSDictionary = responseObject as! NSDictionary
                print(responseDict)
                if responseDict.value(forKey: "code") as! NSNumber == 200 {
                    self.EmailOTPGrayView.isHidden = true
                    self.showSuccessPopUp(msgStr: responseDict.object(forKey: "message") as! String)
                }else if responseDict.value(forKey: "code") as! NSNumber == 201{
                    let tempDict = NSMutableDictionary()
                    tempDict.addEntries(from: responseDict.object(forKey: "data") as! [AnyHashable : Any])
                    
                    if responseDict.value(forKey: "code") as! String == "OTP sent to your mobile. Please enter otp"
                    {
                        self.OTPGrayView.isHidden = false
                        self.OTPTxtField.text = (tempDict.object(forKey: "otp") as! NSNumber).stringValue
                    }
                    else if responseDict.value(forKey: "code") as! String == "Verification code sent to your email. Please enter verification code"
                    {
                        self.EmailOTPGrayView.isHidden = false
                        self.EmailOTPTxtField.text = (tempDict.object(forKey: "otp") as! NSNumber).stringValue

                    }
                    
                    //self.showOTPVerifyView(otpNumber: (tempDict.object(forKey: "otp") as! NSNumber).stringValue)
                }
                else if responseDict.value(forKey: "code") as! NSNumber == 400 {
                    if responseDict.value(forKey: "message") as! String == "Token is Expired" {
                        self.showTokenExpiredPopUp(msgStr: "Token is Expired")
                    }
                }
                else {
                    self.showToastAlert(senderVC: self, messageStr: responseDict.object(forKey: "message")as! String)
                }
                self.stopLoadingIndicator(senderVC: self)
            }, failure: {
                (operation, error) in
                DispatchQueue.main.async { self.stopLoadingIndicator(senderVC: self) }
                print(error.localizedDescription)
            })
    }
    
    
}
