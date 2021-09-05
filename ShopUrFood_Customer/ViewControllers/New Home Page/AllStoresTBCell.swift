//
//  AllStoresTBCell.swift
//  ShopUrGrocery_Customer
//
//  Created by saravanan2 on 19/11/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
protocol delegateForHomeAllStores {
    func passAllStoresData(storeName:String,restId:String)
}
class AllStoresTBCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var itemCollectioView: UICollectionView!
    var dataArray = NSMutableArray()
    var delegate : delegateForHomeAllStores?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getData(tempArray:NSMutableArray){
        dataArray.removeAllObjects()
        dataArray.addObjects(from: tempArray as! [Any])
        self.itemCollectioView.reloadData()
    }
    
    
    //MARK:- ColloectionView Delegate & DataSource Methods
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Home_Resturants_collection_cell", for: indexPath) as! Home_Resturants_collection_cell
        
        cell.resturantImg.layer.cornerRadius = 5.0
        cell.ImgBGView.layer.cornerRadius = 5.0
        if dataArray.count != 0{
            let dataDict = NSMutableDictionary()
            dataDict.addEntries(from: (dataArray.object(at: indexPath.row)as! NSDictionary) as! [AnyHashable : Any])
            var imgStr = String()
            imgStr = dataDict.object(forKey: "restaurant_logo")as! String
            imgStr = imgStr.replacingOccurrences(of: " ", with: "%20")
            let rest_img = URL(string: imgStr)
            cell.resturantImg.kf.setImage(with:rest_img!)
            cell.ImgBGView.backgroundColor = BlackTranspertantColor
            cell.resturantNameLbl.text = (dataDict.object(forKey: "restaurant_name")as! String)
        }
        cell.layer.cornerRadius = 5.0
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataDict = NSMutableDictionary()
        dataDict.addEntries(from: (dataArray.object(at: indexPath.row)as! NSDictionary) as! [AnyHashable : Any])
        self.delegate?.passAllStoresData(storeName: dataDict.object(forKey: "restaurant_name")as! String, restId: (dataDict.object(forKey: "restaurant_id")as! NSNumber).stringValue)
    }
}
