//
//  HomeItemTBCell.swift
//  ShopUrGrocery_Customer
//
//  Created by saravanan2 on 19/11/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
protocol delegateForHomeItem {
    func passHomeItem(storeName:String,restId:String)
}
class HomeItemTBCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var itemCollectioView: UICollectionView!
    var dataArray = NSMutableArray()
     var delegate : delegateForHomeItem?
    let appColor:UIColor = UIColor(red: 219/255, green: 15/255, blue: 15/255, alpha: 1.0)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getData(tempArray:NSMutableArray){
        dataArray.removeAllObjects()
        dataArray.addObjects(from: tempArray as! [Any])
        self.itemCollectioView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // This is the minimum inter item spacing, can be more
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataArray.count != 0 {
            return dataArray.count
        }else{
            return 4
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCollectionCell", for: indexPath) as! FoodCollectionCell
        
        if dataArray.count != 0{
            let dataDict = NSMutableDictionary()
            dataDict.addEntries(from: (dataArray.object(at: indexPath.row)as! NSDictionary) as! [AnyHashable : Any])
            let food_img = URL(string: dataDict.object(forKey: "restaurant_image")as! String)
            cell.foodImg.kf.setImage(with: food_img)
            cell.food_titleLbl.text = (dataDict.object(forKey: "restaurant_name")as! String)
            //cell.ratingsLbl.text = String(format: "%d", Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[0].restaurantDetails[indexPath.row].restaurantRating)
            cell.openTimeLbl.text = (dataDict.object(forKey: "restaurant_category") as? String) ?? ""
            cell.shopLocationLbl.text = (dataDict.object(forKey: "today_wking_time")as! String)
            cell.deliveryTimeLbl.text = "\((dataDict.object(forKey: "delivery_duration") as! NSNumber))"
            cell.deliveryMinLbl.text =  "\(GlobalLanguageDictionary.object(forKey: "min") as! String)"

            
//            cell.deliveryTimeLbl.layer.cornerRadius = 8.0
//            cell.deliveryTimeLbl.layer.masksToBounds = true
            
            
            let string = "\(GlobalLanguageDictionary.object(forKey: "FREE_DELIVERY") as! String)"
            let attributedString = NSMutableAttributedString.init(string: string)
            let range = (string as NSString).range(of: "\(GlobalLanguageDictionary.object(forKey: "FREE") as! String)")
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: appColor, range: range)
            cell.freeDeliveryLbl.attributedText = attributedString
            
            if deliveryFeeAvailable == 0
            {
                cell.freeDeliveryLbl.isHidden = false
                cell.freeDeliveryImageview.isHidden = false

            }
            else
            {
               cell.freeDeliveryLbl.isHidden = true
               cell.freeDeliveryImageview.isHidden = true

            }
            
            
            if dataDict.object(forKey: "restaurant_rating")as! Int == 0{
                cell.ratingStar.isHidden = false
                cell.ratingView.isHidden = false
                cell.ratingValueLbl.isHidden = true
            }else{
                cell.ratingStar.isHidden = true
                cell.ratingValueLbl.isHidden = false
                cell.ratingView.isHidden = false
                cell.ratingValueLbl.text = String(format: "%d", dataDict.object(forKey: "restaurant_rating")as! Int)
            }
            
            
        }
        // code shadow effects
        cell.layer.cornerRadius = 5.0
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowOpacity = 0.6
        let containerView = cell.baseView!
        containerView.layer.cornerRadius = 5
        containerView.clipsToBounds = true
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataDict = NSMutableDictionary()
        dataDict.addEntries(from: (dataArray.object(at: indexPath.row)as! NSDictionary) as! [AnyHashable : Any])
        self.delegate?.passHomeItem(storeName: dataDict.object(forKey: "restaurant_name")as! String, restId: (dataDict.object(forKey: "restaurant_id")as! NSNumber).stringValue)
    }
}
