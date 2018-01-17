//
//  ItemCell.swift
//  CycPop
//
//  Created by 布莱德 王 on 2017/4/12.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
//    @IBOutlet var nameLabel: UILabel!
//    @IBOutlet var serialNumberLabel: UILabel!
//    @IBOutlet var valueLabel: UILabel!
    
    @IBOutlet var memoLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    
    //sets fonts of labels - Dynamic Type
    func updateLabels() {
        let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        memoLabel.font = bodyFont
        
        let captionFont = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        timeLabel.font = captionFont
        locationLabel.font = captionFont
    }
}

