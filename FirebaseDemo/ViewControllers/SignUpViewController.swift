//
//  SignUpViewController.swift
//  FirebaseDemo
//
//  Created by sahil bhatia on 10/05/23.
//  Copyright © 2023 sahil bhatia. All rights reserved.
//

import UIKit
import FirebaseAuth



struct Item: Codable {
    var name: String
    var age: String
}

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var companyNameTxtField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var signUpViewModelHelper: SignUpViewModelHelper?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let btn = self.setImageOnPasswordTextField(passwordTextField)
        btn.addTarget(self, action: #selector(showHidePassword), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func showHidePassword(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    func writeJSON(_ entry: Item) {
        var array = [Item]()
        array.append(entry)
        
        do {
            let fileURL = try FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("JsonData.json")
            
            let encoder = JSONEncoder()
            try encoder.encode(array).write(to: fileURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        if (self.signUpViewModelHelper?.validateTextFields(email: emailTextField.text ?? "", password: passwordTextField.text ?? "", companyName: companyNameTxtField.text ?? ""))! {
            if let email = emailTextField.text, let password = passwordTextField.text, let companyName = self.companyNameTxtField.text {
                self.signUpViewModelHelper?.createUserWith(email: email, password: password, companyName: companyName) { (success) in
                    if success {
                        self.presentAlertController(message: "User was sucessfully created.", style: .default, documentID: self.signUpViewModelHelper?.documentId ?? "0")
                    } else {
                        self.presentAlertController(message: self.signUpViewModelHelper?.error ?? "something went wrong", style: .cancel)
                    }
                }
            }
        } else {
            self.presentAlertController(message: "Please fill all fields", style: .cancel)
        }
    }
    
    
    func presentAlertController(message: String, style: UIAlertAction.Style, documentID: String = "") {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        if style == .default {
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.navigateToEmployeesViewController()
            }))
        } else {
            alertController.addAction(UIAlertAction(title: "Cancel", style: style, handler: nil))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func navigateToEmployeesViewController() {
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(identifier: Identifiers.employeesViewController.rawValue) as! EmployessViewController
            let firBaseAuthManager: FireBaseManagerHelper = FirebaseAuthManager()
            let viewModel: EmployeesViewModelHelper = EmployeesViewModel(authManagerHelper: firBaseAuthManager, documentID: self.signUpViewModelHelper?.documentId ?? "", companyName: self.signUpViewModelHelper?.companyName ?? "")
            vc.employeesViewModelHelper = viewModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
