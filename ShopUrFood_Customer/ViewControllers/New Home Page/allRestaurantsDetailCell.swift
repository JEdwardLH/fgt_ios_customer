//
//  allRestaurantsDetailCell.swift
//  ShopUrFood_Customer
//
//  Created by dineshkumarr on 02/12/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class allRestaurantsDetailCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var categoryNameLbl: UILabel!

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var deliveryTimeLbl: UILabel!
    @IBOutlet weak var deliveryMinLbl: UILabel!
    @IBOutlet weak var openTimeLbl: UILabel!

    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var ratingStar: UIImageView!
    @IBOutlet weak var ratingCountLbl: UILabel!
    @IBOutlet weak var freeDeliveryLbl: UILabel!
    @IBOutlet weak var freeDeliveryImageview: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
