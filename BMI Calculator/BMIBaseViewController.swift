//  NAME:
//  Jovi Chen-Mcintyre - 301125059
//
//  DESCRIPTION:
//  BMI calculator
//
//  REVISION HISTORY:
//  https://github.com/jovichenmcintyrecentenial/bmi_calculator_ios_final_test
//
//  DATE LAST MODIFIED:
//  Decemeber 11, 2022
//
//  BMIBViewController.swift
//  BMI Calculator
//
//  Created by Jovi on 15/12/2022.
//

import UIKit

//different state the page can be in
enum PageState{case new, update, personalInfo}
//base uiviewcontroller use on BMIDetails page and Personal Information screen
class BMIBaseViewController: UIViewController, UITextFieldDelegate {
    
    var personalInfo:PersonalInfo?
    var height:Double?
    var weight:Double?
    //this obj will not be nil if you are updating a record
    var bmiRecordToUpdate:BMIRecord?
    var bmiRecord:BMIRecord?
    var isToggle = false
    var pageState:PageState = PageState.personalInfo
    @IBOutlet weak var wieghtlabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var measurementSystemUISegment: UISegmentedControl!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var bmiDescriptionLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        //get personal information from realm database
        personalInfo = PersonalInfo.getPersonalData()

        //set text field delegate to watch text change
        heightTextField.delegate = self
        weightTextField.delegate = self
        
        if(personalInfo != nil){
            //when page is in new state take personal information height and prefil UI
            if(pageState == .new){
                height = personalInfo?.height
                heightTextField.text = "\(height!)"
                bmiLabel.text = ""
                measurementSystemUISegment.selectedSegmentIndex = personalInfo!.measurementSystem!
                bmiDescriptionLabel.text = ""
            }
            //when page is using use for personal information, prefil data with personalInfo data from the releam database
            else if(pageState == .personalInfo){
                weight = personalInfo?.weight
                height = personalInfo?.height
                heightTextField.text = "\(height!)"
                weightTextField.text = "\(weight!)"

            }
            //when this is in an update page state it should take the BMI record pass to this screen and prefill UI with that information
            else if(pageState == .update){
                
                weight = bmiRecordToUpdate?.weight
                height = bmiRecordToUpdate?.height
                heightTextField.text = "\(height!)"
                weightTextField.text = "\(weight!)"
                bmiLabel.text = "\(bmiRecordToUpdate!.bmi.toAString(dp:1)) BMI"
                measurementSystemUISegment.selectedSegmentIndex = bmiRecordToUpdate!.measurementSystem!
                bmiDescriptionLabel.text = BMI.getBMIDescription(bmi: bmiRecordToUpdate!.bmi!)

            }
            updateUISegmentMeasurementUnits()
        }
    }
    
    
    //use to update varible for height and weight as you type to calculate bmi in realtime
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if(!isToggle){
            if(textField.tag == 1){
                height = Double(textField.text!) ?? nil
            }
            if(textField.tag == 2){
                weight = Double(textField.text!) ?? nil
            }
            calculateBMI()
        }
        
    }
    
    //when toggle measurement system segment then convert bases to respective units of measurement
    @IBAction func measurementSystemValueChanged(_ sender: UISegmentedControl) {
        //toggle flag use to prevent text change listener from registering toggles as typing in the textfield delegate fuction
        isToggle = true
        updateDisplay()
        convertMeasurements()
        calculateBMI()
        isToggle = false
    }
    
    func updateUISegmentMeasurementUnits(){
        if(measurementSystemUISegment.selectedSegmentIndex == 1){
            heightLabel.text = "Height (meters)"
            wieghtlabel.text = "Weight (kilograms)"
        }
        else{
            heightLabel.text = "Height (inches)"
            wieghtlabel.text = "Weight (pounds)"
        }
    }
    
    //function use to update UI when toggle is pressed and clear some data
    func updateDisplay(){

        bmiRecord = nil
        bmiLabel.text = ""
        bmiDescriptionLabel.text = ""
        updateUISegmentMeasurementUnits()
    }
    


    //convert imperical -> metric or from metric -> imperical
    //based on the current value and UISegment index
    func convertMeasurements(){

        //from imperical -> metric
        if(measurementSystemUISegment.selectedSegmentIndex == 0){
            if(weight != nil){
                weight = weight!*2.20462
                weightTextField.text = weight.toAString()
            }
            if(height != nil){
                height = height!/0.0254
                heightTextField.text = height.toAString()
            }
        }
        //from metric -> imperical
        else{
            if(weight != nil){
                weight = weight!/2.20462
                weightTextField.text = weight.toAString()

            }
            if(height != nil){
                height = height!*0.0254
                heightTextField.text = height.toAString()
            }

        }
    }
    
    //function to calculate BMI and update bmiRecord obj and display
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
    
    //valid measument information in input fields
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


extension Double? {
    //function to convert a double to a string with some decimal point input and it also remove trailing zeros
    func toAString(dp:Int = 4)->String{
        if let val = self {
            let removedTrailingZeros = String(format: "%g", val)
            var split = removedTrailingZeros.split(separator: ".")
            //if decmial points pass the set dp then tuncate the string
            if(split.count > 1 && split[1].count > dp){
                var doubleValue = Double(removedTrailingZeros)
                return String(format: ("%."+dp.description+"f"), doubleValue!)
            }
            return removedTrailingZeros
        }
        return ""
    }
}
