//
//  RestaurantTwoFoodCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 20/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
@available(iOS 11.0, *)
class RestaurantTwoFoodCell: UITableViewCell {

    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var foodImg: UIImageView!
    @IBOutlet weak var foodTypeImg: UIImageView!
        @IBOutlet weak var foodNameLbl: UILabel!
    @IBOutlet weak var foodPriceLbl: UILabel!
        @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var addOneBtn: UIButton!
    @IBOutlet weak var firstTimerLbl: UILabel!
    @IBOutlet weak var firstTimerImageView: UIImageView!

    
    @IBOutlet weak var firstFoogImg: UIImageView!
    
    @IBOutlet weak var first_foodType: UIImageView!
    
    @IBOutlet weak var first_foodNameLbl: UILabel!
    @IBOutlet weak var first_foodPriceLbl: UILabel!
    @IBOutlet weak var first_descLbl: UILabel!
    @IBOutlet weak var firstAddBtn: UIButton!
    @IBOutlet weak var secondTimerLbl: UILabel!
    @IBOutlet weak var secondTimerImageView: UIImageView!

    @IBOutlet weak var ratingImg: UIImageView!
    @IBOutlet weak var star_rating: UIImageView!
    @IBOutlet weak var ratingCountLbl: UILabel!
    @IBOutlet weak var first_ratingImg: UIImageView!
    @IBOutlet weak var first_ratingCountLbl: UILabel!
    @IBOutlet weak var first_starRating: UIImageView!

    @IBOutlet weak var firstOutOfStockBGGrayView: UIView!
    @IBOutlet weak var firstOutOfStockImageView: UIImageView!

    @IBOutlet weak var secondOutOfStockBGGrayView: UIView!
    @IBOutlet weak var secondOutOfStockImageView: UIImageView!

    
    @IBOutlet weak var first_ComboOffers: UIImageView!
    @IBOutlet weak var first_HalalCertified: UIImageView!

    @IBOutlet weak var second_ComboOffers: UIImageView!
    @IBOutlet weak var second_HalalCertified: UIImageView!

    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!

    @IBOutlet weak var sideBG1view1: UIView!
    @IBOutlet weak var sideBG1ImageView1: UIImageView!
    @IBOutlet weak var sideBG1ImageView2: UIImageView!
    @IBOutlet weak var sideBG1ImageView3: UIImageView!
    @IBOutlet weak var sideBG1ImageView4: UIImageView!

    @IBOutlet weak var sideBG2view2: UIView!
    @IBOutlet weak var sideBG2ImageView1: UIImageView!
    @IBOutlet weak var sideBG2ImageView2: UIImageView!
    @IBOutlet weak var sideBG2ImageView3: UIImageView!
    @IBOutlet weak var sideBG2ImageView4: UIImageView!

    
    var releaseDate: NSDate?
    var countdownTimer = Timer()
    var releaseDateString = String()

    var releaseDate2: NSDate?
    var countdownTimer2 = Timer()
    var releaseDateString2 = String()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        baseView.layer.shadowColor = UIColor.lightGray.cgColor
        baseView.layer.shadowOffset = CGSize(width: 3, height: 3)
        baseView.layer.shadowOpacity = 0.7
        baseView.layer.shadowRadius = 4.0
        
        
        firstView.layer.shadowColor = UIColor.lightGray.cgColor
        firstView.layer.shadowOffset = CGSize(width: 3, height: 3)
        firstView.layer.shadowOpacity = 0.7
        firstView.layer.shadowRadius = 4.0
        firstView.layer.cornerRadius = 5.0
        
        secondView.layer.shadowColor = UIColor.lightGray.cgColor
        secondView.layer.shadowOffset = CGSize(width: 3, height: 3)
        secondView.layer.shadowOpacity = 0.7
        secondView.layer.shadowRadius = 4.0
        secondView.layer.cornerRadius = 5.0
        
        firstOutOfStockBGGrayView.layer.cornerRadius = 5.0
        secondOutOfStockBGGrayView.layer.cornerRadius = 5.0

