//
//  ViewController.swift
//  Habit Builder
//
//  Created by Henrique Bersani on 9/15/18.
//  Copyright © 2018 Henrique Bersani. All rights reserved.
//

import UIKit
import StoreKit
import Firebase
import Purchases
import AVFoundation
import CoreHaptics

class ViewController: UIViewController, CreationDelegateProtocol, SubscriptionDelegateProtocol, LogInDelegateProtocol {
   
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
    var inAppPurchase = 0
    var subPlayer: SubscriptionViewController?
     var habitPlayer: CategoryViewController?
    var logPlayer: TutorialViewController?
    
    @IBOutlet weak var deleteHabitBtn: UIButton!
    var appLastLogin: Any?
    @IBOutlet weak var nameTheHabit: UITextField!
    func activateSub(){
        isSubscribed = true
        
    }
    var isSubscribed = false
    func actionForEmptyHabits(){
        if habitsLabelArray.count == 0 {
            lastTimeWorkedOn.text = "No Habit Found"
            habitLabelDisplaying.isHidden = true
            deleteHabitBtn.isEnabled = false
            deleteHabitBtn.layer.opacity = 0.5
            buildButton.isHidden = true
            blockInPyramidCount = 0
            showBlocks(numberOfBlocks: blockInPyramidCount)
        } else if habitsLabelArray.count > 0 {
            habitLabelDisplaying.isHidden = false
            deleteHabitBtn.isEnabled = true
            deleteHabitBtn.layer.opacity = 1
            buildButton.isHidden = false

        }
    }
    func logInActivated() {
        self.viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ITSS LOIADINGG")
//        In-App Purchase
        rotateMessage()
       var purchase = 0
        
        if let inAppPurchased = defaults.integer(forKey: "InAppPurchase") as? Int {
            inAppPurchase = inAppPurchased
        }
     
        
        print("purchase :\(inAppPurchase)")
        if let tutorial = defaults.integer(forKey: "TutorialNumber") as? Int {
            tutorialNumber = tutorial
        }
        print("TUTORIAL NUMBER \(tutorialNumber)")
       
        
        
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
        if let id = defaults.string(forKey: "UserID") {
                          userID = id
                      }
        print("USER ID \(userID)")
//        if habitsLabelArray.isEmpty {
//            habitsView.isHidden = true
//        }
        print("HABIT ARRAY \(habitsLabelArray)")
        var numberOfHabitsForArray: Int = 0
        numberOfHabitsForArray = habitsLabelArray.count
        numberOfHabitsMinusOne = numberOfHabitsForArray - 1
        currentHabit = numberOfHabitsForArray - 1
        habitLabelDisplaying.text = habitsLabelArray.last
        
        let hour = calendar.component(.hour, from: todayDate)
        var minute = calendar.component(.minute, from: todayDate)
        let day = calendar.component(.day, from: todayDate)
        let month = calendar.component(.month, from: todayDate)
        let year = calendar.component(.year, from: todayDate)
        switch minute {
        case 0 :
         minute = 00
        case 1:
            minute = 01
        case 2:
            minute = 02
        case 3:
            minute = 03
        case 4:
            minute = 04
        case 5:
            minute = 05
        case 6:
            minute = 06
        case 7:
            minute = 07
        case 8:
            minute = 08
        case 9:
            minute = 09
            break
        default:
            print("default")
        }
        print("\(day)/\(month)/\(year) \(hour):\(minute)")
        let dateOfToday = String(format: "%02d:%02d:%02d %02d:%02d",day,month,year,hour,minute)
        if let appLastOpen = defaults.object(forKey: "AppLastOpen") as? String {
            appLastLogin = appLastOpen
        }
        let appLastLogIn = "\(String(describing: appLastLogin))"
        
        previousHabits.isHidden = true
        if habitsLabelArray.count <= 1 {
            nextHabit.isHidden = true
        } else if habitsLabelArray.count > 1 {
            nextHabit.isHidden = false
        }
        if habitsLabelArray.count > 0 {
            keyOfLabelDisplaying = habitLabelDisplaying.text
            blockInPyramidCount = habitsBlocksArray[keyOfLabelDisplaying!]!
            showBlocks(numberOfBlocks: blockInPyramidCount)
            updateLastTimeWorkedOn()
        }
        print("applastLogIn: \(appLastLogIn)")
        
        if dateOfToday != appLastLogIn{
            defaults.set(dateOfToday, forKey: "AppLastOpen")
            //            you are creating a loop to update value of all keys to false, when
            for key in habitsLabelArray {
                goalDoneForToday.updateValue(false, forKey: key)
            }
        }
        unlimitedPyramidsButtonOutlet.backgroundColor = .clear
        unlimitedPyramidsButtonOutlet.layer.cornerRadius = 5
        unlimitedPyramidsButtonOutlet.layer.borderWidth = 2
        unlimitedPyramidsButtonOutlet.layer.borderColor = UIColor(red: 53.0/255.0, green: 117.0/255.0, blue: 231.0/255.0, alpha: 1.0).cgColor
        
        buildButton.backgroundColor = .clear
        buildButton.layer.cornerRadius = buildButton.frame.height/2
        buildButton.layer.borderWidth = 2
        buildButton.layer.borderColor = UIColor.systemYellow.cgColor

//        swipe function
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(leftSwipe)
         actionForEmptyHabits()
//        if userID.count != 0 {
//            Purchases.configure(withAPIKey: "FVhvfcqZlcjztzJbXehxekKUIaflGAOb")
//        }
        
    }
    var userID = ""
    override func viewDidAppear(_ animated: Bool) {
        if tutorialNumber == 0 {
        //            tutorialView.isHidden = true
                    performSegue(withIdentifier: "tutorialSegue", sender: self)
                }
    }
    
    
      @objc func handleSwipe(sender: UISwipeGestureRecognizer){
        if sender.state == .ended {
            switch sender.direction {
            case .right:
//                print(currentHabit)
//                previous
                if habitsLabelArray.count != 0 {
                   habitsView.isHidden = false
                }
                if currentHabit < habitsLabelArray.count - 1 {
                    let previousHabit: Int = currentHabit + 1
                    habitLabelDisplaying.text = habitsLabelArray[previousHabit]
                    keyOfLabelDisplaying = habitLabelDisplaying.text
                    blockInPyramidCount = habitsBlocksArray[keyOfLabelDisplaying!]!
                    print(blockInPyramidCount)
                    print("blockarray:\(habitsBlocksArray)")
                    currentHabit = previousHabit
                    showBlocks(numberOfBlocks: blockInPyramidCount)
                    updateLastTimeWorkedOn()
                    print(currentHabit)
                    print(habitsLabelArray.count)
                    
                    if currentHabit > 0 {
                        nextHabit.isHidden = false
                    }
                    if currentHabit == habitsLabelArray.count-1 {
                        previousHabits.isHidden = true
                    }
                    
                }
            case .left:
                print(currentHabit)
//                next
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
                    updateLastTimeWorkedOn()
                    currentHabit = nextHabitNumber
                    showBlocks(numberOfBlocks: blockInPyramidCount)
                    previousHabits.isHidden = false
                    
                    if currentHabit == 0 {
                        nextHabit.isHidden = true
                    }
                }
                
            default:
                break
            }
        }
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
        lastTimeWorkedOn.text = ""
    }
