//
//  NoteContentViewController.swift
//  ProyectoFinal - Organizador de Apuntes
//
//  Created by Alumno on 13/03/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit
import CoreData

class NoteContentViewController: UIViewController {

    @IBOutlet weak var tvNoteText: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    var isNewNote: Bool!
    var listImages: [UIImage]!
    var listImagesId: [Int]!
    var nextImageId: Int!
    var currentCourse: Course!
    var currentNote: Note!
    var materialView: protocolManageMaterial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listImages = [UIImage]()
        listImagesId = [Int]()
        nextImageId = CoreDataUtilities.getNextImageId()
        
        if !isNewNote {
            tvNoteText.text = currentNote.text
            self.title = currentNote.name
            loadImages()
        } else {
            self.title = "Nueva Nota"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadImages() {
        var listImagesCoreData : [Image]
        let imagesRequest: NSFetchRequest<Image> = Image.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "belongsTo.name == %@", currentNote.name!)
        imagesRequest.predicate = predicate
        
        do {
            listImagesCoreData = try PersistenceService.context.fetch(imagesRequest)
        } catch {
            // TODO: Update this to improve error handling
            print("Could not retrieve images corresponding to current note.")
            return
        }
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as String
        
        for imageCoreData in listImagesCoreData {
            let imageURL = URL(fileURLWithPath: documentDirectory).appendingPathComponent(String(imageCoreData.id))
            listImages.append(UIImage(contentsOfFile: imageURL.path)!)
            listImagesId.append(Int(imageCoreData.id))
        }
    }

    @IBAction func openPhotoLibrary(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if isNewNote {
            return true
        }
        navigationController?.popViewController(animated: true)
        return false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewMaterialInfo = segue.destination as! MaterialInfoViewController
        viewMaterialInfo.noteText = tvNoteText.text
        viewMaterialInfo.currentCourse = self.currentCourse
        viewMaterialInfo.materialView = self.materialView
        viewMaterialInfo.isNewNote = self.isNewNote
        viewMaterialInfo.listImages = self.listImages
    }
}

// MARK: UIImagePickerControllerDelegate methods

extension NoteContentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage]! as! UIImage
        listImages.append(image)
        listImagesId.append(nextImageId)
        tableView.reloadData()
        nextImageId = nextImageId + 1
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UITableViewDelegate and UITableViewDataSource methods

extension NoteContentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellImage") as! ImageTableViewCell
        cell.imgView.image = listImages[indexPath.row]
        cell.imgName.text = "Imagen \(listImagesId[indexPath.row])"
        return cell
    }
    
}
