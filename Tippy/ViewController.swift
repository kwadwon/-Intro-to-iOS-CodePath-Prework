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
    
    var usDollar = "\u{0024}"
    var ukPound = "\u{00A3}"
    var chinaYuan = "\u{00A5}"
    var currency = [String]()
    var preferredCurrency: (String) = ""

    var billFieldOriginalPosition: (CGFloat, CGFloat)!
    var billFieldOriginalFontSize: CGFloat!
    var tipPercentages = [18.0, 20.0, 22.0]
    var topAndBottomLightBackgroundColors = (UIColor(red:241/255, green:255/255, blue:233/255, alpha:1), UIColor(red:203/255, green:248/255, blue:217/255, alpha:1))
    
    var topAndBottomDarkBackgroundColors = (UIColor(red:189/255, green:228/255, blue:197/255, alpha:1), UIColor(red:0, green:87/255, blue:76/255, alpha:1))
    
    var topAndBottomViewBackgroundColors: (UIColor, UIColor)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        currency = [usDollar, ukPound, chinaYuan]
        loadUserSettings()
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
        billFieldOriginalPosition = (billField.frame.origin.x, billField.frame.origin.y)
        billFieldOriginalFontSize = billField.font?.pointSize
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        saveEnteredData()
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
        
        tipLabel.text = "\(preferredCurrency)" + String(format: "%.2f", tip)
        totalLabel.text = "\(preferredCurrency)" + String(format: "%.2f", total)
        
        //animation
        if (billAmountString != "") {
            unhideElements()
            animateWhenBillIsNotEmpty()
        } else {
            animateWhenEmptyBill()
        }
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func loadUserSettings() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let minimum = defaults.stringForKey("minimum_tip_value") ?? "18"
        
        let median = defaults.stringForKey("median_tip_value") ?? "20"
        
        let maximum = defaults.stringForKey("maximum_tip_value") ?? "22"
        
        tipControl.setTitle("\(minimum)%", forSegmentAtIndex: 0)
        tipControl.setTitle("\(median)%",forSegmentAtIndex: 1)
        tipControl.setTitle("\(maximum)%", forSegmentAtIndex: 2)
        tipControl.selectedSegmentIndex = defaults.integerForKey("default_tip_amount")
        
        tipPercentages = [(tipControl.titleForSegmentAtIndex(0)! as NSString).doubleValue,
                          (tipControl.titleForSegmentAtIndex(1)! as NSString).doubleValue,
                          (tipControl.titleForSegmentAtIndex(2)! as NSString).doubleValue]
        
        let lastTipDateTime = defaults.objectForKey("last_tip_date") as? NSDate ?? NSDate()
        
        let currentDateTime = NSDate()
        let interval = currentDateTime.timeIntervalSinceDate(lastTipDateTime)
        
        let preferredCurrencyIndex = defaults.integerForKey("default_currency") ?? 0
        preferredCurrency = currency[preferredCurrencyIndex]
        billField.placeholder = preferredCurrency

        // if its been less than 10 minutes since app was open, show previous values
        if (interval < 600) {
            let lastBillAmount = defaults.stringForKey("last_bill_amount") ?? ""
            billField.text = lastBillAmount
            //tipControl.selectedSegmentIndex = defaults.integerForKey("last_tip_selection")
        } else {
            billField.text = ""
        }

        updateColorThemeEmptyBill()
    }
    
    func updateColorThemeEmptyBill() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let darkThemeOn = defaults.boolForKey("default_theme_dark") ?? false
        
        if (darkThemeOn) {
            self.topViewBackgroundColor.backgroundColor = UIColor.blackColor()
            self.bottomViewBackgroundColor.backgroundColor = UIColor.blackColor()
        } else {
            self.topViewBackgroundColor.backgroundColor = UIColor.whiteColor()
            self.bottomViewBackgroundColor.backgroundColor = UIColor.whiteColor()
        }
    }
    
    func updateColorThemeWithBill() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let darkThemeOn = defaults.boolForKey("default_theme_dark") ?? false
        
        var topAndBottomColors = self.topAndBottomLightBackgroundColors
        if (darkThemeOn) {
            topAndBottomColors = self.topAndBottomDarkBackgroundColors
        }
        
        self.topViewBackgroundColor.backgroundColor = topAndBottomColors.0
        self.bottomViewBackgroundColor.backgroundColor = topAndBottomColors.1
    }
    
    func saveEnteredData() {
        //Save the users last bill amount, tip selection, and time
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(billField.text, forKey: "last_bill_amount")
        defaults.setInteger(tipControl.selectedSegmentIndex, forKey: "last_tip_selection")
        defaults.setObject(NSDate(), forKey: "last_tip_date")
        defaults.setObject(billField.placeholder, forKey:"last_currency")
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
            self.updateColorThemeEmptyBill()
            //self.topViewBackgroundColor.backgroundColor = UIColor.blackColor()
            //self.bottomViewBackgroundColor.backgroundColor = UIColor.blackColor()
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
            self.updateColorThemeWithBill()
            //self.topViewBackgroundColor.backgroundColor = self.topAndBottomViewBackgroundColors.0
            //self.bottomViewBackgroundColor.backgroundColor = self.topAndBottomViewBackgroundColors.1
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

