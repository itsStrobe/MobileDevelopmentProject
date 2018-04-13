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
    @IBOutlet weak var btNewPhoto: UIButton!
    @IBOutlet weak var btPhotoLibrary: UIButton!
    @IBOutlet weak var btSaveEdit: UIButton!
    
    var isNewNote: Bool!
    var originalImagesCount: Int!
    var listImages: [UIImage]!
    var listImagesId: [Int]!
    var listImagesCoreData : [Image]!
    var listImagesCoreDataToDelete: [Image]!
    var nextImageId: Int!
    var currentCourse: Course!
    var currentNote: Note!
    var materialView: protocolManageMaterial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listImages = [UIImage]()
        listImagesId = [Int]()
        listImagesCoreDataToDelete = [Image]()
        nextImageId = CoreDataUtilities.getNextImageId()
        
        if !isNewNote {
            self.title = currentNote.name
            tvNoteText.text = currentNote.text
            tvNoteText.isEditable = false
            btNewPhoto.isEnabled = false
            btPhotoLibrary.isEnabled = false
            btSaveEdit.setTitle("Editar", for: .normal)
            loadImages()
            originalImagesCount = listImages.count
        } else {
            self.title = "Nueva Nota"
            originalImagesCount = 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadImages() {
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
    
    func saveNewImages() {
        var imageId = CoreDataUtilities.getNextImageId()
        
        for index in originalImagesCount ..< listImages.count {
            if CoreDataUtilities.saveToDocumentDirectory(image: listImages[index], id: imageId) {
                let imageAsCoreData = Image(context: PersistenceService.context)
                imageAsCoreData.id = Int32(imageId)
                currentNote.addToHasImage(imageAsCoreData)
                imageId = imageId + 1
            } else {
                print("Could not save image #", imageId)
            }
        }
        PersistenceService.saveContext()
    }
    
    func deleteUndesiredImages() {
        for imageCoreData in listImagesCoreDataToDelete {
            CoreDataUtilities.deleteImageFromDocumentDirectory(id: Int(imageCoreData.id))
            PersistenceService.context.delete(imageCoreData)
        }
        PersistenceService.saveContext()
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
    
    @IBAction func eliminatePhoto(_ sender: UIButton) {
        let view = sender.superview!
        let cell = view.superview! as! ImageTableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        
        if indexPath.row < originalImagesCount {
            // This executes when the image to be deleted is part of the images that
            // were already attached to the currentNote.
            listImagesCoreDataToDelete.append(listImagesCoreData[indexPath.row])
            listImagesCoreData.remove(at: indexPath.row)
            originalImagesCount = originalImagesCount - 1
        } else {
            // This executes when the image to be deleted is one that was not part of the
            // images that were already attached to the currentNote (it was just recently
            // added in this view).
            nextImageId = nextImageId - 1
        }
        
        listImages.remove(at: indexPath.row)
        listImagesId.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if isNewNote {
            return true
        }
        
        if btSaveEdit.currentTitle == "Editar" {
            btSaveEdit.setTitle("Guardar", for: .normal)
            btNewPhoto.isEnabled = true
            btPhotoLibrary.isEnabled = true
            tvNoteText.isEditable = true
            tableView.reloadData()
            return false
        }
        
        let confirmationAlert = UIAlertController(title: "¿Estás seguro de que deseas guardar los cambios?", message: "El texto y las fotos iniciales (en caso de haberse borrado) no podrán recuperarse. Deberás registrarlas nuevamente.", preferredStyle: .alert)
        
        confirmationAlert.addAction(UIAlertAction(title: "Confirmar", style: .default, handler: { (action: UIAlertAction!) in
            self.saveNewImages()
            self.deleteUndesiredImages()
            self.navigationController?.popViewController(animated: true)
        }))
        
        confirmationAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        present(confirmationAlert, animated: true, completion: nil)
        return false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewMaterialInfo = segue.destination as! MaterialInfoViewController
        viewMaterialInfo.noteText = tvNoteText.text
        viewMaterialInfo.currentCourse = self.currentCourse
        viewMaterialInfo.materialView = self.materialView
        viewMaterialInfo.isNewNote = self.isNewNote
        viewMaterialInfo.listImages = self.listImages
        viewMaterialInfo.materialType = 0
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
        
        print(btSaveEdit.currentTitle!)
        
        if btSaveEdit.currentTitle! == "Editar" {
            cell.btDelete.isHidden = true
        } else {
            cell.btDelete.isHidden = false
        }
        
        return cell
    }
    
}
