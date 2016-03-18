//
//  ModifyWorkoutsViewController.swift
//  Gainz
//
//  Created by Alison on 3/16/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ModifyWorkoutsViewController: PFQueryTableViewController{

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    var currentWorkout:PFObject?
    
    
    override func queryForTable() -> PFQuery {
        print ("query")
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
        let cell = tableView.dequeueReusableCellWithIdentifier("modifyCell", forIndexPath: indexPath) as! ModifyWorkoutExerciseViewCell
        
        object?.pinInBackgroundWithName("localExercises")
        print ("cellforrow")
        print (object)
        
        setTextField(cell.setsField, key: "sets", object: object)
        setTextField(cell.repsField, key: "reps", object: object)
        setTextField(cell.weightField, key: "weight", object: object)
        cell.nameField.text = object?.objectForKey("name") as? String
        cell.exercise = object
        
        return cell
    }
    
    func setTextField (textField: UITextField, key: String, object: PFObject?) {
        if let sets = (object?.objectForKey(key) as? Int) {
            textField.text = String(sets)
            print (sets)
        } else {
            textField.text = ""
        }
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            print ("deleteExercise")
            let object = objectAtIndexPath(indexPath)
            object?.unpinInBackground()
            object?.deleteInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if (success) {
                    print ("successful Delete")
                    self.loadObjects()
                    self.tableView.reloadData()
                }
                else {
                    print ("it failed")
                }
            }
        }
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        for (var row = 0; row < tableView.numberOfRowsInSection(0); row++) {
//            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as! ModifyWorkoutExerciseViewCell
//            if (!cell.completed()) {
//                let alertController = UIAlertController(title: "Invalid Workout data", message: "Please make sure every field is properly filled out", preferredStyle: UIAlertControllerStyle.Alert)
//                
//                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
//                    print("Ok Button Pressed 1");
//                }
//                alertController.addAction(okAction)
//                
//                self.presentViewController(alertController, animated: true, completion:nil)
//            }
//        }
//    }
    
    @IBAction func addExerciseAction(sender: AnyObject) {
        //print (String(currentWorkout))
        print ("addExercise")
        let exercise = PFObject(className: "Exercise")
        exercise["workout"] = currentWorkout
        exercise.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                print ("successful save")
                self.loadObjects()
                self.tableView.reloadData()
            } else {
                print ("it failed")
            }
        }
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
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
