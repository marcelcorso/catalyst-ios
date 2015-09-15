//
//  HomeScreenViewController.swift
//  Catalyst
//
//  Created by Vincent Onderwaater on 15-09-15.
//  Copyright (c) 2015 YoloAmazeballzInterwebs. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class HomeScreenViewController: UIViewController {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserAuth()
        
        
    }
  
    func checkUserAuth() {
    
        if FBSDKAccessToken.currentAccessToken() == nil {
            
            presentViewController(UINavigationController(rootViewController: FBAuthViewController(nibName: "FBAuthViewController", bundle: nil)), animated: true, completion: { () -> Void in
                
            })
        
            
        }
        
    
    }
}
