//
//  MaterialInfoViewController.swift
//  ProyectoFinal - Organizador de Apuntes
//
//  Created by Alumno on 13/03/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit
import CoreData

protocol protocolManageMaterial {
    func addMaterial(material: Note, listImages: [UIImage])
    func delMaterial(material: Note)
    func getNextImageId() -> Int
}

class MaterialInfoViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfTopic: UITextField!
    @IBOutlet weak var tfPartial: UITextField!
    @IBOutlet weak var btDelete: UIButton!
    
    var isNewNote: Bool!
    var noteText: String!
    var listImages: [UIImage]!
    var currentCourse: Course!
    var materialView: protocolManageMaterial!
    var currentNote: Note!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isNewNote {
            self.title = "Info de " + currentNote.name!
            tfName.text = currentNote.name
            tfTopic.text = currentNote.topic
            tfPartial.text = String(currentNote.partial)
            datePicker.setDate(currentNote.date! as Date, animated: false)
        } else {
            self.title = "Info de Nueva Nota"
            btDelete.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveMaterialInfo(_ sender: UIButton) {
        if let materialName = tfName.text, let materialTopic = tfTopic.text, let materialPartial = tfPartial.text, !materialName.isEmpty, !materialTopic.isEmpty, !materialPartial.isEmpty {
            let materialDate = datePicker.date
            let material = Note(context: PersistenceService.context)
            material.name = materialName
            material.topic = materialTopic
            material.partial = Int16(materialPartial)!
            material.text = noteText
            material.date = NSDate(timeInterval: 0, since: materialDate)
            materialView.addMaterial(material: material, listImages: listImages)
            navigationController?.popToViewController(materialView as! CourseMaterialViewController, animated: true)
        } else {
            let alert = UIAlertController(title: "Faltan datos", message: "Es necesario llenar todos los campos", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteCourse(_ sender: UIButton) {
        print(currentNote.name!)
        materialView.delMaterial(material: currentNote)
        navigationController?.popViewController(animated: true)
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
