//
//  ManageAddressCell.swift
//  ShopUrFood_Customer
//
//  Created by dineshkumarr on 23/10/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class ManageAddressCell: UITableViewCell {

    @IBOutlet weak var BaseView: UIView!
    @IBOutlet weak var IconImageView: UIImageView!
    @IBOutlet weak var HeadingLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
