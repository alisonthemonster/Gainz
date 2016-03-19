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

class TodayTableViewController: UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tabBarItem = UITabBarItem(title: "Today", image: UIImage(named: "weight"), tag: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
