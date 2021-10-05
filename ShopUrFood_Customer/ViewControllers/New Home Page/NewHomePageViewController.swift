//
//  NewHomePageViewController.swift
//  ShopUrFood_Customer
//
//  Created by dineshkumarr on 02/12/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import Kingfisher
import AACarousel
import FSPagerView
import SWRevealViewController

@available(iOS 11.0, *)
class NewHomePageViewController: BaseViewController,UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource,delegateForHomeItem,delegateForHomeItem1,delegateForHomeFeatured {
    
    @IBOutlet weak var appLogo: UIImageView!
    
    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var HomeBGView: UIView!
    @IBOutlet weak var noItemsView: UIView!
    @IBOutlet weak var noItemLbl: UILabel!
    @IBOutlet weak var topHeaderNameLbl: UILabel!
    @IBOutlet weak var searchLocationBtn: UIButton!

    //
    @IBOutlet weak var homeTableView: UITableView!
    
    //Search Views
    @IBOutlet weak var searchGrayView: UIView!
    @IBOutlet weak var searchTopView: UIView!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBackButton: UIButton!
    @IBOutlet weak var searchRTextField: UITextField!
    @IBOutlet weak var menuBtn: UIButton!

    //PROMOTIONAL OFFERS VIEW
    @IBOutlet weak var promotionalOfferBGView: UIView!
    @IBOutlet weak var promotionalOfferPopupView: UIView!
    @IBOutlet weak var promotionalOfferTxtLbl: UILabel!
    @IBOutlet weak var promotionalHeaderTxtLbl: UILabel!
    @IBOutlet weak var promotionalOfferOkayButton: UIButton!
    
    
    //LOGIN POPUP VIEW
    @IBOutlet weak var loginPopUpBGView: UIView!
    @IBOutlet weak var loginPopUpView: UIView!
    @IBOutlet weak var loginPopUpOkButton: UIButton!
    @IBOutlet weak var loginPopUpCloseButton: UIButton!
    @IBOutlet weak var loginPopUpTitleLbl: UILabel!
    @IBOutlet weak var loginPopUpTxtLbl: UILabel!

    
    var window: UIWindow?
    
    var titleArray = [String]()
    var images = [UIImage]()
    var searchTxtStr:String = ""
    var pagingIndex = Int()
    var resSelectedBool = Bool()
    var resultsArray = NSMutableArray()
    var promotionOffersDict = NSMutableDictionary()
    
    var resultData = NSMutableDictionary()
    
    var allrestaurantsArray = NSMutableArray()
    var promotionsRestaurantsArray = NSMutableArray()
    var categoryArray = NSMutableArray()
    var newRestaurantsArray = NSMutableArray()
    var topRestaurantsArray = NSMutableArray()
    var ImagesArray = NSMutableArray()

