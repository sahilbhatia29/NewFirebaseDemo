//
//  Helper.swift
//  FirebaseDemo
//
//  Created by sahil bhatia on 15/05/23.
//  Copyright © 2023 sahil bhatia. All rights reserved.
//

import Foundation
class Helper {
    
    let jsonFile = "JsonData"
    let type = "json"
    static let shared: Helper = Helper()
    private init() {
        
    }
    // Copy the file from Main Bundle to Documents Folder as we can only write on file if it is placed in Documents Directory
     func copyFileFromBundleToDocumentsFolder(sourceFile: String, destinationFile: String = "") {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        if let documentsURL = documentsURL {
            let sourceURL = Bundle.main.bundleURL.appendingPathComponent(sourceFile)

            // Use the same filename if destination filename is not specified
            let destURL = documentsURL.appendingPathComponent(!destinationFile.isEmpty ? destinationFile : sourceFile)
            do {
                if !FileManager.default.fileExists(atPath: destURL.path) {
                try FileManager.default.copyItem(at: sourceURL, to: destURL)
                print("\(sourceFile) was copied successfully.")
                } else {
                    print("File Already Present")
                }
            } catch (let error) {
                print(error)
            }
        }
    }
    
    // Check For already existing JSON File
     func checkIfJsonFileExists() -> Bool {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent(self.jsonFile).appendingPathExtension(self.type)
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                return true
            } else {
                return false
            }
        } catch {
            print(error)
        }
        return false
    }
    
    // Delete JSON File
     func deleteDataFromJSON() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent(self.jsonFile).appendingPathExtension(self.type)
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                try FileManager.default.removeItem(at: fileUrl)
                print("File removed successfully")
            }
        } catch {
            print(error)
        }
    }
    
    // Returns Company Name from JSON File
     func getCompanyName() -> String {
        if let jsonData = self.getDataFromJsonFile() {
            let company = jsonData[CollectionKeys.collection.rawValue] as? [String: Any]
            let companyName = company?[CollectionKeys.companyName.rawValue] as? String
            return companyName ?? ""
        }
        
        return ""
    }
    
    // Returns Document Id from JSON File
     func getDocumentID() -> String {
        if let jsonData = self.getDataFromJsonFile() {
            let company = jsonData[CollectionKeys.collection.rawValue] as? [String: Any]
            let documentId = company?[CollectionKeys.documentId.rawValue] as? String
            return documentId ?? ""
        }
        
        return ""
    }
    
    // Return A dictionary containg all data in JSON File
     func getDataFromJsonFile() -> [String:AnyObject]?  {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        if documentsURL != nil {
            let fileURL = URL(fileURLWithPath: self.jsonFile, relativeTo: documentsURL).appendingPathExtension(self.type)
            do {
                // Get the saved data
                let savedData = try Data(contentsOf: fileURL)
                // Convert the data back into a string
                if let savedString = String(data: savedData, encoding: .utf8) {
                    print(savedString)
                    return self.convertStringToDictionary(text: savedString)
                }
            } catch {
                // Catch any errors
                print("Unable to read the file")
            }
        }
        return nil
    }
    
    
     func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
}
