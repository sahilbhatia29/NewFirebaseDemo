//
//  DatabaseManager.swift
//  FirebaseDemo
//
//  Created by sahil bhatia on 12/05/23.
//  Copyright © 2023 sahil bhatia. All rights reserved.
//

import Foundation
import FirebaseFirestore

//protocol DataBaseManagerHelper {
//    func createCollection(companyName: String, documentId: String)
//    func fetchEmployessFromCollection(documentID: String, _ completionHanlder: @escaping ([String: Any]) -> Void)
//    func addEmployessToCompany(companyName: String, employees:[[String: Any]], completionBlock: @escaping (_ success: Bool) -> Void)
//    func editEmployeeInformation(companyName: String, documentId: String, employeeInfo: [[String: Any]], newEmployeeInfo: [[String: Any]], completionBlock: @escaping (_ success: Bool) -> Void)
//}

class DatabaseManager {
    
    private let database = Firestore.firestore()
    static let shared: DatabaseManager = DatabaseManager()
    private init() {
        
    }
    
    // Save JSON Data to file
    func saveJSONDataToFile(json: Data, fileName: String) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        if let documentsURL = documentsURL {
            let fileURL = documentsURL.appendingPathComponent(fileName)

            do {
                try json.write(to: fileURL, options: .atomicWrite)
            } catch {
                print(error)
            }
        }
    }
    // Get company name from Firestore Database based on Document ID
    func getCompanyName(_ documentId: String, completion: @escaping (String) -> Void){
        database.collection(CollectionKeys.collection.rawValue).document(documentId).getDocument { (snapshot, error) in
            guard let document = snapshot?.data(), error == nil else {
                return
            }
            guard let companyname = document[CollectionKeys.companyName.rawValue] as? String else {
                return
            }
            completion(companyname)
        }
    }
    
    // Create Collection in Firestore Database
    func createCollection(companyName: String, documentId: String) {
        database.collection(CollectionKeys.collection.rawValue).document(documentId).setData([CollectionKeys.companyName.rawValue: "\(companyName)"]) { (error) in
            if error == nil {
                print("Success")
                self.addInitialDataInJsonFile(companyName, documentId)
            } else {
                print(error?.localizedDescription ?? "Error")
            }
        }
    }
    
    // Fetch Employees information from database
    func fetchEmployessFromCollection(documentID: String, _ completionHanlder: @escaping ([String: Any]) -> Void) {
        database.collection(CollectionKeys.collection.rawValue).document(documentID).getDocument { (snapshot, error) in
            guard let document = snapshot, error == nil else {
                return
            }
            completionHanlder(document.data() ?? [String: Any]())
        }
    }
    
    // Add Employees to firestore Database
    func addEmployessToCompany(companyName: String, employees:[[String: Any]], completionBlock: @escaping (_ success: Bool) -> Void) {
        database.collection(CollectionKeys.collection.rawValue).whereField(CollectionKeys.companyName.rawValue, isEqualTo: "\(companyName)").getDocuments { (snapshot, error) in
            guard let document = snapshot?.documents, error == nil else {
                return
            }
            
            let documentId = document[0].documentID
            let docRef = self.database.collection(CollectionKeys.collection.rawValue).document(documentId)
            docRef.updateData([
                CollectionKeys.employees.rawValue: FieldValue.arrayUnion(employees)
                ]
                ) { (eror) in
                if eror == nil {
                    print("Success")
                    self.addEmployeesInJsonFile(companyName, employees, documentId)
                    completionBlock(true)
                } else {
                    print(eror?.localizedDescription ?? "Error")
                    completionBlock(false)
                }
            }
        }
    }
    
    // Edit Employee Information in Firestore Database
    func editEmployeeInformation(companyName: String, documentId: String, employeeInfo: [[String: Any]], newEmployeeInfo: [[String: Any]], completionBlock: @escaping (_ success: Bool) -> Void) {
        database.collection(CollectionKeys.collection.rawValue).whereField(CollectionKeys.companyName.rawValue, isEqualTo:"\(companyName)").getDocuments { (snapshot, error) in
            guard let _ = snapshot?.documents, error == nil else {
                return
            }
            
            let docRef = self.database.collection(CollectionKeys.collection.rawValue).document(documentId)
            docRef.updateData([
                CollectionKeys.employees.rawValue: FieldValue.arrayRemove(employeeInfo)
                ]
                ) { (eror) in
                if eror == nil {
                    print("Success")
                    docRef.updateData([
                        CollectionKeys.employees.rawValue: FieldValue.arrayUnion(newEmployeeInfo)
                    ]) { (newErr) in
                        if newErr == nil {
                            print("Succes")
                            self.editDataIntoJSONFile(companyName, documentId)
                            completionBlock(true)
                        } else {
                            print(newErr?.localizedDescription ?? "Error")
                            completionBlock(false)
                        }
                    }
                } else {
                    print(eror?.localizedDescription ?? "Error")
                }
            }
        }
    }
    
    // Edit Data to JSON File(Fetch data from collection and save it into JSON)
    func editDataIntoJSONFile(_ companyName: String, _ documentId: String) {
        var employees = [[String: Any]]()
        
        database.collection(CollectionKeys.collection.rawValue).whereField(CollectionKeys.companyName.rawValue, isEqualTo:"\(companyName)").getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents, error == nil else {
                return
            }
            if let employeesData = documents.first?.data()[CollectionKeys.employees.rawValue] as? [[String: Any]] {
                employees = employeesData
                let data = [CollectionKeys.collection.rawValue:[CollectionKeys.companyName.rawValue:
                    companyName, CollectionKeys.documentId.rawValue: documentId, CollectionKeys.employees.rawValue: employees]] as [String : Any]
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    self.saveJSONDataToFile(json: jsonData, fileName: "JsonData.json")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // Create JSON file in Documents Directory with initial data
    func addInitialDataInJsonFile(_ companyName: String, _ documetId: String) {
        // Copy json file from Bundle to Documents Directory to write data into it
        Helper.shared.copyFileFromBundleToDocumentsFolder(sourceFile: "JsonData.json")
        let data = [CollectionKeys.collection.rawValue:[CollectionKeys.companyName.rawValue:
            companyName, CollectionKeys.documentId.rawValue: documetId, CollectionKeys.employees.rawValue: []]] as [String : Any]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            self.saveJSONDataToFile(json: jsonData, fileName: "JsonData.json")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Add Employess into JSON File
    func addEmployeesInJsonFile(_ companyName: String, _ employees: [[String: Any]], _ documentId: String) {
        let oldData = Helper.shared.getDataFromJsonFile()
        var newData = [String: Any]()
        let company = oldData?[CollectionKeys.collection.rawValue] as? [String: Any]
        let empDict = company?[CollectionKeys.employees.rawValue] as? [[String: Any]]
        if empDict?.isEmpty ?? false{
            newData = [CollectionKeys.collection.rawValue:[CollectionKeys.companyName.rawValue:
                companyName, CollectionKeys.documentId.rawValue: documentId, CollectionKeys.employees.rawValue: employees]] as [String : Any]
        } else {
            var values = empDict?.compactMap { data -> [String: Any]? in
                guard let name = data[CollectionKeys.name.rawValue] as? String, let position = data[CollectionKeys.position.rawValue] as? String, let salary = data[CollectionKeys.salary.rawValue] as? Int else {
                    return nil
                }
                return [CollectionKeys.name.rawValue: name, CollectionKeys.position.rawValue: position, CollectionKeys.salary.rawValue: salary]
            }
            values?.append(contentsOf: employees)
            newData = [CollectionKeys.collection.rawValue:[CollectionKeys.companyName.rawValue:
                companyName, CollectionKeys.employees.rawValue: values!]] as [String : Any]
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: newData, options: .prettyPrinted)
            self.saveJSONDataToFile(json: jsonData, fileName: "JsonData.json")
        } catch {
            print(error.localizedDescription)
        }
    }
}
