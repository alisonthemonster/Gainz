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

        let backgroundImage = UIImage(named: "barbells.jpg")
        var imageView: UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = backgroundImage
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
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
            alertController = UIAlertController(title: "Passwords dont match!", message: "Please try again", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
                print("Ok Button Pressed 1");
            }
            alertController.addAction(okAction)
            
            self.presentViewController(alertController, animated: true, completion:nil)
            print("passwords dont match") 

        } else if (username?.characters.count < 5) {
            alertController = UIAlertController(title: "Username is too short", message: "Usernames must be longer than 5 characters", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
                print("Ok Button Pressed 1");
            }
            alertController.addAction(okAction)
            
            self.presentViewController(alertController, animated: true, completion:nil)
            print("username too short")
        } else if (password1?.characters.count < 5) {
            alertController = UIAlertController(title: "Password is too short", message: "Password must be longer than 5 characters", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
                print("Ok Button Pressed 1");
            }
            alertController.addAction(okAction)
            
            self.presentViewController(alertController, animated: true, completion:nil)
            print("password too short")
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
                        
                        //TODO create first workout object here
                        let workout = PFObject(className: "Workout")
                        workout["saved"] = false
                        workout["user"] = user
                        workout.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("tabController") as! UITabBarController
                                self.presentViewController(viewController, animated: true, completion: nil)

                            } else {
                                print(error)
                            }
                        }
                        
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
