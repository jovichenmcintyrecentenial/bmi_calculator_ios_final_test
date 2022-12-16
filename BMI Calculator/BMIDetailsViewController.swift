//
//  BMIDetailsViewController.swift
//  BMI Calculator
//
//  Created by Jovi on 15/12/2022.
//

import UIKit
import RealmSwift

class BMIDetailsViewController: BMIBaseViewController {

    @IBOutlet weak var pageTitle: UILabel!
    var delegate:DimissedDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(pageState == .update){
            pageTitle.text = "Update record"
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onDoneAction(_ sender: Any) {
        if(bmiRecord != nil && validateMeasurements() == nil){
            if(pageState == .new){
                bmiRecord?.create()
            }
            else{
                let realm = try! Realm()
                try! realm.write {
                    bmiRecordToUpdate?.bmi = bmiRecord?.bmi
                    bmiRecordToUpdate?.height = bmiRecord!.height
                    bmiRecordToUpdate?.weight = bmiRecord!.weight
                    bmiRecordToUpdate?.measurementSystem = bmiRecord!.measurementSystem
                    bmiRecordToUpdate!.date = Date.now

                }
            }
            delegate?.onDismissed(nil)
            dismiss(animated: true)
        }
    }
}
