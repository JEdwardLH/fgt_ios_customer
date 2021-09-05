//
//  MyOffersViewController.swift
//  ShopUrFood_Customer
//
//  Created by Apple3 on 16/08/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import CRRefresh
import SWRevealViewController

class MyOffersViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var BGView: UIView!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var headerTxtLbl: UILabel!
    @IBOutlet weak var noRecordsLbl: UILabel!
    
    
    @IBOutlet weak var topBGView: UIView!
    @IBOutlet weak var topFirstView: UILabel!
    @IBOutlet weak var topSecondView: UILabel!
    @IBOutlet weak var topThirdView: UILabel!
    
    @IBOutlet weak var myOffersTableView: UITableView!
    
    let appColor:UIColor = UIColor(red: 226/255, green: 28/255, blue: 38/255, alpha: 1.0)
    var pagingIndex = Int()
    var navigationType = String()
    var expiredONLbl = String()
    var isfromNotificationClick = Bool()
    var myOffersHistoryArray = NSMutableArray()
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoadingIndicator(senderVC: self)

        if isfromNotificationClick == true
        {
          isfromNotificationClick = false
          backBtn.addTarget(self, action: #selector(self.backBtnTapped), for: .touchUpInside)
        }
        else
        {
        if revealViewController() != nil {
            self.revealViewController()?.rightViewRevealWidth = self.view.frame.width-60
            backBtn.addTarget(self.revealViewController(), action: Selector(("rightRevealToggle:")), for: UIControl.Event.touchUpInside)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
          }
        }
        
        topFirstView.layer.borderWidth = 0.5
        topFirstView.layer.borderColor = UIColor.lightGray.cgColor
        topFirstView.layer.cornerRadius = 8.0
        
        topSecondView.layer.borderWidth = 0.5
        topSecondView.layer.borderColor = UIColor.lightGray.cgColor
        topSecondView.layer.cornerRadius = 8.0
        
        topThirdView.layer.borderWidth = 0.5
        topThirdView.layer.borderColor = UIColor.lightGray.cgColor
        topThirdView.layer.cornerRadius = 8.0
        
        self.pagingIndex = 1
        myOffersData()
        // Do any additional setup after loading the view.
        
        myOffersTableView.cr.addHeadRefresh(animator: FastAnimator()) { [weak self] in

            /// start refresh

            self?.myOffersHistoryArray.removeAllObjects()

            self?.pagingIndex = 1

            self?.myOffersData()

        }
//

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @objc func backBtnTapped(sender:UIButton)
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
    
    //MARK:- API Methods
    func myOffersData()
    {
        let Parse = CommomParsing()
        Parse.myOfferData(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"),page_no: self.pagingIndex, onSuccess: {
            response in
            print ("myOfferData :",response)
            if response.object(forKey: "code") as! Int == 200{
                DispatchQueue.main.async {
                    self.stopLoadingIndicator(senderVC: self)
                }
                let tempDict = NSMutableDictionary()
                tempDict.addEntries(from: (response.object(forKey: "data")as! NSDictionary) as! [AnyHashable : Any])
                self.LoadOffersData(resultDict: tempDict)
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
            }
            self.stopLoadingIndicator(senderVC: self)
                    DispatchQueue.main.async {
                        self.myOffersTableView.cr.endHeaderRefresh()
                        self.myOffersTableView.cr.endLoadingMore()
            
                    }

        }, onFailure: {errorResponse in})
    }
    
    
    func LoadOffersData(resultDict:NSMutableDictionary)
    {
        let currency = (resultDict.object(forKey: "currency")as! String)
        //        let price = (resultDict.object(forKey: "available_balance")as! NSNumber).stringValue
        myOffersHistoryArray.addObjects(from: (resultDict.object(forKey: "coupon_data")as! NSArray) as! [Any])
        
        if myOffersHistoryArray.count == 0
        {
            myOffersTableView.isHidden = true
            topBGView.isHidden = true
            self.noRecordsLbl.isHidden = false
        }
        else
        {
            myOffersTableView.isHidden = false
            topBGView.isHidden = false
            self.noRecordsLbl.isHidden = true
        }
        
        let string = "\("Total Offers Amount")\(" ")\(currency + (resultDict.object(forKey: "total_offer_amount") as! String))"
        
        let attributedString = NSMutableAttributedString.init(string: string)
        let range = (string as NSString).range(of: "Total Offers Amount")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkText, range: range)
        self.topFirstView.attributedText = attributedString
        
        let string1 = "\("Total Used Amount")\(" ")\(currency + (resultDict.object(forKey: "used_offer_amount") as! String))"
        let attributedString1 = NSMutableAttributedString.init(string: string1)
        let range1 = (string1 as NSString).range(of: "Total Used Amount")
        attributedString1.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkText, range: range1)
        self.topSecondView.attributedText = attributedString1
        
        
        let string2 = "\("Balance Amount")\(" ")\(currency + (resultDict.object(forKey: "balance_amount") as! String))"
        let attributedString2 = NSMutableAttributedString.init(string: string2)
        let range2 = (string2 as NSString).range(of: "Balance Amount")
        attributedString2.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkText, range: range2)
        self.topThirdView.attributedText = attributedString2
        myOffersTableView.reloadData()
        
        DispatchQueue.main.async {
            self.myOffersTableView.cr.endHeaderRefresh()
            self.myOffersTableView.cr.endLoadingMore()

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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if myOffersHistoryArray.count > 0
        {
            return myOffersHistoryArray.count
        }
        else
        {
           return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOffersTableViewCell") as? MyOffersTableViewCell
        cell!.selectionStyle = .none
        cell!.BaseView.layer.cornerRadius = 8.0
        createShadowView(getview: cell!.BaseView)
            cell!.toptxtLbl.text = ((myOffersHistoryArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "name") as! String)
        cell!.SlashDownLbl.text = ((myOffersHistoryArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "desc") as! String)
        
        if ((myOffersHistoryArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "order_id") as! String) == ""
        {
           cell!.orderIDLblHeightConstraints.constant = 0
           cell!.orderIDLblLineHeightConstraints.constant = 0
            cell!.orderIDLbl.isHidden = true
        }
        else
        {
            cell!.orderIDLbl.isHidden = false
            cell!.orderIDLblHeightConstraints.constant = 21
            cell!.orderIDLblLineHeightConstraints.constant = 5
        }
        
        cell!.orderIDLbl.text = "OrderID - " + ((myOffersHistoryArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "order_id") as! String)
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy hh:mm a"
        
        let orderDateStringPasser = ((myOffersHistoryArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "expired_on") as! String)
        
        if let date = dateFormatterGet.date(from: orderDateStringPasser)
        {
            print(dateFormatterPrint.string(from: date))
            expiredONLbl = dateFormatterPrint.string(from: date)
            
        }
        else
        {
            print("There was an error decoding the string")
        }
        
            cell!.expiredOnLbl.text = " : " + expiredONLbl
        
            cell!.offerAmountLbl.text = " : " + ((myOffersHistoryArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "currency") as! String) + ((myOffersHistoryArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "price") as! String)
        cell!.statusLbl.text = " : " + ((myOffersHistoryArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "status") as! String)
       
        // Adding Bottom Load
        if indexPath.row == self.myOffersHistoryArray.count - 1 && self.myOffersHistoryArray.count % 10 == 0 {
            pagingIndex += 1
            self.myOffersData()
            
        }
        return cell!
        
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
