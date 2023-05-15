//
//  UiViewController+Extensions.swift
//  FirebaseDemo
//
//  Created by sahil bhatia on 13/05/23.
//  Copyright © 2023 sahil bhatia. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 200, y: self.view.frame.size.height-100, width: 400, height: 60))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = .systemFont(ofSize: 16.0)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func setImageOnPasswordTextField(_ textField: UITextField) -> UIButton {
        let rightButton  = UIButton(type: .custom)
        rightButton.frame = CGRect(x:0, y:0, width:20, height:20)
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        rightButton.tintColor = .black
        let eyeImage = UIImage(systemName: "eye", withConfiguration: symbolConfiguration)
        rightButton.setImage(eyeImage, for: .normal)
       // rightButton.addTarget(self, action: #selector(showHidePassword), for: .touchUpInside)
        textField.rightViewMode = .always
        textField.rightView = rightButton
        return rightButton
    }
    
}
