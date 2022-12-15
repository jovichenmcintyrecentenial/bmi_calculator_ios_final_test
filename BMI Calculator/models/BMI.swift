//
//  BMI.swift
//  BMI Calculator
//
//  Created by Jovi on 15/12/2022.
//

import Foundation

class BMI {
    static func calculate(height:Double,weight:Double,measurementSystem:Int)->Double{
        

        if(measurementSystem == 0){
            return (weight*703)/(height*height)
        }
        
        return (weight)/(height*height)
    }
    
    static func getBMIDescription(bmi:Double) -> String {
        
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
