//
//  WrokingHoursViewController.swift
//  ShopUrFood_Customer
//
//  Created by apple4 on 01/04/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class WrokingHoursViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var navigationTitleLbl: UILabel!
    
    @IBOutlet weak var hoursTable: UITableView!
    @IBOutlet weak var baseContentView: UIView!
    var workingHoursArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()

        baseContentView.layer.cornerRadius = 5.0
        baseContentView = self.setCornorShadowEffects(sender: baseContentView)
        hoursTable.layer.cornerRadius = 5.0
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationTitleLbl.text = "\(GlobalLanguageDictionary.object(forKey: "workinghours") as! String)"
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Tableview Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workingHoursArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkingHoursTableViewCell") as? WorkingHoursTableViewCell
        cell?.selectionStyle = .none
        let dataDict = NSMutableDictionary()
        dataDict.addEntries(from: (workingHoursArray.object(at: indexPath.row)as! NSDictionary) as! [AnyHashable : Any])
        let dayString = dataDict.object(forKey: "working_date")as! String
        let first3 = String(dayString.prefix(3))
        cell?.dayLbl.text = first3
        cell?.openTimeLbl.text = "\(GlobalLanguageDictionary.object(forKey: "from_time") as! String)"
        cell?.closeTimeLbl.text = "\(GlobalLanguageDictionary.object(forKey: "to_time") as! String)"

        let openTime = dataDict.object(forKey: "working_from_time")as! String
        let closeTime = dataDict.object(forKey: "working_end_time")as! String
        cell?.openTimeValueLbl.text = ": \(openTime)"
        cell?.closeTimeValueLbl.text = ": \(closeTime)"
        let statusStr = dataDict.object(forKey: "available_status")as! String
        if statusStr == "Available"{
            cell?.closeView.backgroundColor = UIColor.clear
        }else{
            cell?.closeView.backgroundColor = WhiteTranspertantColor
        }
        cell?.statusLbl.text = statusStr
        cell?.baseView = self.setCornorShadowEffects(sender: (cell?.baseView)!)

        return cell!
    }
    
    

}
