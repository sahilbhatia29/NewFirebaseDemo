//
//  EmployessViewController.swift
//  FirebaseDemo
//
//  Created by sahil bhatia on 11/05/23.
//  Copyright © 2023 sahil bhatia. All rights reserved.
//

import UIKit
import FirebaseFirestore
class EmployessViewController: UIViewController {

    weak var delegate: SecondViewControllerDelegate?
    @IBOutlet weak var btnAddEmployees: UIButton!
    @IBOutlet weak var tblView: UITableView!
    var employeesViewModelHelper: EmployeesViewModelHelper?
    private let database = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnAddEmployees.layer.cornerRadius = self.btnAddEmployees.frame.height/2
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        self.setNavigationTitle()
        self.initView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.employeesViewModelHelper?.employeeList?.removeAll()
        self.fetchEmployess()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
        
    func setNavigationTitle() {
        self.title = self.employeesViewModelHelper?.companyName ?? ""
    }
    
    func initView() {
        self.tblView.register(UINib(nibName: "EmployeesCell", bundle: nil), forCellReuseIdentifier: CellIdentifiers.employeesCellIdentifier.rawValue)
        self.tblView.dataSource = self
        self.tblView.delegate = self
        self.tblView.rowHeight = UITableView.automaticDimension
        self.tblView.estimatedRowHeight = 60.0
    }
    
    
    func fetchEmployess() {
        if !Helper.shared.checkIfJsonFileExists() {
        self.employeesViewModelHelper?.fetchEmployess()
        } else {
            self.employeesViewModelHelper?.fetchEmployeesLocallyFromJson()
        }
        self.employeesViewModelHelper?.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tblView.reloadData()
            }
        }
    }
    
    @IBAction func signOutAction(_ sender: Any) {
        self.employeesViewModelHelper?.signOut()
        let vc = self.storyboard?.instantiateViewController(identifier: Identifiers.viewController.rawValue) as! ViewController
        self.navigationController?.pushViewController(vc, animated: true)
       // self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func addEmployess(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: Identifiers.addEmployeesViewController.rawValue) as! AddEmployeeViewController
        vc.modalPresentationStyle = .fullScreen
        let addEmployeesViewModel: AddEmployeesViewModelHelper = AddEmployeesViewModel(companyName: self.employeesViewModelHelper?.companyName ?? "")
        vc.addemployeesViewModelHelper = addEmployeesViewModel
        self.present(vc, animated: true, completion: nil)
        
    }

}

extension EmployessViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.employeesViewModelHelper?.employeeList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.employeesCellIdentifier.rawValue, for: indexPath) as? EmployeesCell else {
            fatalError("can not load cell")
        }
        cell.btnEdit.addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)
        cell.btnEdit.tag = indexPath.row
        cell.setEmployeesData(employee: (self.employeesViewModelHelper?.employeeList?[indexPath.row])!)
        //cell.setUpData(model: self.viewModelObject.productsList[indexPath.row])
        return cell
    }
    
    @objc func editButtonAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: Identifiers.addEmployeesViewController.rawValue) as! AddEmployeeViewController
        vc.modalPresentationStyle = .fullScreen
        let addEmployeesViewModelHelper = AddEmployeesViewModel(employee: (self.employeesViewModelHelper?.employeeList?[sender.tag])!, documentID: self.employeesViewModelHelper?.documentId ?? "0", companyName: self.employeesViewModelHelper?.companyName ?? "")
        vc.addemployeesViewModelHelper = addEmployeesViewModelHelper
        self.present(vc, animated: true, completion: nil)
    }
    
    
}
