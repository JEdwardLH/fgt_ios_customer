//
//  FeaturedRestaurantViewController.swift
//  ShopUrFood_Customer
//
//  Created by dineshkumarr on 04/11/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import CRRefresh

class FeaturedRestaurantViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var headerLbl: UILabel!

    @IBOutlet weak var featuredRestaurantTableView: UITableView!

    var pageIndex = Int()
    var allStoreArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.pageIndex = 1
        self.getAllResturantData()
        
        
    featuredRestaurantTableView.cr.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
        /// start refresh
         /// Do anything you want...
        self!.pageIndex += 1
        self!.getAllResturantData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        headerLbl.text = "\(GlobalLanguageDictionary.object(forKey: "featuredresturants") as! String)"
    }

    func getAllResturantData()
    {
           //self.showLoadingIndicator(senderVC: self)
           if pageIndex == 1{
               allStoreArray.removeAllObjects()
           }
           let Parse = CommomParsing()
        Parse.getFeaturedBasedRestaurants(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"), user_latitude: login_session.object(forKey: "user_latitude") as! String, user_longitude: login_session.object(forKey: "user_longitude") as! String, page: pageIndex, featured_restaurant: 1, onSuccess:
               {
               response in
               print (response)
               if response.object(forKey: "code") as! Int == 200
               {
                if self.pageIndex > 1
                {
                    self.allStoreArray.addObjects(from: ((response.object(forKey: "data")as! NSDictionary).object(forKey: "all_restautrant_details")as! NSArray) as! [Any])

                }
                else
                {
                   self.allStoreArray.removeAllObjects()
                   self.allStoreArray.addObjects(from: ((response.object(forKey: "data")as! NSDictionary).object(forKey: "all_restautrant_details")as! NSArray) as! [Any])
                }
                
                if self.allStoreArray.count == 0
                {
                    self.featuredRestaurantTableView.isHidden = true
                    //self.noOrdersLbl.isHidden = false
                }
                else
                {
                    self.featuredRestaurantTableView.isHidden = false
                    //self.noOrdersLbl.isHidden = true
                }

                   self.featuredRestaurantTableView.reloadData()
               }
               else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                   self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
               }
               else
               {
                   print(response.object(forKey: "message") as Any)
                
                if self.pageIndex > 1
                {
                    self.featuredRestaurantTableView.isHidden = false
                }
                else
                {
                    self.featuredRestaurantTableView.isHidden = true
                }
               }
               self.stopLoadingIndicator(senderVC: self)
               self.featuredRestaurantTableView.separatorColor = UIColor.lightGray
               self.featuredRestaurantTableView.isHidden = false
               self.featuredRestaurantTableView.cr.endLoadingMore()
           }, onFailure: {errorResponse in})
       }
    
    //MARK:- Tableview Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
           return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if allStoreArray.count == 0
        {
            return 0
        }
        else
        {
          return allStoreArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ViewAllDetailsCell") as? ViewAllDetailsCell
    cell?.selectionStyle = .none
    let restImg = URL(string: (allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_image")as! String)
    cell?.food_imgView.kf.setImage(with: restImg)
    cell?.titleLbl.text = ((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_name")as! String)
    //Mikael changes done here
    cell?.openTimeLbl.text = ((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "category_name")as! String)
    cell?.descriptionLbl.text = "Delivery in " + ((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_delivery_time")as! String)
    cell?.resTimingLbl.text = ((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "today_wking_time")as! String)
        
        
    if ((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_offer")as! NSNumber) == 0
    {
     cell?.offerPercentLbl.isHidden = true
     cell?.offerPercentImageView.isHidden = true
        
        cell?.offerPercentImageHeightConstraint.constant = 0
        cell?.offerPercentLblHeightConstraint.constant = 0
    }
    else
    {
    cell?.offerPercentLbl.isHidden = false
    cell?.offerPercentImageView.isHidden = false
    cell?.offerPercentImageHeightConstraint.constant = 18
    cell?.offerPercentLblHeightConstraint.constant = 21


    cell?.offerPercentLbl.text = "Up to " + (((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_offer")as! NSNumber).stringValue) + "%" + " Off"
    }
        
        
    if ((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_rating")as! Int == 0 ){
        cell?.startRating.isHidden = true
        cell?.ratingLbl.isHidden = false
        cell?.ratingLbl.text = "0"
    }else{
        cell?.startRating.isHidden = true
        cell?.ratingLbl.isHidden = false
        cell?.ratingLbl.text = ((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_rating")as! NSNumber).stringValue
    }
    cell?.food_imgView.layer.cornerRadius = 5.0
    cell?.food_imgView.clipsToBounds = true
    if ((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_status")as! String) == "Closed"{
        cell?.closedLbl.isHidden = true
        cell?.closedTransperantView.isHidden = false
        cell?.closedTransperantView.backgroundColor = WhiteTranspertantColor
        cell?.titleLbl.textColor = UIColor.lightGray
        cell?.openTimeLbl.textColor = UIColor.lightGray
        cell?.descriptionLbl.textColor = UIColor.lightGray
        cell?.offerPercentLbl.textColor = UIColor.lightGray
        cell?.reviewRatingImageView.image = UIImage(named: "newReviewIcon")
        cell?.deliBoyImageView.image = UIImage(named: "newBikeGray")
        cell?.resTimingImageView.image = UIImage(named: "newClockGrayIcon")
        cell?.offerPercentImageView.image = UIImage(named: "grayOfferPercent")
    }else{
        cell?.closedLbl.isHidden = true
        cell?.closedTransperantView.isHidden = true
        cell?.titleLbl.textColor = UIColor.darkText
        cell?.openTimeLbl.textColor = UIColor.darkGray
        cell?.descriptionLbl.textColor = UIColor.darkText
        cell?.offerPercentLbl.textColor = UIColor.darkText
        cell?.reviewRatingImageView.image = UIImage(named: "newReviewIcon")
        cell?.deliBoyImageView.image = UIImage(named: "newBike")
        cell?.resTimingImageView.image = UIImage(named: "newClockIcon")
        cell?.offerPercentImageView.image = UIImage(named: "OfferPercent1")
    }
    
    return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
      let rest_id = ((allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_id")as! NSNumber).stringValue
      let storeName = (allStoreArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "restaurant_name")as! String
      
      let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
      if #available(iOS 11.0, *) {
          let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RestaurantInfoViewController") as! RestaurantInfoViewController
          nextViewController.rest_id = rest_id
          nextViewController.storeName = storeName
        nextViewController.modalPresentationStyle = .fullScreen
          self.present(nextViewController, animated:true, completion:nil)
      }
    }
    
    @IBAction func backBtnAction(_ sender: Any)
    {
       self.navigationController?.popViewController(animated: true)
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
