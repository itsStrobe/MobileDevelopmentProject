//
//  NoteTypeSelectionViewController.swift
//  Organizador De Apuntes
//
//  Created by Alumno on 3/9/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit

class NoteTypeSelectionViewController: UIViewController {
    
    var currentCourse : Course!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = currentCourse.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewMaterial = segue.destination as! CourseMaterialViewController
        
        viewMaterial.currentCourse = self.currentCourse
        if segue.identifier == "practice" {
            viewMaterial.isTheory = false
        }
        else {
            viewMaterial.isTheory = true
        }
    }

}
