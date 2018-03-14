//
//  NoteContentViewController.swift
//  ProyectoFinal - Organizador de Apuntes
//
//  Created by Alumno on 13/03/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit

class NoteContentViewController: UIViewController {

    @IBOutlet weak var tvNoteText: UITextView!
    var currentCourse: Course!
    var currentNote: Note!
    var materialView: protocolManageMaterial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewMaterialInfo = segue.destination as! MaterialInfoViewController
        viewMaterialInfo.noteText = tvNoteText.text
        viewMaterialInfo.currentCourse = self.currentCourse
        viewMaterialInfo.materialView = self.materialView
    }

}
