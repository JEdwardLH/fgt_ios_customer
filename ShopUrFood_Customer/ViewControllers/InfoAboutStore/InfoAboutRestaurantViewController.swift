//
//  InfoAboutRestaurantViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 27/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import BottomPopup

class InfoAboutRestaurantViewController: BottomPopupViewController,UITableViewDelegate,UITableViewDataSource {
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var ResultData = NSMutableDictionary()

    @IBOutlet weak var infoTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        infoTable.dataSource = self
        infoTable.delegate = self
        // Do any additional setup after loading the view.
    }
    

    override func getPopupHeight() -> CGFloat {
        return height ?? CGFloat(300)
    }
    
    @IBAction func closeBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func getPopupTopCornerRadius() -> CGFloat {
        return topCornerRadius ?? CGFloat(10)
    }
    
    override func getPopupPresentDuration() -> Double {
        return presentDuration ?? 1.0
    }
    
    override func getPopupDismissDuration() -> Double {
        return dismissDuration ?? 1.0
    }
    
    override func shouldPopupDismissInteractivelty() -> Bool {
        return shouldDismissInteractivelty ?? true
    }
    
    
    //MARK:- Tableview Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return (ResultData.object(forKey: "restaurant_review")as! NSArray).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
         if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoFirstCell") as? InfoFirstCell
            cell?.selectionStyle = .none
            cell?.restaurantTitleLbl.text = ((ResultData.object(forKey: "restaurant_info")as! NSDictionary).object(forKey: "restaurant_name")as! String)
            
            cell?.workingHoursBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "viewworkinghours") as! String)", for: .normal)
            cell?.descriptionTitleLbl.text = "\(GlobalLanguageDictionary.object(forKey: "description") as! String)"
            cell?.preOrderTitleLbl.text = "\(GlobalLanguageDictionary.object(forKey: "preorder") as! String)"
            cell?.cancellationPolicyLbl.text = "\(GlobalLanguageDictionary.object(forKey: "cancellationpolicy") as! String)"
            cell?.cancelStatusLbl.text = "\(GlobalLanguageDictionary.object(forKey: "cancelstatus") as! String)"
            cell?.refundTitleLbl.text = "\(GlobalLanguageDictionary.object(forKey: "refundstatus") as! String)"
            cell?.reviewTitleLbl.text = "\(GlobalLanguageDictionary.object(forKey: "reviews") as! String)"
            
            cell?.descriptionValueLbl.text = ((ResultData.object(forKey: "restaurant_info")as! NSDictionary).object(forKey: "restaurant_desc")as! String)
            if (ResultData.object(forKey: "restaurant_info")as! NSDictionary).object(forKey: "pre_order")as! String == "Yes"{
                 cell?.preOrderValueLbl.text = "Pre order available"
            }else{
                cell?.preOrderValueLbl.text = "Pre order Unavailable"
            }
            if (ResultData.object(forKey: "restaurant_info")as! NSDictionary).object(forKey: "refund_status")as! String == "Yes"{
                cell?.refundValueLbl.text = "Refund available"
            }else{
                cell?.preOrderValueLbl.text = "Refund Unavailable"
            }
            cell?.cacellationValueLbl.text = ((ResultData.object(forKey: "restaurant_info")as! NSDictionary).object(forKey: "cancellation_policy")as? String) ?? ""
            if (ResultData.object(forKey: "restaurant_review")as! NSArray).count == 0{
                cell?.reviewStatusLbl.text = "(Not Yet update)"
            }else{
                let count = (ResultData.object(forKey: "restaurant_review")as! NSArray).count
                cell?.reviewStatusLbl.text = "\(count) Reviews"
            }
            
            if (ResultData.object(forKey: "restaurant_info")as! NSDictionary).object(forKey: "cancel_status")as! String == "Yes"{
                cell?.cancelStatusResultLbl.text = "Cancel available"
            }else{
                cell?.cancelStatusResultLbl.text = "Cancel Unavailable"
            }
            
            cell?.workingHoursBtn.addTarget(self, action: #selector(workingHoursBtnTapped), for:.touchUpInside)
            return cell!
         }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoReviewCell") as? InfoReviewCell
            cell?.selectionStyle = .none
             let rating = (((ResultData.object(forKey: "restaurant_review")as! NSArray).object(at: indexPath.row)as! NSDictionary).object(forKey: "review_rating")as! NSNumber)
            if rating == 0 {
                cell?.starReview.isHidden = false
                cell?.ratingCountLbl.isHidden = true
            }else{
                cell?.starReview.isHidden = true
                cell?.ratingCountLbl.isHidden = false
                cell?.ratingCountLbl.text = "\(rating)"
            }
            cell?.nameLbl.text = (((ResultData.object(forKey: "restaurant_review")as! NSArray).object(at: indexPath.row)as! NSDictionary).object(forKey: "review_customer_name")as! String)
            cell?.descLbl.text = (((ResultData.object(forKey: "restaurant_review")as! NSArray).object(at: indexPath.row)as! NSDictionary).object(forKey: "review_comments")as! String)
            return cell!
        }
    }
    
    @objc func workingHoursBtnTapped(sender:UIButton){
        showWorkingHoursView = "true"
        self.dismiss(animated: true, completion: nil)
    }
    

}
