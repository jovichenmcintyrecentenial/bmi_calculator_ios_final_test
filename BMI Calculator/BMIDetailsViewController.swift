//
//  BMIDetailsViewController.swift
//  BMI Calculator
//
//  Created by Jovi on 15/12/2022.
//

import UIKit

class BMIDetailsViewController: BMIBaseViewController {

    var delegate:DimissedDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onDoneAction(_ sender: Any) {
        if(bmiRecord != nil && validateMeasurements() == nil){
            bmiRecord?.create()
            delegate?.onDismissed(nil)
            dismiss(animated: true)
        }
    }
}
