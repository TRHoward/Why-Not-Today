//
// Created by Taylor Howard on 4/5/17.
// Copyright (c) 2017 TaylorRayHoward. All rights reserved.
//

import Foundation
import RealmSwift

class Habit: Object {
    dynamic var name = ""
    dynamic var id = ""
    dynamic var createDate = Date()
    var datesCompleted = List<DateCompleted>()
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    convenience init(n: String){
        self.init()
        self.name = n
        self.id = UUID().uuidString
    }
}

class DateCompleted: Object {
    dynamic var dateCompleted: Date = Date()
    dynamic var successfullyCompleted: Int = 0
    dynamic var Habit: Habit?
    dynamic var id = ""
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    convenience init(dateCompleted date: Date, success: Int, for habit: Habit) {
        self.init()
        self.dateCompleted = date
        self.successfullyCompleted = success
        self.Habit = habit
        self.id = UUID().uuidString
    }
}

public enum dayOfWeek: Int {
    case Sunday = 1
    case Monday = 2
    case Tuesday = 3
    case Wednesday = 4
    case Thursday = 5
    case Friday = 6
    case Saturday = 7
}
