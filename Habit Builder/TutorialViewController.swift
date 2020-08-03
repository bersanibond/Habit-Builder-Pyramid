//
//  TutorialViewController.swift
//  Habit Builder
//
//  Created by Henrique Bersani on 5/31/20.
//  Copyright © 2020 Henrique Bersani. All rights reserved.
//



import UIKit
import StoreKit
import Firebase


protocol LogInDelegateProtocol: class
{
    func logInActivated()
}

class TutorialViewController: UIViewController {

    var defaults = UserDefaults.standard
    var userId = ""
    weak var delegateContainer: LogInDelegateProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let goalDB = Database.database().reference()
        let childAuto = goalDB.childByAutoId().key
        self.userId = childAuto!
        

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        print("USER ID \(userId)")
        self.defaults.set(userId, forKey: "UserID")
        self.defaults.set(22, forKey: "TutorialNumber")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.delegateContainer?.logInActivated()
    }
    @IBOutlet weak var tutorialDescription: UILabel!
    
    var dismissTutorial = 0
    
    @IBAction func tutorialNext(_ sender: Any) {
        pyramidImageDone.isHidden = true
        pyramidImageHalfDone.isHidden = false
        tutorialDescription.text = "2. Add a block whenever you complete your habit "
        if dismissTutorial == 1 {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                              appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
                                              (appDelegate.window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
                                               
                                           }
        }
        dismissTutorial += 1
        
    }
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pyramidImageDone: UIImageView!
    @IBOutlet weak var pyramidImageHalfDone: UIImageView!
    
}
