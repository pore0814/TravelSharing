//
//  ScheduleDetailViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/5.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class ScheduleDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    var getDateInfo = [DateInfo]()
    
    
    @IBOutlet weak var detailCollectionViwe: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
detailCollectionViwe.reloadData()
        
        let addBarButtonItem = UIBarButtonItem.init(title: "Add", style: .done, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = addBarButtonItem
        
        detailCollectionViwe.delegate =  self
        detailCollectionViwe.dataSource =  self
        
        let nib = UINib(nibName: "DetailCollectionViewCell", bundle: nil)
        self.detailCollectionViwe.register(nib, forCellWithReuseIdentifier: "DetailCollectionViewCell")
        
        //CollectionView 間距設定
        let layout = detailCollectionViwe.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: (self.view.frame.size.width/2.0) - 2.0 , height: 50)
            //(self.view.frame.size.height/5.0) - 2.0)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 2.0
        layout.minimumInteritemSpacing = 2.0
        detailCollectionViwe.setCollectionViewLayout(layout, animated: false)


       
    }

    @objc func addTapped(sender: AnyObject) {
        print("hjxdbsdhjbv")
        let scheduleDetailToAddLocation = UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "AddLocationViewController") as!
        AddLocationViewController

        self.navigationController?.pushViewController(scheduleDetailToAddLocation, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getDateInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = detailCollectionViwe.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as! DetailCollectionViewCell
        cell.dateLabel.text = getDateInfo[indexPath.row].date
        cell.weekLabel.text = String(getDateInfo[indexPath.row].weekDay)
        return cell
    }
    

}
