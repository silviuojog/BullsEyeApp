//
//  MainViewController.swift
//  BullsEye
//
//  Created by Silviu Ojog on 21.05.21.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
       
   }

   override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
   }
    

    
    @IBAction func loginTapped(_ sender: UIButton) {
    }
    
    @IBAction func signupTapped(_ sender: UIButton) {
    }
}
