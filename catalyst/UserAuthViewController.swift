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
    
    @IBOutlet weak var connectButton: UIButton!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nil)
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
        
        
        if let associatedCode = codeEntryTextField.text as? String where count(associatedCode) > 0 {
            
            let ref = Firebase(url:firebaseURL + "/code2userid/" + self.codeEntryTextField.text)
            
            ref.setValue(id, withCompletionBlock: { (error: NSError!, firebase: Firebase!) -> Void in
                
                if error == nil {
                userId = id
                self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                
                    self.connectButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                    self.connectButton.setTitle("ERROR! Try again", forState: .Normal)
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                        self.connectButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                        self.connectButton.setTitle("Connect", forState: .Normal)
                    })
                }
                
                
            })
            
        } else {
        
            print("CAN'T SET AN EMPTY CODE!")
        }
        
        // TODO: check if entry dissapears
    }
}

