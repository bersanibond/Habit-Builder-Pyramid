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
    var blockInPyramidCount: Int = 0
    var lastSignInDate = [String: String]()
    var goalDoneForToday = [String: Bool]()
    var habitNameToArray: String?
    var keyOfLabelDisplaying: String?
    var defaults = UserDefaults.standard
    let date = Date()
    var lastTimeYouWorkOnThisHabit: String?
    var currentHabit: Int = 0
    var numberOfHabitsMinusOne: Int = 0
    let todayDate = Date()
    let calendar = Calendar.current
    
    var appLastLogin: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let labelArray = defaults.array(forKey: "HabitsLabelArray") as? [String]{
            habitsLabelArray = labelArray
        }
        if let array = defaults.dictionary(forKey: "HabitsBlockArray") as? [String: Int]{
            habitsBlocksArray = array
        }
        if let signInDate = defaults.dictionary(forKey: "LastSignInDate") as? [String: String]{
            lastSignInDate = signInDate
        }
        if let goalDone = defaults.dictionary(forKey: "GoalDoneForToday") as? [String: Bool]{
            goalDoneForToday = goalDone
        }
        if habitsLabelArray.isEmpty {
            habitsView.isHidden = true
        }
        
        var numberOfHabitsForArray: Int = 0
        numberOfHabitsForArray = habitsLabelArray.count
        numberOfHabitsMinusOne = numberOfHabitsForArray - 1
        currentHabit = numberOfHabitsForArray - 1
        habitLabelDisplaying.text = habitsLabelArray.last
      
        let hour = calendar.component(.hour, from: todayDate)
        let minute = calendar.component(.minute, from: todayDate)
        let day = calendar.component(.day, from: todayDate)
        let month = calendar.component(.month, from: todayDate)
        let year = calendar.component(.year, from: todayDate)
        print("\(day)-\(month)-\(year)  \(hour):\(minute)")
        let date = "\(day)-\(month)-\(year)  \(hour):\(minute)"
//        lastTimeYouWorkOnThisHabit = date
        
        if let appLastOpen = defaults.object(forKey: "AppLastOpen") as? String{
            appLastLogin = appLastOpen
        }
        let appLastLogIn = "\(appLastLogin ?? "")"
        
        if date != appLastLogIn{
            defaults.set(date, forKey: "AppLastOpen")
//            you are creating a loop to update value of all keys to false, when
            for key in habitsLabelArray {
                goalDoneForToday.updateValue(false, forKey: key)
            }
            print(date)
            print(appLastLogIn)
            
            keyOfLabelDisplaying = habitLabelDisplaying.text
            blockInPyramidCount = habitsBlocksArray[keyOfLabelDisplaying!]!
            showBlocks(numberOfBlocks: blockInPyramidCount)
            
            
            if currentHabit > 0 {
                previousHabits.isHidden = true
            }
            
        }
    }
    
    
    
           //    let differentDays = Calendar.current.dateComponents([.day], from: date1, to: date2).date
//  let differentDays = Calendar.current.dateComponents([.day], from: todayDate, to: <#T##Date#>)

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
        goalDoneForToday.updateValue(false, forKey: habitNameToArray!)
        lastSignInDate.updateValue("", forKey: habitNameToArray!)
//        habitsLabelArray.removeAll()
//        habitsBlocksArray.removeAll()
//        lastSignInDate.removeAll()
//        goalDoneForToday.removeAll()
//          defaults.set("", forKey: "AppLastOpen")
        self.defaults.set(self.habitsLabelArray, forKey: "HabitsLabelArray")
        self.defaults.set(self.habitsBlocksArray, forKey: "HabitsBlockArray")
        self.defaults.set(self.lastSignInDate, forKey: "LastSignInDate")
        self.defaults.set(self.goalDoneForToday, forKey: "GoalDoneForToday")
        
        print(habitsBlocksArray)
        print(" \(habitsLabelArray)")
        print("date:\(lastSignInDate)")
        habitLabelDisplaying.text = habitsLabelArray.last
        currentHabit = habitsLabelArray.count - 1
        
        
        
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

        keyOfLabelDisplaying = habitLabelDisplaying.text
        let habitAlreadyBuiltToday = goalDoneForToday[keyOfLabelDisplaying!]
        //      Time
        let lastSignIn = Date()
        let hour = calendar.component(.hour, from: lastSignIn)
        let minute = calendar.component(.minute, from: lastSignIn)
        let day = calendar.component(.day, from: lastSignIn)
        let month = calendar.component(.month, from: lastSignIn)
        let year = calendar.component(.year, from: lastSignIn)
        print("\(day)-\(month)-\(year)  \(hour):\(minute)")
        let date = "\(day)-\(month)-\(year)  \(hour):\(minute)"
        lastTimeYouWorkOnThisHabit = date
        
//        if habitAlreadyBuiltToday == false {
            let currentBlockNumber = habitsBlocksArray[keyOfLabelDisplaying!]
            let currentBlockPlusOne = currentBlockNumber! + 1
            habitsBlocksArray.updateValue(currentBlockPlusOne, forKey: keyOfLabelDisplaying!)
            lastSignInDate.updateValue("\(lastTimeYouWorkOnThisHabit!)", forKey: keyOfLabelDisplaying!)
            goalDoneForToday.updateValue(true, forKey: keyOfLabelDisplaying!)
            self.defaults.set(self.lastSignInDate, forKey: "LastSignInDate")
            self.defaults.set(self.goalDoneForToday, forKey: "GoalDoneForToday")
            self.defaults.set(self.habitsBlocksArray, forKey: "HabitsBlockArray")
            print(habitsBlocksArray[keyOfLabelDisplaying!]!)
            print(keyOfLabelDisplaying!)
