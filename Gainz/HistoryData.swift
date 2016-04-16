//
//  HistoryData.swift
//  Gainz
//
//  Created by Siena McFetridge on 4/10/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation
import Parse

class HistoryData {
    
    var pastWorkouts: [PFObject]!
    
    func queryPastWorkouts () {
        let workoutQuery = PFQuery(className: "Workout")
        workoutQuery.whereKey("saved", equalTo: true)
        workoutQuery.whereKey("user", equalTo: PFUser.currentUser()!)
        workoutQuery.orderByDescending("createdAt")
        workoutQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if (error != nil) {
                print (error)
                print("past workouts not found")
                //TODO Display Message
            } else {
                //this is today's workout
                self.pastWorkouts = objects!
                print("we found the most recent workouts!")
            }
            print("inside the block!")
        }
        
    }
    
    func queryExercises(workout: PFObject) -> [PFObject]? {
        //get the exercises that are in workout
        let query = PFQuery(className: "Exercise")
        query.whereKey("workout", equalTo: workout)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if (error != nil) {
                print (error)
                //there are no exercises for today's workout
                print("we found no exercises for todays workout")
            } else {
                //the objects array has today's exercises
                if let exercises = objects {
                    print("we found todays exercises!")
                    print("there are " + String(exercises!.count) + " exercises for today")
                    return exercises
                }
            }
        }
        return nil
    }
}