        firstFoogImg.layer.cornerRadius = 5.0
        firstFoogImg.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        foodImg.layer.cornerRadius = 5.0
        foodImg.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        addOneBtn.layer.cornerRadius = 11.0
        firstAddBtn.layer.cornerRadius = 11.0
        
        sideBG1ImageView1.layer.cornerRadius = 5.0
        sideBG1ImageView2.layer.cornerRadius = 5.0
        sideBG1ImageView3.layer.cornerRadius = 5.0
        sideBG1ImageView4.layer.cornerRadius = 5.0

        sideBG2ImageView1.layer.cornerRadius = 5.0
        sideBG2ImageView2.layer.cornerRadius = 5.0
        sideBG2ImageView3.layer.cornerRadius = 5.0
        sideBG2ImageView4.layer.cornerRadius = 5.0

        
        view1.layer.masksToBounds = true
        let rectShape1 = CAShapeLayer()
        rectShape1.bounds = view1.frame
        rectShape1.position = view1.center
        rectShape1.path = UIBezierPath(roundedRect: view1.bounds, byRoundingCorners: [UIRectCorner.topRight , UIRectCorner.bottomRight], cornerRadii: CGSize.init(width: 10, height: 10)).cgPath
        view1.layer.mask = rectShape1
        
        view2.layer.masksToBounds = true
        let rectShape2 = CAShapeLayer()
        rectShape2.bounds = view2.frame
        rectShape2.position = view2.center
        rectShape2.path = UIBezierPath(roundedRect: view2.bounds, byRoundingCorners: [UIRectCorner.topRight , UIRectCorner.bottomRight], cornerRadii: CGSize.init(width: 10, height: 10)).cgPath
        view2.layer.mask = rectShape2
    }
    
    func loadFirstFoodItems(item:NSDictionary)
    {
        let imgURL = URL(string: item.object(forKey: "item_image") as! String)
        foodImg.kf.setImage(with: imgURL)
        foodNameLbl.text = (item.object(forKey: "item_name") as! String)
        
        if (item.object(forKey: "item_has_discount") as! String == "Yes")
        {
            foodPriceLbl.text = String(format: "%@ %@", item.object(forKey: "item_currency") as! CVarArg,item.object(forKey: "item_discount_price") as! CVarArg)
        }
        else
        {

        foodPriceLbl.text = String(format: "%@ %@", item.object(forKey: "item_currency") as! CVarArg,item.object(forKey: "item_original_price") as! CVarArg)
        }
        
        if (item.object(forKey: "item_availablity") as! String == "Available")
        {
          firstOutOfStockBGGrayView.isHidden = true
            addOneBtn.isHidden  = false

        }
        else
        {
          firstOutOfStockBGGrayView.isHidden = false
          addOneBtn.isHidden  = true
        }
        
        view1.isHidden = true
        first_HalalCertified.isHidden = true
        first_ComboOffers.isHidden = true

        if (item.object(forKey: "item_include") as! NSArray).count == 4
        {
            sideBG1ImageView1.isHidden = false
            sideBG1ImageView2.isHidden = false
            sideBG1ImageView3.isHidden = false
            sideBG1ImageView4.isHidden = false

            let imageUrl0 =  URL(string: ((item.object(forKey: "item_include") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "item_inc_img") as! String)
            sideBG1ImageView1.kf.setImage(with: imageUrl0)

            let imageUrl1 =  URL(string: ((item.object(forKey: "item_include") as! NSArray).object(at: 1) as! NSDictionary).value(forKey: "item_inc_img") as! String)
            sideBG1ImageView2.kf.setImage(with: imageUrl1)
            
            let imageUrl2 =  URL(string: ((item.object(forKey: "item_include") as! NSArray).object(at: 2) as! NSDictionary).value(forKey: "item_inc_img") as! String)
            sideBG1ImageView3.kf.setImage(with: imageUrl2)
            
            let imageUrl3 =  URL(string: ((item.object(forKey: "item_include") as! NSArray).object(at: 3) as! NSDictionary).value(forKey: "item_inc_img") as! String)
            sideBG1ImageView4.kf.setImage(with: imageUrl3)
            
            
        }
        else if (item.object(forKey: "item_include") as! NSArray).count == 3
        {
            sideBG1ImageView1.isHidden = false
            sideBG1ImageView2.isHidden = false
            sideBG1ImageView3.isHidden = false
            sideBG1ImageView4.isHidden = true

           let imageUrl0 =  URL(string: ((item.object(forKey: "item_include") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "item_inc_img") as! String)
                    sideBG1ImageView1.kf.setImage(with: imageUrl0)

                     let imageUrl1 =  URL(string: ((item.object(forKey: "item_include") as! NSArray).object(at: 1) as! NSDictionary).value(forKey: "item_inc_img") as! String)
                     sideBG1ImageView2.kf.setImage(with: imageUrl1)
                     
                     let imageUrl2 =  URL(string: ((item.object(forKey: "item_include") as! NSArray).object(at: 2) as! NSDictionary).value(forKey: "item_inc_img") as! String)
                     sideBG1ImageView3.kf.setImage(with: imageUrl2)
        }
        else if (item.object(forKey: "item_include") as! NSArray).count == 2
        {
            sideBG1ImageView1.isHidden = false
            sideBG1ImageView2.isHidden = false
            sideBG1ImageView3.isHidden = true
            sideBG1ImageView4.isHidden = true
            
         let imageUrl0 =  URL(string: ((item.object(forKey: "item_include") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "item_inc_img") as! String)
          sideBG1ImageView1.kf.setImage(with: imageUrl0)

           let imageUrl1 =  URL(string: ((item.object(forKey: "item_include") as! NSArray).object(at: 1) as! NSDictionary).value(forKey: "item_inc_img") as! String)
           sideBG1ImageView2.kf.setImage(with: imageUrl1)
        }
        else if (item.object(forKey: "item_include") as! NSArray).count == 1
        {
            sideBG1ImageView1.isHidden = false
            sideBG1ImageView2.isHidden = true
            sideBG1ImageView3.isHidden = true
            sideBG1ImageView4.isHidden = true
        
            let imageUrl0 =  URL(string: ((item.object(forKey: "item_include") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "item_inc_img") as! String)
            sideBG1ImageView1.kf.setImage(with: imageUrl0)

         
        }
        else
        {
            sideBG1ImageView1.isHidden = true
            sideBG1ImageView2.isHidden = true
            sideBG1ImageView3.isHidden = true
            sideBG1ImageView4.isHidden = true
        }
        
        
       /* if (item.object(forKey: "item_is_combo") as! Int == 1)
        {
            first_ComboOffers.isHidden = false
            self.first_ComboOffers.image = UIImage(named: "ComboOffers")

        }
        else
        {
            if (item.object(forKey: "item_is_halal") as! Int == 1)
            {
                self.first_ComboOffers.image = UIImage(named: "HalalCertified")
                first_ComboOffers.isHidden = false
                first_HalalCertified.isHidden = true
            }
            else
            {
            first_ComboOffers.isHidden = true
            }
        }
        
        if (item.object(forKey: "item_is_halal") as! Int == 1)
        {
            first_HalalCertified.isHidden = false
            self.first_HalalCertified.image = UIImage(named: "HalalCertified")

        }
        else
        {
            first_HalalCertified.isHidden = true
        }
        
        if (item.object(forKey: "discount_remaining_time") as! Int) != 0
        {
            view1.isHidden = false
            self.releaseDateString = (item.object(forKey: "discount_available_to") as! String)
           self.startOfferTimer1()
        }
        else
        {
           countdownTimer.invalidate()
            view1.isHidden = true

        }*/
        
        
        descLbl.text = (item.object(forKey: "item_desc")as! String)
        if (item.object(forKey: "item_rating") as! Int) == 0 {
            star_rating.isHidden = false
            ratingCountLbl.isHidden = true
        }else{
            ratingCountLbl.isHidden = false
            star_rating.isHidden = true
            ratingCountLbl.text = (item.object(forKey: "item_rating") as! NSNumber).stringValue
        }
        if item.object(forKey: "item_type")as! String == "Veg"{
            foodTypeImg.image = UIImage(named: "veg")
        }else{
            foodTypeImg.image = UIImage(named: "nonVeg")
        }
    }
    
    func startOfferTimer1()
    {
        let releaseDateFormatter = DateFormatter()
        releaseDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        releaseDate = releaseDateFormatter.date(from: releaseDateString)! as NSDate
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime1), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime1() {
        
        let currentDate = Date()
        let calendar = Calendar.current

        let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: releaseDate! as Date)
        
        firstTimerLbl.text = "\(diffDateComponents.hour ?? 0)h:\(diffDateComponents.minute ?? 0)m:\(diffDateComponents.second ?? 0)s"
    }
    
    
    
    
    func loadSecondFoodItems(item:NSDictionary){
        let imgURL = URL(string: item.object(forKey: "item_image") as! String)
        firstFoogImg.kf.setImage(with: imgURL)
        first_foodNameLbl.text = (item.object(forKey: "item_name") as! String)
        
        if (item.object(forKey: "item_has_discount") as! String == "Yes")
        {
        first_foodPriceLbl.text = String(format: "%@ %@", item.object(forKey: "item_currency") as! CVarArg,item.object(forKey: "item_discount_price") as! CVarArg)
        }
        else
        {
            first_foodPriceLbl.text = String(format: "%@ %@", item.object(forKey: "item_currency") as! CVarArg,item.object(forKey: "item_original_price") as! CVarArg)
        }
        
        second_HalalCertified.isHidden = true
        second_ComboOffers.isHidden = true
        view2.isHidden = true

        
        if (item.object(forKey: "item_include") as! NSArray).count == 4
        {
            sideBG2ImageView1.isHidden = false
            sideBG2ImageView2.isHidden = false
            sideBG2ImageView3.isHidden = false
            sideBG2ImageView4.isHidden = false

            let imageUrl0 =  URL(string: ((item.object(forKey: "item_include") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "item_inc_img") as! String)
            sideBG2ImageView1.kf.setImage(with: imageUrl0)

            let imageUrl1 =  URL(string: ((item.object(forKey: "item_include") as! NSArray).object(at: 1) as! NSDictionary).value(forKey: "item_inc_img") as! String)
            sideBG2ImageView2.kf.setImage(with: imageUrl1)
            
            let imageUrl2 =  URL(string: ((item.object(forKey: "item_include") as! NSArray).object(at: 2) as! NSDictionary).value(forKey: "item_inc_img") as! String)
            sideBG2ImageView3.kf.setImage(with: imageUrl2)
            
            let imageUrl3 =  URL(string: ((item.object(forKey: "item_include") as! NSArray).object(at: 3) as! NSDictionary).value(forKey: "item_inc_img") as! String)
            sideBG2ImageView4.kf.setImage(with: imageUrl3)
            

        }
        else if (item.object(forKey: "item_include") as! NSArray).count == 3
        {
            sideBG2ImageView1.isHidden = false
            sideBG2ImageView2.isHidden = false
            sideBG2ImageView3.isHidden = false
            sideBG2ImageView4.isHidden = true

          let imageUrl0 =  URL(string: ((item.object(forKey: "item_include") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "item_inc_img") as! String)
          sideBG2ImageView1.kf.setImage(with: imageUrl0)

          let imageUrl1 =  URL(string: ((item.object(forKey: "item_include") as! NSArray).object(at: 1) as! NSDictionary).value(forKey: "item_inc_img") as! String)
          sideBG2ImageView2.kf.setImage(with: imageUrl1)
          
          let imageUrl2 =  URL(string: ((item.object(forKey: "item_include") as! NSArray).object(at: 2) as! NSDictionary).value(forKey: "item_inc_img") as! String)
          sideBG2ImageView3.kf.setImage(with: imageUrl2)
            
        }
        else if (item.object(forKey: "item_include") as! NSArray).count == 2
        {
            sideBG2ImageView1.isHidden = false
            sideBG2ImageView2.isHidden = false
            sideBG2ImageView3.isHidden = true
            sideBG2ImageView4.isHidden = true
            
          let imageUrl0 =  URL(string: ((item.object(forKey: "item_include") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "item_inc_img") as! String)
                   sideBG2ImageView1.kf.setImage(with: imageUrl0)

                   let imageUrl1 =  URL(string: ((item.object(forKey: "item_include") as! NSArray).object(at: 1) as! NSDictionary).value(forKey: "item_inc_img") as! String)
                   sideBG2ImageView2.kf.setImage(with: imageUrl1)
        }
        else if (item.object(forKey: "item_include") as! NSArray).count == 1
        {
            sideBG2ImageView1.isHidden = false
            sideBG2ImageView2.isHidden = true
            sideBG2ImageView3.isHidden = true
            sideBG2ImageView4.isHidden = true
        
          let imageUrl0 =  URL(string: ((item.object(forKey: "item_include") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "item_inc_img") as! String)
          sideBG2ImageView1.kf.setImage(with: imageUrl0)
            
        }
        else
        {
            sideBG2ImageView1.isHidden = true
            sideBG2ImageView2.isHidden = true
            sideBG2ImageView3.isHidden = true
            sideBG2ImageView4.isHidden = true
        }
        
        
       /* if (item.object(forKey: "item_is_combo") as! Int == 1)
        {
            second_ComboOffers.isHidden = false
            self.second_ComboOffers.image = UIImage(named: "ComboOffers")

        }
        else
        {
            if (item.object(forKey: "item_is_halal") as! Int == 1)
            {
              self.second_ComboOffers.image = UIImage(named: "HalalCertified")
              second_ComboOffers.isHidden = false
              second_HalalCertified.isHidden = true
            }
            else
            {
            second_ComboOffers.isHidden = true
            }
        }
        
        if (item.object(forKey: "item_is_halal") as! Int == 1)
        {
            second_HalalCertified.isHidden = false
            self.second_HalalCertified.image = UIImage(named: "HalalCertified")

        }
        else
        {
            second_HalalCertified.isHidden = true
        }
        
        if (item.object(forKey: "discount_remaining_time") as! Int) != 0
        {
            view2.isHidden = false
            self.releaseDateString2 = (item.object(forKey: "discount_remaining_time") as! NSNumber).stringValue
             self.startOfferTimer2()
        }
        else
        {
            countdownTimer2.invalidate()
            view2.isHidden = true

        }*/
        
        
        if (item.object(forKey: "item_availablity") as! String == "Available")
        {
            secondOutOfStockBGGrayView.isHidden = true
            firstAddBtn.isHidden = false
        }
        else
        {
            secondOutOfStockBGGrayView.isHidden = false
            firstAddBtn.isHidden = true
        }
        
        first_descLbl.text = (item.object(forKey: "item_desc")as! String)
        if (item.object(forKey: "item_rating") as! Int) == 0 {
            first_starRating.isHidden = false
            first_ratingCountLbl.isHidden = true
        }else{
            first_ratingCountLbl.isHidden = false
            first_starRating.isHidden = true
            first_ratingCountLbl.text = (item.object(forKey: "item_rating") as! NSNumber).stringValue
        }
        if item.object(forKey: "item_type")as! String == "Veg"
        {
            first_foodType.image = UIImage(named: "veg")
        }else{
            first_foodType.image = UIImage(named: "nonVeg")
        }
    }

    func startOfferTimer2()
    {
        let releaseDateFormatter = DateFormatter()
        releaseDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        releaseDate2 = releaseDateFormatter.date(from: releaseDateString2)! as NSDate
        
        countdownTimer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime2), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime2() {
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: releaseDate2! as Date)
        
        secondTimerLbl.text = "\(diffDateComponents.hour ?? 0)h:\(diffDateComponents.minute ?? 0)m:\(diffDateComponents.second ?? 0)s"
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
