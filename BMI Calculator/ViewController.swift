//
//  ViewController.swift
//  BMI Calculator
//
//  Created by Jovi on 13/12/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
   

}

