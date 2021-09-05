//
//  MyRewardsViewController.swift
//  ShopUrFood_Customer
//
//  Created by Apple3 on 13/08/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import CRRefresh

class MyRewardsViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var BGView: UIView!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var headerTxtLbl: UILabel!
    @IBOutlet weak var noRecordsLbl: UILabel!

    
    @IBOutlet weak var topBGView: UIView!
    
    @IBOutlet weak var topFirstView: UILabel!
    @IBOutlet weak var topSecondView: UILabel!
    @IBOutlet weak var topThirdView: UILabel!

    
    @IBOutlet weak var UpdatedTopFirstView: UIView!
    @IBOutlet weak var UpdatedTopSecondView: UIView!
    @IBOutlet weak var UpdatedTopThirdView: UIView!

    @IBOutlet weak var earnedPointsTxtLbl: UILabel!
    @IBOutlet weak var rewardPointsTxtLbl: UILabel!
    @IBOutlet weak var balancePointsTxtLbl: UILabel!

    @IBOutlet weak var earnedPointsNumberLbl: UILabel!
    @IBOutlet weak var rewardPointsNumberLbl: UILabel!
    @IBOutlet weak var balancePointsNumberLbl: UILabel!

    
    @IBOutlet weak var earnedPointTableView: UITableView!
    @IBOutlet weak var rewardHistoryTableView: UITableView!

    @IBOutlet weak var control2: BetterSegmentedControl!

    let appColor:UIColor = UIColor(red: 226/255, green: 28/255, blue: 38/255, alpha: 1.0)
    var pagingIndex = Int()
    var selectedIndex = Int()
    var navigationType = String()
    var earnedPointHistoryArray = NSMutableArray()
    var rewardedHistoryArray = NSMutableArray()
    
    var actionedON1 = String()
    var actionedON2 = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoadingIndicator(senderVC: self)
        selectedIndex = 0
        if revealViewController() != nil {
            self.revealViewController().rightViewRevealWidth = self.view.frame.width-60
            backBtn.addTarget(self.revealViewController(), action: Selector(("rightRevealToggle:")), for: UIControl.Event.touchUpInside)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        UpdatedTopFirstView.layer.borderWidth = 0.5
        UpdatedTopFirstView.layer.borderColor = UIColor.lightGray.cgColor
        UpdatedTopFirstView.layer.cornerRadius = 8.0
    
        UpdatedTopSecondView.layer.borderWidth = 0.5
        UpdatedTopSecondView.layer.borderColor = UIColor.lightGray.cgColor
        UpdatedTopSecondView.layer.cornerRadius = 8.0

        UpdatedTopThirdView.layer.borderWidth = 0.5
        UpdatedTopThirdView.layer.borderColor = UIColor.lightGray.cgColor
        UpdatedTopThirdView.layer.cornerRadius = 8.0
        
        control2.setIndex(0, animated: true)
        control2.segments = LabelSegment.segments(withTitles: ["\(GlobalLanguageDictionary.object(forKey: "earnedpointhistory") as! String)","\(GlobalLanguageDictionary.object(forKey: "rewardedhistory") as! String)"], normalFont: UIFont(name: "HelveticaNeue-Light", size: 14.0)!,
                                                  selectedFont: UIFont(name: "HelveticaNeue-Medium", size: 16.0)!,
                                                  selectedTextColor: appColor)
        control2.addTarget(self, action: #selector(segmentedControl1ValueChanged(_:)), for: .valueChanged)
        
        // Do any additional setup after loading the view.
        self.pagingIndex = 1
        totalRewardsWalletData()
        totalHistoryWalletData()
        

        earnedPointTableView.cr.addHeadRefresh(animator: FastAnimator()) { [weak self] in

            /// start refresh

            self?.earnedPointHistoryArray.removeAllObjects()

            self?.pagingIndex = 1

            self?.totalRewardsWalletData()

        }
        
        /// animator: your customize animator, default is NormalFootAnimator
        earnedPointTableView.cr.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
            self?.pagingIndex += 1
            self?.totalRewardsWalletData()
        }
        
        rewardHistoryTableView.cr.addHeadRefresh(animator: FastAnimator()) { [weak self] in
            
            /// start refresh
            
            self?.rewardedHistoryArray.removeAllObjects()
            
            self?.pagingIndex = 1
            
            self?.totalHistoryWalletData()
            
        }
        
        /// animator: your customize animator, default is NormalFootAnimator
        rewardHistoryTableView.cr.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
            self?.pagingIndex += 1
            self?.totalHistoryWalletData()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        headerTxtLbl.text = "\(GlobalLanguageDictionary.object(forKey: "myrewards") as! String)"
        noRecordsLbl.text = "\(GlobalLanguageDictionary.object(forKey: "norecordsfound") as! String)"

        self.navigationController?.navigationBar.isHidden = true
    }
    
