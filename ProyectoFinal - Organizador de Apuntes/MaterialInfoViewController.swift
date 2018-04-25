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
    func addMaterial(material: VideoLink)
    func addMaterial(material: Document)
    func delMaterial(material: Note)
    func delMaterial(material: VideoLink)
    func delMaterial(material: Document)
    func editMaterial()
}

class MaterialInfoViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfTopic: UITextField!
    @IBOutlet weak var tfPartial: UITextField!
    @IBOutlet weak var btDelete: UIButton!
    @IBOutlet weak var btAction: UIButton!
    @IBOutlet weak var tfVideoLink: UITextField!
    @IBOutlet weak var stVideoLink: UIStackView!
    @IBOutlet weak var tfDocument: UITextField!
    @IBOutlet weak var stDocument: UIStackView!
    
    var materialType: Int!
    var isNewDocument: Bool!
    var isNewVideoLink: Bool!
    var isNewNote: Bool!
    var noteText: String!
    var listImages: [UIImage]!
    var materialView: protocolManageMaterial!
    var currentCourse: Course!
    var currentNote: Note!
    var currentVideoLink: VideoLink!
    var currentDocument: Document!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUI()

        stDocument.isHidden = true
        stVideoLink.isHidden = true
        
        switch materialType {
        case 0: // Handle notes.
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
        case 1: // Handle videoLinks.
            stVideoLink.isHidden = false
            if !isNewVideoLink {
                self.title = "Info de " + currentVideoLink.name!
                tfName.text = currentVideoLink.name
                tfTopic.text = currentVideoLink.topic
                tfPartial.text = String(currentVideoLink.partial)
                datePicker.setDate(currentVideoLink.date! as Date, animated: false)
                tfVideoLink.text = currentVideoLink.link
            } else {
                self.title = "Info de Nuevo Video"
                btDelete.isHidden = true
            }
        case 2: // Handle documents.
            stDocument.isHidden = false
            if !isNewDocument {
                self.title = "Info de " + currentDocument.name!
                tfName.text = currentDocument.name
                tfTopic.text = currentDocument.topic
                tfPartial.text = String(currentDocument.partial)
                datePicker.setDate(currentDocument.date! as Date, animated: false)
                tfDocument.text = currentDocument.link
            } else {
                self.title = "Info de Nuevo Documento"
                btDelete.isHidden = true
            }
        default:
            break
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func customizeUI() {
        btAction.layer.cornerRadius = 0.125 * btAction.bounds.size.width
        btDelete.layer.cornerRadius = 0.125 * btDelete.bounds.size.width
        datePicker.setValue(UIColor.white, forKey: "textColor")
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
    
    // Returns a tuple with the following elements:
    // - isRegistered: true if the video link with name 'videoLinkName' was already registered, false otherwise.
    // - courseName: if 'isRegistered' is true, it is the name of the course the 'videoLink' was attached to or an empty string (if the request to CoreData failed). If 'isRegistered' is false, it is an empty String.
    func checkIfVideoLinkExists(videoLinkName: String) -> (isRegistered: Bool, courseName: String) {
        let videoLinkRequest: NSFetchRequest<VideoLink> = VideoLink.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "name == %@", videoLinkName)
        videoLinkRequest.predicate = predicate
        
        do {
            let matchedVideoLinks = try PersistenceService.context.fetch(videoLinkRequest)
            if matchedVideoLinks.count == 0 {
                return (false, "")
            }
            return (true, (matchedVideoLinks[0].belongsTo?.name)!)
        } catch {
            // TODO: Update this to improve error handling
            print("Could not retrieve data from courses")
            return (true, "")
        }
    }
    
    // Returns a tuple with the following elements:
    // - isRegistered: true if the video link with name 'videoLinkName' was already registered, false otherwise.
    // - courseName: if 'isRegistered' is true, it is the name of the course the 'videoLink' was attached to or an empty string (if the request to CoreData failed). If 'isRegistered' is false, it is an empty String.
    func checkIfDocumentExists(documentName: String) -> (isRegistered: Bool, courseName: String) {
        let documentRequest: NSFetchRequest<Document> = Document.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "name == %@", documentName)
        documentRequest.predicate = predicate
        
        do {
            let matchedDocuments = try PersistenceService.context.fetch(documentRequest)
            if matchedDocuments.count == 0 {
                return (false, "")
            }
            return (true, (matchedDocuments[0].belongsTo?.name)!)
        } catch {
            // TODO: Update this to improve error handling
            print("Could not retrieve data from courses")
            return (true, "")
        }
    }
    
    func saveNoteInfo(_ materialName: String, _ materialTopic: String, _ materialPartial: String) -> (isRegistered: Bool, courseName: String) {
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
        }
        return checkResult
    }
    
    func saveVideoInfo(_ materialName: String, _ materialTopic: String, _ materialPartial: String) -> (isRegistered: Bool, courseName: String) {
        let checkResult = checkIfVideoLinkExists(videoLinkName: materialName)
        if !checkResult.isRegistered {
            let materialDate = datePicker.date
            let material = VideoLink(context: PersistenceService.context)
            material.name = materialName
            material.topic = materialTopic
            material.partial = Int16(materialPartial)!
            material.date = NSDate(timeInterval: 0, since: materialDate)
            if let materialLink = tfVideoLink.text {
                material.link = materialLink
            }
            materialView.addMaterial(material: material)
        }
        return checkResult
    }
    
    func saveDocumentInfo(_ materialName: String, _ materialTopic: String, _ materialPartial: String) -> (isRegistered: Bool, courseName: String) {
        let checkResult = checkIfDocumentExists(documentName: materialName)
        if !checkResult.isRegistered {
            let materialDate = datePicker.date
            let material = Document(context: PersistenceService.context)
            material.name = materialName
            material.topic = materialTopic
            material.partial = Int16(materialPartial)!
            material.date = NSDate(timeInterval: 0, since: materialDate)
            if let materialLink = tfDocument.text {
                material.link = materialLink
            }
            materialView.addMaterial(material: material)
        }
        return checkResult
    }
    
    func saveMaterialInfo(_ materialName: String, _ materialTopic: String, _ materialPartial: String) -> (isRegistered: Bool, courseName: String) {
        var saveResult : (isRegistered: Bool, courseName: String) = (false, "")
    
        switch materialType {
        case 0:
            saveResult = saveNoteInfo(materialName, materialTopic, materialPartial)
        case 1:
            saveResult = saveVideoInfo(materialName, materialTopic, materialPartial)
        case 2:
            saveResult = saveDocumentInfo(materialName, materialTopic, materialPartial)
        default:
            break
        }
        
        return saveResult
    }
    
    func updateNoteInfo(_ materialName: String, _ materialTopic: String, _ materialPartial: String) {
        let materialDate = datePicker.date
        currentNote.name = materialName
        currentNote.topic = materialTopic
        currentNote.partial = Int16(materialPartial)!
        currentNote.date = NSDate(timeInterval: 0, since: materialDate)
    }
    
    func updateDocumentInfo(_ materialName: String, _ materialTopic: String, _ materialPartial: String) {
        let materialDate = datePicker.date
        currentDocument.name = materialName
        currentDocument.topic = materialTopic
        currentDocument.partial = Int16(materialPartial)!
        currentDocument.date = NSDate(timeInterval: 0, since: materialDate)
        if let materialLink = tfDocument.text {
            currentDocument.link = materialLink
        }
    }
    
    func updateVideoLinkInfo(_ materialName: String, _ materialTopic: String, _ materialPartial: String) {
        let materialDate = datePicker.date
        currentVideoLink.name = materialName
        currentVideoLink.topic = materialTopic
        currentVideoLink.partial = Int16(materialPartial)!
        currentVideoLink.date = NSDate(timeInterval: 0, since: materialDate)
        if let materialLink = tfVideoLink.text {
            currentVideoLink.link = materialLink
        }
    }
    
    func deleteMaterial() {
        switch materialType {
        case 0:
            materialView.delMaterial(material: currentNote)
        case 1:
            materialView.delMaterial(material: currentVideoLink)
        case 2:
            materialView.delMaterial(material: currentDocument)
        default:
            break
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - IBActions.
    
    @IBAction func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveMaterialInfo(_ sender: UIButton) {
        if let materialName = tfName.text, let materialTopic = tfTopic.text, let materialPartial = tfPartial.text, !materialName.isEmpty, !materialTopic.isEmpty, !materialPartial.isEmpty {
            
            var saveResult : (isRegistered: Bool, courseName: String) = (false, "")
            
            if isNewNote || isNewDocument || isNewVideoLink {
                saveResult = saveMaterialInfo(materialName, materialTopic, materialPartial)
            } else {
                switch materialType {
                case 0:
                    if currentNote.name != materialName {
                        saveResult = checkIfNoteExists(noteName: materialName)
                    }
                case 1:
                    if currentVideoLink.name != materialName {
                        saveResult = checkIfVideoLinkExists(videoLinkName: materialName)
                    }
                case 2:
                    if currentDocument.name != materialName {
                        saveResult = checkIfDocumentExists(documentName: materialName)
                    }
                default:
                    break
                }
                
                if !saveResult.isRegistered {
                    switch materialType {
                    case 0:
                        updateNoteInfo(materialName, materialTopic, materialPartial)
                    case 1:
                        updateVideoLinkInfo(materialName, materialTopic, materialPartial)
                    case 2:
                        updateDocumentInfo(materialName, materialTopic, materialPartial)
                    default:
                        break
                    }
                    
                    materialView.editMaterial()
                }
            }
            
            // Check if the material was already registered...
            if !saveResult.isRegistered {
                navigationController?.popToViewController(materialView as! CourseMaterialViewController, animated: true)
            } else {
                var alert: UIAlertController
                if saveResult.courseName == "" {
                    alert = UIAlertController(title: "Error", message: "Hubo un error al tratar de validar si el material ya existia", preferredStyle: .alert)
                } else {
                    alert = UIAlertController(title: "Material ya registrado", message: "El material'\(materialName)' ya existe en el curso '\(saveResult.courseName)'. Por favor utilice otro nombre.", preferredStyle: .alert)
                }
                
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Faltan datos", message: "Es necesario los campos de 'Nombre', 'Tema' y 'Parcial'", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteMaterial(_ sender: UIButton) {
        let confirmationAlert = UIAlertController(title: "¿Estás seguro de que deseas eliminar este material?", message: "El contenido almacenado será borrado de la aplicación y no podrá recuperarse. Deberás registrarlo nuevamente.", preferredStyle: .alert)
        
        confirmationAlert.addAction(UIAlertAction(title: "Confirmar", style: .default, handler: { (action: UIAlertAction!) in
            self.deleteMaterial()
        }))
        
        confirmationAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        present(confirmationAlert, animated: true, completion: nil)
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
