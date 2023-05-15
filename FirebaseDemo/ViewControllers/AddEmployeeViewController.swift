//
//  AddEmployeeViewController.swift
//  FirebaseDemo
//
//  Created by sahil bhatia on 11/05/23.
//  Copyright © 2023 sahil bhatia. All rights reserved.
//

import UIKit

class AddEmployeeViewController: UIViewController {

    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var employeeSalaryTextField: UITextField!
    @IBOutlet weak var employeePositionTxtField: UITextField!
    @IBOutlet weak var employeeNameTextField: UITextField!
    var addemployeesViewModelHelper: AddEmployeesViewModelHelper?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDataInTextFields()
        self.btnSave.layer.cornerRadius = self.btnSave.frame.height/2
    }
    
    func setDataInTextFields() {
        if self.addemployeesViewModelHelper?.employee != nil {
            employeeNameTextField.text = self.addemployeesViewModelHelper?.employee?.name ?? ""
            employeePositionTxtField.text = self.addemployeesViewModelHelper?.employee?.position ?? ""
            employeeSalaryTextField.text = "\(self.addemployeesViewModelHelper?.employee?.salary ?? 0)"
            btnSave.setTitle("Edit", for: .normal)
        } else {
            btnSave.setTitle("Save", for: .normal)
        }
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        if self.addemployeesViewModelHelper?.employee == nil {
            self.saveEmployeeInformation()
        } else {
            self.editEmployeeInformation()
        }
    }
    
    // Save Emplyee Information in Firestore Database
    func saveEmployeeInformation() {
        if let employeeName = employeeNameTextField.text, let position = employeePositionTxtField.text, let salary = Int64(employeeSalaryTextField.text ?? "0") {
            self.addemployeesViewModelHelper?.saveEmployeeInformation(employeeName, position, salary, isSuccess: { (success) in
                if success {
                    self.showToast(message: "Employee Added Successfully")
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    self.showToast(message: "Somwthing went wrong")
                }
            })
        }
    }
    
    // Update/Edit Employee Information in Firestore Database
    func editEmployeeInformation() {
        if let employeeName = employeeNameTextField.text, let position = employeePositionTxtField.text, let salary = Int64(employeeSalaryTextField.text ?? "0") {
            self.addemployeesViewModelHelper?.editEmployeeInformation(employeeName, position, salary, isSuccess: { (success) in
                if success {
                    self.showToast(message: "Information Edited Successfully")
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    self.showToast(message: "Something went wrong")
                }
            })
        }
    }
    
    @IBAction func dismissViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
