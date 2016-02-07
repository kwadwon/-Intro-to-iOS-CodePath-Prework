//
//  ViewController.swift
//  Tippy
//
//  Created by Kwadwo Nyarko on 1/31/16.
//  Copyright © 2016 Kwadwo Nyarko. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var plusSignLabel: UILabel!
    @IBOutlet weak var equalsSignLabel: UILabel!
    @IBOutlet weak var topViewBackgroundColor: UIView!
    @IBOutlet weak var bottomViewBackgroundColor: UIView!

    var billFieldOriginalPosition: (CGFloat, CGFloat)!
    var billFieldOriginalFontSize: CGFloat!
    var tipPercentages = [18.0, 20.0, 22.0]
    var topAndBottomViewBackgroundColors: (UIColor, UIColor)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadUserSettings()
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
        billFieldOriginalPosition = (billField.frame.origin.x, billField.frame.origin.y)
        billFieldOriginalFontSize = billField.font?.pointSize
        topAndBottomViewBackgroundColors = (topViewBackgroundColor.backgroundColor!, bottomViewBackgroundColor.backgroundColor!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadUserSettings()
        onEditingChanged(animated)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        billField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex] * 0.01
        let billAmountString = (billField.text! as NSString)
        let billAmount = billAmountString.doubleValue
        let tip = billAmount * tipPercentage
        let total = billAmount  + tip
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
        //animation
        if (billAmountString != "") {
            unhideElements()
            animateWhenBillIsNotEmpty()
        } else {
            //
            animateWhenEmptyBill()
        }
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func loadUserSettings() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let minimum = ((defaults.stringForKey("minimum_tip_value")) != nil) ? defaults.stringForKey("minimum_tip_value"): "18"
        
        let median = ((defaults.stringForKey("median_tip_value")) != nil) ? defaults.stringForKey("median_tip_value") : "20"
        
        let maximum = ((defaults.objectForKey("maximum_tip_value")) != nil) ? defaults.stringForKey("maximum_tip_value") : "22"
        
        tipControl.setTitle("\(minimum!)%", forSegmentAtIndex: 0)
        tipControl.setTitle("\(median!)%",forSegmentAtIndex: 1)
        tipControl.setTitle("\(maximum!)%", forSegmentAtIndex: 2)
        tipControl.selectedSegmentIndex = defaults.integerForKey("default_tip_amount")
        
        tipPercentages = [(tipControl.titleForSegmentAtIndex(0)! as NSString).doubleValue,
                          (tipControl.titleForSegmentAtIndex(1)! as NSString).doubleValue,
                          (tipControl.titleForSegmentAtIndex(2)! as NSString).doubleValue]
    }
    
    func animateWhenEmptyBill() {
        UIView.animateWithDuration(0.3, animations: {
            self.tipLabel.alpha = 0
            self.totalLabel.alpha = 0
            self.plusSignLabel.alpha = 0
            self.equalsSignLabel.alpha = 0
            self.tipControl.alpha = 0
        })
        
        UIView.animateWithDuration(0.4, animations: {
            self.billField.frame.origin.y = self.billFieldOriginalPosition.1 + 130
            self.billField.font = UIFont(name: (self.billField.font?.fontName)!, size: CGFloat(60))
            self.topViewBackgroundColor.backgroundColor = UIColor.blackColor()
            self.bottomViewBackgroundColor.backgroundColor = UIColor.blackColor()
        })
    }
    
    func animateWhenBillIsNotEmpty() {
        UIView.animateWithDuration(0.3, animations: {
            self.tipLabel.alpha = 1
            self.totalLabel.alpha = 1
            self.plusSignLabel.alpha = 1
            self.equalsSignLabel.alpha = 1
            self.tipControl.alpha = 1
        })
        
        UIView.animateWithDuration(0.2, animations: {
            self.billField.frame.origin.y = self.billFieldOriginalPosition.1
            self.billField.font = UIFont(name: (self.billField.font?.fontName)!, size: self.billFieldOriginalFontSize)
            self.topViewBackgroundColor.backgroundColor = self.topAndBottomViewBackgroundColors.0
            self.bottomViewBackgroundColor.backgroundColor = self.topAndBottomViewBackgroundColors.1
        })
    }
    
    func unhideElements() {
        tipLabel.hidden = false
        totalLabel.hidden = false
        plusSignLabel.hidden = false
        equalsSignLabel.hidden = false
        tipControl.hidden = false
    }

}

