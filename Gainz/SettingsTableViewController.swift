//
//  SettingsTableViewController.swift
//  Gainz
//
//  Created by Alison on 3/19/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Parse

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "colorful_background.jpg"))
        self.tableView.rowHeight = 50.0
        self.tableView.separatorColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        
        if (indexPath.row == 0) { //CHANGE PASSWORD
            cell = tableView.dequeueReusableCellWithIdentifier("changePasswordCell", forIndexPath: indexPath)
        } else if (indexPath.row == 1) { //LOG OUT
            cell = tableView.dequeueReusableCellWithIdentifier("logOutCell", forIndexPath: indexPath)
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        }
        
        cell.backgroundColor = UIColor(white: 1.0, alpha: 0.35)
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 1) { //LOG OUT
            PFUser.logOut()
            print("Logging out!")
        }
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
