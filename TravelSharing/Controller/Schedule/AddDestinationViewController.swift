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

class AddLocationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var dateSelectedText: UITextField!
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var timeText: UITextField!
    @IBOutlet weak var destinationText: UITextField!
    @IBOutlet weak var stackView: UIStackView!

    let picker =  UIDatePicker()
    let destinationManager = DestinationManager()

    var lat = 0.0
    var long = 0.0
    var dateSelected: [DateInfo]?
    var uid: String?
    var pickerView = UIPickerView()
    var daythRow = "Day1"

    override func viewDidLoad() {
        super.viewDidLoad()

//中心點設在畫面寛度中心點再+200 , animate設時間帶, 將stackview中心點帶到畫面寬度的中心點
       stackView.center.x = self.view.frame.width + 200

        UIView.animate(withDuration: 2.0, delay: 1.0, usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 30,
                       options: [] ,
                       animations: {
                  self.stackView.center.x = self.view.frame.width / 2
        }, completion: nil)
//一開始Time顯示現在時間
        getTime()
//一開始Catagory預設類別為"景點"
        categoryText.text = "景點"
        createDatePicker()

        for index in dateSelected! {
            print(index.date)
            dateSelectedText.text = index.date
        }
// pickView
        guard let dateselect = dateSelected else {return}
        pickerView.delegate = self
        pickerView.dataSource = self
        dateSelectedText.inputView = pickerView
        dateSelectedText.textAlignment = .center
        dateSelectedText.text = dateselect[0].date

}

//取得現在時間
    func getTime() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: date)
        timeText.text = "\(timeString)"
        //timeText.text = "\(hour):\(minutes)"
    }

    @IBAction func saveBtn(_ sender: Any) {
        if destinationText.text! == "" {
            AlertToUser().alert.showError(Constants.WrongMessage, subTitle: "請選擇目的地")
        } else {
            let saveDate = Destination(name: destinationText.text!, time: timeText.text!, date: dateSelectedText.text!, category: categoryText.text!, latitude: lat, longitude: long, query: dateSelectedText.text! + "_" + timeText.text!, uid: "")
          print(saveDate)
          destinationManager.saveDestinationInfo(uid: uid!, dayth: daythRow, destination: saveDate)
            navigationController?.popViewController(animated: true)
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
// format date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: picker.date)

        timeText.text = "\(timeString)"
        self.view.endEditing(true)
    }

//MARK： category 類別設定，要換圖
    @IBAction func spotBtn(_ sender: Any) {
        categoryText.text = "景點"
    }
    @IBAction func restaurantBtn(_ sender: Any) {
         categoryText.text = "餐廳"
    }
    @IBAction func hotelBtn(_ sender: Any) {
     categoryText.text = "住宿"
    }

//Search Location
    @IBAction func searchLocation(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.secondaryTextColor = UIColor.black
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)
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
    }

}

//Search Location  (Auto complete)
extension AddLocationViewController: GMSAutocompleteViewControllerDelegate {

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)

        lat = place.coordinate.latitude
        long = place.coordinate.longitude

            if lat != nil && long != nil {
                guard let dismenstionViewController = UIStoryboard(name: "Schedule", bundle: nil)
                                .instantiateViewController(withIdentifier: "DismenstionViewController")as? DismenstionViewController else {return}
                dismenstionViewController.lat = place.coordinate.latitude
                dismenstionViewController.long  = place.coordinate.longitude
                self.navigationController?.pushViewController(dismenstionViewController, animated: true)
              } else {
                AlertToUser().alert.showEdit(Constants.WrongMessage, subTitle: "需要正確位置哦")
            }
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

}
