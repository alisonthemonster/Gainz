//
//  HistoryTableViewController.swift
//  Gainz
//
//  Created by Siena McFetridge on 4/14/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    var workout: Workout!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initWithWorkout(workout: Workout) {
        self.workout = workout
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return workout.exercises!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("exerciseCell", forIndexPath: indexPath) as! TodaysWorkoutExerciseCell
        print ("CellforRow")
        cell.nameLabel.text = "TESTING"
        print (cell.nameLabel.text)
        return cell
    }

}
