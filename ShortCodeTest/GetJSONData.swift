//
//  GetJSONData.swift
//  ShortCodeTest
//
//  Created by mallesh on 8/29/16.
//  Copyright © 2016 mallesh. All rights reserved.
//

import Foundation
import CoreData

class GetJSONData: NSObject {

    func readJSONData(appdel : AppDelegate, num : Int) {
        
        let numberOfRecords : String! = String(num)
        
        // Store the json URL
        let url = NSURL(string: "http://www.filltext.com/?rows=" + numberOfRecords + "&fname=%7BfirstName%7D&lname=%7BlastName%7D&city=%7Bcity%7D&pretty=true")!
        
        // Access the url using the NSURLSession
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            if error != nil {
                print("there is some problem with data\n")
            }
            else {
                if let urlContent = data {
                    do {
                        // getting the data from the url fjg
                        let jsonArr = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                        
                        // if the url is not empty
                        if jsonArr.count > 0 {
                            for i in 0..<jsonArr.count {
                        
                                // get the array data into the dictionaries
                                if let jsonDic = jsonArr.objectAtIndex(i) as? NSDictionary {
                                    
                                    // check if json is empty
                                    guard   let fname = jsonDic["fname"],
                                        let lname = jsonDic["lname"],
                                        let city = jsonDic["city"]
                                        else {
                                            print("json data is empty!")
                                            return
                                    }
                                    
                                    // create an entity object to store the data into tables
                                    let newPost = NSEntityDescription.insertNewObjectForEntityForName("Details", inManagedObjectContext: appdel.managedObjectContext)
                                    
                                    // add the values to the attributes
                                    
                                    newPost.setValue(fname, forKey: "fname")
                                    newPost.setValue(lname, forKey: "lname")
                                    newPost.setValue(city, forKey: "city")
                                }
                            }
                        }
                    }
                    catch {}
                }
            }
        }
        
        // perform the NSURLSession task
        task.resume()
    }
    
}