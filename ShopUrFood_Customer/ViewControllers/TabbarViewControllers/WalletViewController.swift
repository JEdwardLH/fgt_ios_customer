//
//  WalletViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 05/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import Segmentio
import SWRevealViewController

class WalletViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var topContentView: UIView!
    @IBOutlet weak var walletTable: UITableView!
    @IBOutlet weak var walletHistoryLbl: UILabel!
    @IBOutlet weak var addMoneyBtn: UIButton!
    @IBOutlet weak var availableBalancePriceLbl: UILabel!
    @IBOutlet weak var availableTitleLbl: UILabel!
    @IBOutlet weak var baseContentView: UIView!
    @IBOutlet weak var navogationTitleLbl: UILabel!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var segmentioView: Segmentio!
    @IBOutlet weak var noOrdersLbl: UILabel!

    @IBOutlet weak var usedWalletTable: UITableView!
    
    @IBOutlet weak var totRewardsTable: UITableView!

    var pageIndex = Int()
    var resultsArray = NSMutableArray()
    var usedWalletResultArray = NSMutableArray()
    var totalRewardsArray = NSMutableArray()

    var totWalletCurrency = String()
    var usedwalletCurrency = String()
    var usedWalletOrderDateStr = String()

    var isfromSideBarOrNotifyPage = Bool()
    
    //LOGIN POPUP VIEW
    @IBOutlet weak var loginPopUpBGView: UIView!
    @IBOutlet weak var loginPopUpView: UIView!
    @IBOutlet weak var loginPopUpOkButton: UIButton!
    @IBOutlet weak var loginPopUpCloseButton: UIButton!
    @IBOutlet weak var loginPopUpTitleLbl: UILabel!
    @IBOutlet weak var loginPopUpTxtLbl: UILabel!

    var window: UIWindow?

    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.totalRewardsWalletData()

        topContentView.layer.cornerRadius = 5.0
