//
//  PersonalInfo.swift
//  BMI Calculator
//
//  Created by Jovi on 14/12/2022.
//

import Foundation
import RealmSwift

struct Gender{
    static var male = "male"
    static var female = "female"
    static var other = "other"

}
class PersonalInfo: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String?
    @Persisted var age: Int?
    @Persisted var height: Double?
    @Persisted var weight: Double?
    @Persisted var gender: Int?
    @Persisted var measurementSystem: Int?
    @Persisted var date: Date?
    
    //function use to save this or self obj to realm database
    func create(){
        let realm = try! Realm()
        
        do {
          try realm.write {
            realm.add(self)
          }
        } catch {
            print("errorerror")
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
    static func getPersonalData()->PersonalInfo?{
        let realm = try! Realm()
        var personalInfObjects = realm.objects(PersonalInfo.self)
        if(personalInfObjects.count > 0){
            return personalInfObjects[0]
        }
        return nil
        
    }
}
