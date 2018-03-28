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
    
    // Returns a tuple with the following elements:
    // - isRegistered: true if the note with name 'noteName' was already registered.
    //   false otherwise.
    // - courseName: if 'isRegistered' is true, it is the name of the course the 'noteName' was attached to or an empty string (if the request to CoreData
    //  failed). If 'isRegistered' is false, it is an empty String.
    func checkIfNoteExists(noteName: String) -> (isRegistered: Bool, courseName: String) {
        let notesRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "name == %@", noteName)
        notesRequest.predicate = predicate
        
        do {
            let matchedNotes = try PersistenceService.context.fetch(notesRequest)
            if matchedNotes.count == 0 {
                return (false, "")
            }
            return (true, (matchedNotes[0].belongsTo?.name)!)
        } catch {
            // TODO: Update this to improve error handling
            print("Could not retrieve data from courses")
            return (true, "")
        }
    }
    
    @IBAction func saveMaterialInfo(_ sender: UIButton) {
        if let materialName = tfName.text, let materialTopic = tfTopic.text, let materialPartial = tfPartial.text, !materialName.isEmpty, !materialTopic.isEmpty, !materialPartial.isEmpty {
            let checkResult = checkIfNoteExists(noteName: materialName)
            if !checkResult.isRegistered {
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
                var alert: UIAlertController
                if checkResult.courseName == "" {
                    alert = UIAlertController(title: "Error", message: "Hubo un error al tratar de validar si la nota ya existia", preferredStyle: .alert)
                } else {
                    alert = UIAlertController(title: "Nota ya registrada", message: "La nota '\(materialName)' ya existe en el curso '\(checkResult.courseName)'. Por favor utilice otro nombre.", preferredStyle: .alert)
                }
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Faltan datos", message: "Es necesario llenar todos los campos", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
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
