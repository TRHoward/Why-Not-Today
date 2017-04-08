//
//  Why_Not_TodayTests.swift
//  Why Not TodayTests
//
//  Created by Taylor Ray Howard on 3/19/17.
//  Copyright (c) 2017 TaylorRayHoward. All rights 

import Nimble
import Quick
import RealmSwift
@testable import Why_Not_Today

class HabitSpec: QuickSpec {
  override func spec() {
    describe("The habit object has multiple properties") {
      it("has a name property") {
        let habit1 = Habit()
        habit1.name = "Foo"
        let habit2 = Habit()
        habit2.name = "Foo"
        expect(habit1.name).to(equal(habit2.name))
      }
      it("has a type property") {
        let habit1 = Habit()
        habit1.type = "Bar"
        let habit2 = Habit()
        habit2.type = "Bar"
        expect(habit1.name).to(equal(habit2.name))
      }
    }
    describe("The realm database has database features") {
      var realm: Realm!
      beforeEach {
        realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
      }
      it("can save a habit object") {
        let habit = Habit()
        habit.name = "Foo"
        habit.type = "Bar"
        try! realm.write {
          realm.add(habit)
        }

        let habits = realm.objects(Habit.self)
        expect(habits.count).to(equal(1))
      }

      it("can delete a habit object") {
        let habit = Habit()
        habit.name = "Foo"
        habit.type = "Bar"
        try! realm.write {
          realm.add(habit)
        }

        var habits = realm.objects(Habit.self)

        try! realm.write {
          realm.deleteAll()
        }

        habits = realm.objects(Habit.self)

        expect(habits.count).to(equal(0))
      }
      it("can query") {
        var habit = Habit()
        habit.name = "Foo"
        habit.type = "Bar"
        try! realm.write {
          realm.add(habit)
        }
        habit = Habit()
        habit.name = "FooBar"
        habit.type = "BarFoo"

        try! realm.write {
          realm.add(habit)
        }

        let habits = realm.objects(Habit.self).filter("name == 'Foo'")
        expect(habits.count).to(equal(1))
      }

    }
  }
}

