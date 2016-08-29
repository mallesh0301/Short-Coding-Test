//
//  UserInterfaceViewController.swift
//  ShortCodeTest
//
//  Created by mallesh on 8/29/16.
//  Copyright © 2016 mallesh. All rights reserved.
//

import UIKit

class UserInterfaceViewController: UIViewController {

    @IBOutlet weak var inputField: UITextField!
    
    var input:Int? = Int()
    
    @IBAction func showResults(sender: AnyObject) {
        
        guard let text = self.inputField.text where !text.isEmpty else {
            let alert = UIAlertController(title: "Invalid Data", message: "Please enter a number from 1 to 1000", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        input = Int(self.inputField.text!)
        
        if input > 1000 {
            let alert = UIAlertController(title: "Invalid Data", message: "Please enter a value less than 1000", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            self.performSegueWithIdentifier("SHOW_TABLE", sender: sender)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "SHOW_TABLE") {
            let getData: ViewController = segue.destinationViewController as! ViewController
            getData.num = input!
        }
    }
    
}