//
//  CartDeliveryAddressCell.swift
//  ShopUrFood_Customer
//
//  Created by JHernandez on 4/30/20.
//  Copyright © 2020 apple4. All rights reserved.
//

import UIKit

class CartDeliveryAddressCell: UITableViewCell {
    
    @IBOutlet weak var placeTable: UITableView!
    
    @IBOutlet weak var searchCloseBtn: UIButton!
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var companyField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var otherBtn: UIButton!
    @IBOutlet weak var workBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var selectedAddressValue2: UILabel!
    @IBOutlet weak var selectedAddressValue: UILabel!
    @IBOutlet weak var deliveryDetailLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        cancelBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "txt_checkout_cancel") as! String)", for: .normal)
        applyBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "txt_checkout_apply") as! String)", for: .normal)
        deliveryDetailLabel.text = "\(GlobalLanguageDictionary.object(forKey: "txt_checkout_delivery_detail2") as! String)"
       
        
        homeBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "txt_checkout_address_home") as! String)", for: .normal)
        workBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "txt_checkout_address_work") as! String)", for: .normal)
        otherBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "txt_checkout_address_other") as! String)", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
