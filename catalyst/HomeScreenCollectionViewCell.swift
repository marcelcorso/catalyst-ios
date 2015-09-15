//
//  HomeScreenTableViewCell.swift
//  Catalyst
//
//  Created by Corné Driesprong on 15/09/15.
//  Copyright (c) 2015 YoloAmazeballzInterwebs. All rights reserved.
//

import UIKit

let matchNotification = "matchNotification"
let noMatchNotification = "noMatchNotification"

class HomeScreenCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var gradientImageView: UIImageView!
    
    var person: [String : AnyObject]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.shadowColor = UIColor.blackColor().CGColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.5
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: "moveTap:")
        //gradientImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    func moveTap(gestureRecognizer: UIPanGestureRecognizer) {
        
        let trans = gestureRecognizer.translationInView(self)
        
        switch gestureRecognizer.state {
        
        case .Changed:
            
            print("x: \(trans)")
            self.transform = CGAffineTransformMake(0, 0, 0, 0, trans.x, 0.0)
           // userImageView.transform = CGAffineTransformMake(0, 0, 0, 0, trans.x, 0.0)
            //gradientImageView.transform = CGAffineTransformMake(0, 0, 0, 0, trans.x, 0.0)
        case .Ended:
            self.transform = CGAffineTransformIdentity
            userImageView.transform = CGAffineTransformIdentity
            gradientImageView.transform = CGAffineTransformIdentity
        default:
            break
            
        }
    
        
    
    }
    
    @IBAction func matchButtonTouched(sender: UIButton) {
        
        NSNotificationCenter.defaultCenter().postNotificationName(matchNotification, object: person)
    }
    
    @IBAction func noMatchButtonTouched(sender: UIButton) {
        
        NSNotificationCenter.defaultCenter().postNotificationName(noMatchNotification, object: person)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        person = nil
        userName.text = nil
        userImageView.image = nil
    }
}
