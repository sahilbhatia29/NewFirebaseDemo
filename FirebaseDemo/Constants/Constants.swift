//
//  Constants.swift
//  FirebaseDemo
//
//  Created by sahil bhatia on 14/05/23.
//  Copyright © 2023 sahil bhatia. All rights reserved.
//

import Foundation

enum Identifiers: String {
    case loginViewController = "LoginViewController"
    case signUpViewController = "SignUpViewController"
    case employeesViewController = "EmployessViewController"
    case addEmployeesViewController = "AddEmployeeViewController"
    case viewController = "ViewController"
}

enum CellIdentifiers: String {
    case employeesCellIdentifier = "EmployeesCell"
}

enum CollectionKeys: String {
    case name = "name"
    case position = "position"
    case salary = "salary"
    case employees = "employess"
    case companyName = "companyName"
    case collection = "companies"
    case documentId = "documentId"
}

