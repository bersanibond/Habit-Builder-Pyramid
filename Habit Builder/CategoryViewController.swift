//
//  CategoryViewController.swift
//  Habit Builder
//
//  Created by Henrique Bersani on 5/26/20.
//  Copyright © 2020 Henrique Bersani. All rights reserved.
//

import UIKit
import Purchases

protocol CreationDelegateProtocol: class
{
    func creationActivated()
}

class CategoryViewController: UIViewController, UITextFieldDelegate {

    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupToHideKeyboardOnTapOnView()

        habitTextField.delegate = self
        customHabitBtnView.layer.borderColor = UIColor.systemYellow.cgColor
        customHabitBtnView.layer.borderWidth = 3
        customHabitBtnView.layer.cornerRadius = customHabitBtnView.layer.frame.height/2
        
        addHabitView.layer.borderColor = UIColor.systemYellow.cgColor
        addHabitView.layer.borderWidth = 3
        addHabitView.layer.cornerRadius = addHabitView.layer.frame.height/2
        
        habitTextField.layer.borderColor = UIColor.systemYellow.cgColor
        habitTextField.layer.borderWidth = 2
        habitTextField.layer.cornerRadius = habitTextField.layer.frame.height/2
        
        categoryView.layer.borderColor = UIColor.darkGray.cgColor
        categoryView.layer.borderWidth = 2
        categoryView.layer.cornerRadius = 20
        
        self.habitTextField.attributedPlaceholder = NSAttributedString(string: "Habit Title..",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])

        // Do any additional setup after loading the view.
        print("USER ID \(userID)")
        
        if isMember {
            lockImg.isHidden = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        Purchases.debugLogsEnabled = true

        pullSubscriptionData()
    }
     var package = [Purchases.Package]()
    
    func pullSubscriptionData(){
          
        if userID.count > 0 {
        Purchases.configure(withAPIKey: "FVhvfcqZlcjztzJbXehxekKUIaflGAOb", appUserID: userID)
           Purchases.shared.purchaserInfo { (purchaserInfo, error) in
//                access latest purchaserInfo
               print("------->>>purchaserinfo \(String(describing: purchaserInfo?.originalAppUserId))")
               print("------->>>purchaserInfo?.activeSubscriptions \(purchaserInfo!.activeSubscriptions))")
               if purchaserInfo!.activeSubscriptions.count > 0 {
                self.isMember = true
                self.lockImg.isHidden = true
               }
           }
           Purchases.shared.offerings { (offerings, error) in
                       if (offerings != nil) {
                           print("MY OFFERINGS \(offerings?.current))")
           //              showPaywall(offerings?.current)
                     }
                   }
           Purchases.shared.offerings { (offerings, error) in
               if let packages = offerings?.current?.availablePackages {
                   // Display packages for sale
                   
                   self.package = packages
//                   print("------>> PRODUCT PRICE \(self.package[0].localizedPriceString)")
                   self.membershipPrice = self.package[0].localizedPriceString
                print("MY PACKAGES pricee \(self.membershipPrice)")
            }
               }
        }}
    
    @IBOutlet weak var lockImg: UIImageView!
    var membershipPrice = ""
    @IBOutlet weak var addHabitView: UIView!
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryStack: UIStackView!
    
    @IBAction func healthPressed(_ sender: Any) {
        categorySelected = "health"
        performSegue(withIdentifier: "habitSegue", sender: self)
    }
    
    @IBAction func fitnessPressed(_ sender: Any) {
        categorySelected = "fitness"
        performSegue(withIdentifier: "habitSegue", sender: self)
    }
    
    @IBAction func creativityPressed(_ sender: Any) {
        categorySelected = "creativity"
        performSegue(withIdentifier: "habitSegue", sender: self)
    }
    
    @IBAction func addictionPressed(_ sender: Any) {
        categorySelected = "addiction"
        performSegue(withIdentifier: "habitSegue", sender: self)
    }
    var categorySelected = ""
        weak var delegateContainer: CreationDelegateProtocol?
    
//    CUSTOM HABIT
        var habitNameToArray = ""
        var habitsLabelArray = [String]()
        var blockInPyramidCount: Int = 0
        var lastSignInDate = [String: String]()
        var goalDoneForToday = [String: Bool]()
        var habitsBlocksArray = [String: Int]()
        var defaults = UserDefaults.standard
    override func viewDidDisappear(_ animated: Bool) {
        self.delegateContainer?.creationActivated()
    }
    
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                    
              self.view.endEditing(true)
//                    self.habitName.text = self.habitTextField.text
        //        self.doneView.isHidden = true
                self.view.layoutIfNeeded()
        
        var maBu = false
        if habitTextField.text?.count ?? 0 > 0 {
            addHabitView.isHidden = false
            maBu = true
        } else if habitTextField.text?.count == 0 {
            maBu = false
            addHabitView.isHidden = true
        }
         return maBu
    }
    
        @IBAction func startPressed(_ sender: Any) {
           if habitTextField.text!.count > 0 {
            habitNameToArray = habitTextField.text!
            print(" habit name \(habitNameToArray)")
             habitsLabelArray.append(habitNameToArray)
             habitsBlocksArray.updateValue(0, forKey: habitNameToArray)
             goalDoneForToday.updateValue(false, forKey: habitNameToArray)
            lastSignInDate.updateValue("", forKey: habitNameToArray)

             self.defaults.set(self.habitsLabelArray, forKey: "HabitsLabelArray")
             self.defaults.set(self.habitsBlocksArray, forKey: "HabitsBlockArray")
             self.defaults.set(self.lastSignInDate, forKey: "LastSignInDate")
             self.defaults.set(self.goalDoneForToday, forKey: "GoalDoneForToday")
             
             print(habitsBlocksArray)
             print(" \(habitsLabelArray)")
             print("date:\(lastSignInDate)")
            
            
            self.delegateContainer?.creationActivated()
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                   appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
                                   (appDelegate.window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
                                    
                                }
            }
        }
    var isMember = false
    
    @IBAction func createPyramidPressed(_ sender: Any) {
        if isMember {
            habitCreationView.isHidden = false
        } else {
            performSegue(withIdentifier: "subscriptionSegue", sender: self)
        }
        
    }
    
    @IBOutlet weak var habitName: UILabel!
    
    @IBOutlet weak var customHabitBtnView: UIView!
    
        @IBOutlet weak var habitTextField: UITextField!
    @IBOutlet weak var habitCreationView: UIView!
    
        @IBOutlet weak var startBtn: UIButton!


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.destination is HabitsViewController {
        let vc = segue.destination as? HabitsViewController
        vc?.categorySelected = categorySelected
        vc?.habitsLabelArray = habitsLabelArray
        vc?.habitsBlocksArray = habitsBlocksArray
        vc?.goalDoneForToday = goalDoneForToday
        vc?.lastSignInDate = lastSignInDate
        
        }
        if segue.destination is SubscriptionViewController {
        let vc = segue.destination as? SubscriptionViewController
        vc?.membershipPrice = membershipPrice
        vc?.package = package
        
        }
    }
    
}
extension UIViewController
{
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
