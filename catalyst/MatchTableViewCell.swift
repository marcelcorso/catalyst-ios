//
//  MatchTableViewCell.swift
//  Catalyst
//
//  Created by Vincent Onderwaater on 16-09-15.
//  Copyright (c) 2015 YoloAmazeballzInterwebs. All rights reserved.
//

import UIKit

class MatchTableViewCell: UITableViewCell {

    @IBOutlet weak var matchImageView: UIImageView!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        matchImageView.image = nil
        descriptionTitleLabel.text = nil
        nameLabel.text = nil
    }

    

}
