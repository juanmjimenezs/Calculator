//
//  ViewController.swift
//  Calculator
//
//  Created by Juan Manuel Jimenez Sanchez on 23/01/17.
//  Copyright © 2017 Juan Manuel Jimenez Sanchez. All rights reserved.
//

import UIKit

enum CalcOp: String {
    case Add = "op-suma"
    case Substract = "op-resta"
    case Multiply = "op-multiplica"
    case Divide = "op-divide"
}

class ViewController: UIViewController {

    @IBOutlet weak var icoSuma: UIImageView!
    @IBOutlet weak var icoResta: UIImageView!
    @IBOutlet weak var icoMultiplica: UIImageView!
    @IBOutlet weak var icoDivide: UIImageView!
    
    @IBOutlet weak var labelResult: UILabel!
    
    let currencyFormater = NumberFormatter()
    
    var result: String? {
        didSet {
            if let result = result {
                labelResult.text = currencyFormater.string(from: NSNumber(value: Double(result.replacingOccurrences(of: ",", with: "."))!))
            }
        }
    }
    var previousResult: String?
    var currentOperation: CalcOp? {
        willSet {
            self.resetIcons()
        }
        didSet {
            if let currentOperation = currentOperation {
                switch currentOperation {
                    case .Add:
                        icoSuma.image = UIImage(named: "\(CalcOp.Add.rawValue)-on")
                    case .Substract:
                        icoResta.image = UIImage(named: "\(CalcOp.Substract.rawValue)-on")
                    case .Multiply:
                        icoMultiplica.image = UIImage(named: "\(CalcOp.Multiply.rawValue)-on")
                    case .Divide:
                        icoDivide.image = UIImage(named: "\(CalcOp.Divide.rawValue)-on")
                }
            } else {
                self.resetIcons()
            }
        }
    }
    var previousOperation: CalcOp?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.resetCalculator()
        
        self.currencyFormater.usesGroupingSeparator = true
        self.currencyFormater.maximumFractionDigits = 6
        self.currencyFormater.numberStyle = .decimal
        self.currencyFormater.locale = Locale.current
    }
    
    //Pone los iconos por defecto
    func resetIcons() {
        icoSuma.image = UIImage(named: CalcOp.Add.rawValue)
        icoResta.image = UIImage(named: CalcOp.Substract.rawValue)
        icoMultiplica.image = UIImage(named: CalcOp.Multiply.rawValue)
        icoDivide.image = UIImage(named: CalcOp.Divide.rawValue)
    }
    
    func resetCalculator() {
        self.resetIcons()
        self.result = nil
        self.previousResult = nil
        self.currentOperation = nil
        self.previousOperation = nil
        self.labelResult.text = "0"
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let key = sender.titleLabel!.text!
        
        switch key {
        case "1", "2", "3", "4", "5", "6", "7", "8", "9":
            if var newResult = self.result {
                newResult.append(key)
                self.result = newResult
            } else {
                self.result = key
            }
        case ",":
            if var newResult = self.result {
                if newResult.range(of: ",") == nil {
                    newResult.append(".")
                    self.result = newResult
                }
            }
        case "+":
            self.currentOperation = CalcOp.Add
            self.applyOperation()
        case "-":
            self.currentOperation = CalcOp.Substract
            self.applyOperation()
        case "x":
            self.currentOperation = CalcOp.Multiply
            self.applyOperation()
        case "÷":
            self.currentOperation = CalcOp.Divide
            self.applyOperation()
        case "=":
            self.applyOperation()
            self.currentOperation = nil
            self.previousOperation = nil
            self.previousResult = nil
        case "AC":
            self.resetCalculator()
        case "±":
            if var newResult = self.result, let currentValue = Double(newResult) {
                newResult = String(-currentValue)
                self.result = newResult
            }
        case "%":
            if var newResult = self.result, let currentValue = Double(newResult) {
                newResult = String(currentValue / 100)
                self.result = newResult
            }
        default:
            print("no es posible")
        }
    }
    
    func applyOperation() {
        if self.result != nil {
            if var newResult = self.result, let prevOp = self.previousOperation, let prevResult = self.previousResult, let dblPreviousResult = Double(prevResult), let dblResult = Double(newResult) {
                switch prevOp {
                case .Add:
                    newResult = String(dblPreviousResult + dblResult)
                case .Substract:
                    newResult = String(dblPreviousResult - dblResult)
                case .Multiply:
                    newResult = String(dblPreviousResult * dblResult)
                case .Divide:
                    if dblResult != 0 {
                        newResult = String(dblPreviousResult / dblResult)
                    } else {
                        newResult = "0"
                    }
                }
                
                self.result = newResult
                self.previousResult = nil
                self.previousOperation = nil
            } else {
                self.previousOperation = self.currentOperation
                self.previousResult = self.result
                result = nil
            }
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

}

