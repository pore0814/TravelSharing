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

    var getDateInfo = [ScheduleDateInfo]() {
        didSet {
            print("set data in ScheduleDetailViewController")
        }
    }
    var schedulDetail: ScheduleInfo?

    let dateFormatter1 = TSDateFormatter1()

    var backPage = 0
    @IBOutlet weak var destinationScrollView: LukeScrollView!
    @IBOutlet weak var detailCollectionViwe: LukeCollectionView!

    var ggg: DestinationViewController?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.destinationScrollView.contentOffset = CGPoint(x: self.view.frame.width * CGFloat(backPage), y: 0)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = schedulDetail?.name

        addrightBarButtonItem()

        dateFormatterToCollectionView()

        setUpCollectionView()

        setCollectionViewLayout()

        setUpScrollView()

        createDestinationVC()

    }

    func addrightBarButtonItem() {

        let addBarButtonItem = UIBarButtonItem.init(title: "新增", style: .done, target: self, action: #selector(addTapped))

        addBarButtonItem.tintColor = UIColor.white

        navigationItem.rightBarButtonItem = addBarButtonItem
    }

    func dateFormatterToCollectionView() {
        //日期dateFormatter function 用起程日期及天數計算出所有date
        guard let detail = schedulDetail else {return}

        getDateInfo =  dateFormatter1.getYYMMDD(indexNumber: detail)

    }

    func createDestinationVC() {
        //呼叫DestinationDetailViewController內容
        for index in 0..<(getDateInfo.count) {

            guard let obj1 = self.storyboard?.instantiateViewController(withIdentifier: "DistinationViewController") as? DestinationViewController else {return}

            ggg = obj1

            obj1.scheduleUid = schedulDetail?.uid

            obj1.dayths = getDateInfo[index].dayth

            var frame = CGRect(x: self.view.frame.width * CGFloat(index), y: 0, width: destinationScrollView.frame.width, height: destinationScrollView.frame.height)

            obj1.view.frame = frame

            destinationScrollView.addSubview(obj1.view)

            obj1.didMove(toParentViewController: self)
        }
    }

    func setUpScrollView() {
        //ScrollView 設定

        destinationScrollView.isDirectionalLockEnabled = true
        // 是否限制滑動時只能單個方向 垂直或水平滑動

        destinationScrollView.alwaysBounceVertical = false

        destinationScrollView.showsHorizontalScrollIndicator = true

        destinationScrollView.bounces = false //無彈回效果

        destinationScrollView.delegate = self

        destinationScrollView.contentSize = CGSize(
            width: self.view.bounds.width * CGFloat(getDateInfo.count),
            height: 100)

    }

    func setUpCollectionView() {

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

        layout.minimumLineSpacing = 0

        layout.minimumInteritemSpacing = 0

    }

    @objc func addTapped(sender: AnyObject) {

        guard let scheduleDetailToAddLocation = UIStoryboard(name: "Schedule", bundle: nil)
            .instantiateViewController(withIdentifier: "AddLocationViewController")

            as? AddDestinationViewController else {return}

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

        detailCollectionViwe.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

}

extension ScheduleDetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        guard  let screenshotsCollectionViewFlowLayout = self.detailCollectionViwe.collectionViewLayout as? UICollectionViewFlowLayout else {return}

        let screenshotsDistanceBetweenItemsCenter = screenshotsCollectionViewFlowLayout.minimumLineSpacing + screenshotsCollectionViewFlowLayout.itemSize.width

        let fullScreen =  UIScreen.main.bounds.width

        let offsetFactor = screenshotsDistanceBetweenItemsCenter / fullScreen

        if(scrollView === destinationScrollView) {
            let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x

            detailCollectionViwe.bounds.origin = CGPoint(x: xOffset * offsetFactor, y: detailCollectionViwe.bounds.origin.y)

        }

        if(scrollView === detailCollectionViwe) {

            let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x
            destinationScrollView.bounds.origin = CGPoint(x: xOffset / offsetFactor, y: destinationScrollView.bounds.origin.y)

        }
    }
}
