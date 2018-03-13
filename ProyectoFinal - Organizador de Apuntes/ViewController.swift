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
        print("Hello")
        
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
        // Dispose of any resources that can be recreated.
    }
    
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
    
    func addCourse(course: Course) {
        self.listCourses.append(course)
        self.tableView.reloadData()
        PersistenceService.saveContext()
    }
    
    func delCourse(course: Course) {
        PersistenceService.context.delete(course)
        listCourses.remove(at: lastSelectedCell)
        self.tableView.reloadData()
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

