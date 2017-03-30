//
//  CustomCell.swift
//  Flicks
//
//  Created by Balaji Tummala on 3/30/17.
//  Copyright © 2017 Balaji Tummala. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var moviePosterView: UIImageView!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
