//
//  AddLocationViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/5.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController {

    //@IBOutlet weak var stackview: UIStackView!
   
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var timeText: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //https://stackoverflow.com/questions/30991822/whats-the-swift-3-animatewithduration-syntax
      stackView.center.x = self.view.frame.width + 200
        UIView.animate(withDuration: 2.0, delay: 1.0,usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 30,
                       options: [] ,
                       animations: {
                  self.stackView.center.x = self.view.frame.width / 2
        }, completion: nil)
        
        
      getTime()
}
    
    
    func getTime(){
        let date = Date()
        let calendar = Calendar.current
        
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        dateText.text = "\(year)-\(month)-\(day)"
        
        
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        timeText.text = "\(hour):\(minutes)"
        
        
    }
    
}
