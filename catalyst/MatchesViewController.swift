//
//  MatchesViewController.swift
//  Catalyst
//
//  Created by Vincent Onderwaater on 15-09-15.
//  Copyright (c) 2015 YoloAmazeballzInterwebs. All rights reserved.
//

import UIKit

class MatchesViewController: UIViewController {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
     
        let bbitem = UIBarButtonItem(image: UIImage(named: "catalyst_logo"), style: UIBarButtonItemStyle.Done, target: self, action: "dismissMe:")
        bbitem.tintColor = UIColor.blackColor()
        navigationItem.leftBarButtonItem = bbitem
 
        
        title = "Matches"

    }
    
    func dismissMe(sender: UIBarButtonItem) {
    
        self.navigationController?.popViewControllerAnimated(true)
    }
}
