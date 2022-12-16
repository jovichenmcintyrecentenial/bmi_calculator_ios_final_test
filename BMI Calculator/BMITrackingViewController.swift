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
        cell.selectionStyle = .none

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
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)
        
        (UIApplication.shared.keyWindow?.rootViewController as! UITabBarController).selectedIndex = 1
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
    
    //function for on long press hander
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                //get current task that was long pressed
                let bmiRecord = bmiRecords![indexPath.row]
                //create an alert to confirm if user wants to delete task
                let alert = UIAlertController(title: "Delete BMI Record", message: "Are you sure you want to delete this record?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    //delete data from realm
                    bmiRecord.delete()
                    //reload table view
                    self.tableView.reloadData()
                  
                }))

                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit: UIContextualAction  = UIContextualAction(style: .normal, title: "Edit") {
            (action, sourceView, completionHandler) in
            //trigger edit segue
            self.performSegue(withIdentifier: "updateBMI", sender: indexPath.row)

            completionHandler(true)
            
        }

        //set edit action
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [ edit])
        //on full swipe trigger the first action
        swipeConfiguration.performsFirstActionWithFullSwipe = true
        
               
        return swipeConfiguration
        
    }

}
