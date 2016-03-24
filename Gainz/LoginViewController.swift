//
//  LoginViewController.swift
//  Gainz
//
//  Created by Siena McFetridge on 3/14/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
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
    
    
    @IBAction func loginButton(sender: AnyObject) {
        let username = userNameField.text
        let password = passwordField.text
        var alertController = UIAlertController()
        
        if (username?.characters.count == 0) {
            alertController = UIAlertController(title: "Enter a username", message: "Please enter a username", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
                print("Ok Button Pressed 1");
            }
            alertController.addAction(okAction)
            
            self.presentViewController(alertController, animated: true, completion:nil)
            print("username not entered")
        } else if (password?.characters.count == 0) {
            alertController = UIAlertController(title: "Enter a password", message: "Please enter a password", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
                print("Ok Button Pressed 1");
            }
            alertController.addAction(okAction)
            
            self.presentViewController(alertController, animated: true, completion:nil)
            print("password not entered")

        } else {
            PFUser.logInWithUsernameInBackground(username!, password:password!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("tabController") as! UITabBarController
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })
                } else {
                    print("login failed, error: " + String(error!.code))
                    if error!.code == 101 {
                        alertController = UIAlertController(title: "Invalid Username or Password", message: "Please try again", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
                            print("Ok Button Pressed 1");
                        }
                        alertController.addAction(okAction)
                        
                        self.presentViewController(alertController, animated: true, completion:nil)
                        print("username does not exist")                }
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
