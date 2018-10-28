//
//  ViewController.swift
//  Habit Builder
//
//  Created by Henrique Bersani on 9/15/18.
//  Copyright © 2018 Henrique Bersani. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController, UITextFieldDelegate {
   
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
    @IBOutlet weak var nameTheHabit: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        if let tutorial = defaults.integer(forKey: "TutorialNumber") as? Int {
            tutorialNumber = tutorial
        }
       
        if tutorialNumber > 0 {
            tutorialView.isHidden = true
        }
        
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
        
        print("\(day)/\(month)/\(year) \(hour):\(minute)")
        
        let dateOfToday = "\(day)/\(month)/\(year) \(hour):\(minute)"
        
        //        lastTimeYouWorkOnThisHabit = date
        
        if let appLastOpen = defaults.object(forKey: "AppLastOpen") as? String{
            appLastLogin = appLastOpen
        }
        
//        let appLastLogInInDate = appLastLogin
        
        let appLastLogIn = "\(String(describing: appLastLogin))"
        
        previousHabits.isHidden = true
        if habitsLabelArray.count == 1 {
            nextHabit.isHidden = true
        }
        if habitsLabelArray.count > 0 {
            keyOfLabelDisplaying = habitLabelDisplaying.text
            blockInPyramidCount = habitsBlocksArray[keyOfLabelDisplaying!]!
            showBlocks(numberOfBlocks: blockInPyramidCount)
        }
        print("applastLogIn: \(appLastLogIn)")
        
        if dateOfToday != appLastLogIn{
            defaults.set(dateOfToday, forKey: "AppLastOpen")
            //            you are creating a loop to update value of all keys to false, when
            for key in habitsLabelArray {
                goalDoneForToday.updateValue(false, forKey: key)
            }
        }
        buildButton.backgroundColor = .clear
        buildButton.layer.cornerRadius = 5
        buildButton.layer.borderWidth = 2
        
        buildButton.layer.borderColor = UIColor.white.cgColor
        //            Comparing Dates
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
////        today
//        let myString = dateFormatter.string(from: todayDate)
//        let yourDate = dateFormatter.date(from: myString)
//
////        lastOpened
//        let lastOpendedDateString = dateFormatter.string(from: appLastLogInInDate as! Date)
//        let myLastOpendedDateInDate = dateFormatter.date(from: lastOpendedDateString)
//
      
//        dateFormatter.dateFormat = "dd/MM/yyyy"
//        let myRealString = dateFormatter.string(from: yourDate!)
//        let myRealLastTime = dateFormatter.string(from: myLastOpendedDateInDate!)
//
        
//        if appLastLogIn.count > 2 {
//        let daysSinceLastLogIn = Calendar.current.dateComponents([.day], from: myLastOpendedDateInDate!, to: yourDate!).date
//                                        print("Days Since last Log In : \(daysSinceLastLogIn)")
//
//                                    }
        
        
        
        
        nameTheHabit.delegate = self
       
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func createNewhabit(_ sender: UITextField) {
        
        if nameTheHabit.hasText {
            habitName.text = nameTheHabit.text
            habitName.isHidden = false
            pyramidImage.isHidden = false
            start.isHidden = false
        }
        
    }
    
    
    
    
           //    let differentDays = Calendar.current.dateComponents([.day], from: date1, to: date2).date
