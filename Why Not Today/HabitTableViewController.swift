//
//  HabitTableViewController.swift
//  Why Not Today
//
//  Created by Taylor Ray Howard on 3/19/17.
//  Copyright (c) 2017 TaylorRayHoward. All rights reserved.
//

import UIKit
import RealmSwift

class HabitTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
}

class HabitTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let realm = try! Realm()
    var habits: Results<Habit>!
    @IBOutlet weak var habitTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        habitTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        habitTable.dataSource = self
        habitTable.delegate = self
        reload()
    }

    override func viewWillAppear(_ animated: Bool){
        reload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = habitTable.dequeueReusableCell(withIdentifier: "HabitCell", for: indexPath) as! HabitTableViewCell
        cell.nameLabel?.text = habits[indexPath.row].name
        cell.typeLabel?.text = habits[indexPath.row].type
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath){
        if editingStyle == UITableViewCellEditingStyle.delete {
            let cell = tableView.cellForRow(at: indexPath) as! HabitTableViewCell

            let predicate = NSPredicate(format: "name == %@", "\(cell.nameLabel!.text!)")
            let deleteHabit = realm.objects(Habit.self).filter(predicate)
            try! realm.write {
                realm.delete(deleteHabit)
            }
            reload()
        }
    }

    func reload(){
        habits = self.realm.objects(Habit.self)
        self.habitTable.reloadData()
    }
}
