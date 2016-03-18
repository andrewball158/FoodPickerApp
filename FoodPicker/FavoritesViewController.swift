//
//  SecondViewController.swift
//  FoodPicker
//
//  Created by Andrew Ball on 12/10/15.
//  Copyright © 2015 Andrew Ball. All rights reserved.
//

import UIKit

class FavoritesViewController: UITableViewController {
    
    var savedArray: NSMutableArray = NSMutableArray()
    let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        let fromDefaults = userDefaults.objectForKey("dataList") as? NSMutableArray
        
        if fromDefaults != nil {
            savedArray = fromDefaults!
        }
        
        self.tableView.reloadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedArray.count
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let restData = userDefaults.objectForKey("dataList") as! NSMutableArray
            
            let newRestList: NSMutableArray = NSMutableArray()
            
            for dict: AnyObject in restData {
                newRestList.addObject(dict as! NSDictionary)
            }
            
            newRestList.removeObjectAtIndex(indexPath.row)
            userDefaults.removeObjectForKey("dataList")
            userDefaults.setObject(newRestList, forKey: "dataList")
            savedArray = newRestList
            
            userDefaults.synchronize()
            
            self.tableView.reloadData()
            
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("savedRestaurants", forIndexPath: indexPath)
        let getRestaurant: NSDictionary = savedArray.objectAtIndex(indexPath.row) as! NSDictionary
        
        cell.textLabel?.text = getRestaurant.objectForKey("addRestaurant") as? String
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailedView" {
            let index = self.tableView.indexPathForSelectedRow!.row
            let DestinationViewController = segue.destinationViewController as! DetailedViewController
            
            let getRestaurant = savedArray.objectAtIndex(index) as! NSDictionary
            
            DestinationViewController.passedRestaurant = getRestaurant.objectForKey("addRestaurant") as? String
            
            
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("detailedView", sender: self)
    }


}

