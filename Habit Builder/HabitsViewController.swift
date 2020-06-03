//
//  HabitsViewController.swift
//  Habit Builder
//
//  Created by Henrique Bersani on 5/26/20.
//  Copyright © 2020 Henrique Bersani. All rights reserved.
//

import UIKit

class HabitsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var habitNameToArray = ""
           var habitsLabelArray = [String]()
           var blockInPyramidCount: Int = 0
           var lastSignInDate = [String: String]()
           var goalDoneForToday = [String: Bool]()
           var habitsBlocksArray = [String: Int]()
    var defaults = UserDefaults.standard
    
    var listOfCurrentHabits = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfHabits = 0
        switch categorySelected {
        case "fitness":
            numberOfHabits = fitnessHabitsArray.count
        case "creativity":
            numberOfHabits = creativityHabitsArray.count
        case "health":
            numberOfHabits = healthHabitsArray.count
        case "addiction":
            numberOfHabits = addictionHabitsArray.count
        default:
            print("")
        }
        return numberOfHabits
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customHabitCell", for: indexPath) as! CustomHabitCellTableViewCell
               cell.layoutMargins = UIEdgeInsets.zero
        cell.backgroundColor = .red
        
        switch categorySelected {
        case "fitness":
            listOfCurrentHabits = fitnessHabitsArray
            cell.habitName.text = fitnessHabitsArray[indexPath.row]
            cell.habitDescription.text = fitnessDescription[indexPath.row]
            if  checkIfHabitAlreadyAdded(habit: fitnessHabitsArray[indexPath.row]) {
//                cell.pyramidView.isHidden = true
                cell.addLabel.text = "ADDED"
            } else {
//                cell.pyramidView.isHidden = false
                cell.addLabel.text = "ADD"
            }
            case "creativity":
            listOfCurrentHabits = creativityHabitsArray
            cell.habitName.text = creativityHabitsArray[indexPath.row]
            cell.habitDescription.text = creativityDescription[indexPath.row]
            if  checkIfHabitAlreadyAdded(habit: creativityHabitsArray[indexPath.row]) {
//                cell.pyramidView.isHidden = true
                cell.addLabel.text = "ADDED"
            } else {
//                cell.pyramidView.isHidden = false
                cell.addLabel.text = "ADD"
            }
            case "health":
            listOfCurrentHabits = healthHabitsArray
            cell.habitName.text = healthHabitsArray[indexPath.row]
            cell.habitDescription.text = healthDescription[indexPath.row]
            if  checkIfHabitAlreadyAdded(habit: healthHabitsArray[indexPath.row]) {
//                cell.pyramidView.isHidden = true
                cell.addLabel.text = "ADDED"
            } else {
//                cell.pyramidView.isHidden = false
                cell.addLabel.text = "ADD"
            }
            case "addiction":
                       listOfCurrentHabits = addictionHabitsArray
                       cell.habitName.text = addictionHabitsArray[indexPath.row]
                       cell.habitDescription.text = addictionDescription[indexPath.row]
                       if  checkIfHabitAlreadyAdded(habit: addictionHabitsArray[indexPath.row]) {
//                           cell.pyramidView.isHidden = true
                        cell.addLabel.text = "ADDED"
                       } else {
//                           cell.pyramidView.isHidden = false
                           cell.addLabel.text = "ADD"
                       }
            
        default:
            print("none")
        }
        
        return cell
    
}
    func checkIfHabitAlreadyAdded(habit: String) -> Bool{
        var myBul = false
        for hab in habitsLabelArray {
            if habit == hab {
                myBul = true
            }
        }
        return myBul
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if habitTextField.text!.count > 0 {
        habitNameToArray = listOfCurrentHabits[indexPath.row]
        if  checkIfHabitAlreadyAdded(habit: habitNameToArray) == false {
                   print(" habit name \(habitNameToArray)")
                    habitsLabelArray.append(habitNameToArray)
                    habitsBlocksArray.updateValue(0, forKey: habitNameToArray)
                    goalDoneForToday.updateValue(false, forKey: habitNameToArray)
                   lastSignInDate.updateValue("", forKey: habitNameToArray)
//
                    self.defaults.set(self.habitsLabelArray, forKey: "HabitsLabelArray")
                    self.defaults.set(self.habitsBlocksArray, forKey: "HabitsBlockArray")
                    self.defaults.set(self.lastSignInDate, forKey: "LastSignInDate")
                    self.defaults.set(self.goalDoneForToday, forKey: "GoalDoneForToday")
//                    
                    print(habitsBlocksArray)
                    print(" \(habitsLabelArray)")
                    print("date:\(lastSignInDate)")
        
        print("HABIT CREATEDD")
            habitsTable.reloadData()
//                   
//                   
//                   self.delegateContainer?.creationActivated()
//                   
//                   if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//                                          appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
//                                          (appDelegate.window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
//                                           
//                                       }
//                   }
              }
    }
    
    @IBOutlet weak var habitsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        habitsTable.delegate = self
        habitsTable.dataSource = self
        habitsTable.register(UINib(nibName: "HabitsViewController", bundle: nil) , forCellReuseIdentifier: "customHabitCell")

        // Do any additional setup after loading the view.
    }
var categorySelected = ""
    
//    HABITS DATA
    
//    Fitness
    var fitnessHabitsArray = ["Run 1 mile","50 push-ups 50 crunches"]
    var fitnessDescription = ["Pick a specific time of the day to run 1 mile and add a block each time your run is completed","Pick a specific time of the day to do 50 push-ups and 50 crunches and add a block each time your exercise is completed"]
//    Creativity
    var creativityHabitsArray = ["Journal for 30 minutes"]
    var creativityDescription = [" Get up a little bit earlier every morning and complete 30 minutes of stream of consciousness writing. Write whatever comes to mind, do not overthink, the ideia is to tap into our creative side. By journaling everyday you will find yourself thinking clearer and being more creative. Find a notebook or journal of some kind for this challenge. Do not show the journal to anybody, in order to tap into your most creative side you need privacy and a non-judgmental environment."]
//    Health
    var healthHabitsArray = ["One Gallon Of Water per Day"]
    var healthDescription = ["Fill your jug with a gallon of water every morning and drink it throughout the day. Add a block to the pyramid when the jug is emptied. There are many benefits to drinking a gallon of water a day such as higher metabolic rate, enhanced exercise performance, weight management, brain function, prevents and treats headaches and promotes skin health."]
//    Addiction
    var addictionHabitsArray = ["No Smonking All-Day"]
    var addictionDescription = ["Do not smoke for 24 hours. Add a block to the pyramid whenever the day has ended without smoking. Quitting smoking is a very challenging task, however, with Habit Pyramid you focus on each day at a time."]

}
