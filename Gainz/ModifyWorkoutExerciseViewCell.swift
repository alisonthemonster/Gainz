//
//  ModifyWorkoutExerciseViewCell.swift
//  Gainz
//
//  Created by Siena McFetridge on 3/16/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ModifyWorkoutExerciseViewCell: PFTableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var repsField: UITextField!
    @IBOutlet weak var setsField: UITextField!
    var exercise:PFObject?
    var complete:Bool = false
    
    override func awakeFromNib() {
        self.nameField.delegate = self
        self.setsField.delegate = self
        self.repsField.delegate = self
        self.weightField.delegate = self
        self.setsField.keyboardType = UIKeyboardType.NumbersAndPunctuation
        self.repsField.keyboardType = UIKeyboardType.NumbersAndPunctuation
        self.weightField.keyboardType = UIKeyboardType.NumbersAndPunctuation
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        exercise?["name"] = nameField.text
        setTextFieldInt(setsField, key: "sets")
        setTextFieldInt(repsField, key: "reps")
        setTextFieldInt(weightField, key: "weight")
        exercise?.saveInBackgroundWithBlock{ (success: Bool, error: NSError?) -> Void in
            if (success) {
                print ("successful object save")
            }
            else {
                print ("it failed")
            }
        }
        return true
    }
    
    func completed() -> Bool {
        if (nameField.text != nil && setsField.text != nil && repsField.text != nil && weightField.text != nil) {
            complete = true
        } else {
            complete = false
        }
        return complete
    }
    
    func setTextFieldInt(textField: UITextField, key: String) {
        //print (key)
        if let num = Int(textField.text!) {
            //print (num)
            exercise?[key] = num
        }
        exercise?.saveEventually()
    }
    
}
