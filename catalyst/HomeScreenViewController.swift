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
import SDWebImage

class HomeScreenViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tvShowLabel: UILabel!
    
    var people = [[String : AnyObject]]()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserverForName(matchNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification: NSNotification!) -> Void in
            
            // TODO: Corné : Firebase code for a match
        }
        
        
        NSNotificationCenter.defaultCenter().addObserverForName(noMatchNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification: NSNotification!) -> Void in
            
            // TODO: Corné: Notification code for no match
            
            
        }
        
        collectionView.registerNib(UINib(nibName: "HomeScreenCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collcell")
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "catalyst_logo"))
        
        let settsButton = UIBarButtonItem(image: UIImage(named: "config"), style: .Plain, target: self, action: "settingsButtonTouched:")
        settsButton.tintColor = UIColor.blackColor()
        navigationItem.leftBarButtonItem = settsButton
        let chatButton = UIBarButtonItem(image: UIImage(named: "msg"), style: .Plain, target: self, action: "matchesButtonTouched:")
        chatButton.tintColor = UIColor.blackColor()
        navigationItem.rightBarButtonItem = chatButton
    }
    
    func settingsButtonTouched(sender: UIBarButtonItem) {
        // TODO: fill this constants for real:
        let mineUserId = 1
        let mineUserName = "Pastor Marco Feliciano"
        let herUserId = 2
        
        // sort the ids to get an unique room id
        var first = mineUserId
        var second = herUserId
        if first < second {
            first = herUserId
            second = mineUserId
        }
        
        let room = "\(first)_\(second)"
        
        let ref = Firebase(url:"https://catalysttv.firebaseio.com/chat/" + room)
        
        var queryRef = ref.queryOrderedByKey().queryLimitedToLast(20)
        
        queryRef.observeEventType(.ChildAdded, withBlock: { (snapshot: FDataSnapshot!) in
            let author: AnyObject? = snapshot.value.objectForKey("author_name")
            let message: AnyObject? = snapshot.value.objectForKey("message")
            
            println("\(author): \(message)")
        })
        
        // create a new message:
        let aNewMessageRef = ref.childByAutoId()
        let massage = [
                "author_id": mineUserId,
                "author_name": mineUserName,
                "message": "\(arc4random_uniform(7)) John Lennon foi castigado e morto por Deus por ter dito em certa ocasião que 'Os Beatles são mais populares do que Jesus Cristo'"
        ]
        aNewMessageRef.setValue(massage)
        
    }
    
    func matchesButtonTouched(sender: UIBarButtonItem) {
    
        self.navigationController?.pushViewController(MatchesViewController(nibName: "MatchesViewController", bundle: nil), animated: true)
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
                    self.people.append(person)
                }
                self.collectionView.reloadData()
            })
        }
    }
}

extension HomeScreenViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: CGRectGetWidth(UIScreen.mainScreen().bounds), height: 260)
    }
}

extension HomeScreenViewController : UICollectionViewDataSource  {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collcell", forIndexPath: indexPath) as! HomeScreenCollectionViewCell
        
        let index = indexPath.item
        
        let person = people[indexPath.item]
        cell.person = person
        cell.userName.text = person["name"] as? String
        
        if let urlString = person["avatar"] as? String,
            url = NSURL(string: urlString) {
                
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: nil, progress: nil) { (image, error, imageCacheType, finished, url) -> Void in
                    
                    if image != nil {
                    cell.userImageView.image = image
                    }
                }
        }        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
}