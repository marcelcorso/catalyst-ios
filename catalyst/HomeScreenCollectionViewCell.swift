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
    
    var person: [String : AnyObject]?
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.shadowColor = UIColor.blackColor().CGColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.5
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
