//
//  ViewController.swift
//  SwiftCalc
//
//  Created by Zach Zeleznick on 9/20/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Width and Height of Screen for Layout
    var w: CGFloat!
    var h: CGFloat!
    

    // IMPORTANT: Do NOT modify the name or class of resultLabel.
    //            We will be using the result label to run autograded tests.
    // MARK: The label to display our calculations
    var resultLabel = UILabel()
    var currOp = ""
    
    // TODO: This looks like a good place to add some data structures.
    //       One data structure is initialized below for reference.
    var currNum = ""
    var isDouble = false
    var currResult = ""
    var error = false
    var holdNum = ""
    var holdOp = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        w = view.bounds.size.width
        h = view.bounds.size.height
        navigationItem.title = "The Dank Calculator"
        // IMPORTANT: Do NOT modify the accessibilityValue of resultLabel.
        //            We will be using the result label to run autograded tests.
        resultLabel.accessibilityValue = "resultLabel"
        makeButtons()
        // Do any additional setup here.
        currNum = ""
        currResult = ""
        updateResultLabel(currNum)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: A method to update your data structure(s) would be nice.
    //       Modify this one or create your own.
    func updateSomeDataStructure(_ content: String) {
        print("Update me like one of those PCs")
    }
    
    // TODO: Ensure that resultLabel gets updated.
    //       Modify this one or create your own.
    func updateResultLabel(_ content: String) {
        if (error == true) { //if there is error
            resultLabel.text = "Error"
            currResult = ""
            currNum = ""
            holdNum = ""
            holdOp = ""
            return
        }
        if (Double(content) == 0) { //simply things by making 0 0
            resultLabel.text = "0"
        }
        if (isDouble && Double(content) == 0) { //same as above, but 0.0 = 0
            resultLabel.text = "0"
            return
        }
        if (content == "") { //if there is nothing (in the beginning), display 0
            resultLabel.text = "0"
        } else {
            let d = Double(content)!
            let isInteger = floor(d) == d // true
            if isInteger { //check if double or not
                resultLabel.text = String(Int(d))
            } else {
                resultLabel.text = content
            }
        }
        if resultLabel.text!.characters.count > 7 { //cases for long numbers
            //print("FDSFD")
            let d = Double(content)!
            //let isInteger = floor(d) == d // true
            if (d < 10000000 || (d < 0 && d > -1000000)) { //check if it is smaller than max value
                let index = resultLabel.text!.index(resultLabel.text!.startIndex, offsetBy: 7)
                resultLabel.text = resultLabel.text!.substring(to: index)
            }
            else if d > 1 || d < -1{ //cases for big numbers
                var str = String(Int(d))
                let index = str.index(str.startIndex, offsetBy: 1)
                let pow = str.characters.count
                str = str.substring(to: index)
                str = str + "e" + String(pow)
                resultLabel.text = str
 
                /*
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = NumberFormatter.Style.scientific
                numberFormatter.positiveFormat = "0.###E+0"
                numberFormatter.exponentSymbol = "e"
                if let stringFromNumber = numberFormatter.stringFromNumber(Int(content)!){
                    resultLabel.text = (stringFromNumber)
                }
                */
            }
            else{ //really small numbers like 0.000001
                var i = Int(d)
                var d2 = d
                var pow = 0
                while i == 0 {
                    d2 *= 10
                    i = Int(d2)
                    pow = pow + 1
                }
                var str = String(i)
                str = str + "e-" + String(pow)
                resultLabel.text = str
                
            }
        }
        
    }
    
    
    // TODO: A calculate method with no parameters, scary!
    //       Modify this one or create your own.
    func calculate() -> String {
        return "0"
    }
    
    // TODO: A simple calculate method for integers.
    //       Modify this one or create your own.
    func intCalculate(a: Int, b:Int, operation: String) -> Int {
        print("Calculation requested for \(a) \(operation) \(b)")
        switch operation {
            case "+":
                return b + a
            case "-":
                return b - a
            case "*":
                return b * a
            case "/":
                return b / a
            case "+/-":
                return -1*a
            default:
                return a
        }
    }
    
    // TODO: A general calculate method for doubles
    //       Modify this one or create your own.
    func calculate(a: String, b:String, operation: String) -> Double {
        print("Calculation requested for \(a) \(operation) \(b)")
        if (a == "" && b == "") {
            return 0
        }
        if (a == "") {
            if (operation == "+/-") {
                return -1 * Double(b)!
            } else if (operation == "%") {
                return 0.01 * Double(b)!
            }
        }
        let a1 = Double(a)!
        if (b == "") {
            return a1
        }
        let b1 = Double(b)!

        if (operation == "+/-") {
            return -1 * b1
        } else if (operation == "%") {
            return 0.01 * b1
        }
        switch operation {
            case "+":
                return a1 + b1
            case "-":
                return a1 - b1
            case "*":
                return a1 * b1
            case "/":
                if (b1 == 0) {
                    error = true
                    return 0
                }
                return a1 / b1
            default:
                return a1
        }
    }
    
    // REQUIRED: The responder to a number button being pressed.
    func numberPressed(_ sender: CustomButton) {
        guard Int(sender.content) != nil else { return }
        print("The number \(sender.content) was pressed")
        if (currOp == "=") {
            currNum = ""
            currResult = ""
        }
        if currNum == "" {
            currNum = sender.content
        } else if currNum.characters.count < 7 {
            currNum += sender.content
        }
        updateResultLabel(currNum)
    }
    
    // REQUIRED: The responder to an operator button being pressed.
    func operatorPressed(_ sender: CustomButton) {
        print("Operator \(sender.content) was pressed")
        if (sender.content == "+/-" || sender.content == "%") {
            //currNum = intCalculate(a:currNum, b: currResult, operation: sender.content)
            currNum = String(calculate(a:currResult, b: currNum, operation: sender.content))
            if (Double(currNum)! == 0) {
                currNum = "0"
            }
            updateResultLabel(currNum)
            return
        } else if (sender.content == "C") {
            currNum = ""
            currResult = ""
            currOp = ""
            holdOp = ""
            holdNum = ""
            error = false
            updateResultLabel(currResult)
            return
        } else if (sender.content == "=") {
            //currResult = String(calculate(a:currResult, b: currNum, operation: currOp))
            let d = calculate(a:currResult, b: currNum, operation: currOp)
            if floor(d) == d {
                currResult = String(Int(d))
            } else {
                currResult = String(d)
            }
            if (holdOp != "") {
                currResult = String(calculate(a: holdNum, b: currResult, operation: holdOp))
                holdNum = ""
                holdOp = ""
            }
            currNum = currResult
            updateResultLabel(currResult)
            currOp = "="
            return
        }
        if (currOp != "") {
            /*
            if (currOp == "*" || currOp == "/") {
                //currResult = currNum
                currNum = String(calculate(a: currNum, b: currResult, operation: currOp))
            }
            */
            if (sender.content == "*" || sender.content == "/") {
                if (currOp == "+" || currOp == "-") {
                    holdNum = currResult
                    currResult = currNum
                    currNum = ""
                    isDouble = false
                    holdOp = currOp
                    currOp = sender.content
                } else {
                    currResult = String(calculate(a:currResult, b: currNum, operation: currOp))
                    currOp = sender.content
                    if (currOp != "=") {
                        currNum = ""
                        isDouble = false
                    } else {
                        currNum = currResult
                        isDouble = !(floor(Double(currNum)!) == Double(currNum)!)
                        currResult = ""
                    }
                }
            } else { //sender.content = + or -
                currResult = String(calculate(a:currResult, b: currNum, operation: currOp))
                if (holdOp != "") {
                    currResult = String(calculate(a:holdNum, b: currResult, operation: holdOp))
                    holdNum = ""
                    holdOp = ""
                }
                currOp = sender.content
                if (currOp != "=") {
                    currNum = ""
                    isDouble = false
                } else {
                    currNum = currResult
                    isDouble = !(floor(Double(currNum)!) == Double(currNum)!)
                    currResult = ""
                    currOp = "="
                }
            }
        } else {
            currResult = currNum
            currOp = sender.content
            currNum = ""
            isDouble = false
        }
        if (error == true) {
            currOp = ""
            currNum = ""
            currResult = ""
        }
        updateResultLabel(String(currResult))
    }
    
    // REQUIRED: The responder to a number or operator button being pressed.
    func buttonPressed(_ sender: CustomButton) {
       // Fill me in!
        if (sender.content == "0") {
            if (currNum == "" || currNum == "0") {
                currNum = "0"
            } else {
                currNum += sender.content
            }
            updateResultLabel(currNum)
        } else if(sender.content == "." && isDouble == false) {
            isDouble = true
            print("The symbol \(sender.content) was pressed")
            if (currNum == "") {
                currNum = "0"
            } else {
                let d = Double(currNum)!
                let isInteger = floor(d) == d // true
                if !isInteger { //prevent dot's from appearing twice in code
                    return
                }
            }
            currNum = currNum + sender.content
            resultLabel.text = currNum
        }
    }
    
    // IMPORTANT: Do NOT change any of the code below.
    //            We will be using these buttons to run autograded tests.
    
    func makeButtons() {
        // MARK: Adds buttons
        let digits = (1..<10).map({
            return String($0)
        })
        let operators = ["/", "*", "-", "+", "="]
        let others = ["C", "+/-", "%"]
        let special = ["0", "."]
        
        let displayContainer = UIView()
        view.addUIElement(displayContainer, frame: CGRect(x: 0, y: 0, width: w, height: 160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }
        displayContainer.addUIElement(resultLabel, text: "0", frame: CGRect(x: 70, y: 70, width: w-70, height: 90)) {
            element in
            guard let label = element as? UILabel else { return }
            label.textColor = UIColor.white
            label.font = UIFont(name: label.font.fontName, size: 60)
            label.textAlignment = NSTextAlignment.right
        }
        
        let calcContainer = UIView()
        view.addUIElement(calcContainer, frame: CGRect(x: 0, y: 160, width: w, height: h-160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }

        let margin: CGFloat = 1.0
        let buttonWidth: CGFloat = w / 4.0
        let buttonHeight: CGFloat = 100.0
        
        // MARK: Top Row
        for (i, el) in others.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
                button.backgroundColor = UIColor.gray
                //button.layer.borderWidth = 1
            }
        }
        // MARK: Second Row 3x3
        for (i, digit) in digits.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: digit), text: digit,
            frame: CGRect(x: x, y: y+101.0, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(numberPressed), for: .touchUpInside)
                button.backgroundColor = UIColor.white
                button.setTitleColor(UIColor.black, for: .normal)
            }
        }
        // MARK: Vertical Column of Operators
        for (i, el) in operators.enumerated() {
            let x = (CGFloat(3) + 1.0) * margin + (CGFloat(3) * buttonWidth)
            let y = (CGFloat(i) + 1.0) * margin + (CGFloat(i) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.backgroundColor = UIColor.orange
                button.setTitleColor(UIColor.white, for: .normal)
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Last Row for big 0 and .
        for (i, el) in special.enumerated() {
            let myWidth = buttonWidth * (CGFloat((i+1)%2) + 1.0) + margin * (CGFloat((i+1)%2))
            let x = (CGFloat(2*i) + 1.0) * margin + buttonWidth * (CGFloat(i*2))
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: 405, width: myWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
                button.backgroundColor = UIColor.white
                button.setTitleColor(UIColor.black, for: .normal)

            }
        }
    }

}

