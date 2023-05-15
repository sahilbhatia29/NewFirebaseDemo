//
//  LoginViewModel.swift
//  FirebaseDemo
//
//  Created by sahil bhatia on 13/05/23.
//  Copyright © 2023 sahil bhatia. All rights reserved.
//

import Foundation

protocol LoginViewModelHelper {
    func signInWith(email: String, password: String, isSuccess: @escaping (_ success: Bool) -> Void)
    var documentId: String? {get}
    var error: String? {get}
    var companyName: String? {get set}
}
class LoginViewModel: LoginViewModelHelper {
    var companyName: String?
    
    private var authManager: FireBaseManagerHelper?
    init(authManagerHelper: FireBaseManagerHelper) {
        self.authManager = authManagerHelper
    }
    var documentId: String?
    var error: String?
    func signInWith(email: String, password: String, isSuccess: @escaping (_ success: Bool) -> Void) {
        authManager?.signInWith(email: email, password: password, completionBlock: { (success, error, documentId) in
            if success {
                self.documentId = documentId
                DatabaseManager.shared.getCompanyName(documentId) { (companyName) in
                    self.companyName = companyName
                    isSuccess(true)
                }
            } else {
                self.error = error
                isSuccess(false)
            }
        })
    }
    
}
