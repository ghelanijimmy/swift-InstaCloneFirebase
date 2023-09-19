//
//  SettingsViewController.swift
//  InstaCloneFirebase
//
//  Created by Jimmy Ghelani on 2023-09-19.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutClicked(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Can't sign out: \(error)")
        }
        performSegue(withIdentifier: "toVC", sender: nil)
    }
}

#Preview {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let controller = storyboard.instantiateViewController(withIdentifier: "settingsVC") as! SettingsViewController
    return controller
}
