//
//  ViewController.swift
//  Calculator
//
//  Created by Felipe Rojas Alfonso on 2/10/16.
//  Copyright © 2016 Rojas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var displayDescription: UILabel!
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    @IBAction func clear(_ sender: UIButton) {
        brain = CalculatorBrain()
        displayValue = nil
    }
    @IBAction func backSpace(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            if var text = display.text {
                text.remove(at: text.index(before: text.endIndex))
                if text.isEmpty {
                    text = "0"
                    userIsInTheMiddleOfTyping = false
                }
                display.text = text
            }
        }
    }
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if digit != "." ||  textCurrentlyInDisplay.range(of: ".") == nil {
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    private var displayValue: Double? {
        get {
            if let text = display.text, let value = Double(text) {
                return value
            }
            return nil
        }
        
        set {
            if let value = newValue {
                display.text = String(value)
                displayDescription.text = brain.description + (brain.isPartialResult ? " …" : " =")
            } else {
                display.text = "0"
                displayDescription.text = " "
                userIsInTheMiddleOfTyping = false
            }
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue!)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)
        }
        displayValue = brain.result
    }
}

