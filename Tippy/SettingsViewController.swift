//
//  SettingsViewController.swift
//  Tippy
//
//  Created by Kwadwo Nyarko on 1/31/16.
//  Copyright © 2016 Kwadwo Nyarko. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var minimumTipField: UITextField!
    @IBOutlet weak var medianTipField: UITextField!
    @IBOutlet weak var maximumTipField: UITextField!
    @IBOutlet weak var defaultTipControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // load the previous settings
        loadUserSettings()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadUserSettings()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        saveUserSettings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onTipAmountChanged(sender: AnyObject) {
        
        
        //Look at previous values. If new values don't follow the order of min < med < max, reset to previous values
        
        let min = (minimumTipField.text! as NSString).doubleValue
        let med = (medianTipField.text! as NSString).doubleValue
        let max = (maximumTipField.text! as NSString).doubleValue
        
        if (min > med || med > max) {
            // revert back to previous values
            minimumTipField.text = defaultTipControl.titleForSegmentAtIndex(0)
            medianTipField.text = defaultTipControl.titleForSegmentAtIndex(1)
            maximumTipField.text = defaultTipControl.titleForSegmentAtIndex(2)
        
        } else {
            // save the new tip amount and update the values in
            // the segmented control
            defaultTipControl.setTitle(minimumTipField.text, forSegmentAtIndex: 0)
            defaultTipControl.setTitle(medianTipField.text, forSegmentAtIndex: 1)
            defaultTipControl.setTitle(maximumTipField.text, forSegmentAtIndex: 2)
            
            saveUserSettings()
        }
    }
    @IBAction func onEditingEnded(sender: AnyObject) {
        view.endEditing(true)
    }
    
    
    func saveUserSettings() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(defaultTipControl.titleForSegmentAtIndex(0), forKey: "minimum_tip_value")
        defaults.setObject(defaultTipControl.titleForSegmentAtIndex(1), forKey: "median_tip_value")
        defaults.setObject(defaultTipControl.titleForSegmentAtIndex(2), forKey: "maximum_tip_value")
        defaults.setInteger(defaultTipControl.selectedSegmentIndex, forKey: "default_tip_amount")
        defaults.synchronize()
    }
    
    func loadUserSettings() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let minTipField = ((defaults.stringForKey("minimum_tip_value")) != nil) ? defaults.stringForKey("minimum_tip_value") : "18"
        minimumTipField.text = minTipField!
        let medTipField = ((defaults.stringForKey("median_tip_value")) != nil) ? defaults.stringForKey("median_tip_value") : "20"
        medianTipField.text = medTipField!
        let maxTipField = ((defaults.stringForKey("maximum_tip_value")) != nil) ? defaults.stringForKey("maximum_tip_value") : "22"
        maximumTipField.text = maxTipField!
        
        defaultTipControl.setTitle("\(minTipField!)", forSegmentAtIndex: 0)
        defaultTipControl.setTitle("\(medTipField!)", forSegmentAtIndex: 1)
        defaultTipControl.setTitle("\(maxTipField!)", forSegmentAtIndex: 2)

        defaultTipControl.selectedSegmentIndex = defaults.integerForKey("default_tip_amount")
    }
    @IBAction func onBackClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
