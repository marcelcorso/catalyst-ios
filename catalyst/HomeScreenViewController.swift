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
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "catalyst_logo"))
        
        let settsButton = UIBarButtonItem(image: UIImage(named: "config"), style: .Plain, target: self, action: "settingsButtonTouched:")
        settsButton.tintColor = UIColor.blackColor()
        navigationItem.leftBarButtonItem = settsButton
        let chatButton = UIBarButtonItem(image: UIImage(named: "msg"), style: .Plain, target: self, action: "matchesButtonTouched:")
        chatButton.tintColor = UIColor.blackColor()
        navigationItem.rightBarButtonItem = chatButton
    }
    
    func settingsButtonTouched(sender: UIBarButtonItem) {
        
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
                        
                        let ref = Firebase(url:firebaseURL + "/users/" + id)
                        ref.setValue(userDict)
                        
                        NSUserDefaults.standardUserDefaults().setObject(id, forKey: "id")
                        NSUserDefaults.standardUserDefaults().setObject(name, forKey: "name")
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    }
                }
            }
            
            var channelNumber = 1
            2
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