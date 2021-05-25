//
//  AboutViewController.swift
//  BullsEye
//
//  Created by Silviu Ojog on 19.05.21.
//

import UIKit
import WebKit

class AboutViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let htmlPath = Bundle.main.path(forResource: "BullsEye", ofType: "html") {
          let url = URL(fileURLWithPath: htmlPath)
          let request = URLRequest(url: url)
          webView.load(request)
        }    }
    

    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }

}
