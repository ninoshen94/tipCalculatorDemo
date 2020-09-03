//
//  SettingViewController.swift
//  tip
//
//  Created by Ruoyu Shen on 9/2/20.
//  Copyright © 2020 Ruoyu Shen. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet weak var defTax: UITextField!
    var defaults = UserDefaults.standard;
    @IBOutlet weak var defTip: UISegmentedControl!
    @IBOutlet weak var defCur: UISegmentedControl!
    var beforeTax = -1.0;
    var instance = ViewController();
    override func viewDidLoad() {
        super.viewDidLoad()
        print(defaults.integer(forKey: "defaultTipIndex"));
        defTax.text = String(format:"%.1f", defaults.double(forKey: "defaultTax")*100);
        defTip.selectedSegmentIndex = defaults.integer(forKey: "defaultTipIndex");
        switch (defaults.string(forKey: "defaultCurrency")) {
        case "$":
            defCur.selectedSegmentIndex = 0;
        case "¥":
            defCur.selectedSegmentIndex = 1;
        default:
            defCur.selectedSegmentIndex = 2;
        }
        instance.currency = "P";
        // Do any additional setup after loading the view.
    }
    
    @IBAction func taxRateDefault(_ sender: Any) {
        let defaultTax = Double((sender as! UITextField).text!) ?? beforeTax;
        defaults.set(defaultTax/100, forKey: "defaultTax");
        defaults.synchronize();
        print(defaults.double(forKey: "defaultTax"));
    }
    
    @IBAction func defaultTip(_ sender: Any) {
        let defaultTip = (sender as! UISegmentedControl).selectedSegmentIndex;
        defaults.set(defaultTip, forKey: "defaultTipIndex");
        defaults.synchronize();
    }
    
    @IBAction func defaultCur(_ sender: Any) {
        let dic = ["$", "¥", "£"];
        defaults.set(dic[(sender as! UISegmentedControl).selectedSegmentIndex], forKey: "defaultCurrency");
        defaults.synchronize();
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
