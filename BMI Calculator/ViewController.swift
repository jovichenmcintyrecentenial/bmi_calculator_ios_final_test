//
//  ViewController.swift
//  BMI Calculator
//
//  Created by Jovi on 13/12/2022.
//

import UIKit
import NotificationBannerSwift

class ViewController: UIViewController,UITextFieldDelegate {

    var personalInfo:PersonalInfo?
    var height:Double?
    var weight:Double?
    
    @IBOutlet weak var measurementSystemUISegment: UISegmentedControl!

    @IBOutlet weak var genderUISegment: UISegmentedControl!
    @IBOutlet weak var wieghtlabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var bmiDescriptionLabel: UILabel!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
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
    
    @IBAction func onHeightChanged(_ sender: Any) {
    }
    
    func calculateBMI(){
        if(height != nil && weight != nil) {
            var bmi = BMI.calculate(height: height!, weight: weight!, measurementSystem: measurementSystemUISegment.selectedSegmentIndex)
            bmiLabel.text = "\(bmi)"
            bmiDescriptionLabel.text = BMI.getBMIDescription(bmi: bmi)
            
        }
    }
    
    @IBAction func onWeightChanged(_ sender: Any) {
       
    }
    
    func getUserData(){
        personalInfo = PersonalInfo.getPersonalData()
        if(personalInfo != nil){
            displayUserInformation()
        }
    }
    
    func displayUserInformation(){
        nameTextField.text = personalInfo!.name!
        ageTextField.text = "\(personalInfo!.age!)"
        genderUISegment.selectedSegmentIndex = personalInfo!.gender!
        measurementSystemUISegment.selectedSegmentIndex = personalInfo!.measurementSystem!
        heightLabel.text = "\(personalInfo!.height!)"
        weightTextField.text = "\(personalInfo!.weight!)"
        
        updateBMI()
    }
    
    func updateBMI(){
        
    }

    @IBAction func genderValueChanged(_ sender: UISegmentedControl) {
    }
    
    @IBAction func measurementSystemValueChanged(_ sender: UISegmentedControl) {
        heightTextField.text = ""
        weightTextField.text = ""
        weight = nil
        height = nil
        calculateBMI()

    }
    

   func isDataValid()->Bool{
        var error:String? = nil
        
        if(nameTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty){
            error = "Please enter a name"
        }

       else if(ageTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty){
           error = "Please enter a age"
       }
       else if ageTextField.text!.rangeOfCharacter(from: .decimalDigits) == nil {
           error = "Please enter a number for your age"
       }
       else if(heightTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty){
           error = "Please enter a height"
       }
       else if heightTextField.text!.rangeOfCharacter(from: .decimalDigits) == nil {
           error = "Please enter a number for your height"
       }
       else if(weightTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty){
           error = "Please enter a weight"
       }
       else if weightTextField.text!.rangeOfCharacter(from: .decimalDigits) == nil {
           error = "Please enter a number for your weight"
       }
       
        
        //display banner showing user error for required field
        if(error != nil){
            let banner = NotificationBanner(title: title, subtitle: error!, style: .danger)
            banner.show()
            return false
        }
        
        return true
    }
   
    @IBAction func doneAction(_ sender: Any) {
        if(isDataValid()){
            
        }
    }
    @IBAction func resetAction(_ sender: Any) {
    }
    
}

