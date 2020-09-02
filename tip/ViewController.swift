//
//  ViewController.swift
//  tip
//
//  Created by Ruoyu Shen on 9/1/20.
//  Copyright © 2020 Ruoyu Shen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var billAmountText: UITextField!
    @IBOutlet weak var tipPercentage: UISegmentedControl!
    
    @IBOutlet weak var custom: UITextField!
    @IBOutlet weak var totalArea: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func gesture(_ sender: Any) {
    }
    
    @IBAction func changeDefaultPer(_ sender: Any) {
        var tip = 0.0;
        switch(tipPercentage.selectedSegmentIndex){
        case 0:
            tip = 0.15;
            break;
        case 1:
            tip = 0.18;
            break;
        case 2:
            tip = 0.2;
        default:
            tip = 0;
        }
        custom.text = String(tip * 100);
        changeCustom(self);
    }
    
    @IBAction func changeCustom(_ sender: Any) {
        custom.textColor = UIColor.black;
        billAmountText.textColor = UIColor.black;
        if(checkAva()){
            calculate();
        }
    }
    
    func checkAva() -> Bool {
        var isGood = true;
        if(billAmountText.text == nil || custom.text == nil){
            isGood = false;
        }
        var cus = billAmountText.text!;
        var pattern1 = "^[0-9]+(\\.[0-9]{1,2})?$";
        //var regex1 = NSRegularExpression;
        do{
            var regex1 = try NSRegularExpression(pattern: pattern1, options: []);
            let results = regex1.matches(in: cus, options: [], range: NSMakeRange(0, cus.count));
            
            if (results.endIndex != 1 || (cus as NSString).substring(with: results[0].range) != cus) {
                billAmountText.textColor = UIColor.red;
                isGood = false;
            }
        } catch {
            print("error");
        }
        cus = custom.text!;
        pattern1 = "^0*(100||[0-9]{1,2})(\\.[0-9])?$";
        //var regex1 = NSRegularExpression;
        do{
            var regex1 = try NSRegularExpression(pattern: pattern1, options: []);
            let results = regex1.matches(in: cus, options: [], range: NSMakeRange(0, cus.count));
            
            if (results.endIndex != 1 || (cus as NSString).substring(with: results[0].range) != cus) {
                custom.textColor = UIColor.red;
                isGood = false;
            }
        } catch {
            print("error");
        }
        return isGood;
    }
    
    
    
    func calculate(){
        let tip = (Double(custom.text!) ?? 0) / 100;
        let amount = Double(billAmountText.text!) ?? 0;
        totalArea.text = String(format: "$%.2f", amount * (1 + tip));
    }

}

