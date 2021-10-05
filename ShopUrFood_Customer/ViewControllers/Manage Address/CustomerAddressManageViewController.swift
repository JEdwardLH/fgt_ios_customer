//
//  InfoRestaurantViewController.swift
//  ShopUrFood_Customer
//
//  Created by JHernandez on 4/19/20.
//  Copyright © 2020 apple4. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces
import Lottie
import SWRevealViewController
import BottomPopup
import SCLAlertView
import AFNetworking
@available(iOS 11.0, *)
class CustomerAddressManageViewController: BaseViewController,CLLocationManagerDelegate,GMSMapViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate, UIPickerViewDataSource  {
    
    
    
    @IBOutlet weak var tipstext: UILabel!
    @IBOutlet weak var animtationView: UIView!
    @IBOutlet weak var pickerCancel: UIButton!
    @IBOutlet weak var pickerSelect: UIButton!
    @IBOutlet weak var listingpickerview: UIPickerView!
    @IBOutlet weak var pickerview: UIView!
    @IBOutlet weak var closeSearchBtn: UIButton!
    @IBOutlet weak var addressViewBottom: UIView!
    @IBOutlet weak var selectedAddress2: UILabel!
    @IBOutlet weak var selectedAddress1: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var buttonDown: UIButton!
    @IBOutlet weak var buttonUp: UIButton!
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var placeTable: UITableView!
   
