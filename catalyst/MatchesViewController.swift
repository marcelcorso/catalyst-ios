//
//  MatchesViewController.swift
//  Catalyst
//
//  Created by Vincent Onderwaater on 15-09-15.
//  Copyright (c) 2015 YoloAmazeballzInterwebs. All rights reserved.
//

import UIKit
import Firebase

class MatchesViewController: UIViewController {
    
    var matches: [[String : AnyObject]] = [[String : AnyObject]]()
    
    @IBOutlet weak var tableView: UITableView!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Firebase(url: "https://catalysttv.firebaseio.com/users/\(userId!)/matches/")
        
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot: FDataSnapshot!) in
            
            var matchUserID: String = snapshot.value as! String
            
            let matchRef = Firebase(url: "https://catalysttv.firebaseio.com/users/\(matchUserID)/")
            
            matchRef.observeEventType(.Value, withBlock: { matchSnapshot in
                
                
            
            })
            
        })
        
        tableView.registerNib(UINib(nibName: "MatchTableViewCell", bundle: nil), forCellReuseIdentifier: "MatchTableViewCell")
        
        let bbitem = UIBarButtonItem(image: UIImage(named: "catalyst_logo"), style: UIBarButtonItemStyle.Done, target: self, action: "dismissMe:")
        bbitem.tintColor = UIColor.blackColor()
        navigationItem.leftBarButtonItem = bbitem
        
        title = "Matches"
        
    }
    
    func dismissMe(sender: UIBarButtonItem) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension MatchesViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("MatchTableViewCell", forIndexPath: indexPath) as! MatchTableViewCell
        
        return cell
    }
    
}


