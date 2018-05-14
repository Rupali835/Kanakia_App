//
//  PDFReaderVC.swift
//  Kanakia SOP
//
//  Created by user on 01/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class PDFReaderVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var URLString: String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        print(self.URLString)
        let fileURL = URL(fileURLWithPath: self.URLString)
        let fileRequest = URLRequest(url: fileURL)
        self.webView.loadRequest(fileRequest)
    }
    @IBAction func onBackClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
}
