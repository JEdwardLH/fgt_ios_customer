//
//  FoodCollectionCell.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 08/02/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class FoodCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var freeDeliveryLbl: UILabel!
    @IBOutlet weak var freeDeliveryImageview: UIImageView!

    @IBOutlet weak var ratingValueLbl: UILabel!
    @IBOutlet weak var ratingStar: UIImageView!
    @IBOutlet weak var ratingView: UIImageView!
    
    @IBOutlet weak var shopLocationLbl: UILabel!
    @IBOutlet weak var orderAgainBtn: UIButton!
    @IBOutlet weak var priceLbl: UILabel!

    @IBOutlet weak var openTimeLbl: UILabel!
    @IBOutlet weak var deliveryTimeLbl: UILabel!
    @IBOutlet weak var deliveryMinLbl: UILabel!

    @IBOutlet weak var food_titleLbl: UILabel!
    @IBOutlet weak var foodImg: UIImageView!
    @IBOutlet weak var baseView: UIView!
}
