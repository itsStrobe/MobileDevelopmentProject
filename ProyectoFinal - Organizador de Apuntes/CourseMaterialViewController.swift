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
    var currentCourse : Course!
    var listNotes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let celda = tableView.dequeueReusableCell(withIdentifier: "cellMaterial") as! CustomTableViewCell
        celda.lbName.text = listNotes[indexPath.row].name
        return celda
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
    
    func addMaterial(material: Note) {
        material.isTheory = self.isTheory
        currentCourse.addToHasNote(material)
        listNotes.append(material)
        PersistenceService.saveContext()
        tableView.reloadData()
    }
    
    func delMaterial(material: Note) {
        
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "noteContent" {
            
        } else if segue.identifier == "newNote" {
            let viewNoteContent = segue.destination as! NoteContentViewController
            viewNoteContent.currentCourse = self.currentCourse
            viewNoteContent.materialView = self
        } else {
            
        }
    }

}