//  let differentDays = Calendar.current.dateComponents([.day], from: todayDate, to: <#T##Date#>)

    @IBOutlet weak var start: UIButton!
    
    
    
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
    
    
    @IBOutlet weak var habitDirections: UILabel!
    @IBOutlet weak var pyramidImage: UIView!
    
    @IBOutlet weak var buildButton: UIButton!
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
//        defaults.set("", forKey: "AppLastOpen")
      
        self.defaults.set(self.habitsLabelArray, forKey: "HabitsLabelArray")
        self.defaults.set(self.habitsBlocksArray, forKey: "HabitsBlockArray")
        self.defaults.set(self.lastSignInDate, forKey: "LastSignInDate")
        self.defaults.set(self.goalDoneForToday, forKey: "GoalDoneForToday")
        
        print(habitsBlocksArray)
        print(" \(habitsLabelArray)")
        print("date:\(lastSignInDate)")
        habitLabelDisplaying.text = habitsLabelArray.last
        currentHabit = habitsLabelArray.count - 1
        
        previousHabits.isHidden = true
        
        
        showBlocks(numberOfBlocks: 0)
        if habitsLabelArray.count > 1 {
            nextHabit.isHidden = false
        }
        if habitsLabelArray.count == 1 {
            nextHabit.isHidden = true
        }
       print(habitsLabelArray.count)
    }
    
    @IBAction func addMorehabits(_ sender: Any) {
//        PyramidProducts.store.buyProduct(SKProduct)
//        habitName.isHidden = true
//        pyramidImage.isHidden = true
//        start.isHidden = true
//        habitsView.isHidden = true
//        nameTheHabit.text = ""
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
        print(lastSignInDate)
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
    
    
    
    
    
    
    
    
    
    @IBAction func deleteHabit(_ sender: UIButton) {
        keyOfLabelDisplaying = habitLabelDisplaying.text
        
        let alert = UIAlertController(title: "Delete \(keyOfLabelDisplaying!)", message: "", preferredStyle: .alert)
        let no = UIAlertAction(title: "No", style: .default){ (no) in
            print("test")
        }
        
        let yes = UIAlertAction(title: "Yes", style: .default) { (yes) in
            
            
            self.habitsBlocksArray[self.keyOfLabelDisplaying!] = nil
            self.habitsLabelArray.removeAll{ $0 == self.keyOfLabelDisplaying! }
            self.lastSignInDate[self.keyOfLabelDisplaying!] = nil
            self.goalDoneForToday[self.keyOfLabelDisplaying!] = nil
            print(self.habitsBlocksArray)
            
         
            
            self.defaults.set(self.habitsLabelArray, forKey: "HabitsLabelArray")
            self.defaults.set(self.habitsBlocksArray, forKey: "HabitsBlockArray")
            self.defaults.set(self.lastSignInDate, forKey: "LastSignInDate")
            self.defaults.set(self.goalDoneForToday, forKey: "GoalDoneForToday")
            if self.habitsLabelArray.count > 0 {
                let currentHabit = self.habitsLabelArray.count - 1
                self.habitLabelDisplaying.text = self.habitsLabelArray[currentHabit]
                self.currentHabit = self.habitsLabelArray.count - 1
                print(self.currentHabit)
                self.keyOfLabelDisplaying = self.habitLabelDisplaying.text
                self.blockInPyramidCount = self.habitsBlocksArray[self.keyOfLabelDisplaying!]!
                self.showBlocks(numberOfBlocks: self.blockInPyramidCount)
                
                if self.habitsLabelArray.count > 1 {
                    self.nextHabit.isHidden = false
                }
                if self.habitsLabelArray.count == 1 {
                    self.nextHabit.isHidden = true
                    self.previousHabits.isHidden = true
                }
                print(self.habitLabelDisplaying)
            }
            if self.habitsLabelArray.isEmpty {
                self.habitsView.isHidden = true
                self.habitName.isHidden = true
                self.pyramidImage.isHidden = true
                self.start.isHidden = true
                self.nameTheHabit.text = ""
            }
        }
        
        
        alert.addAction(no)
        alert.addAction(yes)
        present(alert, animated: true, completion: nil)
    }
    
//    Tutorial
    
    @IBOutlet weak var tutorialView: UIView!
    
    @IBOutlet weak var b1: UIStackView!
    @IBOutlet weak var b2: UIImageView!
    @IBOutlet weak var b3: UIImageView!
    @IBOutlet weak var b4: UIImageView!
    @IBOutlet weak var b5: UIImageView!
    @IBOutlet weak var b6: UIImageView!
    @IBOutlet weak var b7: UIImageView!
    @IBOutlet weak var b8: UIImageView!
    @IBOutlet weak var b9: UIImageView!
    @IBOutlet weak var b10: UIImageView!
    @IBOutlet weak var b11: UIImageView!
    @IBOutlet weak var b12: UIImageView!
    @IBOutlet weak var b13: UIImageView!
    

    @IBOutlet weak var nextTutorialButton: UIButton!
    @IBOutlet weak var tutorialExplaining: UILabel!
    var tutorialNumber = 0
    var firstTimeUser = true
    
    @IBAction func nextTutorial(_ sender: UIButton) {
          let hideTutorialBlocks = [b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13]
       
        for i in hideTutorialBlocks {
            i?.isHidden = true
        }
        
        tutorialExplaining.text = "Every time that you work on your habit, a block is added to the Pyramid"
        
        if tutorialNumber == 1 {
            firstTimeUser = false
          self.defaults.set(self.tutorialNumber, forKey: "TutorialNumber")
           tutorialView.isHidden = true
        }
        tutorialNumber += 1
    }
    
    
    
}