//        baseContentView.layer.cornerRadius = 5.0
//        baseContentView = self.setCornorShadowEffects(sender: baseContentView)
        pageIndex = 0
        // set menu Button Action
        
        if isfromSideBarOrNotifyPage == true
        {
          isfromSideBarOrNotifyPage = false
          menuBtn.addTarget(self, action: #selector(self.menuBtnTapped), for: .touchUpInside)
        }
        else
        {
        if revealViewController() != nil {
            self.revealViewController().rightViewRevealWidth = self.view.frame.width-60
            menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.rightRevealToggle(_:)), for: UIControl.Event.touchUpInside)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        }
        addMoneyBtn.addTarget(self, action: #selector(addMoneyBtnAction), for: .touchUpInside)
        
        topNavigationView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topNavigationView.layer.shadowOpacity = 0.6
        topNavigationView.layer.shadowRadius = 3.0
        topNavigationView.layer.shadowColor = UIColor.lightGray.cgColor
        
        
        var content = [SegmentioItem]()
        
        let tornadoItem = SegmentioItem(
            title: "\(GlobalLanguageDictionary.object(forKey: "totalwallet") as! String)",
            image: UIImage(named: "wallet_selected")
        )
        let tornadoItem1 = SegmentioItem(
            title: "\(GlobalLanguageDictionary.object(forKey: "usedwallet") as! String)",
            image: UIImage(named: "wallet_selected")
        )
        
        content.append(tornadoItem)
        content.append(tornadoItem1)
        
        segmentioView.setup(content: content, style: SegmentioStyle.imageOverLabel, options: SegmentioOptions.init(backgroundColor: .white, segmentPosition: SegmentioPosition.dynamic, scrollEnabled: true, indicatorOptions: SegmentioIndicatorOptions.init(type: .bottom, ratio: 1, height: 5, color: .orange), horizontalSeparatorOptions: SegmentioHorizontalSeparatorOptions.init(type: SegmentioHorizontalSeparatorType.topAndBottom, height: 0.5, color: .groupTableViewBackground), verticalSeparatorOptions: SegmentioVerticalSeparatorOptions.init(ratio: 1, color: .groupTableViewBackground), imageContentMode: .center, labelTextAlignment: .center, labelTextNumberOfLines: 0, segmentStates: SegmentioStates(defaultState: SegmentioState.init(backgroundColor: .white, titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), titleTextColor: .lightGray),selectedState: SegmentioState(backgroundColor: .white, titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), titleTextColor: .black),highlightedState: SegmentioState(backgroundColor: UIColor.lightGray.withAlphaComponent(0.6), titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), titleTextColor: .lightGray)), animationDuration: 0.1))

        segmentioView.selectedSegmentioIndex = 0
        
        segmentioView.valueDidChange = { segmentio, segmentIndex in
            print("Selected item: ", segmentIndex)
            if segmentIndex == 0
            {
                if self.resultsArray.count == 0
                {
                    self.noOrdersLbl.isHidden = false
                    self.walletTable.isHidden = true
                    self.usedWalletTable.isHidden = true
                    self.totRewardsTable.isHidden = true

                }
                else
                {
                self.noOrdersLbl.isHidden = true
               self.walletTable.isHidden = false
               self.usedWalletTable.isHidden = true
                self.totRewardsTable.isHidden = true
                }
            }
            else
            {
                if self.usedWalletResultArray.count == 0
                {
                    self.noOrdersLbl.isHidden = false
                    self.walletTable.isHidden = true
                    self.usedWalletTable.isHidden = true
                    self.totRewardsTable.isHidden = true


                }else
                {
                self.noOrdersLbl.isHidden = true
                self.walletTable.isHidden = true
                self.usedWalletTable.isHidden = false
                self.totRewardsTable.isHidden = true
                }

            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loginPopUpTitleLbl.text = "\(GlobalLanguageDictionary.object(forKey: "message") as! String)"
        loginPopUpTxtLbl.text = "\(GlobalLanguageDictionary.object(forKey: "please_login") as! String)"

        navogationTitleLbl.text = "\(GlobalLanguageDictionary.object(forKey: "wallet") as! String)"
        availableTitleLbl.text = "\(GlobalLanguageDictionary.object(forKey: "availablebalance") as! String)"
        noOrdersLbl.text = "\(GlobalLanguageDictionary.object(forKey: "no_information") as! String)"
        if login_session.object(forKey: "user_id") == nil
        {
            loginPopUpBGView.isHidden = false
            loginPopUpView.layer.cornerRadius = 5.0
            loginPopUpOkButton.layer.cornerRadius = 20.0
        }
        else
        {
            loginPopUpBGView.isHidden = true
        self.getData()
        self.getUsedWalletData()
        }

    }
    
    
    @IBAction func loginPopUpOkBtnTapped(_ sender: Any)
    {
        self.loginPopUpBGView.isHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "NewLoginViewController")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    @IBAction func loginPopUpCloseBtnTapped(_ sender: Any)
    {
        self.loginPopUpBGView.isHidden = true
        
        if login_session.object(forKey: "user_longitude") != nil{
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "RevealRootView") as! SWRevealViewController
            tabBarSelectedIndex = 2
            self.window?.rootViewController = mainViewController
            self.window?.makeKeyAndVisible()
        }else{
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LocationOptionPage")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
    }
    
    @objc func menuBtnTapped(sender:UIButton)
    {
        if login_session.object(forKey: "user_longitude") != nil{
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "RevealRootView") as! SWRevealViewController
            tabBarSelectedIndex = 2
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
    
    @objc func addMoneyBtnAction(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ReferFriendsPageViewController") as! ReferFriendsPageViewController
        nextViewController.navigationType = "present"
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    //MARK:- API Methods
    func getData(){
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        Parse.myWalletData(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"),page_no: "1", onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                let tempDict = NSMutableDictionary()
                tempDict.addEntries(from: (response.object(forKey: "data")as! NSDictionary) as! [AnyHashable : Any])
                self.LoadTopData(resultDict: tempDict)
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    func LoadTopData(resultDict:NSMutableDictionary){
        totWalletCurrency = (resultDict.object(forKey: "currency_code") as? String ?? "")
        //let price = (resultDict.object(forKey: "available_balance")as! NSNumber).stringValue
        let price = (resultDict.object(forKey: "available_balance") as! Int)

        availableBalancePriceLbl.text = "\(totWalletCurrency)\(" ")\(price)"
        resultsArray.removeAllObjects()
        resultsArray.addObjects(from: (resultDict.object(forKey: "used_details")as! NSArray) as! [Any])
        if resultsArray.count == 0{
            walletTable.isHidden = true
            self.noOrdersLbl.isHidden = false
        }else{
            walletTable.isHidden = false
            self.noOrdersLbl.isHidden = true

        }
        walletTable.reloadData()
    }
    
    
    //MARK:- API Methods
    func getUsedWalletData(){
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        Parse.usedWalletData(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"),page_no: "1", onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                let tempDict = NSMutableDictionary()
                tempDict.addEntries(from: (response.object(forKey: "data")as! NSDictionary) as! [AnyHashable : Any])
                self.LoadUsedWalletData(resultDict: tempDict)
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    func LoadUsedWalletData(resultDict:NSMutableDictionary){
        usedwalletCurrency = (resultDict.object(forKey: "currency_code") as? String ?? "")
        usedWalletResultArray.removeAllObjects()
        usedWalletResultArray.addObjects(from: (resultDict.object(forKey: "used_details")as! NSArray) as! [Any])
        if usedWalletResultArray.count == 0{
           // usedWalletTable.isHidden = true
        }else{
            //usedWalletTable.isHidden = false
        }
        usedWalletTable.reloadData()
    }
    
   /* //MARK:- API Methods
    func totalRewardsWalletData(){
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        Parse.totRewardsWalletData(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"),page_no: "1", onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                let tempDict = NSMutableDictionary()
                tempDict.addEntries(from: (response.object(forKey: "data")as! NSDictionary) as! [AnyHashable : Any])
                self.LoadTotalRewardsWalletData(resultDict: tempDict)
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    func LoadTotalRewardsWalletData(resultDict:NSMutableDictionary){
//        let currency = (resultDict.object(forKey: "currency_code")as! String)
//        let price = (resultDict.object(forKey: "available_balance")as! NSNumber).stringValue
        totalRewardsArray.addObjects(from: (resultDict.object(forKey: "rewards")as! NSArray) as! [Any])
        if totalRewardsArray.count == 0{
            //totRewardsTable.isHidden = true
        }else{
           // totRewardsTable.isHidden = false
        }
        totRewardsTable.reloadData()
    }*/
    
    //MARK:- Tableview Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == walletTable
        {
         if resultsArray.count > 0
         {
        return resultsArray.count
         }
         else
         {
            return 0
          }
        }
        else if tableView == usedWalletTable
        {
            if usedWalletResultArray.count > 0
            {
                return usedWalletResultArray.count
            }
            else
            {
                return 0
            }
        }
        else
        {
            if totalRewardsArray.count > 0
            {
                return totalRewardsArray.count
            }
            else
            {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == walletTable
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newWalletTBCell") as? newWalletTBCell
        cell?.selectionStyle = .none
        if ((resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "type")as! String == "REFERRAL_HISTORY")
        {
            
            cell?.thirdLbl.isHidden = false
            cell?.thirdValueLbl.isHidden = false
            
            cell?.thirdLblHeightConstraints.constant = 21
            cell?.thirdValueLblHeightConstraints.constant = 21
            
            cell?.thirdLblBottomHeightConstraints.constant = 17
            cell?.thirdValueLblBottomHeightConstraints.constant = 17
            
            cell?.firstLbl.text = "\(GlobalLanguageDictionary.object(forKey: "referralemail") as! String)"
            cell?.secondLbl.text = "\(GlobalLanguageDictionary.object(forKey: "offerpercentage") as! String)"
            cell?.thirdLbl.text = "\(GlobalLanguageDictionary.object(forKey: "amountadded") as! String)"
            let firstValue = ((resultsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "order_id")as! String)
            
            let Str = (resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "order_date")
            
            if ((Str as? Int) != nil)
            {
                let secondValue = ((resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "order_date") as! NSNumber).stringValue
                cell?.secondValueLbl.text =  ":  \(secondValue)" + "%"

            }
            else
            {
                let secondValue = (resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "order_date") as! String
                cell?.secondValueLbl.text =  ":  \(secondValue)" + "%"
            }
            
            let thirdValue = totWalletCurrency + " " + ((resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "used_amount")as! String)
            cell?.firstValueLbl.text = ":  \(firstValue)"
            cell?.thirdValueLbl.text = ":  \(thirdValue)"
        }
        else
        {

            cell?.thirdLbl.isHidden = true
            cell?.thirdValueLbl.isHidden = true
            
            cell?.thirdLblHeightConstraints.constant = 0
            cell?.thirdValueLblHeightConstraints.constant = 0
            
            cell?.thirdLblBottomHeightConstraints.constant = 0
            cell?.thirdValueLblBottomHeightConstraints.constant = 0
            
            cell?.firstLbl.text = "\(GlobalLanguageDictionary.object(forKey: "walletdetail") as! String)"
            cell?.secondLbl.text = "\(GlobalLanguageDictionary.object(forKey: "walletused") as! String)"
            cell?.thirdLbl.text = "\(GlobalLanguageDictionary.object(forKey: "walletused") as! String)"
            let firstValue = ((resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "order_id")as! String)
            let secondValue = totWalletCurrency + " " + ((resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "used_amount")as! String)
            let thirdValue = totWalletCurrency + ((resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "used_amount")as! String)
            cell?.firstValueLbl.text = ":  \(firstValue)"
            cell?.secondValueLbl.text =  ":  \(secondValue)"
            cell?.thirdValueLbl.text = ":  \(thirdValue)"
        }

        return cell!
        }
        else if tableView == usedWalletTable
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newWalletTBCell") as? newWalletTBCell
            cell?.selectionStyle = .none
            

                cell?.firstLbl.text = "\(GlobalLanguageDictionary.object(forKey: "orderid") as! String)"
                cell?.secondLbl.text = "\(GlobalLanguageDictionary.object(forKey: "orderdate") as! String)"
                cell?.thirdLbl.text = "\(GlobalLanguageDictionary.object(forKey: "walletused") as! String)"
                let firstValue = ((usedWalletResultArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "order_id")as! String)
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd MMM, yyyy hh:mm a"
            
            let orderDateStringPasser = ((usedWalletResultArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "order_date")as! String)
            
            if let date = dateFormatterGet.date(from: orderDateStringPasser)
            {
                print(dateFormatterPrint.string(from: date))
                usedWalletOrderDateStr = dateFormatterPrint.string(from: date)
                
            }
            else
            {
                print("There was an error decoding the string")
            }
            let secondValue = usedWalletOrderDateStr
            
            let thirdValue = usedwalletCurrency + " " + (((usedWalletResultArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "used_amount") as! NSNumber).stringValue)
                cell?.firstValueLbl.text = ":  \(firstValue)"
                cell?.secondValueLbl.text =  ":  \(secondValue)"
                cell?.thirdValueLbl.text = ":  \(thirdValue)"
            return cell!
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newWalletTBCell") as? newWalletTBCell
            cell?.selectionStyle = .none
            
            cell?.firstLbl.text = "\(GlobalLanguageDictionary.object(forKey: "orderdetail") as! String)"
            cell?.secondLbl.text = "\(GlobalLanguageDictionary.object(forKey: "addeddate") as! String)"
            cell?.thirdLbl.text = "\(GlobalLanguageDictionary.object(forKey: "walletpoints") as! String)"
            let firstValue = ((totalRewardsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "desc")as! String)
            let secondValue = ((totalRewardsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "added_date")as! String)
            let thirdValue = ((totalRewardsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "points")as! String)
            cell?.firstValueLbl.text = ":  \(firstValue)"
            cell?.secondValueLbl.text =  ":  \(secondValue)"
            cell?.thirdValueLbl.text = ":  \(thirdValue)"
            return cell!
        }
    }
    

}
