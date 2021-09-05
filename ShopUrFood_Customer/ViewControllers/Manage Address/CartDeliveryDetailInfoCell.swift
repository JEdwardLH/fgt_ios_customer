//
//  CartDeliveryDetailInfoCell.swift
//  ShopUrFood_Customer
//
//  Created by JHernandez on 4/30/20.
//  Copyright © 2020 apple4. All rights reserved.
//

import UIKit

class CartDeliveryDetailInfoCell: UITableViewCell {

    @IBOutlet weak var moredetailLabel: UILabel!
  

  
    @IBOutlet weak var buildingTypeBtn: UIButton!
    @IBOutlet weak var buildingTypeTableView: UITableView!
   
    @IBOutlet weak var noteToRider: UITextField!
    @IBOutlet weak var roomHouseNo: UITextField!
    @IBOutlet weak var floor: UITextField!
   
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var buildingName: UITextField!
    @IBOutlet weak var addressInfoLabel: UILabel!
    @IBOutlet weak var buildingType: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
