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
        aNewMessageRef.setValue(massage)
        
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
        cell.setBubbleStyle(.Me)
        
        cell.setNeedsUpdateConstraints()
        
        return cell
    }
    
}

extension ChatViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let message = messages[indexPath.item] as [String : String]
        
        let heSaidSheSaid: String = message["message"]!
        
        let topBottomMargins: CGFloat = 30.0
        let maxWidth: CGFloat = CGRectGetWidth(collectionView.bounds) - 30.0
        
        let maxSize = CGSize(width: maxWidth, height: CGFloat.max)
        
        let s = heSaidSheSaid as NSString
        
        let rect = s.boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesDeviceMetrics, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(17)], context: nil)
        
        return CGSize(width: CGRectGetWidth(collectionView.bounds), height: CGRectGetHeight(rect) + topBottomMargins)
      
    }
}
