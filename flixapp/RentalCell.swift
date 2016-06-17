//
//  RentalCell.swift
//  flixapp
//
//  Created by Angeline Rao on 6/17/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit

class RentalCell: UITableViewCell {

    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
