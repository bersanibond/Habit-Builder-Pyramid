//
//  SubscriptionViewController.swift
//  Habit Builder
//
//  Created by Henrique Bersani on 5/28/20.
//  Copyright © 2020 Henrique Bersani. All rights reserved.
//

import UIKit
import Purchases

protocol SubscriptionDelegateProtocol: class
{
    func activateSub()
}

class SubscriptionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        subBtn.layer.borderWidth = 3
        subBtn.layer.borderColor = UIColor.systemYellow.cgColor
        subBtn.layer.cornerRadius = subBtn.layer.frame.height/2
        subPrice.text = "\(membershipPrice)/Month"
        print("membership Price \(membershipPrice)")
    }
    var membershipPrice = ""
var package = [Purchases.Package]()
    @IBOutlet weak var subPrice: UILabel!
      weak var delegateContainer: SubscriptionDelegateProtocol?
    
    @IBAction func subPressed(_ sender: Any) {
        
        Purchases.shared.purchasePackage(package[0]) { (transaction, purchaserInfo, error, userCancelled) in
              print("purchaserInfo?.entitlements.active.first\(String(describing: purchaserInfo?.entitlements.active.first))")
                  if purchaserInfo?.entitlements.active.first != nil {
                      // Unlock that great "pro" content
                   self.delegateContainer?.activateSub()
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                                      appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
                                                      (appDelegate.window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
                                                       
                                                   }
                  }
              }
    }
    
    @IBOutlet weak var subBtn: UIButton!
    
}
