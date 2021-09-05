//
//  TrackViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 05/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import CRRefresh
import Lottie
import BottomPopup
import SWRevealViewController

@available(iOS 11.0, *)
class TrackViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,BottomPopupDelegate {

    @IBOutlet weak var emptyMsgLbl: UILabel!
    @IBOutlet weak var headingLbl: UILabel!

    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var orderTable: UITableView!
    @IBOutlet weak var baseView: UIView!
    var neworderDateString = String()

    var resultsArray = NSMutableArray()
    var pagingIndex = Int()
    var firstTimeCalled = Bool()
    var maintainSelectedIndex = Int()

    
    @IBOutlet weak var orderHistoryGrayView: UIView!
    @IBOutlet weak var orderHistoryMessagePopUpView: UIView!
    @IBOutlet weak var orderHistoryOrangelineView: UIView!
    @IBOutlet weak var orderHistoryOKButton: UIButton!
    @IBOutlet weak var orderHistoryMessageLbl: UILabel!

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
        firstTimeCalled = true
        baseView = self.setCornorShadowEffects(sender: baseView)
        baseView.layer.cornerRadius = 5.0
        orderTable.layer.cornerRadius = 5.0
        // set menu Button Action
        if revealViewController() != nil {
            self.revealViewController().rightViewRevealWidth = self.view.frame.width-60
            menuBtn.addTarget(self.revealViewController(), action: Selector(("rightRevealToggle:")), for: UIControl.Event.touchUpInside)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
//        pagingIndex = 1
//        self.OrderData()

        orderHistoryGrayView.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        orderHistoryGrayView.addGestureRecognizer(tap)
        orderHistoryGrayView.isUserInteractionEnabled = true
        self.view.addSubview(orderHistoryGrayView)
        
        orderHistoryMessagePopUpView.layer.cornerRadius = 8.0
        
        orderHistoryOrangelineView.clipsToBounds = true
        orderHistoryOrangelineView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        orderHistoryOrangelineView.layer.cornerRadius = 6
        orderHistoryOrangelineView.layer.masksToBounds = true
        
        orderHistoryOKButton.layer.cornerRadius = 20.0


    }
    override func viewWillAppear(_ animated: Bool) {
        headingLbl.text = "\(GlobalLanguageDictionary.object(forKey: "orderhistory") as! String)"

        loginPopUpTitleLbl.text = "\(GlobalLanguageDictionary.object(forKey: "message") as! String)"
        loginPopUpTxtLbl.text = "\(GlobalLanguageDictionary.object(forKey: "please_login") as! String)"

        if login_session.object(forKey: "user_id") == nil
        {
            loginPopUpBGView.isHidden = false
            loginPopUpView.layer.cornerRadius = 5.0
            loginPopUpOkButton.layer.cornerRadius = 20.0
        }
        else
        {
            self.showLoadingIndicator(senderVC: self)

            loginPopUpBGView.isHidden = true
        if newOneOrderUpdated == "true"{
            newOneOrderUpdated = "false"
            pagingIndex = 1
        }
        if isfromPaymentSucessPage == true
        {
         isfromPaymentSucessPage = false
        }
        self.OrderData()
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
    
    @objc func handleTap(_ sender: UITapGestureRecognizer)
    {
        orderHistoryGrayView.isHidden = true
    }
    
    @IBAction func orderHistoryButtonAction(_ sender: Any)
    {
        orderHistoryGrayView.isHidden = true
        
    }

    
    //MARK:- API Methods
    func OrderData(){
        if pagingIndex == 1 {
            resultsArray.removeAllObjects()
        }
        let Parse = CommomParsing()
        Parse.getMyOrderData(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"),order_num: "",page_no: pagingIndex, onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200
            {
                self.resultsArray.addObjects(from: (response.object(forKey: "data")as! NSDictionary).object(forKey: "orderArray") as! [Any])
                self.orderTable.reloadData()
            }
            else if response.object(forKey: "code")as! Int == 400
            {
                self.emptyMsgLbl.text = (response.object(forKey: "message")as! String)
                self.setNoitemFound()

            }
            else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "No Orders available!" && self.pagingIndex == 1 {
                self.emptyMsgLbl.text = (response.object(forKey: "message")as! String)
                self.setNoitemFound()
            }
            else
            {
                self.emptyMsgLbl.text = (response.object(forKey: "message")as! String)
                self.setNoitemFound()

            }
            self.stopLoadingIndicator(senderVC: self)
            self.orderTable.cr.endHeaderRefresh()
            self.orderTable.cr.endLoadingMore()
        }, onFailure: {errorResponse in})
    }
    
    func setNoitemFound()  {
        if firstTimeCalled{
            firstTimeCalled = false
        emptyView.isHidden = false
        let tempView = LOTAnimationView(name: "EmptyCart")
        tempView.frame = CGRect(x:0, y:0, width: 300, height: 300
        )
        animationView.addSubview(tempView)
        
        tempView.play()
        }
        
    }
    
    //MARK:- Tableview Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if resultsArray.count != 0
        {
          return resultsArray.count
        }
        else
        {
        return 0
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryCell") as? OrderHistoryCell
        cell?.selectionStyle = .none
        
        cell?.orderIdLbl.text = "\(GlobalLanguageDictionary.object(forKey: "orderId") as! String)"
        cell?.orderOnLbl.text = "\(GlobalLanguageDictionary.object(forKey: "orderId") as! String)"
        cell?.orderDateLbl.text = "\(GlobalLanguageDictionary.object(forKey: "orderdate") as! String)"
        cell?.totalAmtLbl.text = "\(GlobalLanguageDictionary.object(forKey: "totalamount") as! String)"
        cell?.invoiceBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "invoice") as! String)", for: .normal)
        cell?.reOrderBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "repeatorder") as! String)", for: .normal)
        cell?.trackBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "track") as! String)", for: .normal)
        cell?.viewAllBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "viewall") as! String)", for: .normal)

        cell?.orderIdValueLbl.text = ((resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "orderId")as! String)
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM/dd/yyyy"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM,yyyy"
        
        let orderDateStringPasser = ((resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "orderDate")as! String)
        
        if let date = dateFormatterGet.date(from: orderDateStringPasser)
        {
            print(dateFormatterPrint.string(from: date))
            neworderDateString = dateFormatterPrint.string(from: date)
            
        }
        else
        {
            print("There was an error decoding the string")
        }
        
       // cell?.orderDateLbl.text = ((resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "orderDate")as! String)

        cell?.orderDateLbl.text = neworderDateString
        
        let currency = ((resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "ordCurrency")as! String)
        let amount = ((resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "orderAmount")as! String)
        cell?.TotalAmtValueLbl.text = "\(currency)\(amount)"
        AmountStringToShowForCustomer = "\(currency)\(amount)"
        cell?.reOrderBtn.layer.cornerRadius = 16.0
        cell?.reOrderBtn.layer.borderWidth = 0.2
        cell?.reOrderBtn.layer.borderColor = AppDarkOrange.cgColor
        
        cell?.reOrderBtn.tag = indexPath.row
        cell?.reOrderBtn.addTarget(self, action: #selector(repeatOrderBtnTapped), for: .touchUpInside)

        cell?.baseView.layer.borderWidth = 0.2
        cell?.baseView.layer.borderColor = UIColor.lightGray.cgColor
        cell?.baseView = self.setCornorShadowEffects(sender: (cell?.baseView)!)
        cell?.baseView.layer.cornerRadius = 10.0
        cell?.invoiceBtn.addTarget(self, action: #selector(invoiceBtnTapped), for: .touchUpInside)
        cell?.invoiceBtn.tag = indexPath.row
        cell?.viewAllBtn.addTarget(self, action: #selector(viewAllBtnTapped), for: .touchUpInside)
        cell?.viewAllBtn.tag = indexPath.row

        if (resultsArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "orderTrack")as! Int == 1{
            cell?.trackBtn.isHidden = false
            cell?.trackBtn.addTarget(self, action: #selector(trackOrderBtnTapped), for: .touchUpInside)
            cell?.trackBtn.tag = indexPath.row
        }else{
            cell?.trackBtn.isHidden = true
        }
        
        // Adding Bottom Load
        if indexPath.row == self.resultsArray.count - 1 && self.resultsArray.count % 10 == 0 {
            pagingIndex += 1
            self.OrderData()
            
        }
        return cell!
    }
    
    @objc func viewAllBtnTapped(sender:UIButton)
    {
        let index = sender.tag
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OrderDetailsPage") as! OrderDetailsPage
        nextViewController.orderId = (resultsArray.object(at: index) as! NSDictionary).object(forKey: "orderId")as! String
        nextViewController.orderisRejected = false
        nextViewController.isfromNotificationClick = false
        nextViewController.navigationTypeStr = "push"
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc func invoiceBtnTapped(sender:UIButton){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "InvoiceViewController") as! InvoiceViewController
        nextViewController.order_id = (resultsArray.object(at: sender.tag) as! NSDictionary).object(forKey: "orderId")as! String
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @objc func repeatOrderBtnTapped(sender:UIButton)
    {
        
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        let order_id = ((resultsArray.object(at: sender.tag)as! NSDictionary).object(forKey: "orderId")as! String)
        Parse.setRepeatOrder(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"),order_id:order_id , onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200
            {
                actAsBaseTabbar.selectedIndex = 0
//                self.revealViewController().pushFrontViewController(actAsBaseTabbar, animated: true)
            }
            else if response.object(forKey: "code")as! Int == 400
            {
                self.orderHistoryGrayView.isHidden = false
                self.orderHistoryMessageLbl.text = (response.object(forKey: "message")as! String)
            }
            else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }else{
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OrderDetailsPage") as! OrderDetailsPage
        nextViewController.orderId = (resultsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "orderId")as! String
        //self.present(nextViewController, animated:true, completion:nil)
        nextViewController.navigationTypeStr = "push"
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    @objc func trackOrderBtnTapped(sender:UIButton){
        let index = sender.tag
        maintainSelectedIndex = index
        if ((resultsArray.object(at: index)as! NSDictionary).object(forKey: "store_details")as! NSArray).count == 1{
            let tempArray = NSMutableArray()
            tempArray.addObjects(from: ((resultsArray.object(at: index)as! NSDictionary).object(forKey: "store_details")as! NSArray) as! [Any])
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "TrackingScreen") as! TrackingScreen
            //
            nextViewController.order_id = ((resultsArray.object(at: index)as! NSDictionary).object(forKey: "orderId")as! String)
            nextViewController.store_id = (tempArray.object(at: 0)as! NSDictionary).object(forKey: "store_id")as! String
            nextViewController.navigationTypeStr = "present"
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:true, completion:nil)
            
        }else{
            guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "OrderHistoryTrackingPopUpPage") as? OrderHistoryTrackingPopUpPage else { return }
            popupVC.height = 250
            popupVC.topCornerRadius = 30.0
            popupVC.presentDuration = 0.5
            popupVC.dismissDuration = 0.5
            popupVC.shouldDismissInteractivelty = true
            popupVC.popupDelegate = self
            popupVC.dataArray.addObjects(from: ((resultsArray.object(at: index)as! NSDictionary).value(forKey: "store_details")as! NSArray) as! [Any])
            present(popupVC, animated: true, completion: nil)
        }
        
    }
    
    
    //MARK:- BottomPopUpDelegate
    
    func bottomPopupViewLoaded() {
        print("bottomPopupViewLoaded")
    }
    
    func bottomPopupWillAppear() {
        print("bottomPopupWillAppear")
    }
    
    func bottomPopupDidAppear() {
        
        print("bottomPopupDidAppear")
    }
    
    func bottomPopupWillDismiss() {
        print("bottomPopupWillDismiss")
    }
    
    func bottomPopupDidDismiss() {
        print("bottomPopupDidDismiss")
        if popUpToTrackingStatus == "allow"{
            let tempArray = NSMutableArray()
            tempArray.addObjects(from: ((resultsArray.object(at: maintainSelectedIndex)as! NSDictionary).object(forKey: "store_details")as! NSArray) as! [Any])
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "TrackingScreen") as! TrackingScreen
            //
            nextViewController.order_id = ((resultsArray.object(at: maintainSelectedIndex)as! NSDictionary).object(forKey: "orderId")as! String)
            nextViewController.store_id = (tempArray.object(at: popUpToTrackingSelectedIndex)as! NSDictionary).object(forKey: "store_id")as! String
            nextViewController.navigationTypeStr = "present"
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
    
}
