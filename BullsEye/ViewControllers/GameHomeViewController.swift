//
//  GameHomeController.swift
//  BullsEye
//
//  Created by Silviu Ojog on 24.05.21.
//

import UIKit
import Firebase

class GameHomeViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        AppUtility.lockOrientation(.landscapeLeft, andRotateTo: .landscapeLeft)
   }

   override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func playTapped() {
        transitionToGame()
    }
    
    @IBAction func rankingTapped() {
        
    }
    
    
    func transitionToGame() {
        
        let gameViewController = storyboard?.instantiateViewController(identifier: "GameVC") as? GameViewController
        
        view.window?.rootViewController = gameViewController
        view.window?.makeKeyAndVisible()
        
    }

    func transitionToMainView() {
        
        let mainViewController = storyboard?.instantiateViewController(identifier: "MainNavVC") as? UINavigationController
        
        view.window?.rootViewController = mainViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    
    @IBAction func handleSignOut() {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to sign out?" , preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            self.signOut()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            print ("User signed out")
            transitionToMainView()
        } catch let error {
            print("error: ", error)
        }
    }
}
