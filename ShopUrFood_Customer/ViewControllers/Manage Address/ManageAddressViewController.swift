//
//  ManageAddressViewController.swift
//  ShopUrFood_Customer
//
//  Created by dineshkumarr on 23/10/19.
//  Copyright © 2019 apple4. All rights reserved.
//

import UIKit

class ManageAddressViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var TopNavigationView: UIView!
    @IBOutlet weak var TopHeadingLbl: UILabel!
    @IBOutlet weak var TopBackButton: UIButton!

    @IBOutlet weak var BGView: UIView!
    @IBOutlet weak var manageAddressTableView: UITableView!

    
    //Add Address
    @IBOutlet weak var addAddressGrayView: UIView!
    @IBOutlet weak var addAddressPopUpView: UIView!

    @IBOutlet weak var addAddressHomeButton: UIButton!
    @IBOutlet weak var addAddressWorkButton: UIButton!
    @IBOutlet weak var addAddressOthersButton: UIButton!

    @IBOutlet weak var addAddressHomeRadioImageView: UIImageView!
    @IBOutlet weak var addAddressWorkRadioImageView: UIImageView!
    @IBOutlet weak var addAddressOthersRadioImageView: UIImageView!

    @IBOutlet weak var addAddressButton: UIButton!
    @IBOutlet weak var addNewAddressButton: UIButton!

    @IBOutlet weak var addAddressTxtLbl: UILabel!

    @IBOutlet weak var addAddressInformationTxtField: UITextField!
    @IBOutlet weak var addAddressNameTxtField: UITextField!

    @IBOutlet weak var addressNameTitleHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var addressNameTxtHeightConstraints: NSLayoutConstraint!

    @IBOutlet weak var addAddressSaveButton: UIButton!
    @IBOutlet weak var addAddressCancelButton: UIButton!


    
    var navigationType = String()
    var addressTypeID = Int()
    var editID = Int()
    var deleteID = Int()

    var isFromEditAddressButton = Bool()
    var isFromAddNewAddressButton = Bool()
    var isfromMapLocationPage = Bool()

    var resultDict = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
        self.addAddressHomeRadioImageView.image = UIImage(named: "select_radio")
        self.addAddressWorkRadioImageView.image = UIImage(named: "unSelectRadio")
        self.addAddressOthersRadioImageView.image = UIImage(named: "unSelectRadio")
        addressTypeID = 1
        addressNameTitleHeightConstraints.constant = 0
        addressNameTxtHeightConstraints.constant = 0
        // Do any additional setup after loading the view.
        addAddressPopUpView.layer.cornerRadius = 5.0
        addAddressSaveButton.layer.cornerRadius = 5.0
        addAddressCancelButton.layer.cornerRadius = 5.0
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
     self.navigationController?.navigationBar.isHidden = true
     self.addAddressTxtLbl.text = getAddressFromMapLocationPage
     self.addAddressTxtLbl.textColor = .darkText
    }
    
    
    //MARK:- API Methods
    func getData()
    {
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
        Parse.getCustomerAddress(lang: "en", onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200
            {
                self.resultDict.removeAllObjects()
                self.resultDict.addObjects(from: ((response.object(forKey: "data")as! NSDictionary).value(forKey: "multi_location") as! NSArray) as! [Any])
                self.manageAddressTableView.reloadData()
            }
            else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired"
            {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else
            {
                
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    
    //MARK:- API Methods
       func addAddressAPICalling()
       {
           self.showLoadingIndicator(senderVC: self)
           let Parse = CommomParsing()
        
        if isFromAddNewAddressButton == true
        {
        
            Parse.addNewAddress(lang: "en", address_type: addressTypeID, location: self.addAddressTxtLbl.text!, address_info: self.addAddressInformationTxtField.text!, latitude: getLatitudeFromMapLocationPage, longitude: getLongitudeFromMapLocationPage, address_name: self.addAddressNameTxtField.text!, edit_id: "", zipcode: "0", onSuccess: {
               response in
               print (response)
               if response.object(forKey: "code") as! Int == 200
               {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                self.addAddressGrayView.isHidden = true
                self.getData()

               }
               else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired"
               {
                   self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
               }
               else
               {
                   
               }
               self.stopLoadingIndicator(senderVC: self)
           }, onFailure: {errorResponse in})
        }
        else
        {
        
            Parse.addNewAddress(lang: "en", address_type: addressTypeID, location: self.addAddressTxtLbl.text!, address_info: self.addAddressInformationTxtField.text!, latitude: getLatitudeFromMapLocationPage, longitude: getLongitudeFromMapLocationPage, address_name: self.addAddressNameTxtField.text!, edit_id: self.editID, zipcode: "0", onSuccess: {
               response in
               print (response)
               if response.object(forKey: "code") as! Int == 200
               {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                self.addAddressGrayView.isHidden = true
                self.getData()

               }
               else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired"
               {
                   self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
               }
               else
               {
                   
               }
               self.stopLoadingIndicator(senderVC: self)
           }, onFailure: {errorResponse in})
        }
       }
    
    
    func deleteAddressAPICalling()
    {
        self.showLoadingIndicator(senderVC: self)
        let Parse = CommomParsing()
    
     Parse.deleteAddress(lang: "en", delete_id: self.deleteID, onSuccess: {
            response in
            print (response)
            if response.object(forKey: "code") as! Int == 200
            {
             self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                self.getData()
            }
            else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired"
            {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
            }
            else
            {
                
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    
    
    //MARK:- Tableview Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.resultDict.count == 0
        {
            return 0
        }
        else
        {
            return self.resultDict.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageAddressCell") as? ManageAddressCell
        cell?.selectionStyle = .none
        cell?.BaseView.layer.cornerRadius = 8.0
        createShadowView(getview: cell!.BaseView)
        cell?.editBtn.tag = indexPath.row
        cell?.editBtn.addTarget(self,action:#selector(editBtnClicked(sender:)), for: .touchUpInside)

        cell?.deleteBtn.tag = indexPath.row
        cell?.deleteBtn.addTarget(self,action:#selector(deleteBtnClicked(sender:)), for: .touchUpInside)

        if isfromMapLocationPage == true
        {
            cell?.editBtn.isHidden = true
            cell?.deleteBtn.isHidden = true
        }
        else
        {
            cell?.editBtn.isHidden = false
            cell?.deleteBtn.isHidden = false
        }
        
        if ((self.resultDict.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "loc_type") as! Int) == 1
        {
          cell?.HeadingLbl.text = "Home"
          cell?.IconImageView.image = UIImage(named: "homee")
        }
        else if ((self.resultDict.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "loc_type") as! Int) == 2
        {
          cell?.HeadingLbl.text = "Work"
          cell?.IconImageView.image = UIImage(named: "buil")
        }
        else
        {
            cell?.HeadingLbl.text = "Other"
            cell?.IconImageView.image = UIImage(named: "glo")
        }
        
        cell?.addressLbl.text = "\(((self.resultDict.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "loc_address") as! String))\(((self.resultDict.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "loc_location") as! String))"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isfromMapLocationPage == true
        {
            isFromManagedidSelectAddressPage = true
            getAddressFromMapLocationPage = ((self.resultDict.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "loc_location") as! String)
            getLatitudeFromMapLocationPage = ((self.resultDict.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "loc_latitude") as! String)
            getLongitudeFromMapLocationPage = ((self.resultDict.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "loc_logitude") as! String)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func createShadowView(getview:UIView)
    {
        getview.layer.shadowColor = UIColor.lightGray.cgColor
        getview.layer.shadowOpacity = 1
        getview.layer.shadowOffset = CGSize.zero
        getview.layer.shadowRadius = 5
    }
    
    @objc func editBtnClicked(sender:UIButton)
    {
    let buttonRow = sender.tag
    print("buttonRow is:",buttonRow)
    isFromEditAddressButton = true
    isFromAddNewAddressButton = false
        
    self.addAddressTxtLbl.text = ((self.resultDict.object(at: buttonRow) as? NSDictionary)?.value(forKey: "loc_location") as! String)
    self.addAddressInformationTxtField.text = ((self.resultDict.object(at: buttonRow) as? NSDictionary)?.value(forKey: "loc_address") as! String)
    self.addAddressNameTxtField.text = ((self.resultDict.object(at: buttonRow) as? NSDictionary)?.value(forKey: "loc_address_name") as! String)
    getLatitudeFromMapLocationPage = ((self.resultDict.object(at: buttonRow) as? NSDictionary)?.value(forKey: "loc_latitude") as! String)
    getLongitudeFromMapLocationPage = ((self.resultDict.object(at: buttonRow) as? NSDictionary)?.value(forKey: "loc_logitude") as! String)

    self.addAddressGrayView.isHidden = false
    self.editID = ((self.resultDict.object(at: buttonRow) as? NSDictionary)?.value(forKey: "loc_ic") as! Int)
        
        
    if ((self.resultDict.object(at: buttonRow) as? NSDictionary)?.value(forKey: "loc_type") as! Int) == 1
        {
          addressTypeID = 1
          addressNameTitleHeightConstraints.constant = 0
          addressNameTxtHeightConstraints.constant = 0

          self.addAddressHomeRadioImageView.image = UIImage(named: "select_radio")
          self.addAddressWorkRadioImageView.image = UIImage(named: "unSelectRadio")
          self.addAddressOthersRadioImageView.image = UIImage(named: "unSelectRadio")
        }
        else if ((self.resultDict.object(at: buttonRow) as? NSDictionary)?.value(forKey: "loc_type") as! Int) == 2
        {
          addressNameTitleHeightConstraints.constant = 0
          addressNameTxtHeightConstraints.constant = 0

          print("Work is clicked")
          addressTypeID = 2
          self.addAddressHomeRadioImageView.image = UIImage(named: "unSelectRadio")
          self.addAddressWorkRadioImageView.image = UIImage(named: "select_radio")
          self.addAddressOthersRadioImageView.image = UIImage(named: "unSelectRadio")
        }
        else
        {
            addressNameTitleHeightConstraints.constant = 21
            addressNameTxtHeightConstraints.constant = 34

            print("Other is clicked")
            addressTypeID = 3
            self.addAddressHomeRadioImageView.image = UIImage(named: "unSelectRadio")
            self.addAddressWorkRadioImageView.image = UIImage(named: "unSelectRadio")
            self.addAddressOthersRadioImageView.image = UIImage(named: "select_radio")
        }
        
    }
    
    @objc func deleteBtnClicked(sender:UIButton)
       {
       let buttonRow = sender.tag
       print("buttonRow is:",buttonRow)
        self.deleteID = ((self.resultDict.object(at: buttonRow) as? NSDictionary)?.value(forKey: "loc_ic") as! Int)
       deleteAddressAPICalling()
       }
    
    
    @IBAction func homeIconClicked(_ sender: Any)
    {
      print("Home is clicked")
        addressTypeID = 1
        addressNameTitleHeightConstraints.constant = 0
        addressNameTxtHeightConstraints.constant = 0

        self.addAddressHomeRadioImageView.image = UIImage(named: "select_radio")
        self.addAddressWorkRadioImageView.image = UIImage(named: "unSelectRadio")
        self.addAddressOthersRadioImageView.image = UIImage(named: "unSelectRadio")

    }

    @IBAction func workIconClicked(_ sender: Any)
    {
        addressNameTitleHeightConstraints.constant = 0
        addressNameTxtHeightConstraints.constant = 0

        print("Work is clicked")
        addressTypeID = 2
        self.addAddressHomeRadioImageView.image = UIImage(named: "unSelectRadio")
        self.addAddressWorkRadioImageView.image = UIImage(named: "select_radio")
        self.addAddressOthersRadioImageView.image = UIImage(named: "unSelectRadio")
    }

    @IBAction func othersIconClicked(_ sender: Any)
    {
        addressNameTitleHeightConstraints.constant = 21
        addressNameTxtHeightConstraints.constant = 34

        print("Other is clicked")
        addressTypeID = 3
        self.addAddressHomeRadioImageView.image = UIImage(named: "unSelectRadio")
        self.addAddressWorkRadioImageView.image = UIImage(named: "unSelectRadio")
        self.addAddressOthersRadioImageView.image = UIImage(named: "select_radio")
    }

    @IBAction func addNewAddressBtnClicked(_ sender: Any)
    {
        print("addNewAddressBtnClicked is clicked")
        self.addAddressHomeRadioImageView.image = UIImage(named: "select_radio")
        self.addAddressWorkRadioImageView.image = UIImage(named: "unSelectRadio")
        self.addAddressOthersRadioImageView.image = UIImage(named: "unSelectRadio")
        addressTypeID = 1
        addressNameTitleHeightConstraints.constant = 0
        addressNameTxtHeightConstraints.constant = 0

        self.addAddressTxtLbl.text = "Enter your Location"
        self.addAddressInformationTxtField.text = ""
        self.addAddressNameTxtField.text = ""
        self.addAddressGrayView.isHidden = false
        isFromEditAddressButton = false
        isFromAddNewAddressButton = true
    }
    
    @available(iOS 11.0, *)
    @IBAction func enterLocationButtonClicked(_ sender: Any)
    {
           print("enterLocationButtonClicked is clicked")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MapLocationPage") as! MapLocationPage
        nextViewController.isFromAddAddressPage = true
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func addressSaveButtonClicked(_ sender: Any)
    {
      print("addressSaveButtonClicked is clicked")
        
        if addressTypeID == 1 || addressTypeID == 2
        {
        if self.addAddressTxtLbl.text == "Enter your Location"
        {
         self.showTokenExpiredPopUp(msgStr: "Enter your location")
        }
        else if self.addAddressInformationTxtField.text == ""
        {
          self.showTokenExpiredPopUp(msgStr: "Enter address Information")
        }
        else
        {
         addAddressAPICalling()
        }
        }
        else
        {
          if self.addAddressNameTxtField.text == ""
          {
            self.showTokenExpiredPopUp(msgStr: "Enter address name")
          }
          else
          {
            addAddressAPICalling()
          }
        }
        
    }

    @IBAction func addressCancelButtonClicked(_ sender: Any)
    {
      print("addressCancelButtonClicked is clicked")
        self.addAddressGrayView.isHidden = true

    }

    
    @IBAction func backBtnAction(_ sender: Any)
    {
        if isfromMapLocationPage == true
        {
        self.dismiss(animated: true, completion: nil)
        }
        else
        {
        self.revealViewController().pushFrontViewController(actAsBaseTabbar, animated: true)
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
