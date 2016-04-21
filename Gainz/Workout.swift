//
//  Workout.swift
//  Gainz
//
//  Created by Siena McFetridge on 4/10/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation
import Parse

class Workout {
    
    var workout: PFObject
    var exercises: [PFObject]?
    var delegate: ReloadViewDelegate?
    
    init(workout: PFObject, delegate: ReloadViewDelegate, index: Int) {
        self.workout = workout
        self.delegate = delegate
        let query = PFQuery(className: "Exercise")
        query.whereKey("workout", equalTo: workout)
        query.whereKey("rating", notEqualTo: NSNull())
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if (error != nil) {
                print (error)
                //there are no exercises for today's workout
                print("we found no exercises for todays workout")
            } else {
                //the objects array has today's exercises
                self.exercises = objects
                delegate.dataDidChange(index)
            }
        }
    }

}