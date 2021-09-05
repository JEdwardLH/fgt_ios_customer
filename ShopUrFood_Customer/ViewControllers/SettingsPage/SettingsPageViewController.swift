//
//  SettingsPageViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 21/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class SettingsPageViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var navigaitonTitleLbl: UILabel!
    @IBOutlet weak var baseContentView: UIView!
    @IBOutlet weak var settingsTable: UITableView!
    
    
    @IBOutlet weak var languageBGGrayView: UIView!
    @IBOutlet weak var languagePopupView: UIView!
    @IBOutlet weak var languageHeaderLbl: UILabel!
    
    @IBOutlet weak var thaiLanguageTxtLbl: UILabel!
    @IBOutlet weak var thaiLanguageButton: UIButton!
    @IBOutlet weak var thaiLanguageImage: UIImageView!

    @IBOutlet weak var englishLanguageTxtLbl: UILabel!
    @IBOutlet weak var englishLanguageButton: UIButton!
    @IBOutlet weak var englishLanguageImage: UIImageView!

    
    var imageArray = [String]()
    var nameArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // adding Image name
        imageArray.append("key")
        imageArray.append("Info_orange")
        imageArray.append("login_username")
        imageArray.append("Payment_settings")
        //imageArray.append("Language")
        imageArray.append("Terms")
        
        languagePopupView.layer.cornerRadius = 8.0
        
        
        //adding Lable Name
        nameArray.append("\(GlobalLanguageDictionary.object(forKey: "changepassword") as! String)")
        nameArray.append("\(GlobalLanguageDictionary.object(forKey: "about") as! String)")
        nameArray.append("\(GlobalLanguageDictionary.object(forKey: "profile") as! String)")
        //nameArray.append("Language")
        nameArray.append("\(GlobalLanguageDictionary.object(forKey: "paymentsettings") as! String)")
       // nameArray.append("\(GlobalLanguageDictionary.object(forKey: "language_settings") as! String)")
        nameArray.append("\(GlobalLanguageDictionary.object(forKey: "termasconditions") as! String)")
        nameArray.append("Promotional Notification")
        
        thaiLanguageTxtLbl.text = "ไทย"
