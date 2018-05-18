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
    var destinationManger = DestinationManager()

    @IBOutlet weak var destinationScrollView: UIScrollView!
    @IBOutlet weak var detailCollectionViwe: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
//nagivation Bar 顯示Scheudle名稱
        navigationItem.title = schedulDetail?.name
//日期dateFormatter function 用起程日期及天數計算出所有date 
        guard let detail = schedulDetail else {return}
        getDateInfo =  dateFormatter1.getYYMMDD(indexNumber: detail)
        print("----------31")
        for aaad in 0...(getDateInfo.count-1) {
        print(getDateInfo[aaad].date)
        print(getDateInfo[aaad].dayth)
        }
        
//ScrollView 設定
        destinationScrollView.isDirectionalLockEnabled = true // 是否限制滑動時只能單個方向 垂直或水平滑動
        destinationScrollView.showsHorizontalScrollIndicator = true
        destinationScrollView.bounces = true //無彈回效果
        destinationScrollView.isPagingEnabled = true
        destinationScrollView.contentSize = CGSize(
            width: self.view.bounds.width * CGFloat(getDateInfo.count),
            height: detailCollectionViwe.frame.height)
        destinationScrollView.showsVerticalScrollIndicator = false

//呼叫DestinationDetailViewController內容
        for index in 0..<(getDateInfo.count) {
            guard let obj1 = self.storyboard?.instantiateViewController(withIdentifier: "DistinationViewController") as? DestinationViewController else {return}
            obj1.scheduleUid = schedulDetail?.uid
            obj1.dayths = getDateInfo[index].dayth
            var frame = CGRect(x:self.view.frame.width * CGFloat(index), y:0 , width: destinationScrollView.frame.width, height:destinationScrollView.frame.height)
            obj1.view.frame = frame
            destinationScrollView.addSubview(obj1.view)
        }
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
        scheduleDetailToAddLocation.dateSelected = getDateInfo
        scheduleDetailToAddLocation.uid = schedulDetail?.uid

          self.navigationController?.pushViewController(scheduleDetailToAddLocation, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getDateInfo.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       if let  cell = detailCollectionViwe.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as? DetailCollectionViewCell {
            cell.dateLabel.text = getDateInfo[indexPath.row].date
            cell.weekLabel.text = String(getWeekDayStr(weekDay: getDateInfo[indexPath.row].weekDay))
            return cell
         } else {
                return UICollectionViewCell()
         }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension ScheduleDetailViewController : UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        guard  let screenshotsCollectionViewFlowLayout = self.detailCollectionViwe.collectionViewLayout as? UICollectionViewFlowLayout else {return}
       

        
       let screenshotsDistanceBetweenItemsCenter = screenshotsCollectionViewFlowLayout.minimumLineSpacing + screenshotsCollectionViewFlowLayout.itemSize.width
        let offsetFactor = screenshotsDistanceBetweenItemsCenter / self.view.frame.size.width
        if (scrollView == detailCollectionViwe) {
            let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x
            destinationScrollView.contentOffset.x = xOffset / offsetFactor
        }else if(scrollView == destinationScrollView) {
            print("AAAAAAA")
//            let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x
//            detailCollectionViwe.contentOffset.x = xOffset * offsetFactor
        }
        
        
        
        
//
//        let cellwidthIncludingSapcing = layout.itemSize.width + layout.minimumLineSpacing
//        var offset = targetContentOffset.pointee
//        let index = (offset.x + scrollView.contentInset.left) / cellwidthIncludingSapcing
//        let roundedIndex = round(index)
        
        
        
        
        
//
//        offset = CGPoint(x: roundedIndex * cellwidthIncludingSapcing - scrollView.contentInset.left, y: roundedIndex * cellwidthIncludingSapcing - scrollView.contentInset.left)
//        targetContentOffset.pointee = offset
    
    }
    
}

