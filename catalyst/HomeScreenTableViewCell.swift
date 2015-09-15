//
//  HomeScreenTableViewCell.swift
//  Catalyst
//
//  Created by Corné Driesprong on 15/09/15.
//  Copyright (c) 2015 YoloAmazeballzInterwebs. All rights reserved.
//

import UIKit

class HomeScreenTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
