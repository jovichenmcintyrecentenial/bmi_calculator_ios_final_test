//
//  BMITrackingViewController.swift
//  BMI Calculator
//
//  Created by Jovi on 15/12/2022.
//

import UIKit
import RealmSwift

class BMITrackingViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var bmiRecords:Results<BMIRecord>? = nil
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bmiRecords?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BMIHistoryViewCell
        let bmiRecord:BMIRecord = bmiRecords![indexPath.row]
        let dateformat = DateFormatter()
        dateformat.dateFormat = "MMMM dd, YYYY"
        cell.dateLabel.text = dateformat.string(from: bmiRecord.date!)
        cell.bmiDescriptionLabel.text = BMI.getBMIDescription(bmi: bmiRecord.bmi)
        let unitOfmeasuement = bmiRecord.measurementSystem==1 ? "kg" : "lb"
        cell.heightWeightLabel.text = "Weight: \(bmiRecord.weight) \(unitOfmeasuement)"

        cell.bmiLabel.text = "\(String(format: "%.1f", bmiRecord.bmi)) BMI"

        return cell
    }
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bmiRecords = BMIRecord.getRecords().sorted(byKeyPath: "date", ascending: false)
    
        tableView.reloadData()

        // Do any additional setup after loading the view.
    }
    // row height
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
