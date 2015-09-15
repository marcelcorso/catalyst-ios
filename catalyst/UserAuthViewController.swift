//
//  ViewController.swift
//  Catalyst
//
//  Created by Corné Driesprong on 15/09/15.
//  Copyright (c) 2015 YoloAmazeballzInterwebs. All rights reserved.
//

import UIKit
import Firebase

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
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func connectButtonTapped(sender: AnyObject) {
        let ref = Firebase(url:firebaseURL + "/code2userid/")
        
        ref.queryOrderedByChild("aaaa").observeEventType(.ChildAdded, withBlock: { data in
            if let code = data.value.description, entry = self.codeEntryTextField.text {
                if code != entry {
                    println("wrong code!")
                    var alert = UIAlertController(title: "Error", message: "Invalid code!", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    println("correct code!")
                    // proceed to main view
                }
            }
        })
        
        let code = codeEntryTextField.text
    }
}

