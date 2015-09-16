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
            
            let myId = NSUserDefaults.standardUserDefaults().objectForKey("id") as! String
            let myRef = Firebase(url:"https://catalysttv.firebaseio.com/users/\(myId)/")
            
            let likedPersonId = notification.object!["facebook_id"] as! String
            let likedPersonRef = Firebase(url:"https://catalysttv.firebaseio.com/users/\(likedPersonId)/")
            
            // add like to my profile
            let myLikesRef = myRef.childByAppendingPath("likes")
            let likeRef = myLikesRef.childByAutoId()
            likeRef.setValue(likedPersonId)
            
            let likedPersonsLikesRef = likedPersonRef.childByAppendingPath("likes")
            likedPersonsLikesRef.queryOrderedByValue().observeEventType(.ChildAdded, withBlock: { snapshot in
                if snapshot.value as! String == myId {
                    println("yay, match!")
                    
                    // set match on me
                    let myMatchesRef = myRef.childByAppendingPath("matches")
                    let myMatchRef = myMatchesRef.childByAutoId()
                    myMatchRef.setValue(likedPersonId)
                    
                    // set match on liked person
                    let likedPersonsMatchesRef = likedPersonRef.childByAppendingPath("matches")
                    let likedPersonsMatchRef = likedPersonsMatchesRef.childByAutoId()
                    likedPersonsMatchRef.setValue(myId)
                    
                    // set notification
                    let likedPersonsName = notification.object!["name"] as! String
                    let myNotificationsRef = myRef.childByAppendingPath("notifications")
                    let myNotificationRef = myNotificationsRef.childByAutoId()
                    myNotificationsRef.setValue("Wow, \(likedPersonsName) likes you too!")
                    
                    let myName = NSUserDefaults.standardUserDefaults().objectForKey("name") as! String
                    let likedPersonsNotificationsRef = likedPersonRef.childByAppendingPath("notifications")
                    let likedPersonsNotificationRef = likedPersonsNotificationsRef.childByAutoId()
                    likedPersonsNotificationRef.setValue("Wow, \(myName) likes you too!")
                }
            })
        }
        
        
        NSNotificationCenter.defaultCenter().addObserverForName(noMatchNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification: NSNotification!) -> Void in
            
            // TODO: Corné: Notification code for no match
            
            
        }
        
        collectionView.registerNib(UINib(nibName: "HomeScreenCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collcell")
        collectionView.registerNib(UINib(nibName: "HomeHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        
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
        let userId = NSUserDefaults.standardUserDefaults().objectForKey("id") as? String
        if FBSDKAccessToken.currentAccessToken() == nil {
            let fbAuthViewController = FBAuthViewController(nibName: "FBAuthViewController", bundle: nil)
            presentViewController(fbAuthViewController, animated: false, completion: nil)
        } else {
            let request = FBSDKGraphRequest(graphPath: "me?fields=id,name,picture.type(large)", parameters: [:]).startWithCompletionHandler { (connection, result, error) -> Void in
                
                if error != nil {
                    println(error)
                } else {
                    if let id = result["id"] as? String,
                        name = result["name"] as? String,
                        pictureData = result["picture"] as? [String: AnyObject],
                        picture = pictureData["data"] as? [String : AnyObject],
                        url = picture["url"] as? String
                    {
                        let userDict = ["avatar": url,
                            "facebook_id": id,
                            "name": name]
                        
                        let userRef = Firebase(url:firebaseURL + "/users/" + id)
                        userRef.updateChildValues(userDict, withCompletionBlock: { (error: NSError!, firebase: Firebase!) -> Void in
                            let child = userRef.childByAppendingPath("viewing_channel").observeEventType(.Value, withBlock: { (channelSnapshot: FDataSnapshot!) -> Void in
                                
                                if let channelNumber = channelSnapshot.value as? Int {
                                    
                                    let potentialMatches = Firebase(url:"https://catalysttv.firebaseio.com/users")
                                    
                                    var queryRef = potentialMatches.queryOrderedByChild("viewing_channel").queryEndingAtValue(channelNumber)!.queryStartingAtValue(channelNumber)
                                    
                                    self.people.removeAll(keepCapacity: false)
                                    
                                    queryRef.observeEventType(.ChildAdded, withBlock: { (snapshot: FDataSnapshot!) in
                                        
                                        if let person = snapshot.value as? [String: AnyObject] {
                                            self.people.append(person)
                                        }
                                        self.collectionView.reloadData()
                                    })
                                }
                            })
                        })
                        
                        NSUserDefaults.standardUserDefaults().setObject(id, forKey: "id")
                        NSUserDefaults.standardUserDefaults().setObject(name, forKey: "name")
                        self.dismissViewControllerAnimated(false, completion: nil)
                        
                        let code = NSUserDefaults.standardUserDefaults().objectForKey("userCode")
                        
                        if code == nil {
                            let userAuthViewController = UserAuthViewController(nibName: "UserAuthViewController", bundle: nil)
                            self.presentViewController(userAuthViewController, animated: false, completion: nil)
                            self.collectionView.reloadData()
                        }
                        
                    }
                }
            }
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
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "header", forIndexPath: indexPath) as! HomeHeaderView
        
        let userId = NSUserDefaults.standardUserDefaults().objectForKey("id") as! String
        var ref1 = Firebase(url:"https://catalysttv.firebaseio.com/users/\(userId)/viewing/now/title")
        
        ref1.observeEventType(.Value, withBlock: { snapshot in
            if let title = snapshot.value as? String {
                header.programTitleLabel.text = title
            }
        })
        
        var ref2 = Firebase(url:"https://catalysttv.firebaseio.com/users/\(userId)/viewing_channel/")
        
        ref2.observeEventType(.Value, withBlock: { snapshot in
            if let channel = snapshot.value as? String {
                header.channelTitleLabel.text = "channel " + channel
            }
        })
        
        return header
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
}

extension HomeScreenViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 80)
    }
}