//
//  ViewController.swift
//  ProyectoFinal - Organizador de Apuntes
//
//  Created by Alumno on 3/9/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, protocolManageCourses {
    
    @IBOutlet weak var tableView: UITableView!
    
    var listCourses = [Course]()
    var lastSelectedCell : Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cursos"
        
        let coursesRequest: NSFetchRequest<Course> = Course.fetchRequest()
        
        do {
            let data = try PersistenceService.context.fetch(coursesRequest)
            listCourses = data
            tableView.reloadData()
        } catch {
            // TODO: Update this to improve error handling
            print("Could not retrieve data from courses")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDelegate and UITableViewDataSource methods.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "cellCourse") as! CustomTableViewCell
        celda.lbName.text = listCourses[indexPath.row].name
        return celda
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
    
    
    // MARK: - protocolManageCourses methods.
    
    func addCourse(course: Course) {
        PersistenceService.saveContext()
        self.listCourses.append(course)
        self.tableView.reloadData()
    }
    
    func delCourse(course: Course) {
        // Check if the course has notes.
        if let courseNotes = course.hasNote?.allObjects {
            // Iterate over each note.
            for note in courseNotes {
                // Check if the note has images attached to it.
                if let noteImages = (note as! Note).hasImage?.allObjects {
                    // Iterate over the images attached to the note and delete them.
                    for image in noteImages {
                        CoreDataUtilities.deleteImageFromDocumentDirectory(id:  Int((image as! Image).id))
                        PersistenceService.context.delete(image as! NSManagedObject)
                    }
                }
                // Delete the note.
                PersistenceService.context.delete(note as! NSManagedObject)
            }
        }
        
        // Check if the course has video links.
        if let courseVideoLinks = course.hasVideoLink?.allObjects {
            // Iterate over the video links and delete them.
            for videoLink in courseVideoLinks {
                PersistenceService.context.delete(videoLink as! NSManagedObject)
            }
        }
        
        // Check if the course has documents.
        if let courseDocuments = course.hasDocument?.allObjects {
            // Iterate over the documents and delete them.
            for document in courseDocuments {
                PersistenceService.context.delete(document as! NSManagedObject)
            }
        }
        
        PersistenceService.context.delete(course)
        PersistenceService.saveContext()
        listCourses.remove(at: lastSelectedCell)
        self.tableView.reloadData()
    }
    
    func editCourse() {
        PersistenceService.saveContext()
    }

     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newCourse" {
            let viewCourseInfo = segue.destination as! CourseInfoViewController
            viewCourseInfo.isNew = true
            viewCourseInfo.courseView = self
        } else if segue.identifier == "editCourse" {
            let viewCourseInfo = segue.destination as! CourseInfoViewController
            viewCourseInfo.isNew = false
            viewCourseInfo.courseView = self
            
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview! as! CustomTableViewCell
            
            let indexPath = tableView.indexPath(for: cell)!
            lastSelectedCell = indexPath.row
            viewCourseInfo.currentCourse = listCourses[lastSelectedCell]
        } else {
            let viewCourseMaterial = segue.destination as! NoteTypeSelectionViewController
            let indexPath = tableView.indexPathForSelectedRow!
            viewCourseMaterial.currentCourse = listCourses[indexPath.row]
        }
     }
}

