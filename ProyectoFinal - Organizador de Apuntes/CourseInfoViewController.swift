//
//  CourseInfoViewController.swift
//  ProyectoFinal - Organizador de Apuntes
//
//  Created by Alumno on 3/9/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit

protocol protocolManageCourses {
    func addCourse(course: Course)
    func delCourse(course: Course)
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveCourse(_ sender: UIButton) {
        if let name = lbCourseName.text , !name.isEmpty {
            let course = Course(context: PersistenceService.context)
            course.name = name
            course.professor = lbProfessorName.text
            course.email = lbEmail.text
            course.office = lbOffice.text
            course.tutoring = lbOffice.text
            courseView.addCourse(course: course)
            navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Faltan datos", message: "El campo nombre es obligatorio.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteCourse(_ sender: UIButton) {
        courseView.delCourse(course: currentCourse)
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
