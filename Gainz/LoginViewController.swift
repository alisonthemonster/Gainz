//
//  LoginViewController.swift
//  Gainz
//
//  Created by Siena McFetridge on 3/14/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("testing login View")
        // Do any additional setup after loading the view, typically from a nib.
        
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Object has been saved.")
        }
        var exerciseId:String = "nil"
        
        let workout = PFObject(className: "Workout")
        
        let exercise = PFObject(className: "Exercise")
        exercise["name"] = "Squats"
        exercise["sets"] = 3
        exercise["reps"] = 10
        exercise["weight"] = 40
        exercise["rating"] = 0
        exercise.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                exerciseId = exercise.objectId!
                workout.addObject(exerciseId, forKey: "exerciseArray")
                workout.saveInBackground()
            }
            else {
                print ("it failed")
            }
        }
        
        var exerciseId2:String = "nil"
        let exercise2 = PFObject(className: "Exercise")
        exercise2["name"] = "Bench"
        exercise2["sets"] = 3
        exercise2["reps"] = 10
        exercise2["weight"] = 40
        exercise2["rating"] = 0
        exercise2.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                exerciseId2 = exercise2.objectId!
                workout.addObject(exerciseId2, forKey: "exerciseArray")
                workout.saveInBackground()
            }
            else {
                print ("it failed")
            }
        }

        // username
        let user = PFUser()
        user.username = "testUser"
        user.password = "testPassword"
        user.signUpInBackground()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