    let appColor:UIColor = UIColor(red: 219/255, green: 15/255, blue: 15/255, alpha: 1.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isfromShippingAddressPage = false
        self.getHomeDataFromAPI()
        
        //self.searchGrayView.isHidden = true
        self.searchLocationBtn.layer.cornerRadius = 8.0
        
        let appimg = URL(string:"https://foodtogodeliveryph.com/public/images/logo/applogo.png")

        appLogo.kf.setImage(with: appimg)
        if login_session.object(forKey: "user_id") == nil
        {
            menuBtn.isHidden = false
            menuBtn.addTarget(self, action: #selector(self.menuBtnTapped), for: .touchUpInside)
            
        }
        else
        {
            loginPopUpBGView.isHidden = true
            menuBtn.isHidden = false
        
        if revealViewController() != nil {
            self.revealViewController().rightViewRevealWidth = self.view.frame.width-60
            menuBtn.addTarget(self.revealViewController(), action: Selector(("rightRevealToggle:")), for: UIControl.Event.touchUpInside)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        }
        
        topNavigationView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topNavigationView.layer.shadowOpacity = 0.6
        topNavigationView.layer.shadowRadius = 3.0
        topNavigationView.layer.shadowColor = UIColor.lightGray.cgColor
        
        actAsBaseTabbar = self.tabBarController!
        
        searchRTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let rectShape1 = CAShapeLayer()
        rectShape1.bounds = promotionalOfferPopupView.frame
        rectShape1.position = promotionalOfferPopupView.center
        rectShape1.path = UIBezierPath(roundedRect: promotionalOfferPopupView.bounds, byRoundingCorners: [UIRectCorner.topLeft , UIRectCorner.bottomRight], cornerRadii: CGSize.init(width: 20, height: 20)).cgPath
        let maskLayer = CAShapeLayer()
        maskLayer.frame = promotionalOfferPopupView.bounds
        maskLayer.path = rectShape1.path
        
        // Set the newly created shape layer as the mask for the image view's layer
        promotionalOfferPopupView.layer.mask = maskLayer
       
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        
        promotionalOfferOkayButton.setTitle("\(GlobalLanguageDictionary.object(forKey: "okay_got_it") as! String)", for: .normal)

        noItemLbl.text = "\(GlobalLanguageDictionary.object(forKey: "no_restaurant_found") as! String)"
        searchRTextField.placeholder = "\(GlobalLanguageDictionary.object(forKey: "menu_restaurants") as! String)"
        
        loginPopUpTitleLbl.text = "\(GlobalLanguageDictionary.object(forKey: "message") as! String)"
        loginPopUpTxtLbl.text = "\(GlobalLanguageDictionary.object(forKey: "please_login") as! String)"

        
        let string = "FoodToGo!"
        let attributedString = NSMutableAttributedString.init(string: string)
        let range = (string as NSString).range(of: "\(GlobalLanguageDictionary.object(forKey: "are_you") as! String)")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
       // self.topHeaderNameLbl.attributedText = attributedString
        
//        locationLbl.text = (login_session.object(forKey: "user_address")as! String)
//        self.topUserNameLbl.text = self.greetingLogic()
        self.navigationController?.navigationBar.isHidden = true
        if isfromShippingAddressPage
        {
          isfromShippingAddressPage = false
          getHomeDataFromAPI()
        }
        if isLanguageChanged
        {
          isLanguageChanged = false
          getHomeDataFromAPI()
        }
        
        if login_session.object(forKey: "user_id") != nil
        {
        
        let cartCount = login_session.object(forKey: "userCartCount")as! String
        if (cartCount == "0"){
             actAsBaseTabbar.tabBar.items?[0].badgeValue = nil
        }else{
            actAsBaseTabbar.tabBar.items?[0].badgeValue = cartCount
            actAsBaseTabbar.tabBar.items?[0].badgeColor = AppDarkOrange
        }
        }
    }

    
    
    @objc func menuBtnTapped(sender:UIButton)
    {
        loginPopUpBGView.isHidden = false
        loginPopUpView.layer.cornerRadius = 5.0
        loginPopUpOkButton.layer.cornerRadius = 20.0
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
    }
    
    //MARK:- UITableView Delegate & DataSource Methods
       
       func numberOfSections(in tableView: UITableView) -> Int
       {
        if tableView == searchTableView
        {
           if self.resultsArray.count > 0
           {
           return resultsArray.count
           }
           else
           {
           return 0
           }
        }
        else
        {
           return 9
        }
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
       {
        if tableView == searchTableView
        {
           return ((self.resultsArray[section] as AnyObject).value(forKey: "item_list") as! NSArray).count + 1
        }
        else
         {
            if self.resultData.count != 0
            {
                if section == 8
                {
                 return ((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "all_restaurant")as! NSArray).count
                }
                else if section == 0
                {
                   if ((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "featured_restaurant") as! NSArray).count == 0
                   {
                    return 0
                    }
                    else
                    {
                    return 1
                    }
                }
                else if section == 1
                {
                   if ((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "recent_orders")as! NSArray).count == 0
                   {
                    return 0
                    }
                    else
                   {
                    return 1
                    }
                }
                else
                {
                  return 1
                }
                
            }
            else
            {
               return 0
            }
         }
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
       {
        
        if tableView == searchTableView
        {
        
           if indexPath.row == 0
           {
           let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantListTableViewCell") as? RestaurantListTableViewCell
           cell?.selectionStyle = .none
           cell?.restaurantSelectedButtons.tag = indexPath.section
         cell?.restaurantSelectedButtons.addTarget(self,action:#selector(restaurantBtnClicked(sender:)), for: .touchUpInside)

           cell?.restaurantNameLbl.text = ((self.resultsArray[indexPath.section] as AnyObject).value(forKey: "store_name") as? String)
           return cell!
           }
           else
           {
               let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListTableViewCell") as? ItemListTableViewCell
               cell?.selectionStyle = .none
               cell?.itemNameLbl.text = ((((self.resultsArray[indexPath.section] as AnyObject).value(forKey: "item_list") as! NSArray).object(at: indexPath.row - 1) as! NSDictionary).value(forKey: "item_name") as? String ?? "")

               return cell!
           }
       }
        else
        {
            
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeBannerCell") as? HomeBannerCell
                cell?.selectionStyle = .none
                cell?.contentView.backgroundColor = UIColor.clear
                cell?.getOffersList(offersListArray: self.ImagesArray)
            cell?.getbannerRestaurant(bannerrestListArray:((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "featured_restaurant") as! NSArray))
                return cell!
            }
            
            else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecentOrdersTableViewCell") as? RecentOrdersTableViewCell
                cell?.selectionStyle = .none
                cell?.nameLbl.text = "\(GlobalLanguageDictionary.object(forKey: "recent_orders") as! String)"

                let localArray = NSMutableArray()
                localArray.addObjects(from: ((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "recent_orders")as! NSArray) as! [Any])
                cell?.delegate = self
                cell?.getData(tempArray: localArray)
                cell?.contentView.backgroundColor = UIColor.clear
                return cell!
            }
            else if indexPath.section == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeItemTBCell") as? HomeItemTBCell
                cell?.selectionStyle = .none
                cell?.viewAllBtn.tag = indexPath.section
                cell?.viewAllBtn.addTarget(self, action: #selector(viewAllBtnTapped), for: .touchUpInside)
                cell?.viewAllBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "viewall") as! String)", for: .normal)

                cell?.nameLbl.text = "\(GlobalLanguageDictionary.object(forKey: "new_res") as! String)"
                cell?.nameLbl.textColor = UIColor.darkGray
                cell?.viewAllBtn.setTitleColor(AppLightOrange, for: .normal)
                
                let localArray = NSMutableArray()
                localArray.addObjects(from: ((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "new_restaurant")as! NSArray) as! [Any])
                
                cell?.getData(tempArray: localArray)
                cell?.contentView.backgroundColor = UIColor.white
                cell?.delegate = self
                return cell!
            }
            else if indexPath.section == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeItemTBCell") as? HomeItemTBCell
                cell?.selectionStyle = .none
                cell?.viewAllBtn.tag = indexPath.section
                cell?.viewAllBtn.addTarget(self, action: #selector(viewAllBtnTapped), for: .touchUpInside)
                cell?.viewAllBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "viewall") as! String)", for: .normal)

                cell?.nameLbl.text = "\(GlobalLanguageDictionary.object(forKey: "top_res") as! String)"
                cell?.nameLbl.textColor = UIColor.darkGray
                cell?.viewAllBtn.setTitleColor(AppLightOrange, for: .normal)
                
                let localArray = NSMutableArray()
                localArray.addObjects(from: ((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "top_restaurant")as! NSArray) as! [Any])
                
                cell?.getData(tempArray: localArray)
                cell?.contentView.backgroundColor = UIColor.white
                cell?.delegate = self
                return cell!
            }
            
            else if indexPath.section == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedStoresTBCell") as? FeaturedStoresTBCell
                cell?.selectionStyle = .none
                cell?.nameLbl.text = "\(GlobalLanguageDictionary.object(forKey: "categories") as! String)"
                cell?.viewAllBtn.isHidden = true
                let localArray = NSMutableArray()
                localArray.addObjects(from: ((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "category_list")as! NSArray) as! [Any])
                cell?.delegate = self
                cell?.getData(tempArray: localArray)
                return cell!
            }
                else if indexPath.section == 5 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HomeItemTBCell") as? HomeItemTBCell
                    cell?.selectionStyle = .none
                    cell?.viewAllBtn.tag = indexPath.section
                    cell?.viewAllBtn.addTarget(self, action: #selector(viewAllBtnTapped), for: .touchUpInside)
                    cell?.viewAllBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "viewall") as! String)", for: .normal)

                    cell?.nameLbl.text = "\(GlobalLanguageDictionary.object(forKey: "promotion") as! String)"
                    cell?.nameLbl.textColor = UIColor.darkGray
                    cell?.viewAllBtn.setTitleColor(AppLightOrange, for: .normal)
                    
                    let localArray = NSMutableArray()
                    localArray.addObjects(from: ((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "featured_restaurant")as! NSArray) as! [Any])
                    
                    cell?.getData(tempArray: localArray)
                    cell?.contentView.backgroundColor = UIColor.white
                    cell?.delegate = self
                    return cell!
                }
            else if indexPath.section == 6 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HomeItemTBCell") as? HomeItemTBCell
                    cell?.selectionStyle = .none
                    cell?.viewAllBtn.tag = indexPath.section
                    cell?.viewAllBtn.addTarget(self, action: #selector(viewAllBtnTapped), for: .touchUpInside)
                cell?.viewAllBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "viewall") as! String)", for: .normal)

                    cell?.nameLbl.text = "\(GlobalLanguageDictionary.object(forKey: "near_by") as! String)"
                    cell?.nameLbl.textColor = UIColor.darkGray
                    cell?.viewAllBtn.setTitleColor(AppLightOrange, for: .normal)
                    
                    let localArray = NSMutableArray()
                    localArray.addObjects(from: ((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "nearby_restaurant")as! NSArray) as! [Any])
                    
                    cell?.getData(tempArray: localArray)
                    cell?.contentView.backgroundColor = UIColor.white
                    cell?.delegate = self
                    return cell!
                }
                
            else if indexPath.section == 7
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "allRestaurantsTitleCell") as? allRestaurantsTitleCell
                cell?.selectionStyle = .none
                cell?.viewAllBtn.tag = indexPath.row
                cell?.viewAllBtn.addTarget(self, action: #selector(viewAllRestauranBtnTapped), for: .touchUpInside)
                cell?.viewAllBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "viewall") as! String)", for: .normal)

                cell?.nameLbl.text = "\(GlobalLanguageDictionary.object(forKey: "allrestaurants") as! String)"
                cell?.nameLbl.textColor = UIColor.darkGray
                cell?.viewAllBtn.setTitleColor(AppLightOrange, for: .normal)
                return cell!
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "allRestaurantsDetailCell") as? allRestaurantsDetailCell
                cell?.selectionStyle = .none
                cell?.baseView.layer.cornerRadius = 5.0
                cell?.baseView.layer.borderWidth = 1.0
                cell?.baseView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
                cell?.baseView.layer.masksToBounds = true

                
                let string = "\(GlobalLanguageDictionary.object(forKey: "FREE_DELIVERY") as! String)"
                let attributedString = NSMutableAttributedString.init(string: string)
                let range = (string as NSString).range(of: "\(GlobalLanguageDictionary.object(forKey: "FREE") as! String)")
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: appColor, range: range)
                cell?.freeDeliveryLbl.attributedText = attributedString
                
                if ((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "delivery_fee_status") as! NSNumber) == 0
                {
                    cell?.freeDeliveryLbl.isHidden = false
                    cell?.freeDeliveryImageview.isHidden = false

                }
                else
                {
                   cell?.freeDeliveryLbl.isHidden = true
                   cell?.freeDeliveryImageview.isHidden = true
                }
                
                let shop_img = URL(string: (((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "all_restaurant") as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "restaurant_logo") as! String)
//                cell?.deliveryTimeLbl.layer.cornerRadius = 8.0
//                cell?.deliveryTimeLbl.layer.masksToBounds = true
                cell?.logoImage.kf.setImage(with: shop_img)

                
                cell?.nameLbl.text = ((((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "all_restaurant") as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "restaurant_name") as! String)
                cell?.categoryNameLbl.text = ((((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "all_restaurant") as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "restaurant_category") as? String) ?? ""
                cell?.openTimeLbl.text = ((((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "all_restaurant") as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "today_wking_time") as! String)
                cell?.deliveryTimeLbl.text = "\(((((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "all_restaurant") as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "delivery_duration") as! NSNumber))"
                cell?.deliveryMinLbl.text =  "\(GlobalLanguageDictionary.object(forKey: "min") as! String)"

                if ((((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "all_restaurant") as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "restaurant_rating") as! Int) == 0
                {
                    cell?.ratingStar.isHidden = false
                    cell?.ratingImageView.isHidden = false
                    cell?.ratingCountLbl.isHidden = true
                }
                else
                {
                    cell?.ratingStar.isHidden = true
                    cell?.ratingCountLbl.isHidden = false
                    cell?.ratingImageView.isHidden = false
                    cell?.ratingCountLbl.text = String(format: "%d", ((((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "all_restaurant") as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "restaurant_rating") as! Int))
                }

                return cell!
            }
            
        }
    }

       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
       {
           print(indexPath.section)
           print(indexPath.row)
           
        if tableView == searchTableView
        {
        
           if indexPath.row > 0
           {
           let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
          
           let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FoodDetailsPage") as! FoodDetailsPage
           nextViewController.item_id = ((((self.resultsArray[indexPath.section] as AnyObject).value(forKey: "item_list") as! NSArray).object(at: indexPath.row - 1) as! NSDictionary).value(forKey: "item_id") as! String)
           nextViewController.itemName = ((((self.resultsArray[indexPath.section] as AnyObject).value(forKey: "item_list") as! NSArray).object(at: indexPath.row - 1) as! NSDictionary).value(forKey: "item_name") as! String)
           nextViewController.restaurant_id = ((((self.resultsArray[indexPath.section] as AnyObject).value(forKey: "store_id") as? NSNumber)!.stringValue))
            nextViewController.modalPresentationStyle = .fullScreen
           self.present(nextViewController, animated:true, completion:nil)
           }
        }
        else
        {
            if indexPath.section == 8
            {
                self.passHomeItem(storeName: ((((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "all_restaurant") as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "restaurant_name") as! String), restId: (((((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "all_restaurant") as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "restaurant_id") as! NSNumber).stringValue))
            }
        }
     }
    
    
    @objc func restaurantBtnClicked(sender:UIButton)
    {
       let buttonRow = sender.tag
       print("buttonRow is:",buttonRow)
       
       let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
       let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RestaurantInfoViewController") as! RestaurantInfoViewController
       nextViewController.rest_id = ((((self.resultsArray[buttonRow] as AnyObject).value(forKey: "store_id") as? NSNumber)!.stringValue))
       nextViewController.storeName = (((self.resultsArray[buttonRow] as AnyObject).value(forKey: "store_name") as? String)!)
        nextViewController.modalPresentationStyle = .fullScreen
       self.present(nextViewController, animated:true, completion:nil)
    }
    
    @objc func viewAllRestauranBtnTapped(sender:UIButton)
    {
        actAsBaseTabbar.selectedIndex = 1
    }
    
    
    @objc func viewAllBtnTapped(sender:UIButton)
    {
       
//        http://demo5.pofi5.com/api/customer/all_recent_orders
//        http://demo5.pofi5.com/api/customer/top_restaurant_list
//        http://demo5.pofi5.com/api/customer/new_restaurant_list
//        http://demo5.pofi5.com/api/customer/nearby_restaurant_list
//        http://demo5.pofi5.com/api/customer/featured_restaurant_list
//
        if sender.tag == 2
        {
          let nav = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllDetailsPage") as? ViewAllDetailsPage
          nav?.common_view_all_str = "new_restaurant_list"
          nav?.categoryName = "New Restaurant"
          nav?.isfromCategory = false
          self.navigationController?.pushViewController(nav!, animated: true)
        }
        if sender.tag == 3
               {
                 let nav = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllDetailsPage") as? ViewAllDetailsPage
                 nav?.common_view_all_str = "top_restaurant_list"
                 nav?.categoryName = "Top Restaurant"
                nav?.isfromCategory = false
                   self.navigationController?.pushViewController(nav!, animated: true)
               }
        
        if sender.tag == 5
               {
                 let nav = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllDetailsPage") as? ViewAllDetailsPage
                 nav?.common_view_all_str = "featured_restaurant_list"
                 nav?.categoryName = "Promotions"
                nav?.isfromCategory = false
                   self.navigationController?.pushViewController(nav!, animated: true)
               }
        
        if sender.tag == 6
               {
                 let nav = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllDetailsPage") as? ViewAllDetailsPage
                 nav?.common_view_all_str = "nearby_restaurant_list"
                 nav?.categoryName = "Nearby Restaurant"
                nav?.isfromCategory = false
                   self.navigationController?.pushViewController(nav!, animated: true)
               }
        
//        if sender.tag == 0 {
//            actAsBaseTabbar.selectedIndex = 1
//        }
//        else
//        {
//            let nav = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllDetailsPage") as? ViewAllDetailsPage
//            if sender.tag == 1{
//                nav?.categoryName = (categoryArray.object(at: 0)as! NSDictionary).object(forKey: "category_name")as! String
//                nav?.categoryId =  ((categoryArray.object(at: 0)as! NSDictionary).object(forKey: "category_id")as! NSNumber).stringValue
//            }
//            else
//            {
//                nav?.categoryName = (categoryArray.object(at: sender.tag)as! NSDictionary).object(forKey: "category_name")as! String
//                nav?.categoryId =  ((categoryArray.object(at: sender.tag)as! NSDictionary).object(forKey: "category_id")as! NSNumber).stringValue
//            }
//            self.navigationController?.pushViewController(nav!, animated: true)
//        }
    }
    
    
    //MARK:- Calling API methods
    func getHomeDataFromAPI(){
         self.showLoadingIndicator(senderVC: self)
        //self.showCollectionLoader()
        let Parse = CommomParsing()
        Parse.Resturant_Home_Pasre(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"), user_latitude: login_session.object(forKey: "user_latitude") as! String, user_longitude: login_session.object(forKey: "user_longitude") as! String, onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200
            {
            self.stopLoadingIndicator(senderVC: self)
            self.ImagesArray.removeAllObjects()
            self.resultData.addEntries(from: response as! [AnyHashable : Any])
             deliveryFeeAvailable = ((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "delivery_fee_status") as! Int)
                
                for i in 0..<((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "featured_restaurant")as! NSArray).count
                {
                    self.ImagesArray.add(((((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "featured_restaurant") as! NSArray).object(at: i) as! NSDictionary).value(forKey: "restaurant_banner") as! String))
                    print("self.ImagesArray::::",self.ImagesArray)
                }
                
                
            self.setSlider()
            let mod = ResturantHome(fromDictionary: response as! [String : Any])
            Singleton.sharedInstance.resturantHomeModel = mod
                
                if ((response.object(forKey: "data")as! NSDictionary).value(forKey: "offers") as? NSDictionary) != nil
                {
                self.promotionOffersDict.addEntries(from: (response.object(forKey: "data")as! NSDictionary).value(forKey: "offers") as! [AnyHashable : Any])
                    self.promotionalOfferBGView.isHidden = false
                    self.promotionalOfferTxtLbl.text = self.promotionOffersDict.value(forKey: "description") as? String
                    self.promotionalHeaderTxtLbl.text = self.promotionOffersDict.value(forKey: "title") as? String
                }
                else
                {
                    self.promotionalOfferBGView.isHidden = true

                }
                
                if ((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "featured_restaurant") as! NSArray).count == 0 && ((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "all_restaurant") as! NSArray).count == 0 && ((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "all_restaurant_details") as! NSArray).count == 0 && ((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "category_list") as! NSArray).count == 0 && ((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "nearby_restaurant") as! NSArray).count == 0 && ((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "new_restaurant") as! NSArray).count == 0 && ((self.resultData.object(forKey: "data")as! NSDictionary).object(forKey: "top_restaurant") as! NSArray).count == 0
                {
                  self.homeTableView.isHidden = true
                  self.noItemsView.isHidden = false
                }
                else
                {
                    self.homeTableView.isHidden = false
                    self.noItemsView.isHidden = true

                }
                

                self.homeTableView.reloadData()
            
            }
            else if response.object(forKey: "code") as! Int == 400
            {
                if response.object(forKey: "message")as! String == "Token is Expired"
                {
                    self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message") as! String)
                    self.tokenExpired()
                    self.stopLoadingIndicator(senderVC: self)
                    self.noItemsView.isHidden = false

                }
                else
                {
                    //self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message") as! String)
                    self.stopLoadingIndicator(senderVC: self)
                    self.noItemsView.isHidden = false

                }
            }
            else
            {
                self.showToastAlert(senderVC: self, messageStr: response.object(forKey: "message") as! String)
                self.stopLoadingIndicator(senderVC: self)
                self.noItemsView.isHidden = false
            }
        }, onFailure: {errorResponse in})
    }
    
          func setSlider()
           {
//            silderView.delegate = self
//            silderView.setCarouselData(paths: self.ImagesArray as! [String],  describedTitle: titleArray, isAutoScroll: true, timer: 3.0, defaultImage: "defaultImage")
//            //optional methods
//            silderView.setCarouselOpaque(layer: false, describedTitle: false, pageIndicator: false)
//            silderView.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 2, pageIndicatorColor: nil, describedTitleColor: nil, layerColor: nil)
//            self.stopLoadingIndicator(senderVC: self)
           }
       
    //require method
//    func downloadImages(_ url: String, _ index:Int) {
//
//        let imageView = UIImageView()
//        imageView.kf.setImage(with: URL(string: url)!, placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
//            self.silderView.images[index] = downloadImage!
//        })
//
//    }
//
//    func startAutoScroll() {
//       //optional method
//       self.silderView.startScrollImageView()
//
//    }
//
//    func stopAutoScroll() {
//        //optional method
//        self.silderView.stopScrollImageView()
//    }
    
    func getSearchData()
    {
        //self.showLoadingIndicator(senderVC: self)
//        user_latitude: login_session.object(forKey: "user_latitude") as! String, user_longitude: login_session.object(forKey: "user_longitude") as! String,
        
        let Parse = CommomParsing()
        Parse.getHomeSearchData(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"),search_key: searchTxtStr,user_latitude:login_session.object(forKey: "user_latitude") as! String,user_longitude:login_session.object(forKey: "user_longitude") as! String, onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200{
                let tempDict = NSMutableDictionary()
                tempDict.addEntries(from: (response.object(forKey: "data")as! NSDictionary) as! [AnyHashable : Any])
                self.LoadTopData(resultDict: tempDict)
            }else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired"
            {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else
            {
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    func LoadTopData(resultDict:NSMutableDictionary)
    {
        resultsArray.removeAllObjects()
        resultsArray.addObjects(from: (resultDict.object(forKey: "search_list")as! NSArray) as! [Any])
        print("resultsArray", resultsArray)
        if resultsArray.count == 0
        {
           // searchTableView.isHidden = true
        }
        else
        {
            //searchTableView.isHidden = false
        }
        searchTableView.reloadData()
    }
    
    
    func passHomeItem(storeName: String, restId: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if #available(iOS 11.0, *) {
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RestaurantInfoViewController") as! RestaurantInfoViewController
            nextViewController.rest_id = restId
            //maintainSuperCatStr = ""
            allcategoryItemsStr = "1"
            nextViewController.storeName = storeName
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    
    func passHomeItem1(storeName: String, restId: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if #available(iOS 11.0, *) {
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RestaurantInfoViewController") as! RestaurantInfoViewController
            nextViewController.rest_id = restId
            //maintainSuperCatStr = ""
            allcategoryItemsStr = "1"
            nextViewController.storeName = storeName
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    
    
    
    
    
    func passFeatureData(storeName: String, restId: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if #available(iOS 11.0, *) {
            
            let nav = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllDetailsPage") as? ViewAllDetailsPage
            nav?.common_view_all_str = ""
            nav?.categoryName = storeName
            nav?.categoryId = restId
            nav?.isfromCategory = true
            self.navigationController?.pushViewController(nav!, animated: true)
            
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewAllDetailsPage") as! ViewAllDetailsPage
//            nextViewController.categoryId = restId
//            nextViewController.categoryName = storeName
//            nextViewController.isfromCategory = true
//            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    
    
    
    //MARK: - UITextField Delegate
       func textFieldDidBeginEditing(_ textField: UITextField) {
           //shouldShowResults = true
       }
       
       func textFieldDidEndEditing(_ textField: UITextField) {
           view.endEditing(true)
           if textField.text == ""
           {
             self.searchTableView.isHidden = true
           }
           textField.resignFirstResponder()
       }
       
       
       @objc func textFieldDidChange(_ textField: UITextField)
           {
               if textField.text!.count == 1
               {
                   searchTxtStr = textField.text!
                   self.pagingIndex = 1
                   self.searchTableView.isHidden = false
                   getSearchData()
               }

               if textField.text! == ""
               {
                   self.searchTableView.isHidden = true
               }
       }
       
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
       {
           var updatedTextString : NSString = textField.text! as NSString
           updatedTextString = updatedTextString.replacingCharacters(in: range, with: string) as NSString
           
           if textField.text! != ""
           {
               searchTxtStr = updatedTextString as String
               self.pagingIndex = 1
               self.searchTableView.isHidden = false
               getSearchData()
           }
           else
           {
               searchTxtStr = ""
               self.pagingIndex = 1
               self.searchTableView.isHidden = true
               getSearchData()
           }
           return true
       }
    
    
    @IBAction func locationBtnAction(_ sender: Any)
    {
        self.promotionalOfferBGView.isHidden = true
 
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LocationOptionPage") as! LocationOptionPage
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func promotionOfferOkBtnTapped(_ sender: Any)
    {
       promotionalOfferBGView.isHidden = true
    }
    
    
    func didSelectCarouselView(_ view: AACarousel, _ index: Int) {
        print("text")
    }
    
    func callBackFirstDisplayView(_ imageView: UIImageView, _ url: [String], _ index: Int) {
        print("text")
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

@available(iOS 11.0, *)
extension NewHomePageViewController : delegateForBannerHomeItem
{
    func passBannerHomeItem(storeName: String, restId: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RestaurantInfoViewController") as! RestaurantInfoViewController
            nextViewController.rest_id = restId
            allcategoryItemsStr = "1"
            nextViewController.storeName = storeName
        nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:true, completion:nil)
        
    }}
