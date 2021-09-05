//
//  LoginTopCell.swift
//  ShopUrFood_Customer
//
//  Created by dineshkumarr on 10/12/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class LoginTopCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var signUpLbl: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var socialLoginLbl: UILabel!
    @IBOutlet weak var goBtn: UIButton!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var loginTitleLbl: UILabel!
    @IBOutlet weak var userLoginDataView: UIView!
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var fbBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var orangeLineView: UIView!
    @IBOutlet weak var skipBtn: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
