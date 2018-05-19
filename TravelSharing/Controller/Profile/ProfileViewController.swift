//
//  ProfileViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/4/29.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

      downloadImage()
    }

    @IBAction func logOut(_ sender: Any) {
        guard let switchToLoginPage = AppDelegate.shared?.switchToLoginViewController() else {return}
        UserManager.shared.logout()
        switchToLoginPage
    }
    func downloadImage(){
       profileImage.contentMode = .scaleAspectFill
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/travelshare-d17da.appspot.com/o/profile_image%2FrzuKSTPn3EPZsKc50sMUgZqlRIo2?alt=media&token=ebc23e6b-3f09-40bb-9e45-739fb0df59cc")
        URLSession.shared.dataTask(with: url!) { (data, res, error) in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.profileImage.image = UIImage(data: data!)
            }
        }.resume()
    }

    }
