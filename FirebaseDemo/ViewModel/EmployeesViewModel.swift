//
//  EmployeesViewModel.swift
//  FirebaseDemo
//
//  Created by sahil bhatia on 11/05/23.
//  Copyright © 2023 sahil bhatia. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol EmployeesViewModelHelper {
    func fetchEmployess()
    func fetchEmployeesLocallyFromJson()
    func signOut()
    var documentId: String? {get}
    var err: String? {get}
    var employeeList: [Employee]? {get set}
    var reloadTableView: (() -> Void)? {get set}
    var companyName: String? {get}
}

class EmployeesViewModel: EmployeesViewModelHelper {
    var companyName: String?
    
    var employeeList: [Employee]?
    var companyList = [Company]()
    var reloadTableView: (() -> Void)?
    var error: ((_ error: Error) -> Void)?
    var documentId: String?
    var err: String?
    private var authManager: FireBaseManagerHelper?
    init(authManagerHelper: FireBaseManagerHelper, documentID: String = "", companyName: String) {
        self.authManager = authManagerHelper
        self.documentId = documentID
        self.companyName = companyName
    }
    
    func signOut() {
        authManager?.signOut()
    }
    
    
    // Fetch Employees from Firestore Database
     func fetchEmployess() {
        DatabaseManager.shared.fetchEmployessFromCollection(documentID: self.documentId ?? "0") { (dict) in
            print(dict)
            let empDict = dict[CollectionKeys.employees.rawValue] as? [[String: Any]]
            if !Helper.shared.checkIfJsonFileExists() {
                DatabaseManager.shared.addInitialDataInJsonFile(self.companyName ?? "", self.documentId ?? "")
                DatabaseManager.shared.addEmployeesInJsonFile(self.companyName ?? "", empDict ?? [[String: Any]](), self.documentId ?? "")
            }
            let values = empDict?.compactMap { data -> Employee? in
                guard let name = data[CollectionKeys.name.rawValue] as? String, let position = data[CollectionKeys.position.rawValue] as? String, let salary = data[CollectionKeys.salary.rawValue] as? Int else {
                    return nil
                }
                return Employee(name: name, position: position, salary: salary)
            }
            self.employeeList = values
            self.reloadTableView?()
        }
    }
    
    // Fetch employees locally from JSON File
    func fetchEmployeesLocallyFromJson() {
        let jsonData = Helper.shared.getDataFromJsonFile()
        let company = jsonData?[CollectionKeys.collection.rawValue] as? [String: Any]
        let empDict = company?[CollectionKeys.employees.rawValue] as? [[String: Any]]
        let values = empDict?.compactMap { data -> Employee? in
            guard let name = data[CollectionKeys.name.rawValue] as? String, let position = data[CollectionKeys.position.rawValue] as? String, let salary = data[CollectionKeys.salary.rawValue] as? Int else {
                return nil
            }
            return Employee(name: name, position: position, salary: salary)
        }
        self.employeeList = values
        self.reloadTableView?()
    }
    
}

