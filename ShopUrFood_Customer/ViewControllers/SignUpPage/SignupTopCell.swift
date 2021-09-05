//
//  SignupTopCell.swift
//  ShopUrFood_Customer
//
//  Created by dineshkumarr on 23/12/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class SignupTopCell: UITableViewCell {

    @IBOutlet weak var BGView: UIView!

    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var registerTitleLbl: UILabel!
    
    @IBOutlet weak var NameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var mobileTxt: UITextField!
    @IBOutlet weak var codeTxt: UITextField!
    @IBOutlet weak var referralCodeBtn: UIButton!
    @IBOutlet weak var countryCodeBtn: UIButton!

    @IBOutlet weak var goBtn: UIButton!
    @IBOutlet weak var socialLoginTxtLbl: UILabel!

    @IBOutlet weak var fbBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var orangeLineView: UIView!

    @IBOutlet weak var backBtn: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
