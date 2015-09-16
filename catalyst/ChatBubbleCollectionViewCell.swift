//
//  ChatBubbleCollectionViewCell.swift
//  Catalyst
//
//  Created by Vincent Onderwaater on 16-09-15.
//  Copyright (c) 2015 YoloAmazeballzInterwebs. All rights reserved.
//

import UIKit

let constraintMargin: CGFloat = 10

enum ChatBubbleStyle {
    
    case Me
    case OtherPerson
}

class ChatBubbleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var chatBubble: UIImageView!
    @IBOutlet weak var pickupLine: UILabel!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    func setBubbleStyle(style: ChatBubbleStyle) {
        
        switch style {
        case .Me:
            chatBubble.image = UIImage(named: "chatgrey")
            pickupLine.backgroundColor = UIColor.grayColor()
            leadingConstraint.constant = 400
            pickupLine.textAlignment = NSTextAlignment.Right
        case .OtherPerson:
            chatBubble.image = UIImage(named: "chatlove")
            pickupLine.backgroundColor = UIColor.redColor()
            trailingConstraint.constant = 400
            pickupLine.textAlignment = NSTextAlignment.Left
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
        pickupLine.backgroundColor = UIColor.grayColor()
        
        leadingConstraint.constant = constraintMargin
        trailingConstraint.constant = constraintMargin
        pickupLine.text = nil
        chatBubble.image = nil
    }
    
}
