//
//  CourseInfoViewController.swift
//  ProyectoFinal - Organizador de Apuntes
//
//  Created by Alumno on 3/9/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit

class CourseInfoViewController: UIViewController {
    
    @IBOutlet weak var lbCourseName: UITextField!
    @IBOutlet weak var lbProfessorName: UITextField!
    @IBOutlet weak var lbEmail: UITextField!
    @IBOutlet weak var lbOffice: UITextField!
    @IBOutlet weak var lbTutoring: UITextField!
    
    var courseName = ""
    var professorName = ""
    var email = ""
    var office = ""
    var tutoring = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lbCourseName.text = courseName
        lbProfessorName.text = professorName
        lbEmail.text = email
        lbOffice.text = office
        lbTutoring.text = tutoring
        
        self.title = "Informacion del Curso"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveCourse(_ sender: UIButton) {
        if let name = lbCourseName.text {
            let course = Course(context: PersistenceService.context)
            course.name = name
            course.professor = lbProfessorName.text
            course.email = lbEmail.text
            course.office = lbOffice.text
            course.tutoring = lbOffice.text
            PersistenceService.saveContext()
            navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Faltan datos", message: "El campo nombre es obligatorio.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
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
