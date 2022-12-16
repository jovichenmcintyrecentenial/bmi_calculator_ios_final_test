//  NAME:
//  Jovi Chen-Mcintyre - 301125059
//
//  DESCRIPTION:
//  BMI calculator
//
//  REVISION HISTORY:
//  https://github.com/jovichenmcintyrecentenial/bmi_calculator_ios_final_test
//
//  DATE LAST MODIFIED:
//  Decemeber 11, 2022
//
//  BMIRecord.swift
//  BMI Calculator
//
//  Created by Jovi on 13/12/2022.
//
import RealmSwift
import Foundation


class BMIRecord: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var height: Double = 0
    @Persisted var weight: Double?
    @Persisted var bmi: Double?
    @Persisted var date: Date?
    @Persisted var measurementSystem: Int?
    
    //function use to save this or self obj to realm database
    func create(){
        let realm = try! Realm()
        try! realm.write {
            realm.add(self)
        }
     }
     
     //function update obj in realm database
     func update(){
         let realm = try! Realm()
         try! realm.write {
             realm.add(self, update: .modified)
         }
     }
     
     //function use to delete obj from realm database
     func delete(){
         let realm = try! Realm()
         try! realm.write {
             realm.delete(self)
         }
     }
     
     //static function use to access data for list for todoTasks from realm database
     static func getRecords()->Results<BMIRecord>{
         let realm = try! Realm()
         return realm.objects(BMIRecord.self)
     }
}
