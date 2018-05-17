//
//  ScheduleDetailViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/5.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class ScheduleDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var getDateInfo = [DateInfo]() {
        didSet {
            print("set data in ScheduleDetailViewController")
        }
    }
    var schedulDetail: ScheduleInfo?
    let dateFormatter1 = TSDateFormatter1()

    @IBOutlet weak var destinationScrollView: UIScrollView!
    @IBOutlet weak var detailCollectionViwe: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
//nagivation Bar 顯示Scheudle名稱
        navigationItem.title = schedulDetail?.name
//日期dateFormatter function 用起程日期及天數計算出所有date 
        guard let detail = schedulDetail else {return}
        getDateInfo =  dateFormatter1.getYYMMDD(indexNumber: detail)
//呼叫Destination Detail ViewController內容
        guard let obj1 = self.storyboard?.instantiateViewController(withIdentifier: "DistinationViewController") as?
                                                                    DistinationViewController else {return}
        destinationScrollView.frame = obj1.view.frame
        self.destinationScrollView.addSubview(obj1.view)
//ScrollView 設定
        destinationScrollView.isPagingEnabled = true
        destinationScrollView.contentSize = CGSize(
                              width: self.view.bounds.width * CGFloat(getDateInfo.count),
                              height: 250)
        destinationScrollView.showsVerticalScrollIndicator = false
    //navigation bar ButtonItem
        let addBarButtonItem = UIBarButtonItem.init(title: "Add", style: .done, target: self,
                                                    action: #selector(addTapped))
        navigationItem.rightBarButtonItem = addBarButtonItem
    // CollectionView  reload
        detailCollectionViwe.reloadData()
        detailCollectionViwe.delegate =  self
        detailCollectionViwe.dataSource =  self
    //註冊CollectionViewCell
        let nib = UINib(nibName: "DetailCollectionViewCell", bundle: nil)
        self.detailCollectionViwe.register(nib, forCellWithReuseIdentifier: "DetailCollectionViewCell")
    //CollectionView 間距設定
        guard let layout = detailCollectionViwe.collectionViewLayout as?
                                                UICollectionViewFlowLayout else {return}
        layout.itemSize = CGSize(width: (self.view.frame.size.width/2.0) - 2.0, height: 100)
         let insetX = (view.bounds.width - (self.view.frame.size.width/2.0)) / 2.0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
        layout.minimumLineSpacing = 2.0
        layout.minimumInteritemSpacing = 2.0
        detailCollectionViwe.setCollectionViewLayout(layout, animated: false)
    }

    @objc func addTapped(sender: AnyObject) {
          guard let scheduleDetailToAddLocation = UIStoryboard(name: "Schedule", bundle: nil)
                            .instantiateViewController(withIdentifier: "AddLocationViewController")
                                                        as? AddLocationViewController else {return}
          self.navigationController?.pushViewController(scheduleDetailToAddLocation, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getDateInfo.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       if let  cell = detailCollectionViwe.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as? DetailCollectionViewCell {
            cell.dateLabel.text = getDateInfo[indexPath.row].date
            cell.weekLabel.text = String(getWeekDayStr(weekDay: getDateInfo[indexPath.row].weekDay))
            print(getDateInfo[indexPath.row].date)
            return cell
         } else {
                return UICollectionViewCell()
         }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
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
