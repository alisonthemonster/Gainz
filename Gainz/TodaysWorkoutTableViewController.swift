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
        let innerQuery = PFQuery(className: "Workout")
        innerQuery.whereKey("saved", equalTo: false)
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
        
        cell.sets.text = object?.objectForKey("sets") as? String
        cell.reps.text = object?.objectForKey("reps") as? String
        cell.weights.text = object?.objectForKey("weight") as? String
        cell.nameLabel.text = object?.objectForKey("name") as? String
        cell.exercise = object
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("dequeing cell")
        let cell = tableView.dequeueReusableCellWithIdentifier("todayCell", forIndexPath: indexPath) as! TodaysWorkoutExerciseCell
        
        print("selected cell is: " + cell.nameLabel.text!)
        
        if (!cell.complete) {
            //cell has already been rated
            print("creating alert controller")
            self.alertController = UIAlertController(title: "Rate this workout", message: "Was this workout easy, medium, or hard? We'll plan your next workout based on your feedback.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let buttonOne = UIAlertAction(title: "Easy", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                print("Button One Pressed")
                cell.backgroundColor = UIColor.greenColor()
                cell.complete = true
                //TODO
                //update parse with new sets/reps/weight based on the easy setting
                tableView.reloadData()
            })
            let buttonTwo = UIAlertAction(title: "Medium", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                print("Button Two Pressed")
                cell.backgroundColor = UIColor.yellowColor()
                cell.complete = true
                //TODO
                //update parse with new sets/reps/weight based on the med setting
                tableView.reloadData()
            })
            let buttonThree = UIAlertAction(title: "Hard", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                print("Button Three Pressed")
                cell.backgroundColor = UIColor.redColor()
                cell.complete = true
                //TODO
                //update parse with new sets/reps/weight based on the hard setting
                tableView.reloadData()
            })
            let buttonCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
                print("Cancel Button Pressed")
            }
            print("adding buttons")
            self.alertController!.addAction(buttonOne)
            self.alertController!.addAction(buttonTwo)
            self.alertController!.addAction(buttonThree)
            self.alertController!.addAction(buttonCancel)
            print("presenting popover")
            presentViewController(self.alertController!, animated: true, completion: nil)
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
