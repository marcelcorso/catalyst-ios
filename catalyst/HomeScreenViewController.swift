//
//  HomeScreenViewController.swift
//  Catalyst
//
//  Created by Vincent Onderwaater on 15-09-15.
//  Copyright (c) 2015 YoloAmazeballzInterwebs. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkUserAuth()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        navigationItem.title = "Catalyst"
    }
    
    func checkUserAuth() {
        if FBSDKAccessToken.currentAccessToken() == nil {
            let fbAuthViewController = FBAuthViewController(nibName: "FBAuthViewController", bundle: nil)
            presentViewController(fbAuthViewController, animated: false, completion: nil)
        } else if userId == nil {

            let userAuthViewController = UserAuthViewController(nibName: "UserAuthViewController", bundle: nil)
            presentViewController(userAuthViewController, animated: false, completion: nil)
        } else {
        
            var channelNumber = 1
            
            let ref = Firebase(url:"https://catalysttv.firebaseio.com/users")
            
            var queryRef = ref.queryOrderedByChild("viewing_channel").queryEndingAtValue(channelNumber)!.queryStartingAtValue(channelNumber)
            
            queryRef.observeEventType(.ChildAdded, withBlock: { (snapshot: FDataSnapshot!) in

                println(snapshot.key)
                
            })
        
        }
    }
}

extension HomeScreenViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        return cell
    }
}

extension HomeScreenViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 132
    }
}