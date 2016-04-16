//
//  ExerciseTableViewCell.swift
//  Gainz
//
//  Created by Siena McFetridge on 4/15/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sets: UILabel!
    @IBOutlet weak var reps: UILabel!
    @IBOutlet weak var weight: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
