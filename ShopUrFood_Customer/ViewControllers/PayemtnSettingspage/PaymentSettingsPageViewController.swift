//
//  PaymentSettingsPageViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 21/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import SCLAlertView

class PaymentSettingsPageViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    @IBOutlet weak var navigationTitle: UILabel!
    
    @IBOutlet weak var paymentTable: UITableView!
    @IBOutlet weak var baseContentView: UIView!
    var paypalFlag = Bool()
    var StripeFlag = Bool()
    var NetBankingFlag = Bool()
    var resultDict = NSMutableDictionary()
    var nameArray = [String]()
    var bankDataDict = NSMutableDictionary()

    @IBOutlet weak var topNavigationView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameArray.append("\(GlobalLanguageDictionary.object(forKey: "paypal") as! String)")
        nameArray.append("\(GlobalLanguageDictionary.object(forKey: "bank_account_details") as! String)")
        paypalFlag = false
        StripeFlag = false
        NetBankingFlag = true
//        baseContentView = self.setCornorShadowEffects(sender: baseContentView)
//        baseContentView.layer.cornerRadius = 10.0
        topNavigationView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topNavigationView.layer.shadowOpacity = 0.6
        topNavigationView.layer.shadowRadius = 3.0
        topNavigationView.layer.shadowColor = UIColor.lightGray.cgColor
        self.PaymetData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationTitle.text = "\(GlobalLanguageDictionary.object(forKey: "paymentsettings") as! String)"
    }
    
    @IBAction func backbtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:- API Methods
    func PaymetData(){
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        Parse.getCustomerPaymentDetails(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"), onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                self.resultDict.addEntries(from: response.object(forKey: "data") as! [AnyHashable : Any])
                if self.resultDict.object(forKey: "paypal_status")as! String == "Publish"
                {
                    self.paypalFlag = true
                    self.bankDataDict.setValue((self.resultDict.object(forKey: "paypal_clientId")as! String), forKey: "paypal_clientId")
                   // self.bankDataDict.setValue((self.resultDict.object(forKey: "paypal_secretId")as! String), forKey: "paypal_secretId")
                }else{
                    self.bankDataDict.setValue("", forKey: "paypal_clientId")
                    //self.bankDataDict.setValue("", forKey: "paypal_secretId")
                }
//                if self.resultDict.object(forKey: "stripe_status")as! String == "Publish"
//                {
//                    self.StripeFlag = true
//                    self.bankDataDict.setValue((self.resultDict.object(forKey: "stripe_clientId")as! String), forKey: "stripe_clientId")
//                    self.bankDataDict.setValue((self.resultDict.object(forKey: "stripe_secretId")as! String), forKey: "stripe_secretId")
//                }else{
//                    self.bankDataDict.setValue("", forKey: "stripe_clientId")
//                    self.bankDataDict.setValue("", forKey: "stripe_secretId")
//                }
                if self.resultDict.object(forKey: "netBanking_status")as! String == "Publish"
                {
                    self.NetBankingFlag = true
                    self.bankDataDict.setValue((self.resultDict.object(forKey: "netBanking_accNo")as! String), forKey: "netBanking_accNo")
                    self.bankDataDict.setValue((self.resultDict.object(forKey: "netBanking_bankName")as! String), forKey: "netBanking_bankName")
                    self.bankDataDict.setValue((self.resultDict.object(forKey: "netBanking_branch")as! String), forKey: "netBanking_branch")
                    self.bankDataDict.setValue((self.resultDict.object(forKey: "netBanking_ifsc")as! String), forKey: "netBanking_ifsc")
                }else{
                    self.bankDataDict.setValue("", forKey: "netBanking_accNo")
                    self.bankDataDict.setValue("", forKey: "netBanking_bankName")
                    self.bankDataDict.setValue("", forKey: "netBanking_branch")
                    self.bankDataDict.setValue("", forKey: "netBanking_ifsc")
                }
                self.paymentTable.reloadData()
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else{
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    //MARK:- Tableview Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 0
        }else if section == 1 && NetBankingFlag {
            return 2
        }else if section == 2
        {
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 75
        }else if indexPath.section == 1 && indexPath.row == 1{
            return 240
        }else if indexPath.section == 2{
            return 70
        }else{
            return 90
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0{
            if indexPath.section == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "paymentUpdateCell") as? paymentUpdateCell
                cell?.selectionStyle = .none
                cell?.updateBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "update") as! String)", for: .normal)
                cell?.updateBtn.addTarget(self, action: #selector(updateBtnTapped), for: .touchUpInside)
                return cell!
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTitleTBCell") as? PaymentTitleTBCell
                cell?.selectionStyle = .none
                cell?.paymentSwitch.tag  = indexPath.section
                cell?.paymentSwitch.addTarget(self, action: #selector(paymentSwiftAction), for: .valueChanged)
                
                cell?.paymentCheckboxButton.tag  = indexPath.section
                cell?.paymentCheckboxButton.addTarget(self, action: #selector(paymentCheckboxButtonClicked), for: .touchUpInside)
                
                cell?.nameLbl.text = nameArray[indexPath.section]
                if indexPath.section == 0 && paypalFlag{
                    cell?.paymentSwitch.isOn = true
                    let img = UIImage(named: "selectedCheckBox")
                    cell?.paymentCheckboxButton.setImage(img , for: .normal)
                }else if indexPath.section == 1 && NetBankingFlag{
                    cell?.paymentSwitch.isOn = true
                    let img = UIImage(named: "selectedCheckBox")
                    cell?.paymentCheckboxButton.setImage(img , for: .normal)
                }else{
                    cell?.paymentSwitch.isOn = false
                    let img = UIImage(named: "checkBox")
                    cell?.paymentCheckboxButton.setImage(img , for: .normal)
                }
                return cell!
            }
        }else
        {
            if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentDetailsSecondCell") as? PaymentDetailsSecondCell
                cell?.selectionStyle = .none
                cell?.baseContentView = self.setCornorShadowEffects(sender: (cell?.baseContentView)!)
                
                cell?.fourView.isHidden = true
                cell?.ifscCodeTxt.isHidden = true
                cell?.accountNumberTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "enteraccountnumber") as! String)"
                cell?.bankNameTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "enterbankname") as! String)"
                cell?.branchNameTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "enterbranchname") as! String)"
                cell?.ifscCodeTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "enterifsc") as! String)"

                
                cell?.accountNumberTxt.text = (resultDict.object(forKey: "netBanking_accNo")as? String ?? "" )
                cell?.bankNameTxt.text = (resultDict.object(forKey: "netBanking_bankName")as? String ?? "")
                cell?.branchNameTxt.text = (resultDict.object(forKey: "netBanking_branch")as? String ?? "")
                cell?.ifscCodeTxt.text = (resultDict.object(forKey: "netBanking_ifsc")as? String ?? "")
                cell?.accountNumberTxt.tag = 15
                cell?.bankNameTxt.tag = 16
                cell?.branchNameTxt.tag = 17
                cell?.ifscCodeTxt.tag = 18

                return cell!
                
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentDetailFirstCell") as? PaymentDetailFirstCell
                cell?.selectionStyle = .none
                cell?.clientIdTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "paypalemail") as! String)"
                cell?.baseContentView = self.setCornorShadowEffects(sender: (cell?.baseContentView)!)
                if indexPath.section == 0{
                    cell?.clientIdTxt.text = (resultDict.object(forKey: "paypal_clientId")as? String ?? "")
                    cell?.clientIdTxt.tag = 11
                }
                return cell!
            }
        }
    }
    
    
    @objc func paymentSwiftAction (sender:UISwitch){
        if sender.tag == 0 {
            if paypalFlag{
                paypalFlag = false
            }else{
               paypalFlag = true
            }
        }else if sender.tag == 1 {
            if NetBankingFlag{
                NetBankingFlag = true
            }else{
                NetBankingFlag = true
            }
        }
        self.paymentTable.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
    }
    
    
    @objc func paymentCheckboxButtonClicked(sender:UIButton)
    {
      if sender.tag == 0 {
            if paypalFlag{
                paypalFlag = false
            }else{
               paypalFlag = true
            }
        }else if sender.tag == 1 {
            if NetBankingFlag{
                NetBankingFlag = true
            }else{
                NetBankingFlag = true
            }
        }
        self.paymentTable.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
    }
    
    
    // MARK: TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 11{
            self.bankDataDict.setValue(textField.text, forKey: "paypal_clientId")
        }else if textField.tag == 12{
            self.bankDataDict.setValue(textField.text, forKey: "paypal_secretId")
        }else if textField.tag == 13{
            self.bankDataDict.setValue(textField.text, forKey: "stripe_clientId")
        }else if textField.tag == 14{
            self.bankDataDict.setValue(textField.text, forKey: "stripe_secretId")
        }else if textField.tag == 15{
            self.bankDataDict.setValue(textField.text, forKey: "netBanking_accNo")
        }else if textField.tag == 16{
            self.bankDataDict.setValue(textField.text, forKey: "netBanking_bankName")
        }else if textField.tag == 17{
            self.bankDataDict.setValue(textField.text, forKey: "netBanking_branch")
        }else if textField.tag == 18{
            self.bankDataDict.setValue(textField.text, forKey: "netBanking_ifsc")
        }
        return true
    }
    
    @objc func updateBtnTapped(){
        self.view.endEditing(true)
        if !paypalFlag  && !NetBankingFlag {
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "pleasefillpaypaldetails") as! String)")
        }else if paypalFlag && (bankDataDict.object(forKey: "paypal_clientId")as! String == ""){
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "Please enter the PayPal Email") as! String)")
        }else if paypalFlag &&  isValidEmail(testStr: bankDataDict.object(forKey: "paypal_clientId")as! String) == false{
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "Please enter the valid PayPal Details") as! String)")
        }else if NetBankingFlag && (bankDataDict.object(forKey: "netBanking_accNo")as! String == "" || bankDataDict.object(forKey: "netBanking_bankName")as! String == "" || bankDataDict.object(forKey: "netBanking_branch")as! String == ""){
            self.showToastAlert(senderVC: self, messageStr: "\(GlobalLanguageDictionary.object(forKey: "Please enter the valid Bank Details") as! String)")
        }else{
            self.showLoadingIndicator(senderVC: self)
            var paypalStatus = ""
            var paypal_clientId = ""
            var paypal_sceretId = ""
            var stripeStatus = ""
            var stripe_clientId = ""
            var stripe_sceretId = ""
            var netBankStatus = ""
            var accountNumber = ""
            var bank_name = ""
            var branch_name = ""
            var ifsc = ""
            if paypalFlag{
                paypalStatus = "Publish"
                paypal_clientId = bankDataDict.object(forKey: "paypal_clientId")as! String
                paypal_sceretId = ""
            }else{
                paypalStatus = "Unpublish"
            }
            if StripeFlag{
                stripeStatus = "Publish"
                stripe_clientId = bankDataDict.object(forKey: "stripe_clientId")as! String
                stripe_sceretId = bankDataDict.object(forKey: "stripe_secretId")as! String
            }else{
                stripeStatus = "Unpublish"
            }
            
            if NetBankingFlag{
                netBankStatus = "Publish"
                accountNumber = bankDataDict.object(forKey: "netBanking_accNo")as! String
                bank_name = bankDataDict.object(forKey: "netBanking_bankName")as! String
                branch_name = bankDataDict.object(forKey: "netBanking_branch")as! String
                ifsc = bankDataDict.object(forKey: "netBanking_ifsc")as! String
            }else{
                netBankStatus = "Unpublish"
            }


            let Parse = CommomParsing()
            Parse.updateUserPaymentDetails(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"),stripe_status: stripeStatus,stripe_clientId: stripe_clientId,stripe_secretId: stripe_sceretId,paypal_status: paypalStatus,paypal_clientId: paypal_clientId,paypal_secretId: paypal_sceretId,netBanking_status: netBankStatus,netBanking_bankName: bank_name,netBanking_branch:branch_name,netBanking_accNo: accountNumber,netBanking_ifsc: "" , onSuccess: {
                response in
                print (response)
                if response.object(forKey: "code") as! Int == 200{
                   self.showSuccessPopUp(msgStr: response.object(forKey: "message")as! String)
                }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                }else if response.object(forKey: "code")as! Int == 400{
                    self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                }
                self.stopLoadingIndicator(senderVC: self)
            }, onFailure: {errorResponse in})
        }
        
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
