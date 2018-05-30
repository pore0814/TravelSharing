//
//  ScheduleDetailViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/5.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class ScheduleDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var detailVC: AddDestinationViewController?
    
    var getDateInfo = [DateInfo]() {
        didSet {
            print("set data in ScheduleDetailViewController")
        }
    }
    var schedulDetail: ScheduleInfo?
    let dateFormatter1 = TSDateFormatter1()
    var destinationManger = DestinationManager()
    var backPage = 0
    @IBOutlet weak var destinationScrollView: LukeScrollView!
    @IBOutlet weak var detailCollectionViwe: LukeCollectionView!
    
    var ggg: DestinationViewController?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      //  self.destinationScrollView.contentOffset = CGPoint(x: self.view.frame.width * CGFloat((detailVC?.previousPage)!), y: 0)
        self.destinationScrollView.contentOffset = CGPoint(x: self.view.frame.width * CGFloat(backPage), y: 0)
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
//
//        if let sdetailVC = segue.destination as? AddDestinationViewController {
//            self.detailVC = sdetailVC
//        }
//
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
//nagivation Bar 顯示Scheudle名稱

        navigationItem.title = schedulDetail?.name
//日期dateFormatter function 用起程日期及天數計算出所有date
        guard let detail = schedulDetail else {return}
        getDateInfo =  dateFormatter1.getYYMMDD(indexNumber: detail)

//ScrollView 設定
        destinationScrollView.isDirectionalLockEnabled = true
        // 是否限制滑動時只能單個方向 垂直或水平滑動
        destinationScrollView.alwaysBounceVertical = false
        destinationScrollView.showsHorizontalScrollIndicator = true
        destinationScrollView.bounces = false //無彈回效果
        destinationScrollView.delegate = self
       // destinationScrollView.isPagingEnabled = true

        destinationScrollView.contentSize = CGSize(
            width: self.view.bounds.width * CGFloat(getDateInfo.count),
            height: 100)
//呼叫DestinationDetailViewController內容

        for index in 0..<(getDateInfo.count) {
            guard let obj1 = self.storyboard?.instantiateViewController(withIdentifier: "DistinationViewController") as? DestinationViewController else {return}

            ggg = obj1
            
            obj1.scheduleUid = schedulDetail?.uid

            obj1.dayths = getDateInfo[index].dayth

            var frame = CGRect(x: self.view.frame.width * CGFloat(index), y: 0, width: destinationScrollView.frame.width, height: destinationScrollView.frame.height)

            obj1.view.frame = frame
            destinationScrollView.addSubview(obj1.view)

        }

        let addBarButtonItem = UIBarButtonItem.init(title: "＋", style: .done, target: self,
                                                    action: #selector(addTapped))
        addBarButtonItem.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = addBarButtonItem
        setCollectionView()
        setCollectionViewLayout()

    }

    func setCollectionView() {
    // CollectionView
        detailCollectionViwe.delegate =  self
        detailCollectionViwe.dataSource =  self

    //註冊CollectionViewCell
        let nib = UINib(nibName: "DetailCollectionViewCell", bundle: nil)
        self.detailCollectionViwe.register(nib, forCellWithReuseIdentifier: "DetailCollectionViewCell")
    }

    func setCollectionViewLayout() {
        let screenSize = UIScreen.main.bounds
        guard  let layout = detailCollectionViwe.collectionViewLayout as?
            UICollectionViewFlowLayout else {return}

         layout.itemSize = CGSize(width: screenSize.width / 2.0,
                                height: detailCollectionViwe.frame.height)
            let insetX = screenSize.width / 4.0
            layout.sectionInset = UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 0
      //      detailCollectionViwe.setCollectionViewLayout(layout, animated: false)
    }

    @objc func addTapped(sender: AnyObject) {
          guard let scheduleDetailToAddLocation = UIStoryboard(name: "Schedule", bundle: nil)
                            .instantiateViewController(withIdentifier: "AddLocationViewController")
                                                        as? AddDestinationViewController else {return}
        scheduleDetailToAddLocation.dateSelected = getDateInfo
        scheduleDetailToAddLocation.uid = schedulDetail?.uid

          self.navigationController?.pushViewController(scheduleDetailToAddLocation, animated: true)
/*
        let storyboard : UIStoryboard = UIStoryboard(name: "Schedule", bundle: nil)
        guard    let popupVC = storyboard.instantiateViewController(withIdentifier: "AddLocationViewController") as? AddDestinationViewController else{return}
        popupVC.modalPresentationStyle = UIModalPresentationStyle .popover
        popupVC.preferredContentSize = CGSize(width: 170, height: 130)
        popupVC.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
       
        popupVC.dateSelected = getDateInfo
        self.present(popupVC, animated: true, completion: nil)
  */

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

        destinationScrollView.setContentOffset(
                CGPoint(x: self.view.frame.width * CGFloat(indexPath.row),
                        y: 0), animated: true)
        detailCollectionViwe.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

}

