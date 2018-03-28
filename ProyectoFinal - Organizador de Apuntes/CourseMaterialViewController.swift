//
//  CourseMaterialViewController.swift
//  ProyectoFinal - Organizador de Apuntes
//
//  Created by Alumno on 3/13/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit
import CoreData

class CourseMaterialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, protocolManageMaterial {
    
    @IBOutlet weak var tableView: UITableView!
    var isTheory : Bool!
    var lastSelectedCell : Int!
    var currentCourse : Course!
    var listNotes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isTheory {
            self.title = currentCourse.name! + ": Teoría"
        } else {
            self.title = currentCourse.name! + ": Práctica"
        }
        
        let notesRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "isTheory == %@ AND belongsTo.name == %@", NSNumber(value: isTheory), currentCourse.name!)
        notesRequest.predicate = predicate
        
        do {
            let data = try PersistenceService.context.fetch(notesRequest)
            listNotes = data
            tableView.reloadData()
        } catch {
            // TODO: Update this to improve error handling
            print("Could not retrieve data from notes")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "cellMaterial") as! MaterialTableViewCell
        celda.lbName.text = listNotes[indexPath.row].name
        return celda
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
    
    // MARK: - protocolManageMaterial methods
    
    func addMaterial(material: Note, listImages: [UIImage]) {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        var cont: Int = CoreDataUtilities.getNextImageId()
        
        material.isTheory = self.isTheory
        currentCourse.addToHasNote(material)
        
        for image in listImages {
            let path = documentDirectory.appendingPathComponent(String(cont))
            var successWrite: Bool = false
            
            if let imageAsData = UIImagePNGRepresentation(image) {
                successWrite = NSData(data: imageAsData).write(toFile: path, atomically: true)
            } else if let imageAsData = UIImageJPEGRepresentation(image, 1.0){
                successWrite = NSData(data: imageAsData).write(toFile: path, atomically: true)
            }
            
            if successWrite {
                let imageAsCoreData = Image(context: PersistenceService.context)
                imageAsCoreData.id = Int32(cont)
                material.addToHasImage(imageAsCoreData)
                cont = cont + 1
            } else {
                print("Could not save image #", cont)
            }
        }
        
        listNotes.append(material)
        PersistenceService.saveContext()
        tableView.reloadData()
    }
    
    func delMaterial(material: Note) {
        PersistenceService.context.delete(material)
        listNotes.remove(at: lastSelectedCell)
        self.tableView.reloadData()
        PersistenceService.saveContext()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "noteContent" {
            let viewNoteContent = segue.destination as! NoteContentViewController
            let indexPath = tableView.indexPathForSelectedRow!
            viewNoteContent.materialView = self
            viewNoteContent.currentCourse = self.currentCourse
            viewNoteContent.currentNote = listNotes[indexPath.row]
            viewNoteContent.isNewNote = false
        } else if segue.identifier == "newNote" {
            let viewNoteContent = segue.destination as! NoteContentViewController
            viewNoteContent.currentCourse = self.currentCourse
            viewNoteContent.materialView = self
            viewNoteContent.isNewNote = true
        } else {
            let viewMaterialInfo = segue.destination as! MaterialInfoViewController
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview! as! MaterialTableViewCell
            let indexPath = tableView.indexPath(for: cell)!
            lastSelectedCell = indexPath.row
            
            viewMaterialInfo.currentNote = listNotes[lastSelectedCell]
            viewMaterialInfo.isNewNote = false
            viewMaterialInfo.materialView = self
        }
    }

}
