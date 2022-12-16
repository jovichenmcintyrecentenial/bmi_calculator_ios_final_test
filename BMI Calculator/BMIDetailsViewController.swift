//
//  BMIDetailsViewController.swift
//  BMI Calculator
//
//  Created by Jovi on 15/12/2022.
//

import UIKit
import RealmSwift
import NotificationBannerSwift

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
    
    func isDataValid()->Bool{
        var error:String? = nil
        

        error = validateMeasurements()
        
        
        //display banner showing user error for required field
        if(error != nil){
            let banner = NotificationBanner(title: title, subtitle: error!, style: .danger)
            banner.show()
            return false
        }
        
        return true
    }
    
    
    @IBAction func onDoneAction(_ sender: Any) {
        if(isDataValid() && bmiRecord != nil  ){
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
