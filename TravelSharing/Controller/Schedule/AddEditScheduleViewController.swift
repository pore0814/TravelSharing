//
//  AddScheduleViewController.swift
//  TravelSharin
//
//  Created by 王安妮 on 2018/5/2.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import JTAppleCalendar



class AddEditScheduleViewController: UIViewController {

    //日期/
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "yyyy MM dd"
        return dateFormatter
    }()
 
    
    @IBOutlet weak var scheduleDaysText: UITextField!
    @IBOutlet weak var scheduleNameText: UITextField!
    @IBOutlet weak var scheduleDateText: UITextField!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    //Property
    var scheduleInfoDetail: ScheduleInfo? //接收Schedule帶過來的資料
    let outsideMonthColor = UIColor(colorWithHenValue: 0x584a66)
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor(colorWithHenValue: 0x3a294b)
    let currentDateSelectedViewColor = UIColor(colorWithHenValue: 0xa4e3f5d)

  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(addTapped))
        
        navigationItem.rightBarButtonItem =  rightBarButtonItem
        navigationItem.title = scheduleInfoDetail?.name

        //判斷是否有值(無值就顯今天日期，有值顯示Schedule帶過來的值）
        if  let editDate = scheduleInfoDetail?.date { //有值
            calendarView.scrollToDate(formatter.date(from: editDate)!)
            calendarView.selectDates([formatter.date(from: editDate)!])
        } else {
            calendarView.scrollToDate(Date())
            calendarView.selectDates([Date()])
        }

        setupCalendarView()

        NotificationCenter.default.addObserver(self, selector: #selector(toSchedulePage), name: .switchtoSchedulePage, object: nil)
        scheduleDaysText.text = scheduleInfoDetail?.days
        scheduleDateText.text = scheduleInfoDetail?.date
        scheduleNameText.text = scheduleInfoDetail?.name
    }
    //FireBase資料寫入
    @objc func toSchedulePage(notification: Notification) {

    }
    
    @objc func addTapped(sender: AnyObject) {
        
        if scheduleInfoDetail == nil {
            print("ADD")
        if scheduleDateText.text != "", scheduleDaysText.text != "", scheduleNameText.text != "" {
                //寫入資料
                 ScheduleManager.shared.saveScheduleInfo(uid: scheduleInfoDetail?.uid,
                                                         scheduleName: scheduleNameText.text!,
                                                         scheudleDate: scheduleDateText.text!,
                                                         scheduleDay: scheduleDaysText.text!)
                 self.navigationController?.popViewController(animated: true)
             }else {
               AlertToUser.shared.alerTheUserPurple(title: Constants.Wrong_Message,message: "表格不可為空白")
            }
        }else{
            //UpDate
            print("Edit")
              ScheduleManager.shared.updateaveScheduleInfo(scheduleUid: scheduleInfoDetail?.uid, scheduleName: scheduleNameText.text!, scheudleDate: scheduleDateText.text!, scheduleDay: scheduleDaysText.text!)
            
             self.navigationController?.popViewController(animated: true)
            
        }
}
        
        
        
    
    @IBAction func saveBtn(_ sender: Any) {}
    
    func setupCalendarView() {
        // Setup calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        // Setup labels
        calendarView.visibleDates { dateSegment in
            self.setupCalendarViewData(dateSegment: dateSegment)
        }
    }

    func setupCalendarViewData(dateSegment: DateSegmentInfo) {
        guard let data = dateSegment.monthDates.first?.date else {return}
        
          formatter.dateFormat = "yyyy"
         year.text = self.formatter.string(from: data)  + "年"

         formatter.dateFormat = "MM"
         month.text = self.formatter.string(from: data) + "月"
    }

    //收鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

func configureCell(cell: JTAppleCell?, cellState: CellState) {
    guard let myCustomCell = cell as? CustomCell else {return}
    handleCellSelection(cell: myCustomCell, cellState: cellState)
    handleCellVisibility(cell: myCustomCell, cellState: cellState)
    handleCellTextColor(cell: myCustomCell, cellState: cellState)

    }

    func handleCellTextColor(cell: CustomCell, cellState: CellState) {
        cell.datelabe.textColor =  cellState.isSelected ? UIColor.black : UIColor.white
    }

    func handleCellVisibility(cell: CustomCell, cellState: CellState) {
        cell.isHidden = cellState.dateBelongsTo == .thisMonth ? false : true
    }

    func handleCellSelection(cell: CustomCell, cellState: CellState) {
        cell.selecetedView.isHidden = cellState.isSelected ? false : true
    }

func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
    guard let validCell = view as? CustomCell else {return}
    if cellState.isSelected {
        validCell.selecetedView.isHidden = false
    } else {
        validCell.selecetedView.isHidden = true
    }
   }
 }

extension AddEditScheduleViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
      let startDate = formatter.date(from: "2018 01 01")!
      let endData = formatter.date(from: "2018 12 31")!

     return ConfigurationParameters(startDate: startDate, endDate: endData)
    }

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.datelabe.text = cellState.text

        configureCell(cell: cell, cellState: cellState)
        return cell
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)

        formatter.dateFormat = "yyyy MM dd"
        scheduleDateText.text = formatter.string(from: date)

    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupCalendarViewData(dateSegment: visibleDates)
    }
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {

    }
}

extension UIColor {

    convenience init(colorWithHenValue value: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0xFF0000)  / 255.0,
            alpha: alpha)

    }
}
