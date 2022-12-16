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
    
    func getUserData(){
        if(personalInfo != nil){
            displayUserInformation()
        }
    }
    
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
    
    func savePersonalInfo(){
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
    
    func saveBMIRecord(){
        if(bmiRecord != nil){
            bmiRecord?.create()
            bmiRecord = nil
        }
    }
   
    @IBAction func doneAction(_ sender: Any) {
        if(isDataValid()){
          
            savePersonalInfo()
            saveBMIRecord()
            (UIApplication.shared.keyWindow?.rootViewController as! UITabBarController).selectedIndex = 0

            
        }
    }
    @IBAction func resetAction(_ sender: Any) {
    }
    
}

