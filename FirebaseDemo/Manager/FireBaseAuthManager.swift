//
//  FireBaseAuthManager.swift
//  FirebaseDemo
//
//  Created by sahil bhatia on 10/05/23.
//  Copyright © 2023 sahil bhatia. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth


protocol FireBaseManagerHelper {
    func createUserWith(email: String, password: String, completionBlock: @escaping (_ success: Bool, _ error: String, _ documentId: String) -> Void)
    func signInWith(email: String, password: String, completionBlock: @escaping (_ success: Bool, _ error: String, _ documentId: String) -> Void)
    func signOut()
    func returnTruefalse() -> Bool
}

class FirebaseAuthManager: FireBaseManagerHelper {
    
    func returnTruefalse() -> Bool {
        return false
    }
    func createUserWith(email: String, password: String, completionBlock: @escaping (_ success: Bool, _ error: String, _ documentId: String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user, error == nil {
                print(user)
                completionBlock(true, "", user.uid)
            } else {
                completionBlock(false, error!.localizedDescription, "")
            }
        }
    }
    
    func signInWith(email: String, password: String, completionBlock: @escaping (_ success: Bool, _ error: String, _ documentId: String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false, error.localizedDescription, "")
            } else {
                completionBlock(true, "", result?.user.uid ?? "")
            }
        }
    }
    
    func signOut() {
        do {
           try Auth.auth().signOut()
            Helper.shared.deleteDataFromJSON()
        }
        catch let error {
            debugPrint(error.localizedDescription)
        }
        
    }
}
