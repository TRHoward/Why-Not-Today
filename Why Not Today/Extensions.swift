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
    case approve = 1
    case deny = -1
    case neutral = 0
}
