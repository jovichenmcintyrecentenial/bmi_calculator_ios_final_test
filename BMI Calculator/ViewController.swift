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
//  ViewController.swift
//  BMI Calculator
//
//  Created by Jovi on 13/12/2022.
//

import UIKit
import NotificationBannerSwift
import RealmSwift

class ViewController: BMIBaseViewController {
    

        
    @IBOutlet weak var genderUISegment: UISegmentedControl!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDisplay()
        getUserData()
        
    }
    
    

    
    @IBAction func onHeightChanged(_ sender: Any) {
    }

    @IBAction func onWeightChanged(_ sender: Any) {
        
    }
    
    //check if user nil if not update the ui with data
    func getUserData(){
        if(personalInfo != nil){
            displayUserInformation()
        }
    }
    
    //display store data from realm database
    func displayUserInformation(){
        nameTextField.text = personalInfo!.name!
        ageTextField.text = "\(personalInfo!.age!)"
        genderUISegment.selectedSegmentIndex = personalInfo!.gender!
        measurementSystemUISegment.selectedSegmentIndex = personalInfo!.measurementSystem!
        heightTextField.text = "\(personalInfo!.height!)"
        weightTextField.text = "\(personalInfo!.weight!)"
        weight = Double(weightTextField.text!) ?? nil
        height = Double(heightTextField.text!) ?? nil

        calculateBMI()
        
    }
    
    
    @IBAction func genderValueChanged(_ sender: UISegmentedControl) {
    }
    

    //valid input fields
    func isDataValid()->Bool{
        var error:String? = nil
        
        if(nameTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty){
            error = "Please enter a name"
        }
        
        else if(ageTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty){
            error = "Please enter a age"
        }
        else if Double(ageTextField.text!) == nil {
            error = "Please enter a number for your age"
        }
        else{
            error = validateMeasurements()
        }
        
        
        //display banner showing user error for required field
        if(error != nil){
            let banner = NotificationBanner(title: title, subtitle: error!, style: .danger)
            banner.show()
            return false
        }
        
        return true
    }
    
    //save personal infomation handles for new or existing user
    func savePersonalInfo(){
        //if this user is new create realm object and save it
        if(personalInfo == nil){
            let personalInfo:PersonalInfo? = PersonalInfo()
            personalInfo?.name = nameTextField.text!
            personalInfo?.age = Int(ageTextField.text!)!
            personalInfo?.gender = genderUISegment.selectedSegmentIndex
            personalInfo?.measurementSystem = measurementSystemUISegment.selectedSegmentIndex
            personalInfo?.height = Double(heightTextField.text!)!
            personalInfo?.weight = Double(weightTextField.text!)!
            personalInfo?.create()
            
        }
        //else if user is not new and exist in database already update the data
        else{
            let realm = try! Realm()
            try! realm.write {
                personalInfo?.name = nameTextField.text!
                personalInfo?.age = Int(ageTextField.text!)!
                personalInfo?.gender = genderUISegment.selectedSegmentIndex
                personalInfo?.measurementSystem = measurementSystemUISegment.selectedSegmentIndex
                personalInfo?.height = Double(heightTextField.text!)!
                personalInfo?.weight = Double(weightTextField.text!)!
            }
        }
    }
    
    //save bmi record in realm database
    func saveBMIRecord(){
        if(bmiRecord != nil){
            bmiRecord?.create()
            bmiRecord = nil
        }
    }
   
    @IBAction func doneAction(_ sender: Any) {
        //if data valid then save personal information and the BMI record
        if(isDataValid()){
          
            savePersonalInfo()
            saveBMIRecord()
            //switch the bmi tracking screen
            (UIApplication.shared.keyWindow?.rootViewController as! UITabBarController).selectedIndex = 0

            
        }
    }
    
}

