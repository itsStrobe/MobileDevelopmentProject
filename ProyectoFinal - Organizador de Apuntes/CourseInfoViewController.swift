//
//  CourseInfoViewController.swift
//  ProyectoFinal - Organizador de Apuntes
//
//  Created by Alumno on 3/9/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit
import CoreData

protocol protocolManageCourses {
    func addCourse(course: Course)
    func delCourse(course: Course)
    func editCourse()
}

class CourseInfoViewController: UIViewController {
    
    @IBOutlet weak var lbCourseName: UITextField!
    @IBOutlet weak var lbProfessorName: UITextField!
    @IBOutlet weak var lbEmail: UITextField!
    @IBOutlet weak var lbOffice: UITextField!
    @IBOutlet weak var lbTutoring: UITextField!
    @IBOutlet weak var btAction: UIButton!
    @IBOutlet weak var btDelete: UIButton!
    
    var isNew : Bool!
    var currentCourse : Course!
    var courseView : protocolManageCourses!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Información del Curso"
        btDelete.isHidden = true

        if isNew == false {
            lbCourseName.text = currentCourse.name
            lbProfessorName.text = currentCourse.professor
            lbEmail.text = currentCourse.email
            lbOffice.text = currentCourse.office
            lbTutoring.text = currentCourse.tutoring
            btAction.setTitle("Editar", for: .normal)
            btDelete.isHidden = false
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func isCourseRegistered(courseName: String) -> Bool {
        let coursesRequest: NSFetchRequest<Course> = Course.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "name == %@", courseName)
        coursesRequest.predicate = predicate
        
        do {
            let matchedCourses = try PersistenceService.context.fetch(coursesRequest)
            if matchedCourses.count == 0 {
                return false
            }
            return true
        } catch {
            // TODO: Update this to improve error handling
            print("Could not retrieve data from courses")
            return true
        }
    }
    
    func updateCourseValues(course: Course, name: String) {
        course.name = name
        course.professor = lbProfessorName.text
        course.email = lbEmail.text
        course.office = lbOffice.text
        course.tutoring = lbTutoring.text
    }
    
    func createCourse(name: String) {
        if !isCourseRegistered(courseName: name) {
            let course = Course(context: PersistenceService.context)
            updateCourseValues(course: course, name: name)
            courseView.addCourse(course: course)
            navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Curso ya registrado", message: "El curso '\(name)' ya existe. Por favor utilice otro nombre.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func editCourse(name: String) {
        updateCourseValues(course: currentCourse, name: name)
        courseView.editCourse()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveCourse(_ sender: UIButton) {
        if let name = lbCourseName.text , !name.isEmpty {
            if isNew {
                createCourse(name: name)
            } else {
                editCourse(name: name)
            }
        } else {
            let alert = UIAlertController(title: "Faltan datos", message: "El campo nombre es obligatorio.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteCourse(_ sender: UIButton) {
        let deleteAlert = UIAlertController(title: "¿Estás seguro de que deseas eliminar el curso?", message: "Toda la información del curso y sus contenidos serán eliminados.", preferredStyle: .alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Confirmar", style: .destructive, handler: { (action: UIAlertAction!) in
            self.courseView.delCourse(course: self.currentCourse)
            self.navigationController?.popViewController(animated: true)
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        present(deleteAlert, animated: true, completion: nil)
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
