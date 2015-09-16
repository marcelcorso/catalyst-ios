//
//  ChatViewController.swift
//  Catalyst
//
//  Created by Vincent Onderwaater on 16-09-15.
//  Copyright (c) 2015 YoloAmazeballzInterwebs. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var otherUserId: String!
    
    var messages = [[String : String]]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardDidShowNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification: NSNotification!) -> Void in
            
            
            let frameValue: NSValue = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
            
            let rect = frameValue.CGRectValue()
            
            self.bottomConstraint.constant = rect.height
            
            if self.collectionView.numberOfItemsInSection(0) > 0 {
                
                self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: self.collectionView.numberOfItemsInSection(0)-1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Bottom, animated: true)
            }
            
        }
        
        collectionView.registerNib(UINib(nibName: "ChatBubbleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ChatBubbleCollectionViewCell")
        
        let userId = NSUserDefaults.standardUserDefaults().objectForKey("id") as! String
        let mineUserId =  NSUserDefaults.standardUserDefaults().objectForKey("id") as! String
        let mineUserName = NSUserDefaults.standardUserDefaults().objectForKey("name") as! String
        // TODO: fill this for real:
        let herUserId = otherUserId
        
        // sort the ids to get an unique room id
        var first = mineUserId
        var second = herUserId
        
        let firstNSString = first as NSString
        let secondNSString = second as NSString
        let result = firstNSString.localizedCaseInsensitiveCompare(second)
        
        if result == NSComparisonResult.OrderedAscending {
            first = herUserId
            second = mineUserId
        }
        
        let room = "\(first)_\(second)"
        
        let ref = Firebase(url:"https://catalysttv.firebaseio.com/chat/" + room)
        
        var queryRef = ref.queryOrderedByKey().queryLimitedToLast(20)
        
        messages.removeAll(keepCapacity: false)
        
        queryRef.observeEventType(.ChildAdded, withBlock: { (snapshot: FDataSnapshot!) in
            
            if let author = snapshot.value.objectForKey("author_name") as? String,
                message = snapshot.value.objectForKey("message") as? String {
                    self.messages.append(["author" : author, "message" : message])
                    self.collectionView.reloadData()
            }
        })
        
        // create a new message:
        let aNewMessageRef = ref.childByAutoId()
        let massage = [
            "author_id": mineUserId,
            "author_name": mineUserName,
            "message": "\(arc4random_uniform(7)) John Lennon foi castigado e morto por Deus por ter dito em certa ocasião que 'Os Beatles são mais populares do que Jesus Cristo'"
        ]
        //aNewMessageRef.setValue(massage)
        
    }
    
}

extension ChatViewController : UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ChatBubbleCollectionViewCell", forIndexPath: indexPath) as! ChatBubbleCollectionViewCell
        
        let message = messages[indexPath.item] as [String : String]
        
        let heSaidSheSaid = message["message"]
        cell.pickupLine.text = heSaidSheSaid
        
        let author = message["author"]
        
        let mineName = NSUserDefaults.standardUserDefaults().objectForKey("name") as! String
        
        if mineName == author {
            cell.setBubbleStyle(.Me)
        }
        else {
            cell.setBubbleStyle(.OtherPerson)
        }
        let image = cell.chatBubble.image!
        
        return cell
    }
    
}

extension ChatViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        return CGSize(width: CGRectGetWidth(collectionView.bounds), height: 200)
        
    }
}

extension ChatViewController : UITextFieldDelegate {
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let message = textField.text
        
        let mineUserId =  NSUserDefaults.standardUserDefaults().objectForKey("id") as! String
        let mineUserName = NSUserDefaults.standardUserDefaults().objectForKey("name") as! String
        // TODO: fill this for real:
        let herUserId = otherUserId
        
        // sort the ids to get an unique room id
        var first = mineUserId
        var second = herUserId
        
        let firstNSString = first as NSString
        let secondNSString = second as NSString
        let result = firstNSString.localizedCaseInsensitiveCompare(second)
        
        if result == NSComparisonResult.OrderedAscending {
            first = herUserId
            second = mineUserId
        }
        
        let room = "\(first)_\(second)"
        
        let ref = Firebase(url:"https://catalysttv.firebaseio.com/chat/" + room)
        
        let aNewMessageRef = ref.childByAutoId()
        let massage = [
            "author_id": mineUserId,
            "author_name": mineUserName,
            "message": textField.text
        ]
        aNewMessageRef.setValue(massage)
        
        
        return true
    }
    
}
