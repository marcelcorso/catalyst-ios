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
    @IBOutlet weak var tvShowLabel: UILabel!
    
    var people = [String : [String : AnyObject]]()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "HomeScreenTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        navigationItem.title = "Catalyst"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkUserAuth()
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

                if let person = snapshot.value as? [String: AnyObject] {
                self.people[snapshot.key] = person
                }
                self.tableView.reloadData()
                
            })
            
            
        }
    }
}

extension HomeScreenViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let b = people.count
        return people.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! HomeScreenTableViewCell
        
        
        
        return cell
    }
}

extension HomeScreenViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 132
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        /*// save the 'like'
        let likedPersonId = people[indexPath.row].id
        let userId = NSUserDefaults.standardUserDefaults().objectForKey("id")

        let ref = Firebase(url:firebaseURL + "/likes/" + likeId.description)
        let postRef = ref.childByAppendingPath("likes")
        let likeDict = [dst_user_id: likedPersonId, src_user_id: userId]
        let post1Ref = postRef.childByAutoId()
        post1Ref.setValue(likeDict) */
    }
}