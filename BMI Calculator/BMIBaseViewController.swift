//
//  BMIBViewController.swift
//  BMI Calculator
//
//  Created by Jovi on 15/12/2022.
//

import UIKit

class BMIBaseViewController: UIViewController, UITextFieldDelegate {
    
    var personalInfo:PersonalInfo?
    var height:Double?
    var weight:Double?
    var bmiRecord:BMIRecord? = nil
    
    @IBOutlet weak var wieghtlabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var measurementSystemUISegment: UISegmentedControl!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var bmiDescriptionLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightTextField.delegate = self
        weightTextField.delegate = self
        
    }
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if(textField.tag == 1){
            height = Double(textField.text!) ?? nil
        }
        if(textField.tag == 2){
            weight = Double(textField.text!) ?? nil
        }
        calculateBMI()
        
    }
    
    @IBAction func measurementSystemValueChanged(_ sender: UISegmentedControl) {
        updateDisplay()
        calculateBMI()
        
    }
    
    
    func updateDisplay(){
        heightTextField.text = ""
        weightTextField.text = ""
        weight = nil
        height = nil
        bmiRecord = nil
        bmiLabel.text = ""
        bmiDescriptionLabel.text = ""
        if(measurementSystemUISegment.selectedSegmentIndex == 1){
            heightLabel.text = "Height (meters)"
            wieghtlabel.text = "Weight (kilograms)"
        }
        else{
            heightLabel.text = "Height (inches)"
            wieghtlabel.text = "Weight (pounds)"
        }
    }
    
    
    
    func calculateBMI(){
        if(height != nil && weight != nil) {
            let bmi = BMI.calculate(height: height!, weight: weight!, measurementSystem: measurementSystemUISegment.selectedSegmentIndex)
            bmiLabel.text = "\(String(format: "%.1f", bmi)) BMI"
            bmiDescriptionLabel.text = BMI.getBMIDescription(bmi: bmi)
            
            bmiRecord = BMIRecord()
            bmiRecord?.bmi = bmi
            bmiRecord?.weight = weight!
            bmiRecord?.height = height!
            bmiRecord?.measurementSystem = measurementSystemUISegment.selectedSegmentIndex
            bmiRecord?.date = Date.now
        }
        else{
            bmiRecord = nil
        }
    }
    
    func validateMeasurements()->String?{
        if(heightTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty){
           return "Please enter a height"
        }
        else if Double(heightTextField.text!) == nil {
           return "Please enter a number for your height"
        }
        else if(weightTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty){
           return "Please enter a weight"
        }
        else if Double(weightTextField.text!) == nil {
           return "Please enter a number for your weight"
        }
        return nil
    }
}
