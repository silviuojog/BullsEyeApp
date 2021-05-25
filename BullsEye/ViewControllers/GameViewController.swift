//
//  ViewController.swift
//  BullsEye
//
//  Created by Silviu Ojog on 18.05.21.
//

import UIKit
import Firebase
import FirebaseFirestore

class GameViewController: UIViewController {

    var currentValue = 0
    var targetInt = 0
    var roundNumber = 0
    var score = 0
    var highscore = 0
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var hitMeButton: UIButton!
    
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
        
        //Read and set highscore of current user
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let property = document.get("highscore")
                print("Highscore of current user: \(property ?? "nil")")
                self.highscore = property as! Int
                self.highscoreLabel.text = String(self.highscore)
            } else {
                print("Document does not exist")
            }
        }
        
  
        slider.setValue(50, animated: false)
        let roundedValue = slider.value.rounded()
        currentValue = Int(roundedValue)
        startNewRound()
        
        let thumbImageNormal = #imageLiteral(resourceName: "SliderThumb-Normal")
        slider.setThumbImage(thumbImageNormal, for: .normal)
        let thumbImageHighlighted = #imageLiteral(resourceName: "SliderThumb-Highlighted")
        slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        let trackLeftImage = #imageLiteral(resourceName: "SliderTrackLeft")
        let trackLeftResizable = trackLeftImage.resizableImage(withCapInsets: insets)
        let trackRightImage = #imageLiteral(resourceName: "SliderTrackRight")
        let trackRightResizable = trackRightImage.resizableImage(withCapInsets: insets)
        slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
        slider.setMaximumTrackImage(trackRightResizable, for: .normal)


    }
    
    @IBAction func showAlert() {
        
        //If game is over (round 10/10), restart game (set "restart" to "hit me!")
        if roundNumber > 10 {
            hitMeButton.setTitle("Hit me!", for: UIControl.State.normal)
            highscoreLabel.text = String(highscore)
            startOver()
            
        } else {
            var difference: Int = currentValue - targetInt
            if difference < 0 {
                difference = difference * -1
            }
            
            let points: Int
            if difference == 0 {
                points = 100 - difference + 100
            } else if difference == 1 {
                points = 100 - difference + 50
            } else {
                points = 100 - difference
            }
            score += points
            
            let title: String
            if difference == 0 {
                title = "Perfect!"
            } else if difference < 5 {
                title = "You almost got it!"
            } else if difference < 10 {
                title = "Pretty good."
            } else {
                title =  "Not even close..."
            }
            
            let message: String
            if difference == 0 {
                message = " You hit \(currentValue) " +
                "\nYou scored \(points) points. (+100 bonus)"
            } else if difference == 1 {
                message = " You hit \(currentValue) " +
                "\nYou scored \(points) points. (+50 bonus)"
            } else {
                message = " You hit \(currentValue) " +
                "\nYou scored \(points) points."
            }
            
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: { [self]
                action in
                if (self.roundNumber == 10) {
                    
                    hitMeButton.setTitle("Restart", for: UIControl.State.normal)
                    if score > self.highscore {
                        self.highscore = self.score
                        highscoreLabel.text = String(highscore)
                        
                        let db = Firestore.firestore()
                        let uidRef = db.collection("users").document(Auth.auth().currentUser!.uid)
                        
                        uidRef.updateData([
                            "highscore": highscore
                        ]) { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("Document successfully updated")
                            }
                        }
                        
                        scoreLabel.text = String(score)
                        roundNumber+=1
                    } else {
                        updateLabels()
                        roundNumber+=1
                    }
                } else {
                    self.startNewRound()
                }
            })
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
 
    }
    
    @IBAction func sliderMoved(_ slider: UISlider) {
        currentValue = Int(slider.value)
    }
    
    func startNewRound() {
            roundNumber += 1
            targetInt = Int.random(in: 1...100)
            currentValue = 50
            slider.value = Float(currentValue)
            updateLabels()
        
    }
    
    func updateLabels() {
        targetLabel.text = String(targetInt)
        roundLabel.text = String(roundNumber) + "/10"
        scoreLabel.text = String(score)
    }
    
    @IBAction func startOver() {
        score = 0
        roundNumber = 0
        startNewRound()
    }
    
    @IBAction func returnToGameHome() {
        let gameHomeViewController = storyboard?.instantiateViewController(identifier: "GameHomeVC") as? GameHomeViewController
        
        view.window?.rootViewController = gameHomeViewController
        view.window?.makeKeyAndVisible()
    }
    
}

