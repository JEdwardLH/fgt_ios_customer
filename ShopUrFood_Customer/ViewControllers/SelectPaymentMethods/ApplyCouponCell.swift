//
//  ApplyCouponCell.swift
//  ShopUrFood_Customer
//
//  Created by Apple3 on 17/07/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class ApplyCouponCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var applyCouponLbl: UILabel!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var applyCouponButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
