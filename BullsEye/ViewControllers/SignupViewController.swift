//
//  LoginViewController.swift
//  BullsEye
//
//  Created by Silviu Ojog on 22.05.21.
//

import UIKit
import FirebaseAuth
import Firebase

class SignupViewController: UIViewController {

    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func signupTapped(_ sender: UIButton) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
            
            // Create cleaned versions of the data
            let username = usernameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                // Check for errors
                if err != nil {
                    
                    // There was an error creating the user
                    self.showError("Error creating user")
                    print (err?.localizedDescription)
                }
                else {
                    
                    // User was created successfully, now store the username
                    let database = Firestore.firestore()
                    
                    database.collection("users").document(result!.user.uid).setData(["username":username, "highscore":0, "uid": result!.user.uid ]) { (error) in
                        
                        if error != nil {
                            // Show error message
                            self.showError("Error saving user data")
                        }
                    }
                    
                    // Transition to the game home screen
                    self.transitionToGameHome()
                }
            }
        }
    }
    
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if  usernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        return nil
    }
    
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToGameHome() {
        
        let gameHomeViewController = storyboard?.instantiateViewController(identifier: "GameHomeVC") as? GameHomeViewController
        
        view.window?.rootViewController = gameHomeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
}
