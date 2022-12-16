//
//  BMITrackingViewController.swift
//  BMI Calculator
//
//  Created by Jovi on 15/12/2022.
//

import UIKit
import RealmSwift

//Delegate method to use to trigger when the task details view is dismissed so this view know when to trigger a tableview update
public protocol DimissedDelegate:NSObjectProtocol {
    func onDismissed(_ sender:Any?)
}
class BMITrackingViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,DimissedDelegate {
    
    func onDismissed(_ sender: Any?) {
        loadData()
    }
    
    
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
        cell.bmiDescriptionLabel.text = BMI.getBMIDescription(bmi: bmiRecord.bmi!)
        let unitOfmeasuement = bmiRecord.measurementSystem==1 ? "kg" : "lb"
        cell.heightWeightLabel.text = "Weight: \(bmiRecord.weight.toAString()) \(unitOfmeasuement)"

        cell.bmiLabel.text = "\(String(format: "%.1f", bmiRecord.bmi!)) BMI"

        return cell
    }
    

    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData(){
        bmiRecords = BMIRecord.getRecords().sorted(byKeyPath: "date", ascending: false)
    
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        let tabBar = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController
        tabBar!.selectedIndex = 1
        // Do any additional setup after loading the view.
    }
    // row height
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! BMIDetailsViewController
        if segue.identifier == "newBMI" {
            destinationViewController.pageState = PageState.new
        }
        if segue.identifier == "updateBMI" {
            if let index  = sender {
                destinationViewController.bmiRecordToUpdate = bmiRecords![index as! Int]
                destinationViewController.pageState = PageState.update
            }
        }
        
        //set self as delegate so the modal can trigger the isDismissed function
        destinationViewController.delegate = self
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "updateBMI", sender: indexPath.row)

    }

}
