//
//  TodaysWorkoutTableViewController.swift
//  Gainz
//
//  Created by Siena McFetridge on 3/18/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class TodaysWorkoutTableViewController: PFQueryTableViewController, ReloadViewDelegate {
    
    var currentWorkout:PFObject?
    var alertController:UIAlertController? = nil

    override func queryForTable() -> PFQuery {
        print("query for table")
        //get the unsaved workout (today's workout)
        let innerQuery = PFQuery(className: "Workout")
        innerQuery.whereKey("saved", equalTo: false)
        //get the exercises that are in unsaved workouts
        let query = PFQuery(className: "Exercise")
        query.whereKey("workout", matchesQuery: innerQuery)
        innerQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if (error != nil) {
                print (error)
            } else {
                self.currentWorkout = objects![0]
            }
        }
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier("todayCell", forIndexPath: indexPath) as! TodaysWorkoutExerciseCell
        print("loading cell!!!")
        
        if let sets = (object?.objectForKey("sets") as? Int) {
            cell.sets.text = String(sets)
        } else {
            cell.sets.text = ""
        }
        if let reps = (object?.objectForKey("reps") as? Int) {
            cell.reps.text = String(reps)
        } else {
            cell.reps.text = ""
        }
        if let weight = (object?.objectForKey("weight") as? Int) {
            cell.weights.text = String(weight)
        } else {
            cell.weights.text = ""
        }
        cell.nameLabel.text = object?.objectForKey("name") as? String
        cell.exercise = object
        
        if let rating = (object?.objectForKey("rating") as? Int) {
            if (rating==0) {
                cell.backgroundColor = UIColor.greenColor()
            } else if (rating==1) {
                cell.backgroundColor = UIColor.yellowColor()
            } else if (rating==2) {
                cell.backgroundColor = UIColor.redColor()
            }
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(String(indexPath.row))
        let cell = tableView.dequeueReusableCellWithIdentifier("todayCell", forIndexPath: indexPath) as! TodaysWorkoutExerciseCell
        
        print("selected cell is: " + cell.nameLabel.text!)
        //TODO: THE SELECTED CELL IS WRONG!!!
        
        print(String(cell.backgroundColor))
        if (cell.backgroundColor == UIColor(red: 1, green: 1, blue: 1, alpha: 1)) {
            //cell has not yet been rated
            print("creating alert controller")
            self.alertController = UIAlertController(title: "Rate this workout", message: "Was this workout easy, medium, or hard? We'll plan your next workout based on your feedback.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let buttonOne = UIAlertAction(title: "Easy", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                print("Button One Pressed")
                print("changing this cell's color: " + cell.nameLabel.text!)
                cell.backgroundColor = UIColor.greenColor()
                cell.complete = true
                
//                //update the rating in parse!
//                var query = PFQuery(className:"Exercise")
//                query.whereKey("name", equalTo: cell.nameLabel.text!)
//                //TODO currently relies on the fact that exercise names are unique
//                query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
//                    if (error != nil) {
//                        print (error)
//                    } else {
//                        let object = objects![0]
//                        object["rating"] = 0
//                        object.saveInBackground()
//                    }
//                }

                tableView.reloadData()
            })
            let buttonTwo = UIAlertAction(title: "Medium", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                print("Button Two Pressed")
                print("changing this cell's color: " + cell.nameLabel.text!)
                cell.backgroundColor = UIColor.yellowColor()
                cell.complete = true
                
//                //update the rating in parse!
//                var query = PFQuery(className:"Exercise")
//                query.whereKey("name", equalTo: cell.nameLabel.text!)
//                //TODO currently relies on the fact that exercise names are unique
//                query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
//                    if (error != nil) {
//                        print (error)
//                    } else {
//                        let object = objects![0]
//                        object["rating"] = 1
//                        object.saveInBackground()
//                    }
//                }
                
                tableView.reloadData()
            })
            let buttonThree = UIAlertAction(title: "Hard", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                print("Button Three Pressed")
                print("changing this cell's color: " + cell.nameLabel.text!)
                cell.backgroundColor = UIColor.redColor()
                cell.complete = true
                
//                //update the rating in parse!
//                var query = PFQuery(className:"Exercise")
//                query.whereKey("name", equalTo: cell.nameLabel.text!)
//                //TODO currently relies on the fact that exercise names are unique
//                query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
//                    if (error != nil) {
//                        print (error)
//                    } else {
//                        let object = objects![0]
//                        object["rating"] = 2
//                        object.saveInBackground()
//                    }
//                }
                
                tableView.reloadData()
            })
            let buttonCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
                print("Cancel Button Pressed")
            }
            self.alertController!.addAction(buttonOne)
            self.alertController!.addAction(buttonTwo)
            self.alertController!.addAction(buttonThree)
            self.alertController!.addAction(buttonCancel)

            presentViewController(self.alertController!, animated: true, completion: nil)
        }
        
    }
    
    func setTextField (textField: UITextField, key: String, object: PFObject?) {
        if let sets = (object?.objectForKey(key) as? Int) {
            textField.text = String(sets)
        } else {
            textField.text = ""
        }
    }
    
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func dataDidChange() {
        self.loadObjects()
        self.tableView.reloadData()
    }
    
    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "editSegue") {
            let view = segue.destinationViewController as? ModifyWorkoutsViewController
            view?.changedDataDelegate = self
        }
    }
}
