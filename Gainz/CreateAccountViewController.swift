//
//  CreateAccountViewController.swift
//  Gainz
//
//  Created by Alison on 3/16/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Parse

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField1: UITextField!
    @IBOutlet weak var passwordField2: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createAccountButton(sender: AnyObject) {
        let username = usernameField.text
        let password1 = passwordField1.text
        let password2 = passwordField2.text
        var alertController = UIAlertController()
        
        if (password1?.characters.count != password2?.characters.count) {
            //TODO passwords dont match
        } else if (username?.characters.count < 5) {
            //TODO
        } else if (password1?.characters.count < 5) {
            //TODO
        } else {
            let user = PFUser()
            user.username = username
            user.password = password1
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    print(error)
                    if error.code == 202 {
                        alertController = UIAlertController(title: "Username already taken", message: "Please select a new username", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
                            print("Ok Button Pressed 1");
                        }
                        alertController.addAction(okAction)
    
                        self.presentViewController(alertController, animated: true, completion:nil)
                        print("Username taken. Please select another")
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("modifyWorkouts") as! UITableViewController
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })
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