//        baseContentView.layer.cornerRadius  = 10.0
//        baseContentView = self.setCornorShadowEffects(sender: baseContentView)
        
        topNavigationView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topNavigationView.layer.shadowOpacity = 0.6
        topNavigationView.layer.shadowRadius = 3.0
        topNavigationView.layer.shadowColor = UIColor.lightGray.cgColor

    }
    override func viewWillAppear(_ animated: Bool) {
        navigaitonTitleLbl.text = "\(GlobalLanguageDictionary.object(forKey: "settings") as! String)"
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func thaiLanguageBtnClicked(_ sender: Any)
    {
        self.thaiLanguageImage.image = UIImage(named: "select_radio")
        self.englishLanguageImage.image = UIImage(named: "unSelectRadio")
        login_session.setValue("th", forKey: "Language")
        languageUpdate1()
    }
    
    @IBAction func englishLanguageBtnClicked(_ sender: Any)
    {
        self.thaiLanguageImage.image = UIImage(named: "unSelectRadio")
        self.englishLanguageImage.image = UIImage(named: "select_radio")
        login_session.setValue("en", forKey: "Language")
        languageUpdate1()

    }

    func languageUpdate1()
    {
        if login_session.value(forKey: "Language") == nil
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

                }
                catch {print("Error")}
            }
        }else if login_session.value(forKey: "Language") as! String == "en" {
            login_session.setValue("en", forKey: "Language")
            if let path = Bundle.main.path(forResource: "English", ofType: "json") {
                do {
                    let fileUrl = URL(fileURLWithPath: path)
                    let myJSON = try String(contentsOf: fileUrl, encoding: .utf8)
                    let dict = convertToDictionary(text: myJSON)! as NSDictionary
                    print("JSONLoad : \(dict)")
                    GlobalLanguageDictionary.removeAllObjects()
                    GlobalLanguageDictionary.addEntries(from: dict as! [AnyHashable : Any])
                    isLanguageChanged = true
                }
                catch {print("Error")}
            }
        }else{
            login_session.setValue("th", forKey: "Language")
            if let path = Bundle.main.path(forResource: "Thai", ofType: "json") {
                do {
                    let fileUrl = URL(fileURLWithPath: path)
                    let myJSON = try String(contentsOf: fileUrl, encoding: .utf8)
                    let dict = convertToDictionary(text: myJSON)! as NSDictionary
                    print("JSONLoad : \(dict)")
                    GlobalLanguageDictionary.removeAllObjects()
                    GlobalLanguageDictionary.addEntries(from: dict as! [AnyHashable : Any])
                    isLanguageChanged = true

                }
                catch {print("Error")}
            }
        }
        
        navigaitonTitleLbl.text = "\(GlobalLanguageDictionary.object(forKey: "settings") as! String)"
        imageArray.removeAll()
        imageArray.append("key")
        imageArray.append("Info_orange")
        imageArray.append("login_username")
        imageArray.append("Payment_settings")
        imageArray.append("Language")
        imageArray.append("Terms")
        
        //adding Lable Name
        nameArray.removeAll()
        nameArray.append("\(GlobalLanguageDictionary.object(forKey: "changepassword") as! String)")
        nameArray.append("\(GlobalLanguageDictionary.object(forKey: "about") as! String)")
        nameArray.append("\(GlobalLanguageDictionary.object(forKey: "profile") as! String)")
        //nameArray.append("Language")
        nameArray.append("\(GlobalLanguageDictionary.object(forKey: "paymentsettings") as! String)")
        nameArray.append("\(GlobalLanguageDictionary.object(forKey: "language_settings") as! String)")
        nameArray.append("\(GlobalLanguageDictionary.object(forKey: "termasconditions") as! String)")
        nameArray.append("Promotional Notification")
        settingsTable.reloadData()
        
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
    
    @IBAction func languagePopUpCloseBtnClicked(_ sender: Any)
    {
        self.languageBGGrayView.isHidden = true
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.revealViewController().pushFrontViewController(actAsBaseTabbar, animated: true)
    }
    
    //MARK:- Tableview Delegate & DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count - 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTBCell") as? SettingsTBCell
        cell?.selectionStyle = .none
        cell?.rightImg.image = UIImage(named: imageArray[indexPath.row])
        cell?.nameLbl.text = nameArray[indexPath.row]
//        if indexPath.row == 6{
//            cell?.rightArrow.isHidden = true
//            cell?.switchControl.isHidden = false
//            cell?.orange_BG.isHidden = false
//            cell?.orange_BG.layer.cornerRadius = 5.0
//            cell?.orange_BG.clipsToBounds = true
//            cell?.orange_BG.image = UIImage(named: "orange_BG")
//        }else{
            cell?.rightArrow.isHidden = false
            cell?.switchControl.isHidden = true
            cell?.orange_BG.isHidden = true
        //}
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PaymentSettingsPageViewController") as! PaymentSettingsPageViewController
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:true, completion:nil)
        }else if indexPath.row == 0 {
            let PopMapVC = self.storyboard?.instantiateViewController(withIdentifier: "changePasswordViewController") as? changePasswordViewController
            PopMapVC?.modalPresentationStyle = .overFullScreen
            PopMapVC?.modalTransitionStyle = .crossDissolve
            self.present(PopMapVC!, animated: true, completion: nil)
            //MIBlurPopup.show(PopMapVC!, on: self);

        }else if indexPath.row == 1 {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AboutPageViewController") as! AboutPageViewController
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:true, completion:nil)
            
        }else if indexPath.row == 2 {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            profilepageComesFrom = "settings"
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:true, completion:nil)
            
        }else if indexPath.row == 4
        {
            if login_session.value(forKey: "Language") as! String == "en"
            {
                self.thaiLanguageImage.image = UIImage(named: "unSelectRadio")
                self.englishLanguageImage.image = UIImage(named: "select_radio")
            }
            else
            {
                self.thaiLanguageImage.image = UIImage(named: "select_radio")
                self.englishLanguageImage.image = UIImage(named: "unSelectRadio")

            }
            self.languageBGGrayView.isHidden = false
            
        }else if indexPath.row == 5 {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionsViewController
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:true, completion:nil)
            
        }
    }
}
