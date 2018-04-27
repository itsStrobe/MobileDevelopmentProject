//
//  CustomPickerView.swift
//  ProyectoFinal - Organizador de Apuntes
//
//  Created by Alumno on 20/04/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import Foundation
import UIKit

class CustomPickerView : UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var pickerData : [String]!
    var pickerTextField : UITextField!
    
    init(pickerData: [String], dropdownField: UITextField) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.pickerData = pickerData
        self.pickerTextField = dropdownField
        
        self.delegate = self
        self.dataSource = self
        
        DispatchQueue.main.async(execute: {
            if pickerData.count > 0 {
                self.pickerTextField.text = self.pickerData[0]
                self.pickerTextField.isEnabled = true
            } else {
                self.pickerTextField.text = nil
                self.pickerTextField.isEnabled = false
            }
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Sets number of columns in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Sets the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // This function sets the text of the picker view to the content of the "pickerData" array.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = pickerData[row]
    }
}

extension CustomPickerView {
    static func loadTopics(course : Course) -> [String] {
        var setOfTopics = Set<String>()
        var listTopics = [String]()
        
        if let documents = course.hasDocument {
            for document in documents {
                setOfTopics.insert((document as! Document).topic!)
            }
        }
        
        if let notes = course.hasNote {
            for note in notes {
                setOfTopics.insert((note as! Note).topic!)
            }
        }
        
        if let videoLinks = course.hasVideoLink {
            for videoLink in videoLinks {
                setOfTopics.insert((videoLink as! VideoLink).topic!)
            }
        }
        
        for topic in setOfTopics {
            listTopics.append(topic)
        }
        
        listTopics = listTopics.sorted(by: {
            topic1, topic2 in
            return topic1 < topic2
        })
        
        return listTopics
    }
}

