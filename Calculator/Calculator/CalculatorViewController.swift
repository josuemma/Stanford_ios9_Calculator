//
//  ViewController.swift
//  Calculator
//
//  Created by 李茂琦 on 4/26/16.
//  Copyright © 2016 Li Maoqi. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    private var userIsInTheMiddleOfTyping: Bool = false {
        didSet {
            if !userIsInTheMiddleOfTyping {
                userIsInTheMiddleOfFloatingPointNumber = false
            }
        }
    }
    
    private var userIsInTheMiddleOfFloatingPointNumber = false
    
    private var brain = CalculatorBrain()
    
    private var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .DecimalStyle
            formatter.maximumFractionDigits = 6
            display.text = formatter.stringFromNumber(newValue)
            history.text = brain.description + (brain.isPartialResult ? " ⋯" : " =")
        }
    }
    
    @IBAction private func touchDigit(sender: UIButton) {
        var digit = sender.currentTitle!
        
        if digit == "." {
            if userIsInTheMiddleOfFloatingPointNumber {
                return
            }
            if !userIsInTheMiddleOfTyping {
                digit = "0."
            }
            userIsInTheMiddleOfFloatingPointNumber = true
        }
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display!.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        
        userIsInTheMiddleOfTyping = true
    }
    @IBAction private func clear(sender: UIButton) {
        brain.clear()
        display.text = "0"
        history.text = "⋯"
        userIsInTheMiddleOfTyping = false
    }

    @IBAction private func performOperation(sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        displayValue = brain.result
        
    }

}