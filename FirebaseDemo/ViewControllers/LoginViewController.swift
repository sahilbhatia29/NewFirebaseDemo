//
//  LoginViewController.swift
//  FirebaseDemo
//
//  Created by sahil bhatia on 10/05/23.
//  Copyright © 2023 sahil bhatia. All rights reserved.
//

import UIKit

public protocol SecondViewControllerDelegate: class {
    func navigateToFirstPage()
    func navigateToThirdPage()
}

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    var loginViewModelHelper: LoginViewModelHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = self.setImageOnPasswordTextField(passwordTextField)
        btn.addTarget(self, action: #selector(showHidePassword), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    
    @objc func showHidePassword(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        self.loginViewModelHelper?.signInWith(email: email, password: password) { (success) in
            if success {
                self.navigateToEmployeesViewController()
            } else {
                self.presentAlertController(message: self.loginViewModelHelper?.error ?? "Something went wrong", style: .cancel)
            }
        }
    }
    
    func navigateToEmployeesViewController() {
        let vc = self.storyboard?.instantiateViewController(identifier: Identifiers.employeesViewController.rawValue) as! EmployessViewController
        let firBaseAuthManager: FireBaseManagerHelper = FirebaseAuthManager()
        let viewModel: EmployeesViewModelHelper = EmployeesViewModel(authManagerHelper: firBaseAuthManager, documentID: self.loginViewModelHelper?.documentId ?? "0", companyName: self.loginViewModelHelper?.companyName ?? "")
        vc.employeesViewModelHelper = viewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func registerNowAction(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(identifier: Identifiers.signUpViewController.rawValue) as! SignUpViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentAlertController(message: String, style: UIAlertAction.Style) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: style, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
