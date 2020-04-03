//
//  ViewController.swift
//  KVC-KVO-SW
//
//  Created by Marentilo on 03.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        
    }
    
    private let titles = ["Gender", "FirstName", "LastName", "Grade", "DateOfBirth"]
    
    private let genderController : UISegmentedControl = {
        let segmentController = UISegmentedControl(items: ["Male", "Female"])
        return segmentController
    } ()

    private let firstNameField : UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter name"
        return textField;
    } ()
    
    private let lastNameField : UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter lastName"
        return textField;
    } ()
    
    private let gradeField : UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter grade"
        return textField;
    } ()
    
    private let dateOfBirthField : UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter date"
        return textField;
    } ()
    
    private let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "dd-MMMM-YYYY"
        return formatter
    } ()
    
    private var student : Student!
    
    private var students = [Student]()
    
    func setupView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "id")
        
        let student = Student()
        self.student = student
        
        student.addObserver(self, forKeyPath: "firstName", options: [.new, .old], context: nil)
        student.addObserver(self, forKeyPath: "lastName", options: [.new, .old], context: nil)
        student.addObserver(self, forKeyPath: "grade", options: [.new, .old], context: nil)
        student.addObserver(self, forKeyPath: "genderRaw", options: [.new, .old], context: nil)
        student.addObserver(self, forKeyPath: "dateOfBirth", options: [.new, .old], context: nil)
        
        var students = [Student]()
        for _ in 0...15 {
            let stud = Student()
            students.append(stud)
        }
        
        for index in 0..<students.count {
            students[index].friend = index != students.count - 1 ? students[index + 1] : student
        }
        
        student.friend = students[0]
        students.append(student)
        
        var key = "friend"
        var addKey = ".friend"
        
        for student in students {
            
            print("------------------------\n\(student) will change name")
            if let name = students.randomElement()!.value(forKeyPath: "\(key).firstName") {
                student.setValue(name, forKeyPath: "firstName")
            }
            print("\(student) did change name\n------------------------")
            key += addKey
        }
        
        self.students = students
        
        
        
        print((self.students as AnyObject).value(forKeyPath: "@count")!)
        print("The earliest: \(((self.students as AnyObject).value(forKeyPath: "@min.dateOfBirth"))!)")
        print("The oldest \((self.students as AnyObject).value(forKeyPath: "@max.dateOfBirth")!)")
        print("Max grade : \((((self.students as AnyObject).value(forKeyPath: "@max.grade")) as! NSNumber).floatValue)")
        print("Min grade : \((((self.students as AnyObject).value(forKeyPath: "@min.grade")) as! NSNumber).floatValue)")
        print("Sum grade : \((((self.students as AnyObject).value(forKeyPath: "@sum.grade")) as! NSNumber).floatValue)")
        print("Avf grade : \((((self.students as AnyObject).value(forKeyPath: "@avg.grade")) as! NSNumber).floatValue)")
        
        
    }
    
    func genereteButton (withTag tag : Int) -> UIButton {
        let randomButton = UIButton(type: .custom)
        randomButton.tag = tag
        randomButton.setImage(UIImage(named: "random"), for: .normal)
        randomButton.addTarget(self, action: #selector(randomButtonPressed(sender:)), for: .touchUpInside)
        return randomButton
    }
    
    func setupCell(cell: UITableViewCell, withPath indexPath: IndexPath) {
        let fields = [firstNameField, lastNameField, gradeField, dateOfBirthField]

        let randomButton = genereteButton(withTag: indexPath.row)
        
        if indexPath.row == 0 {
            [
                genderController,
                randomButton
            ].forEach{
                cell.contentView.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
            
            randomButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20).isActive    = true
            randomButton.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 20).isActive               = true
            randomButton.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -20).isActive         = true
            
            genderController.centerYAnchor.constraint(equalTo: randomButton.centerYAnchor, constant: 0).isActive        = true
            genderController.trailingAnchor.constraint(equalTo: randomButton.leadingAnchor, constant: -20).isActive     = true
            
        } else {
            let field = fields[indexPath.row - 1]
            [
                field,
                randomButton
            ].forEach{
                cell.contentView.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
            
            randomButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20).isActive    = true
            randomButton.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 20).isActive               = true
            randomButton.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -20).isActive         = true
            
            field.trailingAnchor.constraint(equalTo: randomButton.leadingAnchor, constant: -20).isActive                = true
            field.centerYAnchor.constraint(equalTo: randomButton.centerYAnchor, constant: 0).isActive                   = true
        }
            
    }
    
    deinit {
    }
    
    // MARK: - Observer
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        print("---------observeValue---------")
        if let key = keyPath, let value = object as? Student, let changes = change {
            print("keyPath: \(key) \nofObject: \(value) \nwithChanges: \(changes)")
        }
        print("---------observeValue---------")
    }
    
    
    // MARK: - Actions
    
    @objc func randomButtonPressed (sender: UIButton) {
        switch sender.tag {
        case 0:
            student.randowGender()
            genderController.selectedSegmentIndex = student.gender.rawValue
        case 1:
            student.randomName()
            firstNameField.text = student.firstName
        case 2:
            student.randomLastName()
            lastNameField.text = student.lastName
        case 3:
            student.randomGrade()
            gradeField.text = String(format: "%.2f", student.grade)
        case 4:
            student.randomDate()
            dateOfBirthField.text = dateFormatter.string(from: student.dateOfBirth)
        default:
            break
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        setupCell(cell: cell, withPath: indexPath)
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

