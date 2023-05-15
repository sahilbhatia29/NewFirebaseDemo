//
//  SignUpViewModel.swift
//  FirebaseDemo
//
//  Created by sahil bhatia on 12/05/23.
//  Copyright © 2023 sahil bhatia. All rights reserved.
//

import Foundation

protocol SignUpViewModelHelper {
    func createUserWith(email: String, password: String, companyName: String, isSuccess: @escaping (_ success: Bool) -> Void)
    func validateTextFields(email: String, password: String, companyName: String) -> Bool
    var documentId: String? {get}
    var error: String? {get}
    var companyName: String? {get}
}

class SignUpViewModel: SignUpViewModelHelper {
    var companyName: String?
    
    var documentId: String?
    var error: String?
    private var authManager: FireBaseManagerHelper?
    init(authManagerHelper: FireBaseManagerHelper) {
        self.authManager = authManagerHelper
    }
    func createUserWith(email: String, password: String, companyName: String, isSuccess: @escaping (_ success: Bool) -> Void) {
        authManager?.createUserWith(email: email, password: password, completionBlock: { (success, error, documentId) in
            if success {
                self.documentId = documentId
                self.companyName = companyName
                self.createCollectionInDatabase(companyName: companyName, documentId: documentId)
                isSuccess(true)
            } else {
                self.error = error
                isSuccess(false)
            }
        })
    }
    
    
    func createCollectionInDatabase(companyName: String, documentId: String) {
        DatabaseManager.shared.createCollection(companyName: companyName, documentId: documentId)
    }
    
    func validateTextFields(email: String, password: String, companyName: String) -> Bool {
        if email.isEmpty || password.isEmpty || companyName.isEmpty {
            return false
        } else if email.isEmpty && password.isEmpty && companyName.isEmpty {
            return false
        } else {
            return true
        }
    }
}
