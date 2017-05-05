//
//  HabitNameViewController.swift
//  Why Not Today
//
//  Created by Taylor Howard on 5/4/17.
//  Copyright © 2017 TaylorRayHoward. All rights reserved.
//

import UIKit

protocol UserEnteredDataDelegate {
    func userEnteredName(data: String)
}

class HabitNameViewController: UIViewController {

    var delegate: UserEnteredDataDelegate? = nil


    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveName(_ sender: UIBarButtonItem) {
//        if delegate != nil {
//            let indexPath = IndexPath(row: 0, section: 0)
//            let cell = nameTableView.cellForRow(at: indexPath) as! EditNameCell
//            if cell.nameInput.text != nil {
//                let data = cell.nameInput.text!
//                delegate!.userDidEnterData(data: data)
//            }
//        }
        _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)

    }
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }

}