    @IBOutlet weak var getLocationBtn: UIButton!
    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet weak var apply2: UIButton!
    @IBOutlet weak var cancel2: UIButton!
    var window: UIWindow?
    var addressType = String()
    var height: CGFloat?
    var myAddressDict = NSMutableDictionary()
    var storeName = String()
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var st_latitude = String()
    var st_longitude = String()
    var locationAddress = ""
    var location_address_name = ""
    var location_landmark = ""
    var location_id = 0
    var location_lat = ""
    var location_long = ""
    var location_lat2 = ""
    var location_long2 = ""
    var ishomeEdit = false
    var isworkEdit = false
    var isotherEdit = false
    var selectedAddress = String()
    var isApply = false
    var country = ""
    var addressString = String()
    var addressString2 = String()
    var locationManager = CLLocationManager()
    var fromPage = String()
    var placeSearchArray = NSMutableArray()
    var setFrom = "api"
    var buildingtypeList = [String]()
    var provinceList = NSMutableArray()
    var districtList = NSMutableArray()
    var subdistrictList = NSMutableArray()
    var clickSection = 0
    var pickerList = NSMutableArray()
    var bToggle = true
    var bToggle1 = true
    var bToggle2 = true
    var isCustom = false
    var pickerselect = 0
    @IBOutlet weak var fullMapView: GMSMapView!
    @IBOutlet weak var baseMapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        buildingtypeList.append("Condominium")
        buildingtypeList.append("Townhouse")
        buildingtypeList.append("Detached house")
        buildingtypeList.append("Office building")
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "googleMapStyle", withExtension: "json") {
                baseMapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                fullMapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Unable to find style.json")
            }
        } catch {
            print("One or more of the map styles failed to load. \(error)")
        }
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        baseMapView.delegate = self
        fullMapView.delegate = self
        baseMapView.isMyLocationEnabled = true
        baseMapView.settings.myLocationButton = false
        fullMapView.isMyLocationEnabled = true
        fullMapView.settings.myLocationButton = false
        getLocationBtn.layer.cornerRadius = 25.0
        getLocationBtn.clipsToBounds = true
        getLocationBtn.backgroundColor = UIColor.white
        apply2.addTarget(self, action:#selector(self.applyAddress), for: .touchUpInside)
        apply2.setTitle("\(GlobalLanguageDictionary.object(forKey: "txt_checkout_apply") as! String)", for: .normal)
        cancel2.addTarget(self, action:#selector(self.cancelPage), for: .touchUpInside)
        cancel2.setTitle("\(GlobalLanguageDictionary.object(forKey: "txt_checkout_cancel") as! String)", for: .normal)
        var province1 = ""
        
        
        self.searchTxt.delegate = self
        self.searchTxt.tag = 2
        self.searchTxt.addTarget(self, action: #selector(typingNameSearch), for: .editingChanged)
        self.searchTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "search") as! String)"
        if (self.myAddressDict.object(forKey: "shipping_address")) != nil{
            let addressval  = (self.myAddressDict.object(forKey: "shipping_address") as! NSDictionary).value(forKey: "sh_location") as! String
            self.addressString2 = addressval
            self.selectedAddress1.text = addressval
            let arradd = addressval.components(separatedBy: ",")
            self.selectedAddress2.text = arradd[arradd.count - 1]
        }
        getCustomerShipping()
        showTipsView()
       
    }
    
    func showTipsView(){
        animtationView.isHidden = false
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        let lightBlackTranspertantColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.3)
        let tempView = LOTAnimationView(name: "TapAnimation")
        let ypt = self.tipstext.frame.origin.y
        tempView.frame = CGRect(x:((appDelegate?.window?.frame.size.width)! - 150)/2, y: ypt, width: 150, height: 150
        )
        animtationView.backgroundColor = lightBlackTranspertantColor
        animtationView.addSubview(tempView)
        
        tempView.play()
        tempView.loopAnimation = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        animtationView.addGestureRecognizer(tap)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        animtationView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
     
       self.closeSearchBtn.isHidden = true
       self.addressViewBottom.isHidden = true
       self.selectedAddress2.isHidden = true
       self.selectedAddress1.isHidden = true
       self.cancelBtn.isHidden = true
       self.acceptBtn.isHidden = true
       self.buttonDown.isHidden = false
       self.buttonUp.isHidden = true
       self.searchTxt.isHidden = true
       self.placeTable.isHidden = true
       self.fullMapView.isHidden = true
      
        self.location_lat = self.st_latitude
        self.location_long = self.st_longitude
       
        self.baseMapView.clear()
        self.fullMapView.clear()
        // handle nil value
        
    cancelBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "txt_checkout_cancel") as! String)", for: .normal)
    acceptBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "txt_checkout_apply") as! String)", for: .normal)
        let MomentaryLatitude = Double(st_latitude) as! Double
        
        let MomentaryLongitude = Double(st_longitude) as! Double
        
        var coordinate = CLLocationCoordinate2D()
        coordinate.latitude = MomentaryLatitude
        coordinate.longitude = MomentaryLongitude
        let position = CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude)
        let marker = GMSMarker(position: position)
        marker.isDraggable=true
        let markerfull = GMSMarker(position: position)
        markerfull.isDraggable=true
        markerfull.map = self.fullMapView
        marker.map = self.baseMapView
        //marker.icon = GMSMarker.markerImage(with: AppLightOrange)
        markerfull.icon = self.imageWithImage(image: UIImage(named: "ic_marker_user1")!, scaledToSize: CGSize(width: 30.0, height:45.0))
        
        marker.icon = self.imageWithImage(image: UIImage(named: "ic_marker_user1")!, scaledToSize: CGSize(width: 30.0, height:45.0))
       
        markerfull.appearAnimation = GMSMarkerAnimation.pop
        marker.appearAnimation = GMSMarkerAnimation.pop
        let lat = String(coordinate.latitude)
        let lon = String(coordinate.longitude)
       
        let camera = GMSCameraPosition.camera(withLatitude: MomentaryLatitude ?? 0, longitude: MomentaryLongitude ?? 0, zoom: 16)
        self.baseMapView?.camera = camera
        self.baseMapView?.animate(to: camera)
        self.fullMapView?.camera = camera
        self.fullMapView.animate(to: camera)
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        
        
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        
        self.setFrom = "search"
          
          
       
        let lat = marker.position.latitude
        let lon =  marker.position.longitude
        self.location_lat = "\(lat)"
        self.location_long = "\(lon)"
        self.geocode(latitude: lat, longitude: lon) { placemark, error in
               guard let placemark = placemark, error == nil else { return }
               
                   // you should always update your UI in the main thread
                   DispatchQueue.main.async {
                       //  update UI here
                       
                       let address1 =  placemark.thoroughfare ?? ""
                       let address2 = placemark.subThoroughfare ?? ""
                       let address3 = placemark.subLocality ?? ""
                       let city = placemark.locality ?? ""
                       let state = placemark.administrativeArea ?? ""
                       let country_val = placemark.country ?? ""
                       let zipcode = placemark.postalCode ?? ""
                       self.country = country_val
                       let indexPath = IndexPath.init(row: 0, section: 1)
                       let cell = self.addressTableView.cellForRow(at: indexPath) as! CartDeliveryDetailInfoCell
                       var place = "\(placemark)"
                       cell.addressField.text = ""
                     
                       
                       cell.buildingName.text = ""
                       cell.buildingType.text = ""
                       cell.floor.text = ""
                       cell.roomHouseNo.text = ""
                       cell.noteToRider.text = ""
                       self.setFrom = "search"
                       self.addressString = ""
                       let indexPathx = IndexPath.init(row: 0, section: 0)
                            
                                     
                       self.addressTableView.scrollToRow(at: indexPathx, at: .bottom, animated: false)
                       let indexPath2 = IndexPath.init(row: 0, section: 0)
                       let cell2 = self.addressTableView.cellForRow(at: indexPath2) as! CartDeliveryAddressCell
                       let pm = placemark
                       if pm.subThoroughfare != nil {
                              self.addressString = self.addressString + pm.subThoroughfare! + ", "
                       }
                       if pm.subLocality != nil {
                            self.addressString = self.addressString + pm.subLocality! + ", "
                       }
                       if pm.thoroughfare != nil {
                              self.addressString = self.addressString + pm.thoroughfare! + ", "
                       }
                       if pm.locality != nil {
                               self.addressString = self.addressString + pm.locality! + ", "
                       }
                       if pm.country != nil {
                              self.addressString = self.addressString + pm.country! + ", "
                           cell2.selectedAddressValue2.text = pm.country!
                           self.selectedAddress2.text = pm.country!
                   
                       }
                       if pm.postalCode != nil {
                               self.addressString = self.addressString + pm.postalCode! + " "
                       }
                       cell2.selectedAddressValue.text = self.addressString
                       self.selectedAddress1.text = self.addressString
                       
                       
                   }
               
               
           }
        

    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.setFrom = "search"
           print("Tapped at coordinate: " + String(coordinate.latitude) + " "
               + String(coordinate.longitude))
        
           mapView.clear()
           let position = CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude)
           let marker = GMSMarker(position: position)
           marker.isDraggable=true
           marker.map = mapView
           marker.icon = self.imageWithImage(image: UIImage(named: "ic_marker_user1")!, scaledToSize: CGSize(width: 30.0, height:45.0))
           marker.appearAnimation = GMSMarkerAnimation.pop
           let lat = coordinate.latitude
           let lon = coordinate.longitude
           self.location_lat = "\(lat)"
           self.location_long = "\(lon)"
           self.geocode(latitude: lat, longitude: lon) { placemark, error in
                   guard let placemark = placemark, error == nil else { return }
                   
                       // you should always update your UI in the main thread
                       DispatchQueue.main.async {
                           //  update UI here
                           
                           let address1 =  placemark.thoroughfare ?? ""
                           let address2 = placemark.subThoroughfare ?? ""
                           let address3 = placemark.subLocality ?? ""
                           let city = placemark.locality ?? ""
                           let state = placemark.administrativeArea ?? ""
                           let country_val = placemark.country ?? ""
                           let zipcode = placemark.postalCode ?? ""
                           self.country = country_val
                           let indexPath = IndexPath.init(row: 0, section: 1)
                           let cell = self.addressTableView.cellForRow(at: indexPath) as! CartDeliveryDetailInfoCell
                           var place = "\(placemark)"
                           cell.addressField.text = ""
                          
                           
                           cell.buildingName.text = ""
                           cell.buildingType.text = ""
                           cell.floor.text = ""
                           cell.roomHouseNo.text = ""
                           cell.noteToRider.text = ""
                           self.setFrom = "search"
                           self.addressString = ""
                           let indexPathx = IndexPath.init(row: 0, section: 0)
                                
                                         
                           self.addressTableView.scrollToRow(at: indexPathx, at: .bottom, animated: false)
                           let indexPath2 = IndexPath.init(row: 0, section: 0)
                           let cell2 = self.addressTableView.cellForRow(at: indexPath2) as! CartDeliveryAddressCell
                           let pm = placemark
                           if pm.subThoroughfare != nil {
                                  self.addressString = self.addressString + pm.subThoroughfare! + ", "
                           }
                           if pm.subLocality != nil {
                                self.addressString = self.addressString + pm.subLocality! + ", "
                           }
                           if pm.thoroughfare != nil {
                                  self.addressString = self.addressString + pm.thoroughfare! + ", "
                           }
                           if pm.locality != nil {
                                   self.addressString = self.addressString + pm.locality! + ", "
                           }
                           if pm.country != nil {
                                  self.addressString = self.addressString + pm.country! + ", "
                               cell2.selectedAddressValue2.text = pm.country!
                               self.selectedAddress2.text = pm.country!
                       
                           }
                           if pm.postalCode != nil {
                                   self.addressString = self.addressString + pm.postalCode! + " "
                           }
                           cell2.selectedAddressValue.text = self.addressString
                           self.selectedAddress1.text = self.addressString
                           
                           
                       }
                   
                   
               }
        
    }
    
    @IBAction func hidePicker(_ sender: Any) {
        pickerview.isHidden = true
    }
    
    @IBAction func selectMeta(_ sender: Any) {
        pickerview.isHidden = true
        let indexPath2 = IndexPath.init(row: 0, section: 1)
        let cell = self.addressTableView.cellForRow(at: indexPath2) as! CartDeliveryDetailInfoCell
        let name = ((self.pickerList.object(at: pickerselect) as? NSDictionary)?.value(forKey: "name") as! String)
        let nameth = ((self.pickerList.object(at: pickerselect) as? NSDictionary)?.value(forKey: "name_th") as! String)
        let lang = ((login_session.value(forKey: "Language") as? String) ?? "th")
        if clickSection == 1 {
            
           
        }else if clickSection == 2 {
            
          
           
          
        }else if clickSection == 3 {
           
          
        }
        
        clickSection = 0
    }
    @IBAction func showSubdistrict(_ sender: Any) {
        self.pickerList = self.subdistrictList
        clickSection = 3
        self.listingpickerview.reloadAllComponents()
        pickerview.isHidden = false
    }
    @IBAction func showDistrict(_ sender: Any) {
        self.pickerList = self.districtList
        clickSection = 2
        self.listingpickerview.reloadAllComponents()
        pickerview.isHidden = false
    }
    @IBAction func showProvinceList(_ sender: Any) {
        
        self.pickerList = self.provinceList
        clickSection = 1
        self.listingpickerview.reloadAllComponents()
        pickerview.isHidden = false
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if clickSection == 0 {
            return 0
        }else{
            return self.pickerList.count
        }
        
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

       if clickSection == 0 {
            return ""
        }else{
            let lang = ((login_session.value(forKey: "Language") as? String) ?? "th")
        if lang == "en"{
            let provincename = ((self.pickerList.object(at: row) as? NSDictionary)?.value(forKey: "name") as! String)
            return provincename
        }else{
            let provincename = ((self.pickerList.object(at: row) as? NSDictionary)?.value(forKey: "name_th") as! String)
            return provincename
        }
            
        }
    
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         pickerselect = row
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 11 || tableView.tag == 111{
            return placeSearchArray.count
        }else if tableView.tag == 20{
            return 4
        }else{
            return 2
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if tableView.tag == 11 || tableView.tag == 111{
            return 1
        }else if tableView.tag == 20{
            return 1
        }else{
            if self.myAddressDict.count != 0{
                return 1
            }else{
                return 0
            }
           
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 20{
           let indexPath2 = IndexPath.init(row: 0, section: 1)
           let cell = self.addressTableView.cellForRow(at: indexPath2) as! CartDeliveryDetailInfoCell
                
           cell.buildingTypeTableView.isHidden = true
            
            cell.buildingType.text = buildingtypeList[indexPath.section]
        }else if tableView.tag == 111{
            self.searchTxt.endEditing(true)
            var placeId = String()
            let tempDict = NSMutableDictionary()
            tempDict.addEntries(from: (placeSearchArray.object(at: indexPath.section)as! NSDictionary) as! [AnyHashable : Any])
            self.searchTxt.text = (tempDict.object(forKey: "description") as! String)
            placeId = tempDict.object(forKey: "place_id")as! String
            self.getLatitudeLogitude(place_id: placeId){ (result) -> Void in
                print(result)
                self.baseMapView.clear()
                let MomentaryLatitude = result.object(forKey: "lat")as! Double
                let MomentaryLongitude = result.object(forKey: "lng")as! Double
                var coordinate = CLLocationCoordinate2D()
                coordinate.latitude = MomentaryLatitude
                coordinate.longitude = MomentaryLongitude
                let position = CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude)
                let marker = GMSMarker(position: position)
                marker.isDraggable=true
                marker.map = self.baseMapView
                marker.icon = GMSMarker.markerImage(with: AppLightOrange)
                marker.title = "Tap to select location"

                marker.appearAnimation = GMSMarkerAnimation.pop
                let lat = coordinate.latitude
                let lon = coordinate.longitude
                self.location_lat = "\(lat)"
                self.location_long = "\(lon)"
                let camera = GMSCameraPosition.camera(withLatitude: MomentaryLatitude, longitude: MomentaryLongitude, zoom: 16)
                self.fullMapView?.camera = camera
                self.fullMapView?.animate(to: camera)
                self.geocode(latitude: lat, longitude: lon) { placemark, error in
                guard let placemark = placemark, error == nil else { return }
                
                    // you should always update your UI in the main thread
                    DispatchQueue.main.async {
                        self.addressString2 = ""
                      
                        let pm = placemark
                        if pm.subThoroughfare != nil {
                               self.addressString2 = self.addressString2 + pm.subThoroughfare! + ", "
                        }
                        if pm.subLocality != nil {
                             self.addressString2 = self.addressString2 + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                               self.addressString2 = self.addressString2 + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                                self.addressString2 = self.addressString2 + pm.locality! + ", "
                        }
                        if pm.country != nil {
                               self.addressString2 = self.addressString2 + pm.country! + ", "
                            self.selectedAddress2.text = pm.country!
                        }
                        if pm.postalCode != nil {
                                self.addressString2 = self.addressString2 + pm.postalCode! + " "
                        }
                        self.selectedAddress1.text = self.addressString2
                    }
                }
            }
        }else if tableView.tag == 11{
            self.setFrom = "search"
            let indexPath = IndexPath.init(row: 0, section: 0)
            let cell = self.addressTableView.cellForRow(at: indexPath) as! CartDeliveryAddressCell
            cell.searchTxt.endEditing(true)
            cell.searchTxt.isHidden = true
            cell.searchCloseBtn.isHidden = true
            var placeId = String()
            let tempDict = NSMutableDictionary()
            tempDict.addEntries(from: (placeSearchArray.object(at: indexPath.section)as! NSDictionary) as! [AnyHashable : Any])
            cell.searchTxt.text = (tempDict.object(forKey: "description") as! String)
            placeId = tempDict.object(forKey: "place_id")as! String
            self.getLatitudeLogitude(place_id: placeId){ (result) -> Void in
                print(result)
                self.baseMapView.clear()
                let MomentaryLatitude = result.object(forKey: "lat")as! Double
                let MomentaryLongitude = result.object(forKey: "lng")as! Double
                var coordinate = CLLocationCoordinate2D()
                coordinate.latitude = MomentaryLatitude
                coordinate.longitude = MomentaryLongitude
                let position = CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude)
                let marker = GMSMarker(position: position)
                marker.isDraggable=true
                marker.map = self.baseMapView
                marker.icon = GMSMarker.markerImage(with: AppLightOrange)
                marker.title = "Tap to select location"

                marker.appearAnimation = GMSMarkerAnimation.pop
                let lat = coordinate.latitude
                let lon = coordinate.longitude
                self.location_lat = "\(lat)"
                self.location_long = "\(lon)"
                let camera = GMSCameraPosition.camera(withLatitude: MomentaryLatitude, longitude: MomentaryLongitude, zoom: 16)
                self.baseMapView?.camera = camera
                self.baseMapView?.animate(to: camera)
                self.geocode(latitude: lat, longitude: lon) { placemark, error in
                    guard let placemark = placemark, error == nil else { return }
                    
                        // you should always update your UI in the main thread
                        DispatchQueue.main.async {
                            //  update UI here
                            
                            let address1 =  placemark.thoroughfare ?? ""
                            let address2 = placemark.subThoroughfare ?? ""
                            let address3 = placemark.subLocality ?? ""
                            let city = placemark.locality ?? ""
                            let state = placemark.administrativeArea ?? ""
                            let country_val = placemark.country ?? ""
                            let zipcode = placemark.postalCode ?? ""
                            self.country = country_val
                            let indexPath = IndexPath.init(row: 0, section: 1)
                            let cell = self.addressTableView.cellForRow(at: indexPath) as! CartDeliveryDetailInfoCell
                            var place = "\(placemark)"
                            cell.addressField.text = ""
                           
                            cell.buildingName.text = ""
                            cell.buildingType.text = ""
                            cell.floor.text = ""
                            cell.roomHouseNo.text = ""
                            cell.noteToRider.text = ""
                            self.setFrom = "search"
                            self.addressString = ""
                            let indexPath2 = IndexPath.init(row: 0, section: 0)
                            let cell2 = self.addressTableView.cellForRow(at: indexPath2) as! CartDeliveryAddressCell
                            let pm = placemark
                            if pm.subThoroughfare != nil {
                                   self.addressString = self.addressString + pm.subThoroughfare! + ", "
                            }
                            if pm.subLocality != nil {
                                 self.addressString = self.addressString + pm.subLocality! + ", "
                            }
                            if pm.thoroughfare != nil {
                                   self.addressString = self.addressString + pm.thoroughfare! + ", "
                            }
                            if pm.locality != nil {
                                    self.addressString = self.addressString + pm.locality! + ", "
                            }
                            if pm.country != nil {
                                   self.addressString = self.addressString + pm.country! + ", "
                                cell2.selectedAddressValue2.text = pm.country!
                            }
                            if pm.postalCode != nil {
                                    self.addressString = self.addressString + pm.postalCode! + " "
                            }
                            cell2.selectedAddressValue.text = self.addressString
                            
                            
                            
                        }
                    
                    
                }
            }
        }
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
            if indexPath.section == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CartDeliveryAddressCell") as? CartDeliveryAddressCell
                    cell?.selectionStyle = .none
                if self.addressType == "home"{
                    cell?.homeBtn.backgroundColor = AppLightOrange
                    cell?.homeBtn.setTitleColor(UIColor.white, for: .normal)
                    cell?.homeBtn.layer.borderColor = AppDarkOrange.cgColor
                }else{
                    cell?.homeBtn.backgroundColor = UIColor.white
                    cell?.homeBtn.setTitleColor(UIColor.darkText, for: .normal)
                    cell?.homeBtn.layer.borderColor = AppDarkOrange.cgColor
                }
                if self.addressType == "work"{
                    cell?.workBtn.backgroundColor = AppLightOrange
                    cell?.workBtn.setTitleColor(UIColor.white, for: .normal)
                    cell?.workBtn.layer.borderColor = AppDarkOrange.cgColor
                }else{
                    cell?.workBtn.backgroundColor = UIColor.white
                    cell?.workBtn.setTitleColor(UIColor.darkText, for: .normal)
                    cell?.workBtn.layer.borderColor = AppDarkOrange.cgColor
                }
                if self.addressType == "other"{
                    cell?.otherBtn.backgroundColor = AppLightOrange
                    cell?.otherBtn.setTitleColor(UIColor.white, for: .normal)
                    cell?.otherBtn.layer.borderColor = AppDarkOrange.cgColor
                }else{
                    cell?.otherBtn.backgroundColor = UIColor.white
                    cell?.otherBtn.setTitleColor(UIColor.darkText, for: .normal)
                    cell?.otherBtn.layer.borderColor = AppDarkOrange.cgColor
                }
                
                cell?.applyBtn.addTarget(self, action:#selector(self.applyAddress), for: .touchUpInside)
                cell?.applyBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "txt_checkout_apply") as! String)", for: .normal)
                cell?.cancelBtn.addTarget(self, action:#selector(self.cancelPage), for: .touchUpInside)
                cell?.cancelBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "txt_checkout_cancel") as! String)", for: .normal)
                cell?.homeBtn.addTarget(self, action:#selector(self.setHomeAddress), for: .touchUpInside)
                cell?.workBtn.addTarget(self, action:#selector(self.setWrokAddress), for: .touchUpInside)
                cell?.otherBtn.addTarget(self, action:#selector(self.setOtherAddress), for: .touchUpInside)
                cell?.deliveryDetailLabel.text = "\(GlobalLanguageDictionary.object(forKey: "txt_checkout_delivery_detail") as! String)"
                self.location_address_name = ""
                
                let mutliAddress = self.myAddressDict.object(forKey: "multi_address") as! NSArray
                var addressType = 1
                if self.addressType == "home"{
                    addressType = 1
                   // let addressArr = address.components(separatedBy: ",")
                }else if self.addressType == "work"{
                    addressType = 2
                    
                }else{
                    addressType = 3
                }
                var address = ""
                
                if mutliAddress.count != 0{
                    for item in mutliAddress {
                        let type = (item as! NSDictionary).object(forKey: "loc_type") as! Int
                        
                        if type == addressType{
                           
                            self.location_address_name = (item as! NSDictionary).object(forKey: "loc_address_name") as! String
                            address = (item as! NSDictionary).object(forKey: "loc_location") as! String
                        }
                        

                    }

                }
               
                let addressArray = address.components(separatedBy: ",")
                
                if addressArray.count > 2{
                    cell?.selectedAddressValue2.text = addressArray[addressArray.count-2]
                }else{
                    cell?.selectedAddressValue2.text = ""
                }
                var locaaddressval = ""
                
                 
                 
                 if addressArray.count > 0{
                     if addressArray[0] != ""{
                         locaaddressval =   addressArray[0]
                     }
                 }
                 if addressArray.count > 1{
                     if addressArray[1] != ""  && addressArray[1] != " "{
                        if locaaddressval == ""{
                            locaaddressval =  addressArray[1]
                        }else{
                            locaaddressval = locaaddressval  + ", " + addressArray[1]
                        }
                         
                     }
                 }
                 if addressArray.count > 2{
                     if addressArray[2] != ""  && addressArray[2] != " "{
                         if locaaddressval == ""{
                             locaaddressval =  addressArray[2]
                         }else{
                             locaaddressval = locaaddressval  + ", " + addressArray[2]
                         }
                     }
                 }
                 if addressArray.count > 3{
                     if addressArray[3] != ""  && addressArray[3] != " "{
                         if locaaddressval == ""{
                             locaaddressval =  addressArray[3]
                         }else{
                             locaaddressval = locaaddressval  + ", " + addressArray[3]
                         }
                     }
                 }
                 if addressArray.count > 4{
                     if addressArray[4] != ""  && addressArray[4] != " "{
                         if locaaddressval == ""{
                             locaaddressval =  addressArray[4]
                         }else{
                             locaaddressval = locaaddressval  + ", " + addressArray[4]
                         }
                     }
                 }
                 if addressArray.count > 5{
                     if addressArray[5] != ""  && addressArray[5] != " "{
                         if locaaddressval == ""{
                             locaaddressval =  addressArray[5]
                         }else{
                             locaaddressval = locaaddressval  + ", " + addressArray[5]
                         }
                     }
                 }
                 if addressArray.count > 6{
                      if addressArray[6] != ""  && addressArray[6] != " "{
                          if locaaddressval == ""{
                              locaaddressval =  addressArray[6]
                          }else{
                              locaaddressval = locaaddressval  + ", " + addressArray[6]
                          }
                      }
                 }
                
                 if addressArray.count > 7{
                    if addressArray[7] != ""  && addressArray[7] != " "{
                        if locaaddressval == ""{
                            locaaddressval =  addressArray[7]
                        }else{
                            locaaddressval = locaaddressval  + ", " + addressArray[7]
                        }
                    }
                     
                 }
                if self.setFrom == "api"{
                    cell?.selectedAddressValue.text = locaaddressval
                    
                }
                
                
                
                cell?.searchCloseBtn.addTarget(self, action:#selector(self.closeSearch), for: .touchUpInside)
                cell?.editBtn.addTarget(self, action:#selector(self.openSearch), for: .touchUpInside)
                cell?.searchTxt.delegate = self
                cell?.searchTxt.tag = 1
                cell?.searchTxt.addTarget(self, action: #selector(typingName), for: .editingChanged)
                cell?.editBtn.setTitle("\(GlobalLanguageDictionary.object(forKey: "txt_checkout_edit_button") as! String)", for: .normal)
                cell?.searchTxt.placeholder = "\(GlobalLanguageDictionary.object(forKey: "search") as! String)"
                return cell!
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CartDeliveryDetailInfoCell") as? CartDeliveryDetailInfoCell
                let mutliAddress = self.myAddressDict.object(forKey: "multi_address") as! NSArray
                var addressType = 1
                if self.addressType == "home"{
                    addressType = 1
                   // let addressArr = address.components(separatedBy: ",")
                }else if self.addressType == "work"{
                    addressType = 2
                    
                }else{
                    addressType = 3
                }
                self.location_lat = ""
                self.location_long = ""
                self.locationAddress = ""
                self.location_address_name = ""
                self.location_landmark = ""
                self.location_id = 0
                if mutliAddress.count != 0{
                    for item in mutliAddress {
                        let type = (item as! NSDictionary).object(forKey: "loc_type") as! Int
                        
                        if type == addressType{
                            self.locationAddress = (item as! NSDictionary).object(forKey: "loc_location") as! String
                            self.location_landmark = (item as! NSDictionary).object(forKey: "loc_address") as! String
                            self.location_id = (item as! NSDictionary).object(forKey: "loc_id") as! Int
//                            self.location_lat = (item as! NSDictionary).object(forKey: "loc_latitude") as! String
//                            self.location_long = (item as! NSDictionary).object(forKey: "loc_logitude") as! String
                            self.location_address_name = (item as! NSDictionary).object(forKey: "loc_address_name") as! String
                            
                            cell?.addressField.text = (item as! NSDictionary).object(forKey: "loc_address") as! String
                           
                            cell?.buildingName.text = (item as! NSDictionary).object(forKey: "village_name") as! String
                            cell?.buildingType.text = (item as! NSDictionary).object(forKey: "buiding_type") as! String
                            cell?.floor.text = (item as! NSDictionary).object(forKey: "land_floor") as! String
                            cell?.roomHouseNo.text = (item as! NSDictionary).object(forKey: "land_room") as! String
                            cell?.noteToRider.text = (item as! NSDictionary).object(forKey: "land_note") as! String
                        }
                        

                    }

                }
               
               
                
                cell?.buildingType.addTarget(self, action: #selector(myTargetFunction), for: UIControl.Event.touchDown)
                cell?.buildingType.addTarget(self, action: #selector(myTargetFunction), for: UIControl.Event.touchUpInside)
                
                
                cell?.buildingTypeBtn.addTarget(self, action:#selector(self.myTargetFunction), for: .touchUpInside)
               
                
                
                cell?.buildingTypeTableView.layer.borderColor = UIColor.gray.cgColor
                cell?.buildingTypeTableView.layer.borderWidth = 1.0
                cell?.addressInfoLabel.text = "\(GlobalLanguageDictionary.object(forKey: "txt_checkout_addressinformation") as! String)"
                cell?.moredetailLabel.text = "\(GlobalLanguageDictionary.object(forKey: "txt_checkout_moredetail") as! String)"
               cell?.noteToRider.placeholder = "\(GlobalLanguageDictionary.object(forKey: "txt_checkout_placeholder_landmark") as! String)"
               cell?.roomHouseNo.placeholder = "\(GlobalLanguageDictionary.object(forKey: "txt_checkout_placeholder_room") as! String)"
               cell?.floor.placeholder = "\(GlobalLanguageDictionary.object(forKey: "txt_checkout_placeholder_floor") as! String)"
               
               cell?.addressField.placeholder = "\(GlobalLanguageDictionary.object(forKey: "txt_checkout_placeholder_add") as! String)"
               cell?.buildingName.placeholder = "\(GlobalLanguageDictionary.object(forKey: "txt_checkout_placeholder_blg") as! String)"
               cell?.buildingType.placeholder = "\(GlobalLanguageDictionary.object(forKey: "txt_checkout_placeholder_btype") as! String)"
                cell?.selectionStyle = .none
                 return cell!
            }
        
        
    }
    @objc func myTargetFunction(textField: UITextField) {
        let indexPath = IndexPath.init(row: 0, section: 1)
        let cell = self.addressTableView.cellForRow(at: indexPath) as! CartDeliveryDetailInfoCell
        self.bToggle = !self.bToggle
        cell.buildingTypeTableView.isHidden = self.bToggle
    }
    @objc func myTargetFunction1(textField: UITextField) {
        let indexPath = IndexPath.init(row: 0, section: 1)
        let cell = self.addressTableView.cellForRow(at: indexPath) as! CartDeliveryDetailInfoCell
        self.bToggle1 = !self.bToggle1
       
    }
    @objc func myTargetFunction2(textField: UITextField) {
        let indexPath = IndexPath.init(row: 0, section: 1)
        let cell = self.addressTableView.cellForRow(at: indexPath) as! CartDeliveryDetailInfoCell
        self.bToggle2 = !self.bToggle2
       
    }
    @objc func setHomeAddress(sender: UIButton!) {
        self.addressType = "home";
        self.setFrom = "api"

        self.addressTableView.reloadData()
        self.selectedAddress = "Home"
    }
    @objc func setWrokAddress(sender: UIButton!) {
        self.addressType = "work";
        self.setFrom = "api"
        self.addressTableView.reloadData()
        self.selectedAddress = "Work"
    }
    @objc func setOtherAddress(sender: UIButton!) {
        self.addressType = "other";
        self.setFrom = "api"
        self.addressTableView.reloadData()
        self.selectedAddress = "Other"
    }
    
    
    @objc func openSearch(sender: UIButton!) {
       let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.addressTableView.cellForRow(at: indexPath) as! CartDeliveryAddressCell
        cell.searchTxt.isHidden = false
        cell.searchTxt.becomeFirstResponder()
        cell.searchCloseBtn.isHidden = false
        cell.searchTxt.text = ""
        cell.placeTable.isHidden = true
        cell.selectedAddressValue.isHidden = true
        cell.selectedAddressValue2.isHidden = true
    }
    @objc func closeSearch(sender: UIButton!) {
       let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.addressTableView.cellForRow(at: indexPath) as! CartDeliveryAddressCell
       
        cell.searchTxt.text = ""
        cell.placeTable.isHidden = true
    }
    @objc func applyAddress(sender: UIButton!) {
       // if fromPage == "checkout"{
            self.saveAddress()
//        }else{
//
//           if globalCartCount != 0
//                       {
//                           let refreshAlert = UIAlertController(title: "Message from HungryNow", message: "\(GlobalLanguageDictionary.object(forKey: "Your cart will be emptied, if you change your address. Are you sure you want you to proceed ?") as! String)", preferredStyle: UIAlertController.Style.alert)
//
//                           refreshAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
//
//                                self.saveshipp()
//
//                           }))
//                           refreshAlert.addAction(UIAlertAction(title: "NO", style: .default, handler: { (action: UIAlertAction!) in
//                               refreshAlert .dismiss(animated: true, completion: nil)
//                           }))
//
//                           self.present(refreshAlert, animated: true, completion: nil)
//
//           }else{
//                self.saveshipp()
//            }
//
//
//        }
        
    }
    
    func saveshipp(){
        self.showLoadingIndicator(senderVC: self)
         let Parse = CommomParsing()
         let indexPath = IndexPath.init(row: 0, section: 1)
         let cell = self.addressTableView.cellForRow(at: indexPath) as! CartDeliveryDetailInfoCell
         //[0 - Address][1 - Moo]][2 - Soi][3 - district][4 - subdistrict][5 - province][7 - postal code]
        var  locationvalue = ""
        var locationAddress = ""
        if self.isCustom == true{
            locationvalue = self.addressString2
        }else{
             locationvalue = "\(cell.addressField.text ?? ""), \(self.country)"
             //0 - building , 1 - building type, 2 - floor, 3 - room #, 4 -note/landmark
              locationAddress = "\(cell.buildingName.text ?? ""), \(cell.buildingType.text ?? ""), \(cell.floor.text ?? ""), \(cell.roomHouseNo.text ?? ""), \(cell.noteToRider.text ?? "")"
             
            
             let indexPath2 = IndexPath.init(row: 0, section: 0)
             let cell2 = self.addressTableView.cellForRow(at: indexPath2) as! CartDeliveryAddressCell
            location_address_name = ""
        }
         
         Parse.saveShippingAddress(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"), search_latitude: self.location_lat, search_longitude: self.location_long, zipcode: "0" ?? "", location: locationvalue, address: locationAddress, onSuccess: {
            response in
            
            if response.object(forKey: "code") as! Int == 200
            {
             let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
             login_session.setValue(self.location_lat, forKey: "user_latitude")
             login_session.setValue(self.location_long, forKey: "user_longitude")
             login_session.setValue(locationAddress, forKey: "user_address")
             login_session.synchronize()
                self.isApply = true
                self.dismiss(animated: true, completion: nil)
            }
            else if response.object(forKey: "code")as! Int == 400
            {
                self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
                self.showTipsView()
            }
            else
            {
                self.showTipsView()
                
            }
            self.stopLoadingIndicator(senderVC: self)
        }, onFailure: {errorResponse in})
    }
    @objc func cancelPage(sender: UIButton!) {
        self.isApply = false
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func closeBtnTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveAddress(){
        var addressTypeID = 1
        var isNewAddress = true
        if self.addressType == "home"{
            addressTypeID = 1
            if self.ishomeEdit == true{
                isNewAddress = false
            }
        }else if self.addressType == "work"{
            addressTypeID = 2
            if self.isworkEdit == true{
                isNewAddress = false
            }
        }else{
            addressTypeID = 3
            if self.isotherEdit == true{
                isNewAddress = false
            }
        }
        var tokenStr = String()
          if login_session.value(forKey: "user_token") != nil {
              if login_session.value(forKey: "user_token") as! String != "" {
                  tokenStr = login_session.value(forKey: "user_token") as! String
              }
          }
        var editid = "\(self.location_id)"
        if isNewAddress == false{
            editid = ""
        }else{
            
            if self.location_id == 0{
                editid = ""
            }
        }
        
          
        let finalURL:String = BASEURL_CUSTOMER+ADD_NEW_ADDRESS
       
       
        
        var params = NSMutableDictionary()
        let indexPath = IndexPath.init(row: 0, section: 1)
        let cell = self.addressTableView.cellForRow(at: indexPath) as! CartDeliveryDetailInfoCell
        let indexPath2 = IndexPath.init(row: 0, section: 0)
        
                 
        self.addressTableView.scrollToRow(at: indexPath2, at: .bottom, animated: false)
        let cell2 = self.addressTableView.cellForRow(at: indexPath2) as! CartDeliveryAddressCell
        params = [
            "lang": ((login_session.value(forKey: "Language") as? String) ?? "th"),
            "address_type" : addressTypeID,
            "address_info" : cell.addressField.text,
            "latitude" : self.location_lat,
            "longitude" : self.location_long,
            "address_name" : self.addressType,
            "edit_id" : editid,
            "land_floor" : cell.floor.text,
            "land_room" : cell.roomHouseNo.text,
            "land_note" : cell.noteToRider.text,
            
        ]
      
        print(params)
        let tokenString = "Bearer " + tokenStr
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
       
        manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/plain", "text/html", "application/json"]) as Set<NSObject> as? Set<String>
        manager.requestSerializer.setValue(tokenString, forHTTPHeaderField: "Authorization")
        manager.post(finalURL, parameters: params, headers: [:], progress: nil, success: { (operation, responseObject) -> Void in
            print(responseObject)
            let response:NSDictionary = responseObject as! NSDictionary
            
            if response.object(forKey: "code") as! Int == 200
            {
               
                    self.getCustomerShipping()
                    self.isApply = true
                    self.dismiss(animated: true, completion: nil)
                
             

            }
            else if response.object(forKey: "code")as! Int == 400
            {
                self.showFailed(msgStr: response.object(forKey: "message")as! String  )
            }
            else
            {

            }
           
        }, failure: { (operation, error) -> Void in
          
        })
    }
    
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
    }
    func getCustomerShipping(){
        let Parse = CommomParsing()
        self.showLoadingIndicator(senderVC: self)
        
          Parse.getCustomerAddress(lang: ((login_session.value(forKey: "Language") as? String) ?? "th"), onSuccess: {
              response in
              print (response)
              if response.object(forKey: "code") as! Int == 200
              {
                 
                    self.myAddressDict.addEntries(from: (response.object(forKey: "data")as! NSDictionary) as! [AnyHashable : Any])
                    self.setFrom = "api"
                    self.addressTableView.reloadData()
                    self.stopLoadingIndicator(senderVC: self)
              }
              else if response.object(forKey: "code")as! Int == 400 && response.object(forKey: "message")as! String == "Token is Expired"
              {
                  self.showTokenExpiredPopUp(msgStr: response.object(forKey: "message")as! String)
              }
              else
              {
                  self.stopLoadingIndicator(senderVC: self)
              }
              
          }, onFailure: {errorResponse in
            self.stopLoadingIndicator(senderVC: self)
          })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        _ = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 15.0)
        baseMapView.camera = camera
        baseMapView.isMyLocationEnabled = true
        locationManager.stopUpdatingLocation()
        let position = CLLocationCoordinate2DMake(userLocation!.coordinate.latitude,userLocation!.coordinate.longitude)
        baseMapView.clear()
        let marker = GMSMarker(position: position)
        marker.isDraggable=true
        marker.map = self.baseMapView
        marker.icon = self.imageWithImage(image: UIImage(named: "ic_marker_user1")!, scaledToSize: CGSize(width: 30.0, height:45.0))
        marker.title = "Tap to select location"

        marker.appearAnimation = GMSMarkerAnimation.pop
        let lat = userLocation!.coordinate.latitude
        let lon = userLocation!.coordinate.longitude

        self.location_lat = "\(lat)"
        self.location_long = "\(lon)"
        self.geocode(latitude: lat, longitude: lon) { placemark, error in
                guard let placemark = placemark, error == nil else { return }
                
                    // you should always update your UI in the main thread
                    DispatchQueue.main.async {
                        //  update UI here
                        
                        let address1 =  placemark.thoroughfare ?? ""
                        let address2 = placemark.subThoroughfare ?? ""
                        let address3 = placemark.subLocality ?? ""
                        let city = placemark.locality ?? ""
                        let state = placemark.administrativeArea ?? ""
                        let country_val = placemark.country ?? ""
                        let zipcode = placemark.postalCode ?? ""
                        self.country = country_val
                        let indexPath = IndexPath.init(row: 0, section: 1)
                        let cell = self.addressTableView.cellForRow(at: indexPath) as! CartDeliveryDetailInfoCell
                        var place = "\(placemark)"
                        cell.addressField.text = ""
                       
                        
                        cell.buildingName.text = ""
                        cell.buildingType.text = ""
                        cell.floor.text = ""
                        cell.roomHouseNo.text = ""
                        cell.noteToRider.text = ""
                        self.setFrom = "search"
                        self.addressString = ""
                        let indexPathx = IndexPath.init(row: 0, section: 0)
                             
                                      
                        self.addressTableView.scrollToRow(at: indexPathx, at: .bottom, animated: false)
                        let indexPath2 = IndexPath.init(row: 0, section: 0)
                        let cell2 = self.addressTableView.cellForRow(at: indexPath2) as! CartDeliveryAddressCell
                        let pm = placemark
                        if pm.subThoroughfare != nil {
                               self.addressString = self.addressString + pm.subThoroughfare! + ", "
                        }
                        if pm.subLocality != nil {
                             self.addressString = self.addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                               self.addressString = self.addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                                self.addressString = self.addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                               self.addressString = self.addressString + pm.country! + ", "
                            cell2.selectedAddressValue2.text = pm.country!
                            self.selectedAddress2.text = pm.country!
                    
                        }
                        if pm.postalCode != nil {
                                self.addressString = self.addressString + pm.postalCode! + " "
                        }
                        cell2.selectedAddressValue.text = self.addressString
                        self.selectedAddress1.text = self.addressString
                        
                        
                    }
                
                
            
            
           
            
            
        }
    }
    
    func isLocationEnable()    -> String {
        
        let locStatus = CLLocationManager.authorizationStatus()
        switch locStatus {
           case .notDetermined:
              locationManager.requestWhenInUseAuthorization()
           return "not"
           case .denied, .restricted:
            locationManager.requestWhenInUseAuthorization()
           return "not"
           case .authorizedAlways, .authorizedWhenInUse:
            
            return "allowed"
           
        }
    }
    func showFailed(msgStr:String){
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "TruenoBd", size: 20.0)!,
            kTextFont: UIFont(name: "TruenoRg", size: 14.0)!,
            kButtonFont: UIFont(name: "TruenoBd", size: 16.0)!,
            showCloseButton: false,
            dynamicAnimatorActive: false,
            buttonsLayout: .horizontal
        )
        let alert = SCLAlertView(appearance: appearance)
        _ = alert.addButton("Ok") {
            

        }
        
        let icon = UIImage(named:"ic_info")
        let color = UIColor.red
        
        _ = alert.showCustom("Failed", subTitle: msgStr, color: color, icon: icon!, circleIconImage: icon!)
    }
    @IBAction func currentLocationBtnAction(_ sender: UIButton) {
        if isLocationEnable() == "allowed"{
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }else{
            self.showFailed(msgStr: "Please turn on device location and allow app permission " )
        }
    }
    @objc func typingName(textField:UITextField){
        if let typedText = textField.text {
            googlePlacesResult(input: typedText) { (result) -> Void in
                print(result)
        }
        }
    }
    @objc func typingNameSearch(textField:UITextField){
        if let typedText = textField.text {
            googlePlacesResult2(input: typedText) { (result) -> Void in
                print(result)
        }
        }
    }
    func googlePlacesResult2(input: String, completion: @escaping (_ result: NSArray) -> Void) {
       
           
           let urlString = NSString(format: "https://foodtogodeliveryph.com/autocomplete/json?input=%@",input)
            
            print(urlString)
                        let url = NSURL(string: urlString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)!)
                    
                    //let url = URL(string: urlString as String)
                        //print(url!)
                        let defaultConfigObject = URLSessionConfiguration.default
                        let delegateFreeSession = URLSession(configuration: defaultConfigObject, delegate: nil, delegateQueue: OperationQueue.main)
                        let request = NSURLRequest(url: url! as URL)
                        let task =  delegateFreeSession.dataTask(with: request as URLRequest, completionHandler:
                        {
                            (data, response, error) -> Void in
                            if let data = data
                            {
                                do {
                                    let jSONresult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                                    let results:NSArray = jSONresult["predictions"] as! NSArray
                                    let status = jSONresult["status"] as! String
                                    if status == "NOT_FOUND" || status == "REQUEST_DENIED"
                                    {
            //                            let userInfo:NSDictionary = ["error": jSONresult["status"]!]
            //                            let newError = NSError(domain: "API Error", code: 666, userInfo: userInfo as [NSObject : AnyObject])
            //                            let arr:NSArray = [newError]
            //                            completion(arr)
                                        return
                                    }
                    else
                                    {
                                        self.placeSearchArray.removeAllObjects()
                                        self.placeSearchArray.addObjects(from: results as! [NSDictionary])
                                        if self.placeSearchArray.count == 0 {
                                           
                                            self.placeTable.isHidden = true
                                        }else{
                                            
                                            self.placeTable.isHidden = false
                                            
                                           
                                            self.placeTable.reloadData()
                                           
                                        }
                                        completion(results)
                                    }
                                }
                                catch
                                {
                                    print("json error: \(error)")
                                }
                            }
                            else if let error = error
                            {
                                print(error)
                            }
                        })
                        task.resume()


            
    }
    func googlePlacesResult(input: String, completion: @escaping (_ result: NSArray) -> Void) {
       
            let indexPath = IndexPath.init(row: 0, section: 0)
            let cell = self.addressTableView.cellForRow(at: indexPath) as! CartDeliveryAddressCell
           let urlString = NSString(format: "https://foodtogodeliveryph.com/autocomplete/json?input=%@",input)
            
            print(urlString)
                        let url = NSURL(string: urlString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)!)
                    
                    //let url = URL(string: urlString as String)
                        //print(url!)
                        let defaultConfigObject = URLSessionConfiguration.default
                        let delegateFreeSession = URLSession(configuration: defaultConfigObject, delegate: nil, delegateQueue: OperationQueue.main)
                        let request = NSURLRequest(url: url! as URL)
                        let task =  delegateFreeSession.dataTask(with: request as URLRequest, completionHandler:
                        {
                            (data, response, error) -> Void in
                            if let data = data
                            {
                                do {
                                    let jSONresult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                                    let results:NSArray = jSONresult["predictions"] as! NSArray
                                    let status = jSONresult["status"] as! String
                                    if status == "NOT_FOUND" || status == "REQUEST_DENIED"
                                    {
            //                            let userInfo:NSDictionary = ["error": jSONresult["status"]!]
            //                            let newError = NSError(domain: "API Error", code: 666, userInfo: userInfo as [NSObject : AnyObject])
            //                            let arr:NSArray = [newError]
            //                            completion(arr)
                                        return
                                    }
                    else
                                    {
                                        self.placeSearchArray.removeAllObjects()
                                        self.placeSearchArray.addObjects(from: results as! [NSDictionary])
                                        if self.placeSearchArray.count == 0 {
                                            cell.placeTable.isHidden = true
                                            
                                        }else{
                                            cell.placeTable.isHidden = false
                                            
                                           
                                            
                                            cell.placeTable.reloadData()
                                        }
                                        completion(results)
                                    }
                                }
                                catch
                                {
                                    print("json error: \(error)")
                                }
                            }
                            else if let error = error
                            {
                                print(error)
                            }
                        })
                        task.resume()


            
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1{
            let indexPath = IndexPath.init(row: 0, section: 0)
            self.addressTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            let cell = self.addressTableView.cellForRow(at: indexPath) as! CartDeliveryAddressCell
            cell.searchCloseBtn.isHidden = true
            cell.searchTxt.isHidden = true
            cell.searchCloseBtn.isHidden = true
            cell.placeTable.isHidden = true
            
            cell.selectedAddressValue.isHidden = false
            cell.selectedAddressValue2.isHidden = false
        }else{
            self.placeTable.isHidden = true
        }
        
        
    }
    func getLatitudeLogitude(place_id: String,completion: @escaping (_ result: NSDictionary) -> Void) {
        
        if (login_session.value(forKey: "Language") as? String) == "en"
        {
        let urlString = NSString(format: "https://foodtogodeliveryph.com/place/details/json?input=&placeid=%@",place_id)
            
        print(urlString)
        //let url = NSURL(string: urlString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)!)
        let url = URL(string: urlString as String)
        print(url!)
        let defaultConfigObject = URLSessionConfiguration.default
        let delegateFreeSession = URLSession(configuration: defaultConfigObject, delegate: nil, delegateQueue: OperationQueue.main)
        let request = NSURLRequest(url: url! as URL)
        let task =  delegateFreeSession.dataTask(with: request as URLRequest, completionHandler:
        {
            (data, response, error) -> Void in
            if let data = data
            {
                do {
                    let jSONresult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                    if jSONresult["result"] != nil{
                        let resultsDict:NSDictionary = jSONresult["result"] as! NSDictionary
                        let geometryDict:NSDictionary = resultsDict["geometry"]as! NSDictionary
                        let locationDict:NSDictionary = geometryDict["location"]as! NSDictionary
                        let status = jSONresult["status"] as! String
                        if status == "NOT_FOUND" || status == "REQUEST_DENIED"
                        {
                            //                            let userInfo:NSDictionary = ["error": jSONresult["status"]!]
                            //                            let newError = NSError(domain: "API Error", code: 666, userInfo: userInfo as [NSObject : AnyObject])
                            //                            let arr:NSArray = [newError]
                            //                            completion(arr)
                            return
                        }
                        else
                        {
                            completion(locationDict)
                        }
                    }
                    
                }
                catch
                {
                    print("json error: \(error)")
                }
            }
            else if let error = error
            {
                print(error)
            }
        })
        task.resume()
        }
        else
        {
            let urlString = NSString(format: "https://foodtogodeliveryph.com/place/details/json?input=&placeid=%@&key=AIzaSyAUSBquvfmOg6-YMDxAVRYkDABzk9yoO3o&language=th",place_id)
            print(urlString)
            //let url = NSURL(string: urlString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)!)
            let url = URL(string: urlString as String)
            print(url!)
            let defaultConfigObject = URLSessionConfiguration.default
            let delegateFreeSession = URLSession(configuration: defaultConfigObject, delegate: nil, delegateQueue: OperationQueue.main)
            let request = NSURLRequest(url: url! as URL)
            let task =  delegateFreeSession.dataTask(with: request as URLRequest, completionHandler:
            {
                (data, response, error) -> Void in
                if let data = data
                {
                    do {
                        let jSONresult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                        let resultsDict:NSDictionary = jSONresult["result"] as! NSDictionary
                        let geometryDict:NSDictionary = resultsDict["geometry"]as! NSDictionary
                        let locationDict:NSDictionary = geometryDict["location"]as! NSDictionary
                        let status = jSONresult["status"] as! String
                        if status == "NOT_FOUND" || status == "REQUEST_DENIED"
                        {
                            //                            let userInfo:NSDictionary = ["error": jSONresult["status"]!]
                            //                            let newError = NSError(domain: "API Error", code: 666, userInfo: userInfo as [NSObject : AnyObject])
                            //                            let arr:NSArray = [newError]
                            //                            completion(arr)
                            return
                        }
                        else
                        {
                            completion(locationDict)
                        }
                    }
                    catch
                    {
                        print("json error: \(error)")
                    }
                }
                else if let error = error
                {
                    print(error)
                }
            })
            task.resume()

        }
        
    }
    func getAddressFromLatLon(pdblLatitude: String, pdblLongitude: String) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.addressTableView.cellForRow(at: indexPath) as! CartDeliveryAddressCell
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        self.addressString = ""
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        if #available(iOS 11.0, *) {
            ceo.reverseGeocodeLocation(loc, preferredLocale: Locale.init(identifier: ((login_session.value(forKey: "Language") as? String)!)), completionHandler: {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                 self.addressString = ""
                if pm.count > 0 {
                    let pm = placemarks![0]
                    if pm.subThoroughfare != nil {
                           self.addressString = self.addressString + pm.subThoroughfare! + ", "
                    }
                    if pm.subLocality != nil {
                         self.addressString = self.addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                           self.addressString = self.addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                            self.addressString = self.addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                           self.addressString = self.addressString + pm.country! + ", "
                        cell.selectedAddressValue2.text = pm.country!
                    }
                    if pm.postalCode != nil {
                            self.addressString = self.addressString + pm.postalCode! + " "
                    }
                    
                    
                    print(self.addressString)
                    
                    self.st_latitude = pdblLatitude
                                        
                    self.st_longitude = pdblLongitude
                                        
                }
            })
        } else {
            // Fallback on earlier versions
        }
        
        

        

    }
    
    
    @IBAction func buttonDownTap(_ sender: Any) {
        
        self.addressViewBottom.isHidden = false
        self.selectedAddress2.isHidden = false
        self.selectedAddress1.isHidden = false
        self.cancelBtn.isHidden = false
        self.acceptBtn.isHidden = false
        self.buttonDown.isHidden = true
        self.buttonUp.isHidden = false
        self.searchTxt.isHidden = false
       
        self.fullMapView.isHidden = false
    }
    @IBAction func buttonUpTap(_ sender: Any) {
       
        self.addressViewBottom.isHidden = true
        self.selectedAddress2.isHidden = true
        self.selectedAddress1.isHidden = true
        self.cancelBtn.isHidden = true
        self.acceptBtn.isHidden = true
        self.buttonDown.isHidden = false
        self.buttonUp.isHidden = true
        self.searchTxt.isHidden = true
        self.placeTable.isHidden = true
        self.fullMapView.isHidden = true
    }
   
    @IBAction func applychanges(_ sender: Any) {
       
        if fromPage == "checkout"{
            self.saveAddress()
        }else if fromPage == "register"{
             self.saveAddress()
        }else if fromPage == "registersns"{
             self.saveAddress()
        }else{
         
           if globalCartCount != 0
                       {
                           let refreshAlert = UIAlertController(title: "Message from HungryNow", message: "\(GlobalLanguageDictionary.object(forKey: "Your cart will be emptied, if you change your address. Are you sure you want you to proceed ?") as! String)", preferredStyle: UIAlertController.Style.alert)
                           
                           refreshAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
                               
                                 self.saveAddress()
                               
                           }))
                           refreshAlert.addAction(UIAlertAction(title: "NO", style: .default, handler: { (action: UIAlertAction!) in
                               refreshAlert .dismiss(animated: true, completion: nil)
                           }))
                           
                           self.present(refreshAlert, animated: true, completion: nil)
                           
           }else{
                 self.saveAddress()
            }
          
            
        }
    }
    
     
    
    @IBAction func cancelClose(_ sender: Any) {
       
            self.dismiss(animated: true, completion: nil)
        
        
    }
}
