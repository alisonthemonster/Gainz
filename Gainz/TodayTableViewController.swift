//
//  TodayTableViewController.swift
//  Gainz
//
//  Created by Siena McFetridge on 3/18/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class TodayTableViewController: UITableViewController {
    
    var alertController:UIAlertController? = nil
    var currentWorkout:PFObject?
    var todaysExercises = [PFObject]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tabBarItem = UITabBarItem(title: "Today", image: UIImage(named: "weight"), tag: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = PFUser.currentUser()!.username! + "'s Workout"
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "colorful_background.jpg"))
        self.tableView.rowHeight = 50.0
        self.tableView.separatorColor = UIColor.clearColor()
        let nib = UINib(nibName: "ExerciseTableCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "exerciseCell")
    }
    
    @IBAction func doneButton(sender: AnyObject) {
        
        var completed:Bool = false
        for (var row = 0; row < tableView.numberOfRowsInSection(0); row++) {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as! ExerciseTableViewCell
            if cell.rating != -1 {
                completed = true
                break
            }
            
        }
        
        if (!completed) {
            let alertController = UIAlertController(title: "No Completed Exercises", message: "Tap an exercise to rate it and mark it as completed. You cannot complete a workout unless you have completed at least one of your exercises!", preferredStyle: UIAlertControllerStyle.Alert)
                
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
                print("Ok Button Pressed 1");
            }
            alertController.addAction(okAction)
                
            self.presentViewController(alertController, animated: true, completion:nil)
        }
        
        else {
            self.alertController = UIAlertController(title: "All done?", message: "Are you sure you're finished? Once you press okay we'll generate your next workout for you and this workout can be found in your history. \n \nNote: Unrated exercises will not be saved in your History.", preferredStyle: UIAlertControllerStyle.Alert)
            let done = UIAlertAction(title: "Done!", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                print("Button One Pressed")
                self.createNewWorkout()
            })
            let buttonCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
                print("Cancel Button Pressed")
            }
            self.alertController!.addAction(done)
            self.alertController!.addAction(buttonCancel)
        
            presentViewController(self.alertController!, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //get the unsaved workout (today's workout)
        let innerQuery = PFQuery(className: "Workout")
        innerQuery.whereKey("saved", equalTo: false)
        innerQuery.whereKey("user", equalTo: PFUser.currentUser()!)

        //get the exercises that are in today's workout
        let query = PFQuery(className: "Exercise")
        query.whereKey("workout", matchesQuery: innerQuery)
        innerQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if (error != nil) {
                print (error)
                print("a workout for today was not found")
               
            } else {
                //this is today's workout
                self.currentWorkout = objects![0]
                print("we found the most recent non-finished workout!")
            }
            print("inside the block!")
        }
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if (error != nil) {
                print (error)
                //there are no exercises for today's workout
                print("we found no exercises for todays workout")
            } else {
                //the objects array has today's exercises
                self.todaysExercises = objects!
                print("we found todays exercises!")
                print("there are " + String(self.todaysExercises.count) + " exercises for today")
                if (self.todaysExercises.count == 0) {
                    //an unsaved workout hasn't been created for today
                    //TODO create new workout here!
                        //use old data to build new exercise objects
                        //if there is no old data then show message for first time users to direct them to modify screen
                    self.createEmptyStateView()
                }
                else {
                    self.tableView.backgroundView = UIImageView(image: UIImage(named: "colorful_background.jpg"))
                }
                print("reloading data")
                self.tableView.reloadData()
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createEmptyStateView() {
        let frame = self.view.frame
        let view = UIView(frame: frame)
        let imageView = UIImageView(image: UIImage(named: "colorful_background.jpg"))
        let label = UILabel(frame: frame)
        label.backgroundColor = UIColor(white: 1.0, alpha: 0.35)
        
        label.text = "You haven't created a workout yet!\n\nGo to Edit to make your first routine"
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.Center
        view.addSubview(label)
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        let horizontalConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraint)
        self.tableView.backgroundView = view
    }
    
    //builds the new workout based on the current workout and updates table
    func createNewWorkout() {
        print("building new workout")
        //save current workout
        currentWorkout!["saved"] = true
        currentWorkout?.saveInBackground()
        
        //build new workout
        let newWorkout = PFObject(className: "Workout")
        newWorkout["saved"] = false
        newWorkout["user"] = PFUser.currentUser()
        
        var totalWeight = 0
        var totalReps = 0
        var todaysExercises = 0
        
        var newExercises = [PFObject]()
        //build each new exercise based of off the last ones
        for exercise in self.todaysExercises {
            let newExercise = PFObject(className: "Exercise")
            let rating = (exercise.objectForKey("rating") as? Int)
            let reps = (exercise.objectForKey("reps") as? Int)
            let weight = (exercise.objectForKey("weight") as? Int)
            let sets = (exercise.objectForKey("sets") as? Int)
            

            if (rating == 0) { //if last workout was too easy
                newExercise["reps"] = reps! + 5
                newExercise["weight"] = weight! + 5
                newExercise["sets"] = sets! + 5
                totalWeight += weight!*reps!
                totalReps += sets!*reps!
                todaysExercises++
            } else if (rating == 2) { //if last workout was too hard
                newExercise["reps"] = reps! - 5
                newExercise["weight"] = weight! - 5
                newExercise["sets"] = sets! - 5
                if (reps! - 5 < 0) {
                    newExercise["reps"] = 0
                }
                if (sets! - 5 < 0) {
                    newExercise["sets"] = 0
                }
                if (weight! - 5 < 0) {
                    newExercise["weight"] = 0
                }
                totalWeight += weight!*reps!
                totalReps += sets!*reps!
                todaysExercises++
            } else if (rating == 1) { //if last workout was juuust right
                newExercise["reps"] = reps!
                newExercise["weight"] = weight!
                newExercise["sets"] = sets!
                totalWeight += weight!*reps!
                totalReps += sets!*reps!
                todaysExercises++
            } else {
                newExercise["reps"] = reps!
                newExercise["weight"] = weight!
                newExercise["sets"] = sets!
            }
            newExercise["name"] = exercise.objectForKey("name") as? String
            newExercise["workout"] = newWorkout
            newExercise.saveInBackground()
            newExercises.append(newExercise)
        }
        
        //udpate the user object with the new total weights and sets
        let query : PFQuery = PFUser.query()!
        query.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!) {
            (object, error) -> Void in
            if error != nil {
                print(error)
            } else {
                if let object = object {
                    print("updating user")
                    let prevWeightTotal = object.objectForKey("totalWeight") as? Int
                    object["totalWeight"] = prevWeightTotal! + totalWeight
                    let prevRepsTotal = object.objectForKey("totalReps") as? Int
                    object["totalReps"] = prevRepsTotal! + totalReps
                    let prevExercisesTotal = object.objectForKey("totalExercises") as? Int
                    object["totalExercises"] = prevExercisesTotal! + todaysExercises
                    object.saveInBackground()
                }
            }
        }
        
        //buid the exercises based on the current exercises ratings
        newWorkout.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                //set the new workout as the currentWorkout
                self.currentWorkout = newWorkout
                self.todaysExercises = newExercises
                //reload
                self.tableView.reloadData()
                
            } else {
                print(error)
            }
        }
        checkForNewEarnedBadges()
    }
    
    func checkForNewEarnedBadges() {
        print("checking for new earned badges")
        let query : PFQuery = PFUser.query()!
        var totalWeight = 0
        var totalReps = 0
        var totalExercises = 0
        var badgeValues:[Bool] = [false, false, false, false, false, false, false, false, false, false, false, false, false, false]
        query.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!) {
            (object, error) -> Void in
            if error != nil {
                print(error)
            } else {
                if let object = object {
                    print("updating user")
                    totalWeight = (object.objectForKey("totalWeight") as? Int)!
                    totalReps = (object.objectForKey("totalReps") as? Int)!
                    totalExercises = (object.objectForKey("totalExercises") as? Int)!
                    let oldBadgeValues = (object.objectForKey("badges") as? [Bool])!
                    badgeValues = self.checkBadgeValues(totalReps, totalWeight: totalWeight, totalExercises: totalExercises)
                    if (badgeValues != oldBadgeValues) {
                        print("congrats on the new badge")
                        let alertMessage = UIAlertController(title: "Congratulations!", message: "You just unlocked a new badge!", preferredStyle: .Alert)
                        
                        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertMessage .addAction(action)
                        
                        self.presentViewController(alertMessage, animated: true, completion: nil)
                    }
                    
                    //update parse with these new badge values
                    let query2 : PFQuery = PFUser.query()!
                    query2.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!) {
                        (object, error) -> Void in
                        if error != nil {
                            print(error)
                        } else {
                            if let object = object {
                                object["badges"] = badgeValues
                                print("updating database with new badges")
                                object.saveInBackground()
                            }
                        }
                    }
                }
            }
        }

    }
    
    //checks to see which badges have been unlocked
    func checkBadgeValues(totalReps:Int, totalWeight:Int, totalExercises:Int) -> [Bool] {
        print("checking values")
        var badgeValues:[Bool] = [false, false, false, false, false, false, false, false, false, false, false, false, false, false]
        
        print(String(totalReps))
        if (totalReps>=500) {
            badgeValues[2] = true
        }
        if (totalReps>=100) {
            badgeValues[1] = true
        }
        if (totalReps>=50) {
            badgeValues[0] = true
        }
        if (totalWeight>=400) {
            badgeValues[3] = true
        }
        if (totalWeight>=13000) {
            badgeValues[4] = true
        }
        if (totalWeight>=18000) {
            badgeValues[5] = true
        }
        if (totalWeight>=420000) {
            badgeValues[6] = true
        }
        if (totalExercises>=10) {
            badgeValues[7] = true
        }
        if (totalExercises>=25) {
            badgeValues[8] = true
        }
        if (totalExercises>=50) {
            badgeValues[9] = true
        }
        if (totalExercises>=100) {
            badgeValues[1] = true
        }
        //TODO handle the days in a row badge
        
        return badgeValues
    }
    
    //resizes an image
    func imageResize(imageObj:UIImage, sizeChange:CGSize)-> UIImage {
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, false, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext() // !!!
        return scaledImage
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todaysExercises.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("exerciseCell", forIndexPath: indexPath) as! ExerciseTableViewCell
        
        let object = self.todaysExercises[indexPath.row]
        cell.object = object

        if let sets = (object.objectForKey("sets") as? Int) {
            cell.sets.text = String(sets)
        } else {
            cell.sets.text = ""
        }
        if let reps = (object.objectForKey("reps") as? Int) {
            cell.reps.text = String(reps)
        } else {
            cell.reps.text = ""
        }
        if let weight = (object.objectForKey("weight") as? Int) {
            cell.weight.text = String(weight)
        } else {
            cell.weight.text = ""
        }
        cell.nameLabel.text = object.objectForKey("name") as? String
        cell.exercise = object
        cell.contentView.backgroundColor = UIColor.clearColor()
        
        
        if let rating = (object.objectForKey("rating") as? Int) {
            if (rating == 0) {
                cell.rating = 0
                cell.checkMark.image = UIImage(named: "green")
            } else if (rating == 1) {
                cell.rating = 1
                cell.checkMark.image = UIImage(named: "orange")
            } else if (rating == 2) {
                cell.rating = 2
                cell.checkMark.image = UIImage(named: "red")
            }
            cell.backgroundColor = UIColor(white: 1.0, alpha: 0.35)
        } else {
            //dont show the checkmark
            cell.checkMark.image = UIImage()
            cell.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(String(indexPath.row))
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! ExerciseTableViewCell
        print("selected cell is: " + cell.nameLabel.text!)
        
        let exercise = self.todaysExercises[indexPath.row]
        let exerciseName = exercise.objectForKey("name") as? String
        print("the parse object is: " + exerciseName!)
        
        
        print("creating alert controller")
        self.alertController = UIAlertController(title: "Rate this workout", message: "Was this workout easy, medium, or hard? We'll plan your next workout based on your feedback.", preferredStyle: UIAlertControllerStyle.Alert)
        
        if let rating = (exercise.objectForKey("rating") as? Int) {
            if (rating==0 || rating==1 || rating==2) {
                print("already rated!")
                self.alertController?.title = "Re-Rate this workout"
                self.alertController?.message = "NOTICE: you already rated this workout, you will be overwriting your previous rating."
            }
        }
        
        let buttonOne = UIAlertAction(title: "Easy", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            print("Button One Pressed")
            print("changing this cell's color: " + cell.nameLabel.text!)
            cell.rating = 0
            
            //update the rating in parse!
            let query = PFQuery(className:"Exercise")
            query.getObjectInBackgroundWithId(exercise.objectId!) {
                (object, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    if let object = object {
                        object["rating"] = 0
                        object.saveInBackground()
                        tableView.reloadData()
                    }
                }
            }
        })
        let buttonTwo = UIAlertAction(title: "Medium", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            print("Button Two Pressed")
            print("changing this cell's color: " + cell.nameLabel.text!)
            
            //update the rating in parse!
            let query = PFQuery(className:"Exercise")
            query.getObjectInBackgroundWithId(exercise.objectId!) {
                (object, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    if let object = object {
                        object["rating"] = 1
                        object.saveInBackground()
                        tableView.reloadData()
                    }
                }
            }
        })
        let buttonThree = UIAlertAction(title: "Hard", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            print("Button Three Pressed")
            print("changing this cell's color: " + cell.nameLabel.text!)
            
            //update the rating in parse!
            let query = PFQuery(className:"Exercise")
            query.getObjectInBackgroundWithId(exercise.objectId!) {
                (object, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    if let object = object {
                        object["rating"] = 2
                        object.saveInBackground()
                        tableView.reloadData()
                    }
                }
            }
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
