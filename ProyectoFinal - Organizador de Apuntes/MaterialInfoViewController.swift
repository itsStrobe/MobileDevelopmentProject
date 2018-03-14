//
//  MaterialInfoViewController.swift
//  ProyectoFinal - Organizador de Apuntes
//
//  Created by Alumno on 13/03/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit

protocol protocolManageMaterial {
    func addMaterial(material: Note)
    func delMaterial(material: Note)
}

class MaterialInfoViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfTopic: UITextField!
    @IBOutlet weak var tfPartial: UITextField!
    
    var noteText : String!
    var currentCourse: Course!
    var materialView : protocolManageMaterial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveMaterialInfo(_ sender: UIButton) {
        if let materialName = tfName.text, let materialTopic = tfTopic.text, let materialPartial = tfPartial.text {
            let materialDate = datePicker.date
            let material = Note(context: PersistenceService.context)
            material.name = materialName
            material.topic = materialTopic
            material.partial = Int16(materialPartial)!
            material.text = noteText
            material.date = NSDate(timeInterval: 0, since: materialDate)
            materialView.addMaterial(material: material)
        } else {
            let alert = UIAlertController(title: "Faltan datos", message: "Es necesario llenar todos los campos", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
