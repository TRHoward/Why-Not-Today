//
//  DBHelper.swift
//  Why Not Today
//
//  Created by Taylor Howard on 4/23/17.
//  Copyright © 2017 TaylorRayHoward. All rights reserved.
//

import Foundation
import RealmSwift


enum Environment {
    case Application
    case Test
}

class DBHelper {
    var realm: Realm
    static let sharedInstance = DBHelper(inEnvironment: .Application)
    static let testInstance = DBHelper(inEnvironment: .Test)
    
    init(inEnvironment env: Environment) {
        if(env == .Application) {
            realm = try! Realm()
        }
        else if(env == .Test) {
            realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
        }
        else {
            realm = try! Realm()
        }
    }
    
    func getAll(ofType type: Object.Type) -> Results<Object> {
        return realm.objects(type)
    }
    
    func writeObject(objects: [Object]) {
        try! realm.write {
            for o in objects {
                realm.add(o)
            }
        }
    }
    
    func updateHabit(_ habit: Habit) {
        try! realm.write {
            realm.add(habit, update: true)
        }
    }
    func updateHabit(_ habit: Habit, name: String?) {
        try! realm.write {
            habit.name = name ?? habit.name
        }
    }
    
    func deleteAll(ofType type: Object.Type) {
        let objects = getAll(ofType: type)
        try! realm.write {
            realm.delete(objects)
        }
    }
    
    func deleteHabit(_ habit: Habit) {
        try! realm.write {
            realm.delete(habit.datesCompleted)
            realm.delete(habit)
        }
    }
    
    func updateDateCompleted(_ dateCompleted: DateCompleted) {
        try! realm.write {
            realm.add(dateCompleted, update: true)
        }
    }
    
    func updateDateCompleted(_ dateCompleted: DateCompleted, success: Int?, date: Date?) {
        try! realm.write {
            dateCompleted.successfullyCompleted = success ?? dateCompleted.successfullyCompleted
            dateCompleted.dateCompleted = date ?? dateCompleted.dateCompleted
        }
    }
    
    func addDateCompleted(for habit: Habit, with dateCompleted:DateCompleted) {
        try! realm.write {
            habit.datesCompleted.append(dateCompleted)
            realm.add(habit, update: true)
        }
    }
    
    func updateNotificaiton(_ notif: Notification) {
        try! realm.write {
            realm.add(notif, update: true)
        }
    }
    
    func updateNotification(_ notif: Notification, date: Date?, message: String?) {
        try! realm.write {
            notif.FireTime = date ?? notif.FireTime
            notif.Message = message ?? notif.Message
        }
    }
    
    func deleteNotification(_ notif: Notification) {
        try! realm.write {
            realm.delete(notif)
        }
    }
    
}
