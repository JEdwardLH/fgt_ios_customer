//
//  RecentOrdersTableViewCell.swift
//  ShopUrGrocery_Customer
//
//  Created by saravanan2 on 19/11/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import SCLAlertView

protocol delegateForHomeItem1 {
    func passHomeItem1(storeName:String,restId:String)
}
class RecentOrdersTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var itemCollectioView: UICollectionView!
    var dataArray = NSMutableArray()
    var orderID = Int()
    var dataDict = NSMutableDictionary()

     var delegate : delegateForHomeItem1?

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
        
        if dataArray.count != 0
        {
            dataDict.addEntries(from: (dataArray.object(at: indexPath.row)as! NSDictionary) as! [AnyHashable : Any])
            let food_img = URL(string: dataDict.object(forKey: "item_image")as! String)
            cell.foodImg.kf.setImage(with: food_img)
            cell.food_titleLbl.text = (dataDict.object(forKey: "stem_store_name") as? String) ?? ""
            //cell.ratingsLbl.text = String(format: "%d", Singleton.sharedInstance.resturantHomeModel.data.allRestaurantDetails[0].restaurantDetails[indexPath.row].restaurantRating)
            cell.openTimeLbl.text = (dataDict.object(forKey: "item_name")as! String)
            cell.priceLbl.text = "\((dataDict.object(forKey: "item_currency") as! String))\((dataDict.object(forKey: "item_original_price") as! NSNumber))"
            cell.shopLocationLbl.isHidden = true
            cell.orderAgainBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "order_again") as! String)", for: .normal)
            cell.orderAgainBtn.layer.cornerRadius = 16.0
            cell.orderAgainBtn.tag = indexPath.row
            cell.orderAgainBtn.addTarget(self, action: #selector(repeatOrderBtnTapped), for: .touchUpInside)

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
    
    
    @objc func repeatOrderBtnTapped(sender:UIButton)
        {
            let index = sender.tag

            let Parse = CommomParsing()
            let order_id = (dataArray.object(at: index) as! NSDictionary).value(forKey: "item_order_id") as! String
            Parse.setRepeatOrder(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"),order_id:order_id , onSuccess: {
                response in
                print (response)
                if response.object(forKey: "code") as! Int == 200
                {
                    actAsBaseTabbar.selectedIndex = 0
                }
                else if response.object(forKey: "code")as! Int == 400
                {
                  self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                }
                else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired" {
                }else{
                }
            }, onFailure: {errorResponse in})
            
        }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let dataDict = NSMutableDictionary()
        dataDict.addEntries(from: (dataArray.object(at: indexPath.row)as! NSDictionary) as! [AnyHashable : Any])
        self.delegate?.passHomeItem1(storeName: ((dataDict.object(forKey: "stem_store_name") as? String) ?? ""), restId: (dataDict.object(forKey: "stem_store_id")as! NSNumber).stringValue)
    }
    
    
    func showTokenExpiredPopUp(msgStr:String){
              let appearance = SCLAlertView.SCLAppearance(
                  kTitleFont: UIFont(name: "TruenoBd", size: 20.0)!,
                  kTextFont: UIFont(name: "TruenoRg", size: 14.0)!,
                  kButtonFont: UIFont(name: "TruenoBd", size: 16.0)!,
                  showCloseButton: false,
                  dynamicAnimatorActive: false,
                  buttonsLayout: .horizontal
              )
              let alert = SCLAlertView(appearance: appearance)
              _ = alert.addButton("Ok") {

              }
              
              let icon = UIImage(named:"warning")
              let color = AppLightOrange
              
              _ = alert.showCustom("\(GlobalLanguageDictionary.object(forKey: "warning") as! String)", subTitle: msgStr, color: color, icon: icon!, circleIconImage: icon!)
          }
}
