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
    @IBOutlet weak var dollor: UILabel!
    @IBOutlet weak var tipPercentage: UISegmentedControl!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var tipsView: UILabel!
    
    @IBOutlet weak var custom: UITextField!
    @IBOutlet weak var totalArea: UILabel!
    var defaults = UserDefaults.standard;
    var taxRate = 0.065;
    var currency = "$";
    var initialized = false;
    override func viewDidLoad() {
        super.viewDidLoad();
        billAmountText.becomeFirstResponder();
        self.title = "Tip Calcu";
        readDefault();
        tipPercentage.selectedSegmentIndex = defaults.integer(forKey: "defaultTipIndex");
        switch (tipPercentage.selectedSegmentIndex) {
        case 0:
            custom.text = "15.0";
        case 1:
            custom.text = "18.0";
        default:
            custom.text = "20.0";
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(!initialized){
            initialized = true;
        } else {
            billAmountText.becomeFirstResponder();
            readDefault();
            let temp = [price, tax, tipsView, totalArea];
            for e in temp{
                if(e!.text != "-"){
                    var temp = e!.text as! String;
                    temp = String(temp.suffix(temp.count - 1));
                    e!.text = currency + temp;
                }
            }
        }
    }

    @IBAction func gesture(_ sender: Any) {
    }
    
    @IBAction func changeDefaultPer(_ sender: Any) {
        var tip = 0.0;
        var current = tipPercentage.selectedSegmentIndex;
        switch(current){
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
        tipPercentage.selectedSegmentIndex = current;
    }
    
    @IBAction func changeCustom(_ sender: Any) {
        tipPercentage.selectedSegmentIndex = -1;
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
                    setback();
                } else if(Double(cus)! >= 10000000.0){
                    isGood = false;
                    setback();
            } else {
                    price.text = currency + String(format: "%.2f", Double(cus)!);
                    let cur = Double(cus)!;
                    tax.text = currency + String(format: "%.2f", cur * taxRate);
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
        print(currency);
        let tip = (Double(custom.text!) ?? 0) / 100;
        let amount = Double(billAmountText.text!) ?? 0;
        tipsView.text = currency + String(format: "%.2f", amount * tip);
        totalArea.text = currency + String(format: "%.2f", amount * (1 + tip));
    }
    
    @IBAction func checkIsDefault(_ sender: UITextField!) {
        if(sender.textColor == UIColor.red){
            return;
        }
        let temp = Double(sender.text!)!;
        switch(temp){
        case 15.0:
                tipPercentage.selectedSegmentIndex = 0;
                break;
        case 18.0:
            tipPercentage.selectedSegmentIndex = 1;
            break;
        case 20.0:
            tipPercentage.selectedSegmentIndex = 2;
            break;
        default:
            tipPercentage.selectedSegmentIndex = -1;
        }
    }
    func setback(){
        
        tipsView.text = "-";
        totalArea.text = "-";
        price.text = "-";
        tax.text = "-";
    }
    
    func readDefault(){
        if(defaults.integer(forKey: "logined") != 1){
            print("yes");
            defaults.set(1, forKey: "logined");
            defaults.set(0, forKey: "defaultTipIndex");
            defaults.set("$", forKey: "defaultCurrency");
            defaults.set(0.065, forKey: "defaultTax");
            defaults.synchronize();
        }
        taxRate = defaults.double(forKey: "defaultTax");
        currency = defaults.string(forKey: "defaultCurrency")!;
        dollor.text = currency;
    }
}

