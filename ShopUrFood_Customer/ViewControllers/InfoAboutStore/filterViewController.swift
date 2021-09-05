//
//  filterViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 28/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import BottomPopup
class filterViewController: BottomPopupViewController {
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?

    @IBOutlet weak var lowHightBtn: UIButton!
    @IBOutlet weak var hightLowBtn: UIButton!
    @IBOutlet weak var ZABtn: UIButton!
    @IBOutlet weak var AZBtn: UIButton!
    @IBOutlet weak var filterHeadingLbl: UILabel!
    @IBOutlet weak var byNameLbl: UILabel!
    @IBOutlet weak var byPriceLbl: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if sortByStr == "2"{
            AZBtn.setImage(UIImage(named: "select_radio"), for: .normal)
        }else if sortByStr == "3"{
            ZABtn.setImage(UIImage(named: "select_radio"), for: .normal)
        }else if sortByStr == "4"{
            lowHightBtn.setImage(UIImage(named: "select_radio"), for: .normal)
        }else if sortByStr == "5"{
            hightLowBtn.setImage(UIImage(named: "select_radio"), for: .normal)
        }
        // Do any additional setup after loading the view.
        filterHeadingLbl.text = "\(GlobalLanguageDictionary.object(forKey: "filter") as! String)"
        byNameLbl.text = "\(GlobalLanguageDictionary.object(forKey: "byname") as! String)"
        byPriceLbl.text = "\(GlobalLanguageDictionary.object(forKey: "byprice") as! String)"

        
    }
    
    @IBAction func closeBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func HighLowBtnAction(_ sender: Any) {
        sortByStr = "5"
        AZBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        ZABtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        hightLowBtn.setImage(UIImage(named: "select_radio"), for: .normal)
        lowHightBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func lowHightBtnAction(_ sender: Any) {
        sortByStr = "4"
        AZBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        ZABtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        hightLowBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        lowHightBtn.setImage(UIImage(named: "select_radio"), for: .normal)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func ZABtnAction(_ sender: Any) {
        sortByStr = "3"
        AZBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        ZABtn.setImage(UIImage(named: "select_radio"), for: .normal)
        hightLowBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        lowHightBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func AZBtnAction(_ sender: Any) {
        sortByStr = "2"
        AZBtn.setImage(UIImage(named: "select_radio"), for: .normal)
        ZABtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        hightLowBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        lowHightBtn.setImage(UIImage(named: "unSelectRadio"), for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    override func getPopupHeight() -> CGFloat {
        return height ?? CGFloat(278)
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
    
   
}
