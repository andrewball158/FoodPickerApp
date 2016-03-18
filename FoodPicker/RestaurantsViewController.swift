//
//  FirstViewController.swift
//  FoodPicker
//
//  Created by Andrew Ball on 12/10/15.
//  Copyright © 2015 Andrew Ball. All rights reserved.
//

import UIKit

class RestaurantsViewController: UIViewController, UITextFieldDelegate {
    
    var randomArray: [String] = []

    @IBOutlet weak var rest1: UILabel!
    @IBOutlet weak var rest2: UILabel!
    @IBOutlet weak var rest3: UILabel!
    @IBOutlet weak var rest4: UILabel!
    @IBOutlet weak var rest5: UILabel!
    
    @IBOutlet weak var randRestaurant: UILabel!
    @IBOutlet weak var restaurantLabel: UILabel!
    
    @IBOutlet weak var restText1: UITextField!
    @IBOutlet weak var restText2: UITextField!
    @IBOutlet weak var restText3: UITextField!
    @IBOutlet weak var restText4: UITextField!
    @IBOutlet weak var restText5: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restText1.delegate = self
        restText2.delegate = self
        restText3.delegate = self
        restText4.delegate = self
        restText5.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func delete1(sender: AnyObject) {
        restText1.text = ""
    }
    
    @IBAction func delete2(sender: AnyObject) {
        restText2.text = ""
    }
    
    @IBAction func delete3(sender: AnyObject) {
        restText3.text = ""
    }
    
    @IBAction func delete4(sender: AnyObject) {
        restText4.text = ""
    }
    
    @IBAction func delete5(sender: AnyObject) {
        restText5.text = ""
    }
    
    @IBAction func randomize(sender: AnyObject) {
        if restText1.text != "" {
            randomArray.append(restText1.text!)
        }
        if restText2.text != "" {
            randomArray.append(restText2.text!)
        }
        if restText3.text != "" {
            randomArray.append(restText3.text!)
        }
        if restText4.text != "" {
            randomArray.append(restText4.text!)
        }
        if restText5.text != "" {
            randomArray.append(restText5.text!)
        }
        
        if randomArray.count == 0 {
            randRestaurant.text = "Enter Restaurants Above"
        }
        else {
            let convert = UInt32(randomArray.count)
            let ranNumber = Int(arc4random_uniform(convert))
            randRestaurant.text = randomArray[ranNumber]
            randomArray = []
        }
        
        restText1.resignFirstResponder()
        restText2.resignFirstResponder()
        restText3.resignFirstResponder()
        restText4.resignFirstResponder()
        restText5.resignFirstResponder()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}

