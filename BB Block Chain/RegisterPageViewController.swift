//
//  RegisterPageViewController.swift
//  BB Block Chain
//
//  Created by Nwamaka Nzeocha on 9/28/15.
//  Copyright © 2015 Nwamaka Nzeocha. All rights reserved.
//

import UIKit
import Parse

class RegisterPageViewController: UIViewController {
    
    @IBOutlet weak var userFirstNameTextField: UITextField!
    @IBOutlet weak var userLastNameTextField: UITextField!
    @IBOutlet weak var userAccountNumberTextField: UITextField!
    @IBOutlet weak var userUsernameTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //hide keyboard when not typing
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    @IBAction func registerButtonTapped(sender: AnyObject) {
        let userFirstName = userFirstNameTextField.text
        let userLastName = userLastNameTextField.text
        let userAccountNumber = userAccountNumberTextField.text
        let userUsername = userUsernameTextField.text
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        let userRepeatPassword = repeatPasswordTextField.text
        
        // Check for empty fields .(!) is unwrap operator to force out value
        if (userFirstName!.isEmpty || userLastName!.isEmpty || userAccountNumber!.isEmpty || userUsername!.isEmpty || userEmail!.isEmpty || userPassword!.isEmpty || userRepeatPassword!.isEmpty){
            
            // Display alert message
            displayMyAlertMessage("All fields are required")
            return
        } else if (userPassword != userRepeatPassword){ // Check if passwords match
            // Display an alert message
            displayMyAlertMessage("Passwords do not match")
            return
        } else {
            // Run a spinner to show a task in progress
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            /***********************************
             USER AUTHENTICATION W/ PARSE DB
            ************************************/
            let newUser = PFUser()
            
            newUser["firstname"] = userFirstName
            newUser["lastname"] = userLastName
            newUser["account_number"] = userAccountNumber
            newUser["bank_name"] = "Bank of America"
            newUser.username = userUsername
            newUser.password = userPassword
            newUser.email = userEmail
            newUser["mobile_phone"] = "8325418199"
            newUser["balance"] = 30000.00
            
            // sign up the user asynchronously
            newUser.signUpInBackgroundWithBlock ({
                (success: Bool, error: NSError?) -> Void in
                
                // stop the spinner
                spinner.stopAnimating()
                if (success) {
                    // The object has been saved.
                    
                    // Store data
                    NSUserDefaults.standardUserDefaults().setObject(userFirstName, forKey: "userFirstName")
                    NSUserDefaults.standardUserDefaults().setObject(userLastName, forKey: "userLastName")
                    NSUserDefaults.standardUserDefaults().setObject(userAccountNumber, forKey: "userAccountNumber")
                    NSUserDefaults.standardUserDefaults().setObject(userUsername, forKey: "userUsername")
                    NSUserDefaults.standardUserDefaults().setObject(userEmail, forKey: "userEmail")
                    NSUserDefaults.standardUserDefaults().setObject(userPassword, forKey: "userPassword")
                    NSUserDefaults.standardUserDefaults().setObject("Bank of America", forKey: "userBankName")
                    NSUserDefaults.standardUserDefaults().setObject("8325418199", forKey: "userMobilePhone")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    // Display alert message with confirmation.
                    let myAlert = UIAlertController(title:"Registration successful.", message:"Thank you!", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    // Dismiss when OK button is pressed
                    let okAction = UIAlertAction(title: "Ok", style:UIAlertActionStyle.Default){
                        action in self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    
                    // go back to viewController screen
                    myAlert.addAction(okAction);
                    self.presentViewController(myAlert, animated: true, completion: nil)
                } else {
                    // There was a problem, check error.description
                }
            })
        }
    }
    
    
    func displayMyAlertMessage(userMessage: String){
        let myAlert = UIAlertController(title:"WAIT, NO", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        myAlert.addAction(okAction)
        
        presentViewController(myAlert, animated: true, completion: nil)
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