//            print("goaldonefortoday: \(goalDoneForToday)")
//            print(lastSignInDate)
        //        }
        keyOfLabelDisplaying = habitLabelDisplaying.text
        blockInPyramidCount = habitsBlocksArray[keyOfLabelDisplaying!]!
        showBlocks(numberOfBlocks: blockInPyramidCount)
    }
    
    @IBAction func previousHabit(_ sender: UIButton) {
        if currentHabit < habitsLabelArray.count - 1 {
            let previousHabit: Int = currentHabit + 1
            habitLabelDisplaying.text = habitsLabelArray[previousHabit]
            keyOfLabelDisplaying = habitLabelDisplaying.text
            blockInPyramidCount = habitsBlocksArray[keyOfLabelDisplaying!]!
            print(blockInPyramidCount)
            print("blockarray:\(habitsBlocksArray)")
            currentHabit = previousHabit
            showBlocks(numberOfBlocks: blockInPyramidCount)
            
            print(currentHabit)
            print(habitsLabelArray.count)

            if currentHabit > 0 {
                nextHabit.isHidden = false
            }
            if currentHabit == habitsLabelArray.count-1 {
                previousHabits.isHidden = true
            }
        }
    }
  
 
    @IBAction func nextHabit(_ sender: UIButton) {
      
        
        if currentHabit > 0 {
       
            let nextHabitNumber:Int = currentHabit - 1
            //        print(numberOfHabits)
            //        print(nextHabit)
            //        print(habitsLabelArray)
            habitLabelDisplaying.text = habitsLabelArray[nextHabitNumber]
            keyOfLabelDisplaying = habitLabelDisplaying.text
            blockInPyramidCount = habitsBlocksArray[keyOfLabelDisplaying!]!
            print(blockInPyramidCount)
            print("blockarray:\(habitsBlocksArray)")
            currentHabit = nextHabitNumber
            showBlocks(numberOfBlocks: blockInPyramidCount)
            previousHabits.isHidden = false
            
            if currentHabit == 0 {
                nextHabit.isHidden = true
            }
        }
    }

    @IBOutlet weak var block1: UIImageView!
    @IBOutlet weak var block2: UIImageView!
    @IBOutlet weak var block3: UIImageView!
    @IBOutlet weak var block4: UIImageView!
    @IBOutlet weak var block5: UIImageView!
    @IBOutlet weak var block6: UIImageView!
    @IBOutlet weak var block7: UIImageView!
    @IBOutlet weak var block8: UIImageView!
    @IBOutlet weak var block9: UIImageView!
    @IBOutlet weak var block10: UIImageView!
    @IBOutlet weak var block11: UIImageView!
    @IBOutlet weak var block12: UIImageView!
    @IBOutlet weak var block13: UIImageView!
    @IBOutlet weak var block14: UIImageView!
    @IBOutlet weak var block15: UIImageView!
    @IBOutlet weak var block16: UIImageView!
    @IBOutlet weak var block17: UIImageView!
    @IBOutlet weak var block18: UIImageView!
    @IBOutlet weak var block19: UIImageView!
    @IBOutlet weak var block20: UIImageView!
    @IBOutlet weak var block21: UIImageView!
    @IBOutlet weak var block22: UIImageView!
    @IBOutlet weak var block23: UIImageView!
    @IBOutlet weak var block24: UIImageView!
    @IBOutlet weak var block25: UIImageView!
    @IBOutlet weak var block26: UIImageView!
    @IBOutlet weak var block27: UIImageView!
    @IBOutlet weak var block28: UIImageView!
    @IBOutlet weak var block29: UIImageView!
    @IBOutlet weak var block30: UIImageView!
    @IBOutlet weak var block31: UIImageView!
    @IBOutlet weak var block32: UIImageView!
    @IBOutlet weak var block33: UIImageView!
    @IBOutlet weak var block34: UIImageView!
    @IBOutlet weak var block35: UIImageView!
    @IBOutlet weak var block36: UIImageView!
    @IBOutlet weak var block37: UIImageView!
    @IBOutlet weak var block38: UIImageView!
    @IBOutlet weak var block39: UIImageView!
    @IBOutlet weak var block40: UIImageView!
    @IBOutlet weak var block41: UIImageView!
    @IBOutlet weak var block42: UIImageView!
    @IBOutlet weak var block43: UIImageView!
    @IBOutlet weak var block44: UIImageView!
    @IBOutlet weak var block45: UIImageView!
    
    
    @IBOutlet weak var previousHabits: UIButton!
    @IBOutlet weak var nextHabit: UIButton!
    
    
    func showBlocks(numberOfBlocks: Int)  {
        let blocks = [block1, block2,block3,block4,block5,block6,block7,block8,block9,block10,block11,block12,block13,block14,block15,block16,block17,block18,block19,block20,block21,block22,block23,block24,block25,block26,block27,block28,block29,block30,block31,block32,block33,block34,block35,block36,block37,block38,block39,block40,block41,block42,block43,block44,block45]
        
        var blockLocal = 0
   
        for block in blocks {
            if blockLocal < numberOfBlocks {
                block?.isHidden = false
                blockLocal += 1
         
            } else {
                block?.isHidden = true
            }
        }
        
        
    }
    
    
}






