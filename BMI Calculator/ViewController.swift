//
//  ViewController.swift
//  BMI Calculator
//
//  Created by Jovi on 13/12/2022.
//

import UIKit

class ViewController: UIViewController {

    var personalInfo:PersonalInfo?
    
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
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func onHeightChanged(_ sender: Any) {
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
    }
    
    func getBMIDescription(bmi:Double) -> String {
        
        // Determine the BMI category based on the calculated BMI
      if bmi < 16 {
        return "Severe Thinness"
      } else if bmi <  17{
        return "Moderate Thiness"
      } else if bmi < 18.5 {
        return "Mild Thiness"
      } else if bmi < 25.0 {
        return "Normal weight"
      } else if bmi < 30.0 {
        return "Overweight"
      } else if bmi < 35.0 {
        return "Obese Class I"
      } else if bmi < 40.0 {
        return "Obese Class II"
      } else {
        return "Obese Class III"
      }
    }
   
    @IBAction func doneAction(_ sender: Any) {
    }
    @IBAction func resetAction(_ sender: Any) {
    }
    
}

