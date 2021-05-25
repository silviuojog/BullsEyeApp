//
//  RankingViewController.swift
//  BullsEye
//
//  Created by Silviu Ojog on 24.05.21.
//

import UIKit
import Firebase

class RankingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var usernames: [String] = []
    var highscores: [Int] = []

    @IBOutlet var tableView1: UITableView!
    @IBOutlet var tableView2: UITableView!
    @IBOutlet var tableView3: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
        tableView1.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView2.register(UITableViewCell.self, forCellReuseIdentifier: "cell2")
        tableView3.register(UITableViewCell.self, forCellReuseIdentifier: "cell3")
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView2.delegate = self
        tableView2.dataSource = self
        tableView3.delegate = self
        tableView3.dataSource = self
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rank:[Int] = Array(1...highscores.count)
        print ("ranklength: \(rank.count)")
        if tableView == tableView1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = usernames[indexPath.row]
            cell.textLabel?.font = UIFont(name:"Avenir", size:20)
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .clear
            cell.backgroundView = UIView()
            cell.selectedBackgroundView = UIView()
            print (usernames[indexPath.row])
            return cell
            
        } else if tableView == tableView2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
            cell.textLabel?.text = "\(highscores[indexPath.row])"
            cell.textLabel?.font = UIFont(name:"Avenir", size:20)
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .clear
            cell.backgroundView = UIView()
            cell.selectedBackgroundView = UIView()
            print (highscores[indexPath.row])
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath)
            cell.backgroundColor = .clear
            cell.textLabel?.font = UIFont(name:"Avenir", size:20)
            cell.textLabel?.textColor = .white
            cell.backgroundView = UIView()
            cell.selectedBackgroundView = UIView()
            print ("indexpath.row: \(indexPath.row)")
            cell.textLabel?.text = "\(rank[indexPath.row])"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == tableView1 {
            return "Username"
        } else if tableView == tableView2 {
            return "Highscore"
        } else {
            return "Rank"
        }
    }
    
    //Read and set usernames and highscores to UITableView
    func fetchData()  {
        Firestore.firestore().collection("users").whereField("highscore", isGreaterThan: 0).order(by: "highscore", descending: true).getDocuments { (snapshot, error) in
            if let snapshot = snapshot {
                for doc in snapshot.documents {
                    if let username = doc.get("username") as? String {
                        self.usernames.append(username)
                        print(username)
                    } else {
                        print("username not found")
                    }
                    
                    if let highscore = doc.get("highscore") as? Int {
                        self.highscores.append(highscore)
                        print(highscore)
                    } else {
                        print("highscore not found")
                    }
                }
                
                print(self.usernames)
                print(self.highscores)
            } else {
                if let error = error {
                    print(error)
                }
                
            }
            DispatchQueue.main.async {
                self.tableView1.reloadData()
                self.tableView2.reloadData()
                self.tableView3.reloadData()
            }
        }
    }
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //    func fetchData(completion: @escaping (Bool) -> ()){
    //
    //        let db = Firestore.firestore()
    //        db.collection("users").getDocuments { (snapshot, err) in
    //
    //            if let err = err {
    //                print("Error getting documents: \(err)")
    //                completion(false)
    //            } else {
    //                for document in snapshot!.documents {
    //
    //                    let username = document.get("username") as! String
    //
    //                    print("username: ",username)
    //                   // let restaurant1 = Restaurants(title: name)
    //
    //                    self.usernames.append(username)
    //
    //                }
    //
    //                completion(true)
    //            }
    //        }
    //    }
    
}
    



