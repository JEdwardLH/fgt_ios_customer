//
//  AboutPageViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 21/03/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class AboutPageViewController: BaseViewController {
    @IBOutlet weak var appLogoImg: UIImageView!
    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var latestVersionLbl: UILabel!

    @IBOutlet weak var baseContentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //let logoURL = URL(string: login_session.object(forKey: "logo")as! String)
        //self.appLogoImg.kf.setImage(with: logoURL)
        //self.appLogoImg.image = UIImage(named: "SUFLogo.png")

        ///self.appLogoImg.backgroundColor = OrangeTransperantColor
//        self.baseContentView = self.setCornorShadowEffects(sender: baseContentView)
//        baseContentView.layer.cornerRadius = 5.0
        
        topNavigationView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topNavigationView.layer.shadowOpacity = 0.6
        topNavigationView.layer.shadowRadius = 3.0
        topNavigationView.layer.shadowColor = UIColor.lightGray.cgColor
        headerLbl.text = "\(GlobalLanguageDictionary.object(forKey: "about") as! String)"
        latestVersionLbl.text = "\(GlobalLanguageDictionary.object(forKey: "versionDesc") as! String)"
        updateBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "versionupdate") as! String)", for: .normal)

    }

    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
