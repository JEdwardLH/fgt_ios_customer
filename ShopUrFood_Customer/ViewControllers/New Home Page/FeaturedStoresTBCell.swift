//
//  FeaturedStoresTBCell.swift
//  ShopUrGrocery_Customer
//
//  Created by saravanan2 on 19/11/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
protocol delegateForHomeFeatured {
    func passFeatureData(storeName:String,restId:String)
}

class FeaturedStoresTBCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var itemCollectioView: UICollectionView!
    var dataArray = NSMutableArray()
    var delegate : delegateForHomeFeatured?
    let appColor:UIColor = UIColor(red: 219/255, green: 15/255, blue: 15/255, alpha: 1.0)
    //let billBorderColor:UIColor = UIColor(red: 255/255, green: 201/255, blue: 205/255, alpha: 1.0)
    let billBorderColor:UIColor = UIColor(red: 206/255, green: 121/255, blue: 121/255, alpha: 1.0)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func getData(tempArray:NSMutableArray){
        dataArray.removeAllObjects()
        dataArray.addObjects(from: tempArray as! [Any])
        self.itemCollectioView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // This is the minimum inter item spacing, can be more
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataArray.count != 0 {
            return dataArray.count
        }else{
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreCollectionCell", for: indexPath) as! StoreCollectionCell
        if dataArray.count != 0{
            let dataDict = NSMutableDictionary()
            dataDict.addEntries(from: (dataArray.object(at: indexPath.row)as! NSDictionary) as! [AnyHashable : Any])
            let shop_img = URL(string: dataDict.object(forKey: "category_image")as! String)
            cell.storeImg.contentMode = .center
            cell.storeImg.kf.setImage(with: shop_img)
            cell.categoryNameLbl.text = (dataDict.object(forKey: "category_name") as! String)
        }
        cell.layer.cornerRadius = 5.0
        cell.layer.masksToBounds = false
//        cell.layer.shadowColor = appColor.cgColor
//        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
//        cell.layer.shadowOpacity = 0.6
        let containerView = cell.baseView!
        containerView.layer.cornerRadius = 43.0
       // containerView.layer.borderColor = billBorderColor.cgColor
        containerView.layer.borderColor = UIColor.white.cgColor

        containerView.layer.borderWidth = 7.0
        containerView.layer.masksToBounds = true

        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataDict = NSMutableDictionary()
        dataDict.addEntries(from: (dataArray.object(at: indexPath.row)as! NSDictionary) as! [AnyHashable : Any])
        self.delegate?.passFeatureData(storeName: dataDict.object(forKey: "category_name")as! String, restId: (dataDict.object(forKey: "category_id")as! NSNumber).stringValue)
    }

}
