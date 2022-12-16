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
    var isToggle = false
    @IBOutlet weak var wieghtlabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var measurementSystemUISegment: UISegmentedControl!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var bmiDescriptionLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        personalInfo = PersonalInfo.getPersonalData()

        heightTextField.delegate = self
        weightTextField.delegate = self
        
        if(personalInfo != nil){
            lastHeightValue = personalInfo?.height
            lastWeightValue = personalInfo?.weight

        }
    }
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if(!isToggle){
            if(textField.tag == 1){
                height = Double(textField.text!) ?? nil
                lastHeightValue = height
            }
            if(textField.tag == 2){
                weight = Double(textField.text!) ?? nil
                lastWeightValue = weight
            }
            calculateBMI()
        }
        
    }
    
    @IBAction func measurementSystemValueChanged(_ sender: UISegmentedControl) {
        var x = sender.selectedSegmentIndex
        isToggle = true
        updateDisplay()
        convertMeasurements()
        calculateBMI()
        isToggle = false

        
    }
    
    
    func updateDisplay(){
//        heightTextField.text = ""
//        weightTextField.text = ""
//        weight = nil
//        height = nil
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
    
    var lastWeightValue:Double? = nil
    var lastHeightValue:Double? = nil

    func convertMeasurements(){
        var tempWeight:Double? = 0
        var tempHeight:Double? = 0

        //from imperical -> metric
        if(measurementSystemUISegment.selectedSegmentIndex == 0){
            if(lastWeightValue != nil){
                tempWeight = weight!*2.2
                lastWeightValue = tempWeight
                weightTextField.text = doubleToString(tempWeight)
            }
            if(lastHeightValue != nil){
                tempHeight = height!/0.0254
                lastHeightValue = tempHeight
                heightTextField.text = doubleToString(tempHeight)
            }
        }
        //from metric -> imperical
        else{
            if(lastWeightValue != nil){
                tempWeight = lastWeightValue!/2.2
                lastWeightValue = tempWeight
                weightTextField.text = doubleToString(tempWeight)

            }
            if(lastHeightValue != nil){
                tempHeight = lastHeightValue!*0.0254
                lastHeightValue = tempHeight
                heightTextField.text = doubleToString(tempHeight)
            }

        }
    }
    

    func doubleToString(_ value:Double?,dp:Int = 2)->String{
        if let val = value {
            var removedTrailingZeros = String(format: "%g", val)
//            var split = removedTrailingZeros.split(separator: ".")
//            if(split.count > 1 && split[1].count > dp){
//                var doubleValue = Double(removedTrailingZeros)
//                return String(format: ("%."+dp.description+"f"), doubleValue!)
//            }
            return removedTrailingZeros
        }
        return ""
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
