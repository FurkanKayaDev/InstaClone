//
//  SettingsViewController.swift
//  InstaClone
//
//  Created by Furkan Kaya on 4.01.2024.
//

import UIKit
import Firebase
class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func logoutClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        } catch{
            print("Error")
        }
    }
    
}
