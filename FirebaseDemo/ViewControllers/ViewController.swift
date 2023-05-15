//
//  ViewController.swift
//  FirebaseDemo
//
//  Created by sahil bhatia on 10/05/23.
//  Copyright © 2023 sahil bhatia. All rights reserved.
//

import UIKit

public protocol FirstViewControllerDelegate: class {
    func navigateToNextPage()
}
class ViewController: UIViewController {

    weak var delegate: FirstViewControllerDelegate?
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did Load")
        self.setCornerRadiusOnButtons()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func setCornerRadiusOnButtons() {
        self.loginBtn.layer.cornerRadius = self.loginBtn.frame.height/2
        self.signUpButton.layer.cornerRadius = self.signUpButton.frame.height/2
    }

    @IBAction func loginButtonAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: Identifiers.loginViewController.rawValue) as! LoginViewController
        let fireBaseManager: FireBaseManagerHelper = FirebaseAuthManager()
        let viewModel:LoginViewModelHelper = LoginViewModel(authManagerHelper: fireBaseManager)
        vc.loginViewModelHelper = viewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: Identifiers.signUpViewController.rawValue) as! SignUpViewController
        let fireBaseManager: FireBaseManagerHelper = FirebaseAuthManager()
        let viewModel:SignUpViewModelHelper = SignUpViewModel(authManagerHelper: fireBaseManager)
        vc.signUpViewModelHelper = viewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

