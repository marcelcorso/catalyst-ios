//
//  HomeHeaderView.swift
//  Catalyst
//
//  Created by Vincent Onderwaater on 15-09-15.
//  Copyright (c) 2015 YoloAmazeballzInterwebs. All rights reserved.
//

import UIKit

class HomeHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var programTitleLabel: UILabel!
    @IBOutlet weak var channelTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        programTitleLabel.text = nil
        channelTitleLabel.text = nil
    }
    
}
