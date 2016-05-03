//
//  AlgorithmViewController.swift
//  Gainz
//
//  Created by Alison on 4/30/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Parse

class AlgorithmViewController: UIViewController {

    
    @IBOutlet weak var easy: UITextField!
    @IBOutlet weak var medium: UITextField!
    @IBOutlet weak var hard: UITextField!
    
    var easyNum = 0
    var mediumNum = 0
    var hardNum = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(image: UIImage(named: "colorful_background.jpg"))
        imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)

        let query : PFQuery = PFUser.query()!
        query.whereKey("username", equalTo: (PFUser.currentUser()?.username)!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                if let objects = objects {
                    let user = objects[0]
                    self.easyNum = user["easy"] as! Int
                    self.easy.text = String(self.easyNum)
                    self.mediumNum = user["medium"] as! Int
                    self.medium.text = String(self.mediumNum)
                    self.hardNum = user["hard"] as! Int
                    self.hard.text = String(self.hardNum)
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func submit(sender: AnyObject) {
        let easyText = easy.text
        let mediumText = medium.text
        let hardText = hard.text
        
        if (easyText!.isEmpty || mediumText!.isEmpty || hardText!.isEmpty) {
            let alertController = UIAlertController(title: "Blank Text Field", message: "Please make sure every field is properly filled out", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
                print("Ok Button Pressed 1");
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion:nil)
        } else {
            var valid = true
            if let easyNum = Int(easyText!) {
                self.easyNum = easyNum
            } else {
                //not valid string
                valid = false
                let alertController = UIAlertController(title: "Invalid Text Field", message: "Please make sure every field is properly filled out", preferredStyle: UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
                    print("Ok Button Pressed 1");
                }
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion:nil)
            }
            if let mediumNum = Int(mediumText!) {
                self.mediumNum = mediumNum
            } else {
                //not valid string                
                valid = false
                let alertController = UIAlertController(title: "Invalid Text Field", message: "Please make sure every field is properly filled out", preferredStyle: UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
                    print("Ok Button Pressed 1");
                }
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion:nil)
            }
            if let hardNum = Int(hardText!) {
                self.hardNum = hardNum
            } else {
                //not valid string
                valid = false
                let alertController = UIAlertController(title: "Invalid Text Field", message: "Please make sure every field is properly filled out", preferredStyle: UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
                    print("Ok Button Pressed 1");
                }
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion:nil)
            }
            if (valid) {
                let query : PFQuery = PFUser.query()!
                query.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!) {
                    (object, error) -> Void in
                    if error != nil {
                        print(error)
                    } else {
                        if let object = object {
                            object["easy"] = self.easyNum
                            object["medium"] = self.mediumNum
                            object["hard"] = self.hardNum
                            print("updating database with new algorithm")
                            object.saveInBackground()
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    }
                }
            }

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
