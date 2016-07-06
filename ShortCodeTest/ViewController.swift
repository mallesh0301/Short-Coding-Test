//
//  ViewController.swift
//  ShortCodeTest
//
//  Created by mallesh on 7/5/16.
//  Copyright © 2016 mallesh. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // Outlet for the tableview
    @IBOutlet weak var tableView: UITableView!
    
    // AppDelegate class object
    let appdel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Store the json URL
        let url = NSURL(string: "http://www.filltext.com/?rows=100&fname=%7BfirstName%7D&lname=%7BlastName%7D&city=%7Bcity%7D&pretty=true")!
        
        // Access the url using the NSURLSession
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            if error != nil {
                print("there is some problem with data\n")
            }
            else {
                if let urlContent = data {
                    do {
                        // getting the data from the url
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
                                    let newPost = NSEntityDescription.insertNewObjectForEntityForName("Details", inManagedObjectContext: self.appdel.managedObjectContext)
                                    
                                    // add the values to the attributes
                                    
                                    print("fname \(fname)")
                                    print("lname \(lname)")
                                    print("city \(city)")
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // declare the number rows for the tableview
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.fetchedResultsController.sections![section]).numberOfObjects
    }
    
    // update each row with the data
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Use the existing cell to update the tableview (if the tableview is scrolled)
        let cell = tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath: indexPath)
        
        // fetch the data from the table
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
        
        // add the details to the cell
        self.configureCell(cell, withObject: object)
        
        // return the cell object
        return cell
    }
    
    // Add the details to the labels in the row
    func configureCell(cell: UITableViewCell, withObject object: NSManagedObject) {
        
        cell.textLabel!.text = object.valueForKey("fname")!.description
        cell.textLabel!.text?.appendContentsOf(" ")
        cell.textLabel!.text?.appendContentsOf(object.valueForKey("lname")!.description)
        cell.detailTextLabel!.text = object.valueForKey("city")!.description
    }
    
    // MARK: - Fetched results controller
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        
        // create an entity object for the table
        let entity = NSEntityDescription.entityForName("Details", inManagedObjectContext: self.appdel.managedObjectContext)
        fetchRequest.entity = entity
        
        // Set the batch size.
        fetchRequest.fetchBatchSize = 20
        
        // Sorting the rows in ascending order
        let sortDescriptor = NSSortDescriptor(key: "lname", ascending: true)
        
        // Applying the sort to the request
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.appdel.managedObjectContext, sectionNameKeyPath: nil, cacheName: "ViewController")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            abort()
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, withObject: anObject as! NSManagedObject)
        case .Move:
            tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
}