//
//  HomeBannerCell.swift
//  ShopUrFood_Customer
//
//  Created by dineshkumarr on 02/12/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit
import FSPagerView

protocol delegateForBannerHomeItem {
    func passBannerHomeItem(storeName:String,restId:String)
}
@available(iOS 11.0, *)
class HomeBannerCell: UITableViewCell,FSPagerViewDataSource,FSPagerViewDelegate {

    var dataArray = NSMutableArray()
    var restaurantListArray = NSMutableArray()
    var delegate : delegateForBannerHomeItem?
    let billBorderColor:UIColor = UIColor(red: 255/255, green: 201/255, blue: 205/255, alpha: 1.0)
    let appColor:UIColor = UIColor(red: 226/255, green: 28/255, blue: 38/255, alpha: 1.0)

    @IBOutlet weak var silderView: FSPagerView! {
        didSet {
            self.silderView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.silderView.itemSize = FSPagerView.automaticSize
        }
    }
    @IBOutlet weak var pageControl: FSPageControl! {
           didSet {
               self.pageControl.numberOfPages = self.dataArray.count
               self.pageControl.contentHorizontalAlignment = .center
               self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
               self.pageControl.setStrokeColor(appColor, for: .normal)
               self.pageControl.setStrokeColor(appColor, for: .selected)
               self.pageControl.setFillColor(appColor, for: .selected)

           }
       }

    //fileprivate var sliderVc1: LIHSliderViewController!

    override func awakeFromNib() {
        super.awakeFromNib()
        silderView.delegate = self
        silderView.dataSource = self
//        silderView.transformer = FSPagerViewTransformer(type: .linear)
//        let transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//        self.silderView.itemSize = self.silderView.frame.size.applying(transform)
        self.silderView.automaticSlidingInterval = 4.0
        
        // Initialization code
    }
    
    
    func getbannerRestaurant(bannerrestListArray:NSArray)
    {
        restaurantListArray.removeAllObjects()
        restaurantListArray.addObjects(from: bannerrestListArray as! [Any])
        print("restaurantListArray images::::",restaurantListArray)
    }
    
    
    func getOffersList(offersListArray:NSMutableArray){
        dataArray.removeAllObjects()
        dataArray.addObjects(from: offersListArray as! [Any])
        print("dataArray images::::",dataArray)
        self.pageControl.numberOfPages = dataArray.count
        silderView.reloadData()
    }
    
    
    // MARK:- FSPagerViewDataSource
        public func numberOfItems(in pagerView: FSPagerView) -> Int {
            print("dataArray.count::",dataArray.count)
            return dataArray.count
            
        }
        public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell
        {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
            let imgURL = URL(string: (dataArray[index] as! String))
            cell.imageView?.setImageWith(imgURL!)
            cell.imageView?.contentMode = .scaleToFill
            cell.imageView?.clipsToBounds = true
            return cell
            
    //        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "PagerCollectionViewCell", at: index) as! PagerCollectionViewCell
    //        cell.layer.cornerRadius = 10
    //        cell.offerImageView?.layer.cornerRadius = 10
    //
    //        let imgURL = URL(string: (ImagesArray[index] as AnyObject).value(forKey: "item_image") as! String)
    //        cell.offerImageView?.setImageWith(imgURL!)
    //        cell.offerImageView?.contentMode = .scaleAspectFill
    //        cell.offerImageView?.clipsToBounds = true
              
        }
        
        func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
            pagerView.deselectItem(at: index, animated: true)
            pagerView.scrollToItem(at: index, animated: true)
            let dataDict = NSMutableDictionary()
            dataDict.addEntries(from: (restaurantListArray.object(at: index)as! NSDictionary) as! [AnyHashable : Any])
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            if #available(iOS 11.0, *) {
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RestaurantInfoViewController") as! RestaurantInfoViewController
                nextViewController.rest_id = (dataDict.object(forKey: "restaurant_id")as! NSNumber).stringValue
                allcategoryItemsStr = "1"
                nextViewController.storeName = dataDict.object(forKey: "restaurant_name")as! String
                nextViewController.modalPresentationStyle = .fullScreen
                self.window?.rootViewController?.present(nextViewController, animated: true, completion: nil)

            } else {
                // Fallback on earlier versions
            }

            
            delegate?.passBannerHomeItem(storeName: dataDict.object(forKey: "restaurant_name")as! String, restId: (dataDict.object(forKey: "restaurant_id")as! NSNumber).stringValue)
            
    //        let itemId: NSNumber = (dataArray[index] as AnyObject).value(forKey: "item_id") as! NSNumber
    //        print("itemId is: \(itemId)")
    //        let CatId: NSNumber = (dataArray[index] as AnyObject).value(forKey: "cat_id") as! NSNumber
    //        print("cat_id is: \(CatId)")
    //        delegate?.tapOffersCell(indexPath:index, itemIDString: "\(itemId)", categoryIDString:"\(CatId)")
        }
        
        // MARK:- FSPagerViewDelegate
        func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
            self.pageControl.currentPage = targetIndex
        }
        func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
            self.pageControl.currentPage = pagerView.currentIndex
        }
        
    
//    func setSlider()
//    {
//        let images: [UIImage] = [UIImage(named: "carSlide1")!,UIImage(named: "carSlide1")!,UIImage(named: "carSlide1")!]
//
//        let slider1: LIHSlider = LIHSlider(images: images)
//        self.sliderVc1 = LIHSliderViewController(slider: slider1)
//        sliderVc1.delegate = (self as! LIHSliderDelegate)
//        //self.addChildViewController(self.sliderVc1)
//        self.silderView.addSubview(self.sliderVc1.view)
//        self.sliderVc1.didMove(toParent: self)
//    }
//    
//    
//    override func viewDidLayoutSubviews()
//    {
//        if self.sliderVc1 != nil{
//            self.sliderVc1!.view.frame = self.silderView.frame
//        }
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
