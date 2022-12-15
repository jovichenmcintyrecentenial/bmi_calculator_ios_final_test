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
    @Persisted var weight: Double = 0
    @Persisted var bmi: Double = 0
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
