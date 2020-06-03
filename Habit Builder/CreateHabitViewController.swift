//
//  CreateHabitViewController.swift
//  Habit Builder
//
//  Created by Henrique Bersani on 5/27/20.
//  Copyright © 2020 Henrique Bersani. All rights reserved.
//

import UIKit

class CreateHabitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    var habitNameToArray = ""
    var habitsLabelArray = [String]()
    var blockInPyramidCount: Int = 0
    var lastSignInDate = [String: String]()
    var goalDoneForToday = [String: Bool]()
    var habitsBlocksArray = [String: Int]()
    var defaults = UserDefaults.standard
    @IBAction func startPressed(_ sender: Any) {
        if habitTextField.text!.count > 0 {
          habitNameToArray = habitTextField.text!
            
         habitsLabelArray.append(habitNameToArray)
         habitsBlocksArray.updateValue(0, forKey: habitNameToArray)
         goalDoneForToday.updateValue(false, forKey: habitNameToArray)
        lastSignInDate.updateValue("", forKey: habitNameToArray)

         self.defaults.set(self.habitsLabelArray, forKey: "HabitsLabelArray")
         self.defaults.set(self.habitsBlocksArray, forKey: "HabitsBlockArray")
         self.defaults.set(self.lastSignInDate, forKey: "LastSignInDate")
         self.defaults.set(self.goalDoneForToday, forKey: "GoalDoneForToday")
         
         print(habitsBlocksArray)
         print(" habits array \(habitsLabelArray)")
         print("date:\(lastSignInDate)")
//         habitLabelDisplaying.text = habitsLabelArray.last
//         currentHabit = habitsLabelArray.count - 1
//
//         previousHabits.isHidden = true
//         showBlocks(numberOfBlocks: 0)
//         if habitsLabelArray.count > 1 {
//             nextHabit.isHidden = false
//         }
//         if habitsLabelArray.count == 1 {
//             nextHabit.isHidden = true
//         }
//        print(habitsLabelArray.count)
//         lastTimeWorkedOn.text = ""
        }
    }
    
    @IBOutlet weak var habitTextField: UITextField!
    
    @IBOutlet weak var startBtn: UIButton!
    
}