//MARK:- API Methods
     func totalRewardsWalletData()
     {
     //self.showLoadingIndicator(senderVC: self)
     let Parse = CommomParsing()
     Parse.totRewardsWalletData(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"),page_no: self.pagingIndex, onSuccess: {
     response in
        print ("totRewardsWalletData :",response)
     if response.object(forKey: "code") as! Int == 200{
        DispatchQueue.main.async {
            self.stopLoadingIndicator(senderVC: self)
            
        }
     let tempDict = NSMutableDictionary()
     tempDict.addEntries(from: (response.object(forKey: "data")as! NSDictionary) as! [AnyHashable : Any])
        
      if self.pagingIndex > 1
      {
     self.earnedPointHistoryArray.addObjects(from: (tempDict.object(forKey: "earned_points_history")as! NSArray) as! [Any])
        }else
      {
        self.earnedPointHistoryArray.removeAllObjects()
        self.earnedPointHistoryArray.addObjects(from: (tempDict.object(forKey: "earned_points_history")as! NSArray) as! [Any])
      }
        
        
        if self.earnedPointHistoryArray.count == 0
        {
            self.earnedPointTableView.isHidden = true
            self.noRecordsLbl.isHidden = false
        }
        else
        {
            self.earnedPointTableView.isHidden = false
            self.noRecordsLbl.isHidden = true
        }
        
//        "totalrewardpoints": "Reward points",
//        "totalearnedpoints": "Earned points",
//        "totalbalancepoints": "Balance points",

        
        let string = "\((GlobalLanguageDictionary.object(forKey: "totalearnedpoints") as! String))\(" ")\((tempDict.object(forKey: "total_points") as! String))"
        let attributedString = NSMutableAttributedString.init(string: string)
        let range = (string as NSString).range(of: (GlobalLanguageDictionary.object(forKey: "totalearnedpoints") as! String))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkText, range: range)
        //self.topFirstView.attributedText = attributedString
        
        self.earnedPointsTxtLbl.text = (GlobalLanguageDictionary.object(forKey: "totalearnedpoints") as! String)
        self.earnedPointsNumberLbl.text = (tempDict.object(forKey: "total_points") as! String)

        
        let string1 = "\((GlobalLanguageDictionary.object(forKey: "totalrewardpoints") as! String))\(" ")\((tempDict.object(forKey: "rewarded_points") as! String))"
        let attributedString1 = NSMutableAttributedString.init(string: string1)
        let range1 = (string1 as NSString).range(of: (GlobalLanguageDictionary.object(forKey: "totalrewardpoints") as! String))
        attributedString1.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkText, range: range1)
        //self.topSecondView.attributedText = attributedString1
        
        self.rewardPointsTxtLbl.text = (GlobalLanguageDictionary.object(forKey: "totalrewardpoints") as! String)
        self.rewardPointsNumberLbl.text = (tempDict.object(forKey: "rewarded_points") as! String)
        
        let string2 = "\((GlobalLanguageDictionary.object(forKey: "totalbalancepoints") as! String))\(" ")\((tempDict.object(forKey: "balance_points") as! String))"
        let attributedString2 = NSMutableAttributedString.init(string: string2)
        let range2 = (string2 as NSString).range(of: (GlobalLanguageDictionary.object(forKey: "totalbalancepoints") as! String))
        attributedString2.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkText, range: range2)
        //self.topThirdView.attributedText = attributedString2
        
        self.balancePointsTxtLbl.text = (GlobalLanguageDictionary.object(forKey: "totalbalancepoints") as! String)
        self.balancePointsNumberLbl.text = (tempDict.object(forKey: "balance_points") as! String)
        
        self.earnedPointTableView.reloadData()
        
     //self.LoadTotalRewardsWalletData(resultDict: tempDict)
     }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
     self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
     }
     else
     {
        if self.pagingIndex > 1
        {
            self.earnedPointTableView.isHidden = false
            self.noRecordsLbl.isHidden = true
        }
        else
        {
        if self.earnedPointHistoryArray.count == 0
        {
            self.earnedPointTableView.isHidden = true
            self.noRecordsLbl.isHidden = false
        }
        else
        {
            self.earnedPointTableView.isHidden = false
            self.noRecordsLbl.isHidden = true
        }
        }
     }
     self.stopLoadingIndicator(senderVC: self)
        DispatchQueue.main.async {
            self.earnedPointTableView.cr.endHeaderRefresh()
            self.earnedPointTableView.cr.endLoadingMore()
        }
     }, onFailure: {errorResponse in})
     }
    
    
    
    func totalHistoryWalletData()
    {
        //self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        Parse.totRewardsWalletData(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"),page_no: self.pagingIndex, onSuccess: {
            response in
            print ("totalHistoryWalletData :",response)
            if response.object(forKey: "code") as! Int == 200{
                
                DispatchQueue.main.async {
                    self.stopLoadingIndicator(senderVC: self)

                }
                
                let tempDict = NSMutableDictionary()
                tempDict.addEntries(from: (response.object(forKey: "data")as! NSDictionary) as! [AnyHashable : Any])
                
                if self.pagingIndex > 1
                {
                    self.rewardedHistoryArray.addObjects(from: (tempDict.object(forKey: "rewarded_history")as! NSArray) as! [Any])
                }else
                {
                    self.rewardedHistoryArray.removeAllObjects()
                    self.rewardedHistoryArray.addObjects(from: (tempDict.object(forKey: "rewarded_history")as! NSArray) as! [Any])
                }
                
                if self.rewardedHistoryArray.count == 0
                {
                    self.rewardHistoryTableView.isHidden = true
                    //self.noRecordsLbl.isHidden = false
                }
                else
                {
                    //self.rewardHistoryTableView.isHidden = false
                    //self.noRecordsLbl.isHidden = true
                }
                
                self.rewardHistoryTableView.reloadData()
                
                //self.LoadTotalRewardsWalletData(resultDict: tempDict)
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else
            {
                if self.pagingIndex > 1
                {
                    self.rewardHistoryTableView.isHidden = false
                    self.noRecordsLbl.isHidden = true
                }
                else
                {
                if self.rewardedHistoryArray.count == 0
                {
                    self.rewardHistoryTableView.isHidden = true
                    self.noRecordsLbl.isHidden = false
                }
                else
                {
                    self.rewardHistoryTableView.isHidden = false
                    self.noRecordsLbl.isHidden = true
                }
                }
            }
            self.stopLoadingIndicator(senderVC: self)
            DispatchQueue.main.async {
                self.rewardHistoryTableView.cr.endHeaderRefresh()
                self.rewardHistoryTableView.cr.endLoadingMore()
            }
        }, onFailure: {errorResponse in})
    }
    
    
    @objc func segmentedControl1ValueChanged(_ sender: BetterSegmentedControl) {
        print("The selected index is \(sender.index)")
        selectedIndex = Int(sender.index)
        if sender.index == 0
        {
            rewardHistoryTableView.isHidden = true
            
            if earnedPointHistoryArray.count == 0
            {
                earnedPointTableView.isHidden = true
                self.noRecordsLbl.isHidden = false
            }
            else
            {
                earnedPointTableView.isHidden = false
                self.noRecordsLbl.isHidden = true
                self.earnedPointTableView.reloadData()

            }
            
        }
        else if sender.index == 1
        {
            earnedPointTableView.isHidden = true

            if rewardedHistoryArray.count == 0
            {
                rewardHistoryTableView.isHidden = true
                self.noRecordsLbl.isHidden = false
            }
            else
            {
                rewardHistoryTableView.isHidden = false
                self.noRecordsLbl.isHidden = true
                self.rewardHistoryTableView.reloadData()
                    
            }
            
        }
        
    }
    
    
    func createShadowView(getview:UIView)
    {
        //getview.layer.cornerRadius = 8
        getview.layer.shadowColor = UIColor.lightGray.cgColor
        getview.layer.shadowOpacity = 1
        getview.layer.shadowOffset = CGSize.zero
        getview.layer.shadowRadius = 3
    }
    
    //MARK:- Tableview Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if tableView == earnedPointTableView
        {
            if earnedPointHistoryArray.count > 0
            {
                return earnedPointHistoryArray.count
            }
            else
            {
                return 0
            }
        }
        else
        {
            if rewardedHistoryArray.count > 0
            {
                return rewardedHistoryArray.count
            }
            else
            {
                return 0
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == earnedPointTableView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EarnedPointHistoryCell") as? EarnedPointHistoryCell
            cell!.selectionStyle = .none
            cell!.BaseView.layer.cornerRadius = 8.0
            createShadowView(getview: cell!.BaseView)
            
            cell!.toptxtLbl.text = ((earnedPointHistoryArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "desc") as! String)
            cell!.OrderIDLbl.text = "Order ID - " + ((earnedPointHistoryArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "order_id") as! String)
            cell!.pointsEarnedLbl.text = " : " + ((earnedPointHistoryArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "points") as! String)
            
            cell!.pointsEarnedHeadingLbl.text = "\(GlobalLanguageDictionary.object(forKey: "pointsearned") as! String)"
            cell!.actionedOnHeadingLbl.text = "\(GlobalLanguageDictionary.object(forKey: "actionedon") as! String)"

            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd MMM, yyyy hh:mm a"
            
            let orderDateStringPasser = ((earnedPointHistoryArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "added_date") as! String)
            
            if let date = dateFormatterGet.date(from: orderDateStringPasser)
            {
                print(dateFormatterPrint.string(from: date))
                actionedON1 = dateFormatterPrint.string(from: date)
                
            }
            else
            {
                print("There was an error decoding the string")
            }
            
            
            
            cell!.actionedOnLbl.text = " : " + actionedON1
            
            // Adding Bottom Load
//            if indexPath.row == self.earnedPointHistoryArray.count - 1 && self.earnedPointHistoryArray.count % 10 == 0 {
//                pagingIndex += 1
//                self.totalRewardsWalletData()
//
//            }
            return cell!

        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RewardedHistoryCell") as? RewardedHistoryCell
            cell!.selectionStyle = .none
            cell!.BaseView.layer.cornerRadius = 8.0
            createShadowView(getview: cell!.BaseView)
            
            cell!.rewardedAmountLbl.text = " : " + ((rewardedHistoryArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "rewarded_amount") as! String)
            cell!.pointsEarnedLbl.text = " : " + ((rewardedHistoryArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "points") as! String)
            
            cell!.pointsEarnedHeadingLbl.text = "\(GlobalLanguageDictionary.object(forKey: "pointsearned") as! String)"
            cell!.actionedOnHeadingLbl.text = "\(GlobalLanguageDictionary.object(forKey: "actionedon") as! String)"
            cell!.rewardAmountHeadingLbl.text = "\(GlobalLanguageDictionary.object(forKey: "reward_amount") as! String)"

            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd MMM, yyyy hh:mm a"
            
            let orderDateStringPasser = ((rewardedHistoryArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "actioned_on") as! String)
            
            if let date = dateFormatterGet.date(from: orderDateStringPasser)
            {
                print(dateFormatterPrint.string(from: date))
                actionedON2 = dateFormatterPrint.string(from: date)
                
            }
            else
            {
                print("There was an error decoding the string")
            }
            
            
            cell!.actionedOnLbl.text = " : " + actionedON2
            
            // Adding Bottom Load
//            if indexPath.row == self.rewardedHistoryArray.count - 1 && self.rewardedHistoryArray.count % 10 == 0 {
//                pagingIndex += 1
//                self.totalHistoryWalletData()
//
//            }
            return cell!

        }
        
        
    }
    
}
