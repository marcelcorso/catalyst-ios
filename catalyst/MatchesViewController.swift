//
//  MatchesViewController.swift
//  Catalyst
//
//  Created by Vincent Onderwaater on 15-09-15.
//  Copyright (c) 2015 YoloAmazeballzInterwebs. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

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
        
        let userId = NSUserDefaults.standardUserDefaults().objectForKey("id") as! String
        let ref = Firebase(url: "https://catalysttv.firebaseio.com/users/\(userId)/matches/")
        
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot: FDataSnapshot!) in
            
            var matchUserID: String = snapshot.value as! String
            self.processMatchUserID(matchUserID)
        })
        
        tableView.registerNib(UINib(nibName: "MatchTableViewCell", bundle: nil), forCellReuseIdentifier: "MatchTableViewCell")
        
        let bbitem = UIBarButtonItem(image: UIImage(named: "catalyst_logo"), style: UIBarButtonItemStyle.Done, target: self, action: "dismissMe:")
        bbitem.tintColor = UIColor.blackColor()
        navigationItem.leftBarButtonItem = bbitem
        
        title = "Matches"
        
    }
    
    func processMatchUserID(matchUserID: String) {
        
        let matchRef = Firebase(url: "https://catalysttv.firebaseio.com/users/\(matchUserID)/")
        
        matchRef.observeEventType(.Value, withBlock: { matchSnapshot in
            if let match = matchSnapshot.value as? [String : AnyObject] {
                self.matches.append(match)
                self.tableView.reloadData()
            }
        })
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
        
        let match = matches[indexPath.item]
        
        if let name = match["name"] as? String {
            cell.nameLabel.text = name
        }
        
        if let urlString = match["avatar"] as? String,
            url = NSURL(string: urlString) {
                
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: nil, progress: nil) { (image, error, imageCacheType, finished, url) -> Void in
                    
                    if image != nil {
                        cell.matchImageView.image = image
                    }
                }
        }
        
        return cell
    }
}

extension MatchesViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let match = matches[indexPath.item]
        
        let chatVC = ChatViewController(nibName: "ChatViewController", bundle: nil)
        
        if let fbid = match["facebook_id"] as? String {
            
            chatVC.otherUserId = fbid
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }
}


