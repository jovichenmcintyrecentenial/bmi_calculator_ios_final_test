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
    
    //on modal dismiss load data
    func onDismissed(_ sender: Any?) {
        loadData()
    }
    
    
    var bmiRecords:Results<BMIRecord>? = nil
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bmiRecords?.count ?? 0
    }
    
    //function to render cell for each bmi record
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
    
    //pull data from releam and reload table data
    func loadData(){
        bmiRecords = BMIRecord.getRecords().sorted(byKeyPath: "date", ascending: false)
    
        //if there is no record left on reload navigate to personal details tab
        if(bmiRecords?.count == 0){
            (UIApplication.shared.keyWindow?.rootViewController as! UITabBarController).selectedIndex = 1
        }
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        //add long press for deleting a record
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
        //base on segue identifier set state of BMIDetailsViewController
        if segue.identifier == "newBMI" {
            destinationViewController.pageState = PageState.new
        }
        if segue.identifier == "updateBMI" {
            if let index  = sender {
                //pass current bmi record to destinationViewController
                destinationViewController.bmiRecordToUpdate = bmiRecords![index as! Int]
                destinationViewController.pageState = PageState.update
            }
        }
        
        //set self as delegate so the modal can trigger the isDismissed function
        destinationViewController.delegate = self
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //on tap check trigger update segue and pass index of row item
        performSegue(withIdentifier: "updateBMI", sender: indexPath.row)
    }
    
    //function for on long press hander to delete a record
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                //get current task that was long pressed
                let bmiRecord = bmiRecords![indexPath.row]
                //create an alert to confirm if user wants to delete task
                let alert = UIAlertController(title: "Delete BMI Record", message: "Are you sure you want to delete this record?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] action in
                    //delete data from realm
                    bmiRecord.delete()
                    //reload table view
                    loadData()
                }))

                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //function to swipe to edit data
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