extension ScheduleDetailViewController: UIScrollViewDelegate {

/*-----------------Luke
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard  let screenshotsCollectionViewFlowLayout = self.detailCollectionViwe.collectionViewLayout as? UICollectionViewFlowLayout else {return}
        let screenshotsDistanceBetweenItemsCenter = screenshotsCollectionViewFlowLayout.minimumLineSpacing + screenshotsCollectionViewFlowLayout.itemSize.width
        let fullScreen =  UIScreen.main.bounds.width
        let offsetFactor = screenshotsDistanceBetweenItemsCenter / fullScreen
       // let offsetFactor1 = screenshotsDistanceBetweenItemsCenter / self.view.frame.size.width
        if(scrollView == destinationScrollView) {
          let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x
            
           detailCollectionViwe.bounds.origin = CGPoint(x: xOffset * offsetFactor, y: detailCollectionViwe.bounds.origin.y)
           //  detailCollectionViwe.contentOffset.x = xOffset * offsetFactor
            print("-----------SCrollview------------------")
            print("scrollview",destinationScrollView.contentOffset)
            print("collectionview",detailCollectionViwe.contentOffset)
            
        }
        else if (scrollView == detailCollectionViwe) {
            let xOffset = scrollView.contentOffset.x  - scrollView.frame.origin.x
            //destinationScrollView.bounds.origin = CGPoint(x: xOffset / offsetFactor, y: destinationScrollView.bounds.origin.y)
            destinationScrollView.bounds.origin.x = xOffset / offsetFactor
            print("------------dateCollectionview------------------")

            print(detailCollectionViwe.contentOffset)
             print(destinationScrollView.contentOffset)

        }
    }
 -------------Luke*/

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard  let screenshotsCollectionViewFlowLayout = self.detailCollectionViwe.collectionViewLayout as? UICollectionViewFlowLayout else {return}
        let screenshotsDistanceBetweenItemsCenter = screenshotsCollectionViewFlowLayout.minimumLineSpacing + screenshotsCollectionViewFlowLayout.itemSize.width
        let fullScreen =  UIScreen.main.bounds.width
        let offsetFactor = screenshotsDistanceBetweenItemsCenter / fullScreen
        // let offsetFactor1 = screenshotsDistanceBetweenItemsCenter / self.view.frame.size.width
        if(scrollView == destinationScrollView) {
            let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x

            detailCollectionViwe.bounds.origin = CGPoint(x: xOffset * offsetFactor, y: detailCollectionViwe.bounds.origin.y)
            //  detailCollectionViwe.contentOffset.x = xOffset * offsetFactor
            print("-----------SCrollview------------------")
            print("scrollview", destinationScrollView.contentOffset)
            print("collectionview", detailCollectionViwe.contentOffset)

        }
    }
}
