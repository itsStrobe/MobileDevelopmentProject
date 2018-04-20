//
//  UITextFieldExtension.swift
//  ProyectoFinal - Organizador de Apuntes
//
//  Created by Alumno on 20/04/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func loadDropdownData(data: [String]) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        //toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(doneClick))
        toolBar.setItems([flexible, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.inputView = CustomPickerView(pickerData: data, dropdownField: self)
        self.inputAccessoryView = toolBar
    }
    
    @objc func doneClick() {
        self.resignFirstResponder()
    }
}
