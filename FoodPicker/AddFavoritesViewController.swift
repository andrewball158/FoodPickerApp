//
//  AddFavoritesViewController.swift
//  FoodPicker
//
//  Created by Andrew Ball on 12/11/15.
//  Copyright © 2015 Andrew Ball. All rights reserved.
//

import UIKit

class AddFavoritesViewController: UIViewController {

    @IBOutlet weak var addRestLabel: UILabel!
    @IBOutlet weak var addText: UITextField!
    
    
    
    @IBAction func doneButton(sender: AnyObject) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        var restList: NSMutableArray? = userDefaults.objectForKey("dataList") as? NSMutableArray
        
        let data: NSMutableDictionary = NSMutableDictionary()
        data.setObject(addText.text!, forKey: "addRestaurant")
        
        if (restList != nil) {
            let newMutableList: NSMutableArray = NSMutableArray();
            
            for dict:AnyObject in restList! {
                newMutableList.addObject(dict as! NSDictionary)
            }
            
            userDefaults.removeObjectForKey("dataList")
            newMutableList.addObject(data)
            userDefaults.setObject(newMutableList, forKey: "dataList")
        }
        else {
            userDefaults.removeObjectForKey("dataList")
            restList = NSMutableArray()
            restList!.addObject(data)
            userDefaults.setObject(restList, forKey: "dataList")
        }
        
        userDefaults.synchronize()
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
