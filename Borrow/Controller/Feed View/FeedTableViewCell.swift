//
//  FeedTableViewCell.swift
//  Borrow
//
//  Created by jackie on 4/17/19.
//  Copyright © 2019 jackie. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var timeText: UILabel!
    @IBOutlet weak var borrower: UILabel!
    @IBOutlet weak var lender: UILabel!
    @IBOutlet weak var item: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePic.setRounded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
