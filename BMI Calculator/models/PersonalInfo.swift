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
    @Persisted var height: Double?
    @Persisted var weight: Double?
    @Persisted var gender: String?
    @Persisted var date: Date?
}
