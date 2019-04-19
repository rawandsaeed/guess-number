//
//  ViewController.swift
//  GuessNumber
//
//  Created by Rawand Saeed on 6/6/18.
//  Copyright © 2018 Rawand Saeed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var rangeLbl: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var numGuessLbl: UILabel!
    
    //instances
    private var lowerBound = 0
    private var upperBound = 100
    private var numGuesses = 0
    private var secretNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberTextField.becomeFirstResponder()
        reset()
   }


    
    @IBAction func onOkPressed(_ sender: UIButton) {
        let number = Int(numberTextField.text!)
        if let number = number{
            selectedNumber(number: number)
        } else {
            let alert = UIAlertController(title: nil, message: "Enter a number", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
}

//Logic of the game, good practice to use extention

private extension ViewController{
    enum Comparison {
        case Smaller
        case Greater
        case Equals
    }
    
    func selectedNumber(number: Int){
        
        switch compareNumber(number: number, otherNumber: secretNumber) {
            
        case .Equals:
            let alert = UIAlertController(
                title: nil,
                message: "You won in \(numGuesses) guesses",
                preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(
                title: "Ok",
                style: UIAlertActionStyle.default,
                handler: {
                    cmd in
                    self.reset()
                    self.numberTextField.text = "" }))
            self.present(alert, animated: true)
            
        case .Smaller:
            
            lowerBound = max(lowerBound, number)
            messageLbl.text = "Your last guess was too low"
            numberTextField.text = ""
            //numGuesses
            renderRange()
            renderNumGuesses()
        
        case .Greater:
            
            upperBound = min(upperBound, number)
            messageLbl.text = "Your last guess was too high"
            numberTextField.text = ""
            //numGuesses
            renderRange()
            renderNumGuesses()
        }
        
    }
    func compareNumber(number: Int, otherNumber: Int) ->Comparison{
        if number < otherNumber{
            return .Smaller
        }else if number > otherNumber{
            return .Greater
        }
        return .Equals
    }
}

//Rendering All the labels

private extension ViewController{
    func extractSecretNumber(){
        let diff = upperBound - lowerBound
        let randomNumber = Int(arc4random_uniform(UInt32(diff)))
        secretNumber = randomNumber + Int(lowerBound)
        
    }
    //Dynamic labels
    func renderRange(){
        rangeLbl.text = "\(lowerBound) and \(upperBound)"
    }
    //Dynamic Labels
    func renderNumGuesses(){
        numGuessLbl.text = "Number of Guesses: \(numGuesses)"
    }
    func resetData(){
        lowerBound = 0;
        upperBound = 100
        numGuesses = 0
    }
    func resetMsg(){
        
        messageLbl.text = ""
    }
    func reset(){
        resetData()
        renderRange()
        renderNumGuesses()
        extractSecretNumber()
        resetMsg()
    }
}

