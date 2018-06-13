//
//  AddLocationViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/5.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SCLAlertView

class AddDestinationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var dateSelectedText: UITextField!
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var timeText: UITextField!
    @IBOutlet weak var destinationText: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var saveBtn: UIButton!

    let picker =  UIDatePicker()
    let destinationManager = DestinationManager()

    var lat = 0.0
    var long = 0.0
    var dateSelected: [ScheduleDateInfo]?
    var uid: String?
    var pickerView = UIPickerView()
    var daythRow = "Day1"
    var alert = SCLAlertView()
    var previousPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()

//一開始Catagory預設類別為"景點"

        stackView.center.x = self.view.frame.width + 200

        UIView.animate(withDuration: 2.0, delay: 0.5, usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 30,
                       options: [] ,
                       animations: {
                        self.stackView.center.x = self.view.frame.width / 2
        }, completion: nil)

        saveBtn.setConerRect()

//一開始Time顯示現在時間
      getCurrentTime()

      createDatePicker()

      setPickerView()

      searchPlaceTextGesture()

      categoryTextGesture()
        
     timeText.delegate = self
}
    func searchPlaceTextGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchPlaceTapGesture(_:)))

            destinationText.superview?.addGestureRecognizer(tapGesture)
    }

    @objc private dynamic func searchPlaceTapGesture(_ gesture: UITapGestureRecognizer) {
        let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.secondaryTextColor = UIColor.black
            autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)
    }

    func categoryTextGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(categoryTapGesture(_:)))

        categoryText.superview?.addGestureRecognizer(tapGesture)
    }

    @objc private dynamic func categoryTapGesture(_ gesture: UITapGestureRecognizer) {
    }

    func setPickerView() {
        guard let dateselect = dateSelected else {return}
        pickerView.delegate = self
        pickerView.dataSource = self
        dateSelectedText.inputView = pickerView
        dateSelectedText.textAlignment = .center
        dateSelectedText.text = dateselect[0].date
    }

//取得現在時間
    func getCurrentTime() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: date)
        timeText.text = "\(timeString)"
    }

    @IBAction func saveBtn(_ sender: Any) {
        if destinationText.text != "" && dateSelectedText.text != "" && categoryText.text != "" {

                        let saveDate = Destination(name: destinationText.text!, time: timeText.text!, category: categoryText.text!, latitude: lat, longitude: long, query: dateSelectedText.text! + "_" + timeText.text!, uid: "")
                      print(saveDate)
                      destinationManager.saveDestinationInfo(uid: uid!, dayth: daythRow, destination: saveDate)
                      destinationText.text = ""
          //   navigationController?.popViewController(animated: true)
            _ = self.navigationController?.popViewController(animated: true)
            guard    let previousViewController = self.navigationController?.viewControllers.last as? ScheduleDetailViewController else {return}
            previousViewController.backPage = previousPage
            previousViewController.ggg?.tableView.reloadData()

        //    self.navigationController?.dismiss(animated: true, completion: {
//                guard let detail = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleDetailViewController ") as? ScheduleDetailViewController else {return}
//                self.detailVC?.backPage = self.previousPage

  //         })

        } else {
            AlertManager.showEdit(title: Constants.WrongMessage, subTitle: Constants.NoEmpty)
        }

    }

//Time Picker
    func createDatePicker() {
        let toolbar = UIToolbar()
            toolbar.sizeToFit()
        //Done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
            toolbar.setItems([done], animated: false)

         timeText.inputAccessoryView = toolbar
         timeText.inputView = picker
         picker.datePickerMode = .time
    }

    @objc func donePressed() {
// formatdate
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: picker.date)

        timeText.text = "\(timeString)"
        self.view.endEditing(true)
    }

//MARK： category 類別設定，要換圖
    @IBAction func spotBtn(_ sender: Any) {
        categoryText.text = "景點"
        categoryText.textColor =  TSColor.gradientBlue.color()
    }
    @IBAction func restaurantBtn(_ sender: Any) {
         categoryText.text = "餐廳"
         categoryText.textColor = TSColor.gradientPurple.color()

    }
    @IBAction func hotelBtn(_ sender: Any) {
     categoryText.text = "住宿"
     categoryText.textColor = TSColor.gradientBlue.color()
    }

    @IBAction func otherBtn(_ sender: Any) {
        categoryText.text = "其它"
        categoryText.textColor = TSColor.gradientPurple.color()
    }

//Search Location
    @IBAction func streetViewBtn(_ sender: Any) {
                    if lat != 0.0 && long != 0.0 {
                        guard let dismenstionViewController = UIStoryboard(name: "Schedule", bundle: nil)
                                        .instantiateViewController(withIdentifier: "DismenstionViewController")as? GoogleStreeViewController else {return}
                        dismenstionViewController.lat = lat
                        dismenstionViewController.long  = long
                        self.navigationController?.pushViewController(dismenstionViewController, animated: true)
                    } else {
                        AlertManager.showEdit(title: Constants.Destination.AddDestination, subTitle: Constants.Destination.StreetView)
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let selected = dateSelected else {return 0}
        return selected.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let selected = dateSelected else {return ""}
        daythRow = selected[row].dayth
        return selected[row].date + "   " + selected[row].dayth

    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let selected = dateSelected else {return}
        dateSelectedText.text = selected[row].date
        previousPage  = row
    }
}

//Search Location  (Auto complete)
extension AddDestinationViewController: GMSAutocompleteViewControllerDelegate,UITextFieldDelegate {

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)

            lat = place.coordinate.latitude
            long = place.coordinate.longitude
//placeText 顯示 Locaion Name
            destinationText.text = place.name
        self.dismiss(animated: true, completion: nil) // dismiss after select place
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error auto complete\(error)")
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
}
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if newText.isEmpty { return true }
        
        if Int(newText) != nil { return true }
        
        return false 
    }
    

}