//    In App Purchase
    
    @IBOutlet weak var inAppPurchaseView: UIView!
    @IBAction func backFromInAppPurchase(_ sender: UIButton) {
        inAppPurchaseView.isHidden = true
        if inAppPurchase == 1 {
            habitsView.isHidden = true
            habitName.isHidden = true
            pyramidImage.isHidden = true
            start.isHidden = true
            nameTheHabit.text = ""
        }
       
    }
    
    @IBOutlet weak var unlimitedPyramidsButtonOutlet: UIButton!
    @IBAction func unlimitedPyrsmidsButton(_ sender: UIButton) {
        IAPHandler.shared.purchaseMyProduct(index: 0)
    }

    
    @IBAction func addMorehabits(_ sender: Any) {

    
//        if habitsLabelArray.count < 1 || inAppPurchase == 1 {
//            habitName.isHidden = true
//            pyramidImage.isHidden = true
//            start.isHidden = true
//            habitsView.isHidden = true
//            nameTheHabit.text = ""
//        } else if inAppPurchase == 0 {
//            inAppPurchaseView.isHidden = false
//        }
    }
   
    
    @IBAction func restorePurchaseButton(_ sender: Any) {
        IAPHandler.shared.restorePurchase()
        
        let alert = UIAlertController(title: "Restore purchase made in previous owned device", message: "", preferredStyle: .alert)
        let no = UIAlertAction(title: "No", style: .default){ (no) in
            print("test")
        }
        let yes = UIAlertAction(title: "Yes", style: .default) { (yes) in
          self.restoredLabel.isHidden = false
            self.restoreButtonOutlet.isHidden = true
            if restoreP == true {
                let purchase = 1
                self.inAppPurchase = purchase
                self.defaults.set(purchase, forKey: "InAppPurchase")
                self.restoredLabel.text = "Restored"
            } else {
                self.restoredLabel.text = "Previous purchase not found"
            }
        }
        
        alert.addAction(no)
        alert.addAction(yes)
        present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var restoredLabel: UILabel!
    
    @IBOutlet weak var restoreButtonOutlet: UIButton!
    //   Building Pyramid
    

    @IBOutlet weak var habitLabelDisplaying: UILabel!
    
    @IBAction func buildHabit(_ sender: Any) {

        keyOfLabelDisplaying = habitLabelDisplaying.text
//        let habitAlreadyBuiltToday = goalDoneForToday[keyOfLabelDisplaying!]
        
        //      Time
        let lastSignIn = Date()
        let hour = calendar.component(.hour, from: lastSignIn)
        let minute = calendar.component(.minute, from: lastSignIn)
       
        let day = calendar.component(.day, from: lastSignIn)
        let month = calendar.component(.month, from: lastSignIn)
        let year = calendar.component(.year, from: lastSignIn)
        print("\(day)-\(month)-\(year)  \(hour):\(minute)")

        let date =  String(format: "%02d/%02d/%02d at %02d:%02d",day,month,year,hour,minute)
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
        updateLastTimeWorkedOn()
//        UIDevice.vibrate()
//        let generator = UIImpactFeedbackGenerator(style: .heavy)
//        generator.impactOccurred()
                    let generator = UINotificationFeedbackGenerator()
                               generator.notificationOccurred(.success)
    }
    
    func rotateMessage() {
        testLabel.text = congratsLabels.randomElement()
//                testLabel.text = test
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.testLabel.isHidden = false
                    self.testLabel.alpha = 100

//                   self.testLabel.isHidden = true
                    UIView.animate(withDuration: 4.0) {
                    self.testLabel.frame = CGRect(x: -300, y: 55, width: 100, height: 20)
                }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) {
                       UIView.animate(withDuration: 4) {
                        self.testLabel.alpha = 80
                        self.testLabel.alpha = 60
                        self.testLabel.alpha = 40
                        self.testLabel.alpha = 0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                        self.rotateMessage()
                        
                       }
                    }
               }
    }
    var test = ".Habits are important. Up to 90 percent of our everyday behavior is based on habit. \n Nearly all of what we do each day, every day, is simply habit.LLALALALA BIGG tALLLK"
    let congratsLabels = ["Good Job!","Take control of your habits. Take control of your life.","Habits are important. Up to 90 percent of our everyday behavior is based on habit. Nearly all of what we do each day, every day, is simply habit.","You’ll never change your life until you change something you do daily. The secret of your success is found in your daily routine.","Good habits, once established are just as hard to break as are bad habits.","Consciously create habits because habits unconsciously dictate your life.","You leave old habits behind by starting with the thought, ‘I release the need for this in my life’.","Nothing is stronger than a habit.","Bad habits are easier to abandon today than tomorrow.","Happiness is a habit. Cultivate it.","Laziness is nothing more than the habit of resting before you get tired.","Habits change into character.","Good habits are as addictive as bad habits but much more rewarding.","Good habits are the key to all success.","Your character is the harvest of your habits.","Success is the sum of small efforts repeated day in day out.","If you want to change your world, you need to start cultivating good habits.","Results can only change when we change our consistent actions and make them habits.","Consistency creates habit and our habits shape our life.","If your habits don’t line up with your dream, then you need to either change your habits or change your dream.","And it all began with one small win.","We first make our habits, and then our habits make us.","Motivation is what gets you started, habit is what keeps you going.","We are what we repeatedly do. Excellence, then, is not an act, but a habit.","Successful people are simply those with successful habits."]
    @IBOutlet weak var sideLabel: NSLayoutConstraint!
    
    @IBOutlet weak var testLabel: UILabel!
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
            updateLastTimeWorkedOn()
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
           updateLastTimeWorkedOn()
            currentHabit = nextHabitNumber
            showBlocks(numberOfBlocks: blockInPyramidCount)
            previousHabits.isHidden = false
            
            if currentHabit == 0 {
                nextHabit.isHidden = true
            }
        }
    }
    var empty = ""
    func updateLastTimeWorkedOn () {
        let value = lastSignInDate[keyOfLabelDisplaying!]
        if (value?.isEmpty)! {
            lastTimeWorkedOn.text = ""
        } else {
            lastTimeWorkedOn.text = "Last built: \(lastSignInDate[keyOfLabelDisplaying!] ?? empty)"
        }
        
    }

    @IBOutlet weak var lastTimeWorkedOn: UILabel!
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
//                block?.isHidden = false
                block?.backgroundColor = UIColor(red: 255.0/255.0, green: 231.0/255.0, blue: 40.0/255.0, alpha: 1.0)
                block?.alpha = 1
                
                blockLocal += 1
         
            } else {
//                block?.isHidden = true
                block?.backgroundColor = UIColor.white
                block?.alpha = 0.30
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

            self.viewDidLoad()
         
        }
        
        
        alert.addAction(no)
        alert.addAction(yes)
        present(alert, animated: true, completion: nil)
        
    }
    
//    Tutorial
    func creationActivated(){
        viewDidLoad()
    }
    
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
        
        tutorialExplaining.text = "Build your Habit Pyramid whenever you work on your habit"
        
        if tutorialNumber == 1 {
            firstTimeUser = false
//            tutorialNumber = 0
          self.defaults.set(self.tutorialNumber, forKey: "TutorialNumber")
           tutorialView.isHidden = true
        }
        tutorialNumber += 1
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.destination is CategoryViewController {
               let vc = segue.destination as? CategoryViewController
               habitPlayer = vc
               habitPlayer?.delegateContainer = self
            vc?.habitsLabelArray = habitsLabelArray
            vc?.habitsBlocksArray = habitsBlocksArray
            vc?.goalDoneForToday = goalDoneForToday
            vc?.lastSignInDate = lastSignInDate
            vc?.userID = userID
            vc?.isMember = isSubscribed
           }
        if segue.destination is TutorialViewController {
            let vc = segue.destination as? TutorialViewController
                      logPlayer = vc
                      logPlayer?.delegateContainer = self
        }
    }
    
    
}
extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}






