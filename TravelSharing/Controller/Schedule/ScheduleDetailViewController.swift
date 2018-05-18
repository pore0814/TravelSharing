//
//  ScheduleDetailViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/5.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class ScheduleDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    var getDateInfo = [DateInfo]() {
        didSet {
            print("set data in ScheduleDetailViewController")
        }
    }
    
    @IBOutlet weak var destinationScrollView: UIScrollView!
    
    let destination1 = ["destination":"Annie's Home","time":"9:00"]
    let destination2 = ["destination":"Sam's Home","time":"10:00"]
    let destination3 = ["destination":"Luke's Home","time":"12:00"]
    
    var Array = [Dictionary<String,String>]()
    
    @IBOutlet weak var detailCollectionViwe: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailCollectionViwe.reloadData()
        Array = [destination1,destination2,destination3]
        destinationScrollView.isPagingEnabled = true
        destinationScrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(Array.count), height: 250)
        destinationScrollView.showsVerticalScrollIndicator = false
        
        
        
        
        
        let addBarButtonItem = UIBarButtonItem.init(title: "Add", style: .done, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = addBarButtonItem
        
        detailCollectionViwe.delegate =  self
        detailCollectionViwe.dataSource =  self
        
        let nib = UINib(nibName: "DetailCollectionViewCell", bundle: nil)
        self.detailCollectionViwe.register(nib, forCellWithReuseIdentifier: "DetailCollectionViewCell")

        //CollectionView 間距設定
        let layout = detailCollectionViwe.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: (self.view.frame.size.width/2.0) - 2.0 , height: 100)
        let insetX = (view.bounds.width - (self.view.frame.size.width/2.0)) / 2.0
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: insetX , bottom: 0, right: insetX)
            layout.minimumLineSpacing = 2.0
            layout.minimumInteritemSpacing = 2.0
        detailCollectionViwe.setCollectionViewLayout(layout, animated: false)
        
        loadFeatures()
        
    }

    func loadFeatures(){
        for (index, destination) in Array.enumerated(){
            if let destinationView = Bundle.main.loadNibNamed("LocationView", owner: self, options: nil)?.first as? LocationView{
                destinationView.destinationLabel.text = destination["destination"]
                destinationView.arrivalLabel.text = destination["time"]
                
                destinationScrollView.addSubview(destinationView)
                destinationView.frame.size.width = self.view.bounds.size.width
                destinationView.frame.origin.x = CGFloat(index) * self.view.bounds.size.width
            }
        }
        
    }
    
    
    
    @objc func addTapped(sender: AnyObject) {
        print("hjxdbsdhjbv")
        let scheduleDetailToAddLocation = UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "AddLocationViewController") as!
        AddLocationViewController
    self.navigationController?.pushViewController(scheduleDetailToAddLocation, animated: true)
        getDateInfo.removeAll()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getDateInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = detailCollectionViwe.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as! DetailCollectionViewCell
        cell.dateLabel.text = getDateInfo[indexPath.row].date
        cell.weekLabel.text = String(getDateInfo[indexPath.row].weekDay)
        print(getDateInfo[indexPath.row].date)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        scrollView.contentOffset.x / scrollView.frame.width
//
//    }
    
}
/*
extension ScheduleDetailViewController : UIScrollViewDelegate{
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.detailCollectionViwe.collectionViewLayout as!
        UICollectionViewFlowLayout
        
        let cellwidthIncludingSapcing = layout.itemSize.width + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellwidthIncludingSapcing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellwidthIncludingSapcing - scrollView.contentInset.left, y: roundedIndex * cellwidthIncludingSapcing - scrollView.contentInset.left)
        targetContentOffset.pointee = offset
    }
    
}
 */
