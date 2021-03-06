//
//  ConfirmViewController.swift
//  BB Block Chain
//
//  Created by Nwamaka Nzeocha on 10/6/15.
//  Copyright © 2015 Nwamaka Nzeocha. All rights reserved.
//

import UIKit
import SCLAlertView
import Parse
import Alamofire

class ConfirmViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var showInfoTableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        showInfoTableView.dataSource = self
        cancelButton.layer.borderColor = UIColor(red:188/255.0, green:179/255.0, blue:165/255.0, alpha: 1.0).CGColor
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        // check if user first name, last name, and bank info match the stored info
        let receiverfirstName = NSUserDefaults.standardUserDefaults().stringForKey("receiverFirstName");
        let receiverLastName = NSUserDefaults.standardUserDefaults().stringForKey("receiverLastName");
        let sendAmount = NSUserDefaults.standardUserDefaults().stringForKey("dollarAmount")
        let receiverBankName = NSUserDefaults.standardUserDefaults().stringForKey("receiverBankName");
        let receiverAccountNumber = NSUserDefaults.standardUserDefaults().stringForKey("receiverAccountNumber");
        let receiverMobileNumber = NSUserDefaults.standardUserDefaults().stringForKey("receiverMobileNumber");
        
        let myCell:UITableViewCell = showInfoTableView.dequeueReusableCellWithIdentifier("nwammysCell", forIndexPath: indexPath)
        
        switch (indexPath.row) {
        case 0:
            myCell.textLabel?.text = "First Name"
            myCell.detailTextLabel?.text = receiverfirstName
        case 1:
            myCell.textLabel?.text = "Last Name"
            myCell.detailTextLabel?.text = receiverLastName
        case 2:
            myCell.textLabel?.text = "Amount"
            myCell.detailTextLabel?.text = "$" + sendAmount!
        case 3:
            myCell.textLabel?.text = "Bank Name"
            myCell.detailTextLabel?.text = receiverBankName
        case 4:
            myCell.textLabel?.text = "Account Name"
            myCell.detailTextLabel?.text = receiverAccountNumber
        case 5:
            myCell.textLabel?.text = "Mobile Number"
            myCell.detailTextLabel?.text = receiverMobileNumber
        default:
            break
        }
        return myCell
    }


    @IBAction func sendButtonPressed(sender: AnyObject) {
        let user = PFUser.currentUser()
        let userUsername = user!.objectForKey("username")!
        let receiverfirstName = NSUserDefaults.standardUserDefaults().stringForKey("receiverFirstName")
        let receiverLastName = NSUserDefaults.standardUserDefaults().stringForKey("receiverLastName");
        let sendAmount = NSUserDefaults.standardUserDefaults().stringForKey("dollarAmount")
        let receiverBankName = NSUserDefaults.standardUserDefaults().stringForKey("receiverBankName")
        let receiverAccountNumber = NSUserDefaults.standardUserDefaults().stringForKey("receiverAccountNumber")
        let receiverMobileNumber = NSUserDefaults.standardUserDefaults().stringForKey("receiverMobileNumber")
    
        let amount: Float = (sendAmount! as NSString).floatValue

        //send Transaction data to Parse Database
        let Transactions = PFObject(className:"Transactions")
        
        //sender username
        Transactions["username"] = userUsername
        // receiver info
        Transactions["receiver_first_name"] = receiverfirstName
        Transactions["receiver_last_name"] = receiverLastName
        Transactions["amount"] = amount
        Transactions["receiver_bank_name"] = receiverBankName
        Transactions["receiver_account_number"] = receiverAccountNumber
        Transactions["receiver_mobile_number"] = receiverMobileNumber
        
        Transactions.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                
                // fancy alert button
                let alert = SCLAlertView()
                alert.showCloseButton = false
                alert.addButton("Okay") {
                    self.performSegueWithIdentifier("segueA", sender: nil)
                }
                alert.showSuccess(
                    "Congratulations",
                    subTitle: "$" + sendAmount! + " sent to " + receiverfirstName! + " " + receiverLastName!,
                    colorStyle: 0x43CAA7,
                    colorTextButton: 0xFFFFFF)
                
                // TWILIO text message notifications
                let user = PFUser.currentUser()
                print ("PHONE", "+1" + String(user!.objectForKey("mobile_phone")!))
                print ("SENDER NAME", user!.objectForKey("firstname")!)
                
                let messageDetails: [String: String] = [
                    "receiverfirstName": receiverfirstName!,
                    "sendAmount": sendAmount!,
                    "senderFirstName": user!.objectForKey("firstname")! as! String,
                    "senderLastName": user!.objectForKey("lastname")! as! String,
                    "receiverPhoneC": "+1" + String(receiverMobileNumber!)
                ]
                
                // call twilio js function from15 main.js
                PFCloud.callFunctionInBackground("twilio", withParameters: messageDetails) { (result: AnyObject?, error: NSError?) in
                    let getBack = result as? NSObject
                    print(getBack)
                }
            } else {
                // There was a problem, check error.description
            }
            
            // prep addresses for blockchain
            let roberts = "1YKM2c3PWFGXK5pU7msNViFKnELgEnvDT5ahsA"
            let nwams = "1MzkirbCMSaiTmm3z8XWAt4v8gGK3NrgLPkpY7"
            let murata = "118K6VND8V9fFqCnjbN1xKuk9b4TJbaqppYxLa"
            let jsp = "1Ykjusd1gjVb8qsHzMN1gyYbHo"
            
            let AMOUNTVALUE = sendAmount!
            let SENDERADDRESS = "1MzkirbCMSaiTmm3z8XWAt4v8gGK3NrgLPkpY7"
            let RECIPIENTADRESS = "118K6VND8V9fFqCnjbN1xKuk9b4TJbaqppYxLa"
            
            
            // Send to blockchain
            // Make HTTP request
            
            
            let url = String("http://52.23.215.189:8000/?amt="+AMOUNTVALUE+"&sname="+SENDERADDRESS+"&rname="+RECIPIENTADRESS+"")
            print ("URL=", url)
            Alamofire.request(.GET, url)
            
            }
    }

    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    func getData(theArray: [String]) -> [String] {
    let nwammysArray = theArray
    return nwammysArray
    }
    */
    
    /*
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier")
        if(cell == nil){
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "reuseIdentifier")
        }

        cell?.textLabel?.text = "goat"
        return cell!
    }
    */

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
