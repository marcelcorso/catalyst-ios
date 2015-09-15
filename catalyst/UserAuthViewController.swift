//
//  ViewController.swift
//  Catalyst
//
//  Created by Corné Driesprong on 15/09/15.
//  Copyright (c) 2015 YoloAmazeballzInterwebs. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class UserAuthViewController: UIViewController {
    
    @IBOutlet weak var codeEntryTextField: UITextField!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "ViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = UIRectEdge.None
    }

    @IBAction func connectButtonTapped(sender: AnyObject) {
        let id = NSUserDefaults.standardUserDefaults().objectForKey("id") as! String
        let entry = codeEntryTextField.text as NSString
        
        if entry.length > 0 {
            let ref = Firebase(url:firebaseURL + "/code2userid/" + self.codeEntryTextField.text)
            ref.setValue(id)
        }
        
        // TODO: check if entry dissapears
    }
}

