//
//  EmployeesCell.swift
//  FirebaseDemo
//
//  Created by sahil bhatia on 11/05/23.
//  Copyright © 2023 sahil bhatia. All rights reserved.
//

import UIKit

class EmployeesCell: UITableViewCell {

    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblSalary: UILabel!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setEmployeesData(employee: Employee) {
        self.lblSalary.text = "Salary:  " + "\(employee.salary)"
        self.lblName.text = "Name:  " + employee.name
        self.lblPosition.text = "Position:  " + employee.position
    }
    
}
