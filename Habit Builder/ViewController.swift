//
//  ViewController.swift
//  Habit Builder
//
//  Created by Henrique Bersani on 9/15/18.
//  Copyright © 2018 Henrique Bersani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var habitsLabelArray = [String]()
    var habitsBlocksArray = [String: Int]()
    var lastSignInDate = [String: String]()
    var habitNameToArray: String?
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if let labelArray = defaults.array(forKey: "HabitsLabelArray") as? [String]{
            habitsLabelArray = labelArray
        }
        if let array = defaults.dictionary(forKey: "HabitsBlockArray") as? [String: Int]{
            habitsBlocksArray = array
        }
        if let signInDate = defaults.dictionary(forKey: "LastSignInDate") as? [String: String] {
            lastSignInDate = signInDate
        }
        if habitsLabelArray.isEmpty {
            habitsView.isHidden = true
        }
        habitLabelDisplaying.text = habitsLabelArray.last
        let date = Date()
        print("The date is :\(date)")
    }

    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var nameTheHabit: UITextField!
    @IBAction func addHabit(_ sender: UIButton) {
        if nameTheHabit.hasText {
            habitName.text = nameTheHabit.text 
            habitName.isHidden = false
            pyramidImage.isHidden = false
            start.isHidden = false
            
//            let habitDirection: String = "Hello Habit Builder, you are about to build the \(habitName.text!).Everyday that you work on your habit, a block is added to the pyramid, however, thiefs can still a block the day you don't show up. Let's go you can build this habit in habit in 90 days."
//            habitDirections.text = habitDirection
//            habitDirections.isHidden = false
        }
        
    }
   
    @IBOutlet weak var habitName: UILabel!
    
    @IBOutlet weak var pyramidImage: UIImageView!
    
    @IBOutlet weak var habitDirections: UILabel!
    
    @IBOutlet weak var habitsView: UIView!
    
    @IBAction func startHabit(_ sender: UIButton) {
        habitsView.isHidden = false
        habitNameToArray = habitName.text
        habitsLabelArray.append(habitNameToArray!)
        habitsBlocksArray.updateValue(0, forKey: habitNameToArray!)
        let date = Date()
        lastSignInDate.updateValue("\(date)", forKey: habitNameToArray!)
//        habitsLabelArray.removeAll()
//        habitsBlocksArray.removeAll()
        self.defaults.set(self.habitsLabelArray, forKey: "HabitsLabelArray")
        self.defaults.set(self.habitsBlocksArray, forKey: "HabitsBlockArray")
        self.defaults.set(self.lastSignInDate, forKey: "LastSignInDate")
       
        
        print(habitsBlocksArray)
        print(" \(habitsLabelArray)")
        print("date:\(lastSignInDate)")
        habitLabelDisplaying.text = habitsLabelArray.last
        
    }
    @IBAction func addMorehabits(_ sender: Any) {
        habitName.isHidden = true
        pyramidImage.isHidden = true
        start.isHidden = true
        habitsView.isHidden = true
        nameTheHabit.text = ""
        
    }
//   Building Pyramid
    

    @IBOutlet weak var habitLabelDisplaying: UILabel!
    
    @IBAction func buildHabit(_ sender: Any) {
        
        let keyOfLabelDisplaying = habitLabelDisplaying.text
        
//        habitsBlocksArray.values
//        habitsBlocksArray.updateValue(<#T##value: Int##Int#>, forKey: <#T##String#>)
        
        let currentBlockNumber = habitsBlocksArray[keyOfLabelDisplaying!]
        let currentBlockPlusOne = currentBlockNumber! + 1
        habitsBlocksArray.updateValue(currentBlockPlusOne, forKey: keyOfLabelDisplaying!)
        print(habitsBlocksArray[keyOfLabelDisplaying!]!)
        print(keyOfLabelDisplaying!)
        print("currentPlusOne : \(currentBlockPlusOne)")
    }
    
    
    // In Swift 4 there is a simple one-liner to get the number of days (or any other DateComponent) between two dates
    //    let differentDays = Calendar.current.dateComponents([.day], from: date1, to: date2).date
    
    
  

}

