//
//  RefundCompletedTableViewCell.swift
//  ShopUrFood_Customer
//
//  Created by dineshkumarr on 05/09/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class RefundCompletedTableViewCell: UITableViewCell {

    @IBOutlet weak var baseContentView: UIView!
    @IBOutlet weak var itemNameValuelbl: UILabel!
    @IBOutlet weak var itemAmtValueLbl: UILabel!
    @IBOutlet weak var refundAmountlbl: UILabel!
    @IBOutlet weak var cancelTypeValueLbl: UILabel!
    @IBOutlet weak var refundDetailsBtn: UIButton!
    @IBOutlet weak var orderIDValueLbl: UILabel!

    @IBOutlet weak var orderIDHeadingLbl: UILabel!
    @IBOutlet weak var itemNameHeadingLbl: UILabel!
    @IBOutlet weak var itemAmountHeadingLbl: UILabel!
    @IBOutlet weak var refundAmountHeadingLbl: UILabel!
    @IBOutlet weak var cancelTypeHeadingLbl: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
