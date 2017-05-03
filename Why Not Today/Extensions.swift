//
// Created by Taylor Howard on 4/9/17.
// Copyright (c) 2017 TaylorRayHoward. All rights reserved.
//

import UIKit
import JTAppleCalendar
import RealmSwift

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.locale = Calendar.current.locale
        formatter.timeZone = Calendar.current.timeZone
        
        var components = DateComponents()
        components.year = 2016
        components.month = 1
        components.day = 1
        let startDate = Calendar.current.date(from: components)!
        let params = ConfigurationParameters(startDate: startDate, endDate: Date(), numberOfRows: 6, calendar: nil, generateInDates: nil, generateOutDates: .tillEndOfRow, firstDayOfWeek: nil, hasStrictBoundaries: nil)
        
        return params
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState,
                  indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        changeCellDisplay(cell, with: calendarView, withState: cellState)
        cell.selectedView.isHidden = Calendar.current.startOfDay(for: date) != selectedDate
        cell.progressView.isHidden = true
        
        let percent = getProgressBarPercentage(forDate: date)
        if percent != nil {
            cell.progressView.isHidden = false
            cell.progressView.setProgress(percent!, animated: false)
        }
        
        return cell
        
    }
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setMonthLabel(from: visibleDates)
        setYearLabel(from: visibleDates)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        self.selectedDate = Calendar.current.startOfDay(for: date)
        guard let validCell = cell as? CustomCell else { return }
        validCell.selectedView.isHidden = false
        self.reload()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CustomCell else { return }
        validCell.selectedView.isHidden = true
    }
}


func getProgressBarPercentage(forDate date: Date) -> Double? {
    let currentDates = getCurrentDates(forDate: date)
    if currentDates.count == 0 {
        return nil
    }
    var success = 0
    for d in currentDates {
        if d.successfullyCompleted == 1 {
            success += 1
        }
    }
    
    let habits = DBHelper.sharedInstance.getAll(ofType: Habit.self)
    return  Double(success)/Double(habits.count)
}


func getCurrentDates(forDate date: Date) ->  List<DateCompleted> {
    let datesCompleted = DBHelper.sharedInstance.getAll(ofType: DateCompleted.self)
    let currentDates = List<DateCompleted>()
    for d in datesCompleted {
        let dateCompleted = d as! DateCompleted
        if dateCompleted.dateCompleted == date {
            currentDates.append(dateCompleted)
        }
    }
    return currentDates
}

func isCompleteForDay(forDate date: Date) -> Bool {
    let currentDates = getCurrentDates(forDate: date)
    let habits = DBHelper.sharedInstance.getAll(ofType: Habit.self)
    return currentDates.count == habits.count
}


enum ApproveDeny: Int {
    case Approve = 1
    case Deny = -1
}
