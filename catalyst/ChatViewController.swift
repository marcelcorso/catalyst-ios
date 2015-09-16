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

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

	collectionView.registerNib(UINib(nibName: "ChatBubbleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ChatBubbleCollectionViewCell")


        let userId = NSUserDefaults.standardUserDefaults().objectForKey("id") as! String
        let mineUserId =  NSUserDefaults.standardUserDefaults().objectForKey("id") as! String
        let mineUserName = NSUserDefaults.standardUserDefaults().objectForKey("name") as! String
        // TODO: fill this for real:
        let herUserId = "2"
        
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
    
}

extension ChatViewController : UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ChatBubbleCollectionViewCell", forIndexPath: indexPath) as! ChatBubbleCollectionViewCell
        
        
        
        return cell
    }

    
}
