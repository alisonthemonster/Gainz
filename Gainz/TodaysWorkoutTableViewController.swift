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

    override func queryForTable() -> PFQuery {
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
        
        setTextField(cell.setsField, key: "sets", object: object)
        setTextField(cell.repsField, key: "reps", object: object)
        setTextField(cell.weightField, key: "weight", object: object)
        cell.nameLabel.text = object?.objectForKey("name") as? String
        cell.exercise = object
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var alertController = UIAlertController()
        
        let cell = tableView.dequeueReusableCellWithIdentifier("todayCell", forIndexPath: indexPath) as! TodaysWorkoutExerciseCell
        alertController = UIAlertController(title: "Alert Controller", message: "Alert Controller with multiple buttons", preferredStyle: UIAlertControllerStyle.Alert)
        
        let buttonOne = UIAlertAction(title: "Easy", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            print("Button One Pressed")
            cell.backgroundColor = UIColor.greenColor()
            tableView.reloadData()
        })
        let buttonTwo = UIAlertAction(title: "Medium", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            print("Button Two Pressed")
            cell.backgroundColor = UIColor.yellowColor()
            tableView.reloadData()
        })
        let buttonThree = UIAlertAction(title: "Hard", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            print("Button Three Pressed")
            cell.backgroundColor = UIColor.redColor()
            tableView.reloadData()
        })
        let buttonCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            print("Cancel Button Pressed")
        }
        
        alertController.addAction(buttonOne)
        alertController.addAction(buttonTwo)
        alertController.addAction(buttonThree)
        alertController.addAction(buttonCancel)
        
        presentViewController(alertController, animated: true, completion: nil)

        
        
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
