//
//  LoginViewController.swift
//  BullsEye
//
//  Created by Silviu Ojog on 22.05.21.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    


    @IBAction func loginTapped(_ sender: Any) {
        
        // Create cleaned versions of the text field
        let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                
                self.transitionToGameHome()
            }
        }
        
    }
    
    func transitionToGameHome() {
        
        let gameHomeViewController = storyboard?.instantiateViewController(identifier: "GameHomeVC") as? GameHomeViewController
        
        view.window?.rootViewController = gameHomeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
}
