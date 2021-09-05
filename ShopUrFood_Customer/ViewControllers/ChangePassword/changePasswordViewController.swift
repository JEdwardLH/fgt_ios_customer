//
//  changePasswordViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 22/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import MIBlurPopup
import  SCLAlertView

class changePasswordViewController: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var confirmLine: UIView!
    @IBOutlet weak var newLine: UIView!
    @IBOutlet weak var oldLine: UIView!
    @IBOutlet weak var goBtn: UIButton!
    @IBOutlet weak var confirmPasswordtxt: UITextField!
    @IBOutlet weak var newPasswordTxt: UITextField!
    @IBOutlet weak var oldPasswordTxt: UITextField!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var popupContentContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.goBtn.layer.cornerRadius = 25.0
        self.goBtn.clipsToBounds = true
        // Do any additional setup after loading the view.
        titleLbl.text = "\(GlobalLanguageDictionary.object(forKey: "changepassword") as! String)"
        oldPasswordTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "oldpassword") as! String)"
        newPasswordTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "newpassword") as! String)"
        confirmPasswordtxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "newconfirmpassword") as! String)"
        goBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "go") as! String)", for: .normal)

        
    }
    @IBAction func goBtnAction(_ sender: Any) {
        self.view.endEditing(true)
        if oldPasswordTxt.text?.count == 0 || oldPasswordTxt.text == ""{
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "pleaseenteryouroldpassword") as! String)")
        }else if newPasswordTxt.text?.count == 0 || newPasswordTxt.text == ""{
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "pleaseenteryournewpassword") as! String)")
        }else if confirmPasswordtxt.text?.count == 0 || confirmPasswordtxt.text == ""{
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "pleaseenteryourconfirmpassword") as! String)")
        }else if newPasswordTxt.text != confirmPasswordtxt.text {
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "passwordmismatch") as! String)")
        }else{
            self.showLoadingIndicator(senderVC: self)
            let Parse = CommomParsing()
            Parse.userResetPassword(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"),old_password: oldPasswordTxt.text!,new_password: newPasswordTxt.text!, onSuccess: {
                response in
                print (response)
                if response.object(forKey: "code") as! Int == 200{
                    self.showSuccessPopUp(msgStr: response.object(forKey: "message")as! String)
                   self.dismiss(animated: true, completion: nil)
                }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                }
                else{
                    self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message")as! String)
                }
                self.stopLoadingIndicator(senderVC: self)
            }, onFailure: {errorResponse in})
        }
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }
    
    
    // MARK: TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        oldLine.isHidden = true
        newLine.isHidden = true
        confirmLine.isHidden = true

        if textField == oldPasswordTxt{
            oldLine.isHidden = false
        }else if textField == newPasswordTxt{
            newLine.isHidden = false
        }else if textField == confirmPasswordtxt{
            confirmLine.isHidden = false
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return true
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

}
extension changePasswordViewController: MIBlurPopupDelegate {
    
    var popupView: UIView {
        return popupContentContainerView ?? UIView()
    }
    var blurEffectStyle: UIBlurEffect.Style {
        return UIBlurEffect.Style.light
    }
    var initialScaleAmmount: CGFloat {
        return 1.0
    }
    var animationDuration: TimeInterval {
        return 0.1
    }
}
