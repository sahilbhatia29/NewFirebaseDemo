//
//  EmployessDataModel.swift
//  FirebaseDemo
//
//  Created by sahil bhatia on 11/05/23.
//  Copyright © 2023 sahil bhatia. All rights reserved.
//

import Foundation

struct CompanyDataModel: Codable {
    let companies: [Company]
}

// MARK: - Company
struct Company: Codable {
    let companyName: String
    let employess: [Employee]
}

// MARK: - Employee
struct Employee: Codable {
    let name, position: String
    let salary: Int
}
