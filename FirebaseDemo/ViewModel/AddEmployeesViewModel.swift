//
//  AddEmployeesViewModel.swift
//  FirebaseDemo
//
//  Created by sahil bhatia on 14/05/23.
//  Copyright © 2023 sahil bhatia. All rights reserved.
//

import Foundation

protocol AddEmployeesViewModelHelper {
    func saveEmployeeInformation(_ employeeName: String, _ position: String, _ salary: Int64, isSuccess: @escaping (_ success: Bool) -> Void)
    func editEmployeeInformation(_ employeeName: String, _ position: String, _ salary: Int64, isSuccess: @escaping (_ success: Bool) -> Void)
    var employee: Employee? {get set}
    var documentId: String? {get}
    var companyName: String? {get}
    
}

class AddEmployeesViewModel: AddEmployeesViewModelHelper {
    
    init(employee: Employee, documentID: String, companyName: String) {
        self.employee = employee
        self.documentId = documentID
        self.companyName = companyName
    }
    
    init(companyName: String) {
        self.companyName = companyName
    }
    
    var employee: Employee?
    var documentId: String?
    var companyName: String?
    func saveEmployeeInformation(_ employeeName: String, _ position: String, _ salary: Int64, isSuccess: @escaping (_ success: Bool) -> Void) {
        let employees = [[CollectionKeys.name.rawValue: employeeName, CollectionKeys.position.rawValue: position, CollectionKeys.salary.rawValue: salary]] as [[String : Any]]
        DatabaseManager.shared.addEmployessToCompany(companyName: "\(self.companyName ?? "")", employees: employees) { (success) in
            if success {
                isSuccess(true)
            } else {
                isSuccess(false)
            }
        }
    }
    
    func editEmployeeInformation(_ employeeName: String, _ position: String, _ salary: Int64, isSuccess: @escaping (_ success: Bool) -> Void) {
        let newEmployeeInfo = [[CollectionKeys.name.rawValue: employeeName, CollectionKeys.position.rawValue: position, CollectionKeys.salary.rawValue: salary]] as [[String : Any]]
        let oldEmployeeInfo = [[CollectionKeys.name.rawValue: self.employee?.name ?? "", CollectionKeys.position.rawValue: self.employee?.position ?? "", CollectionKeys.salary.rawValue: self.employee?.salary ?? 0]]
        DatabaseManager.shared.editEmployeeInformation(companyName: self.companyName ?? "", documentId: self.documentId ?? "", employeeInfo: oldEmployeeInfo, newEmployeeInfo: newEmployeeInfo) { (success) in
            if success {
                isSuccess(true)
            } else {
                isSuccess(false)
            }
        }
    }
}
