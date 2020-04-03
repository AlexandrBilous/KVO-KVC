//
//  Student.swift
//  KVC-KVO-SW
//
//  Created by Marentilo on 03.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import Foundation

@objc class Student : NSObject {
    
    public enum Gender : Int {
        case male = 0
        case female = 1
    }

    @objc public dynamic private(set) var genderRaw : NSNumber!
    
    public var gender : Gender! {
        didSet {
            self.convertGender()
        }
    }
    
    func convertGender () {
        genderRaw = NSNumber(integerLiteral: gender.rawValue)
    }
    
    let names = ["Adam", "Alex", "Aaron", "Ben", "Carl", "Dan", "David", "Edward", "Fred", "Frank", "George", "Hal", "Hank", "Ike", "John", "Jack", "Joe", "Larry", "Monte", "Matthew", "Mark", "Nathan", "Otto", "Paul", "Peter", "Roger", "Roger", "Steve", "Thomas", "Tim", "Ty", "Victor", "Walter"]
    
    let lastNames = ["Anderson", "Ashwoon", "Aikin", "Bateman", "Bongard", "Bowers", "Boyd", "Cannon", "Cast", "Deitz", "Dewalt", "Ebner", "Frick", "Hancock", "Haworth", "Hesch", "Hoffman", "Kassing", "Knutson", "Lawless", "Lawicki", "Mccord", "McCormack", "Miller", "Myers", "Nugent", "Ortiz", "Orwig", "Ory", "Paiser", "Pak", "Pettigrew", "Quinn", "Quizoz", "Ramachandran", "Resnick", "Sagar", "Schickowski", "Schiebel", "Sellon", "Severson", "Shaffer", "Solberg", "Soloman", "Sonderling", "Soukup", "Soulis", "Stahl", "Sweeney", "Tandy", "Trebil", "Trusela", "Trussel", "Turco", "Uddin", "Uflan", "Ulrich", "Upson", "Vader", "Vail", "Valente", "Van Zandt", "Vanderpoel", "Ventotla"]
    
    @objc dynamic var firstName = String()
    @objc dynamic var lastName = String()
    @objc dynamic var grade : Float = 0
    @objc dynamic var dateOfBirth = Date()
    @objc dynamic weak var friend : Student!
            
    override init() {
        super.init()
        setupStudent()
    }
    
    func setupStudent() {
        randomDate()
        randomName()
        randowGender()
        randomLastName()
        randomGrade()
    }
    
    func randomName () {
        firstName = names.randomElement() ?? "Alex"
    }
    
    func randomLastName () {
        lastName = lastNames.randomElement() ?? "Bilous"
    }
    
    func randomDate () {
        dateOfBirth = Date(timeIntervalSince1970: Double.random(in: 0...(24 * 30 * 3600 * 365)))
    }
    
    func randowGender () {
        gender = Int.random(in: 0...1000) < 500 ? .male : .female
    }
    
    func randomGrade () {
        grade = Float.random(in: 3...5)
    }
    
    override var description: String {
        return firstName + " " + lastName
    }
    
    
    override class func setValue(_ value: Any?, forKey key: String) {
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("undefinedKey" + key)
    }
    
    override func value(forUndefinedKey key: String) -> Any? {
        
        print(" valueForUndefinedKey" + key)
        return nil
    }

}
