//
//  ModifyWorkoutExerciseViewCell.swift
//  Gainz
//
//  Created by Siena McFetridge on 3/16/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class ModifyWorkoutExerciseViewCell: UITableViewCell {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var repsField: UITextField!
    @IBOutlet weak var setsField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
