//
//  CourseMaterialViewController.swift
//  ProyectoFinal - Organizador de Apuntes
//
//  Created by Alumno on 3/13/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit
import WebKit
import CoreData

class CourseMaterialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, protocolManageMaterial {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var materialType: UISegmentedControl!
    var isTheory : Bool!
    var lastSelectedCell : Int!
    var currentCourse : Course!
    var listNotes = [Note]()
    var listNotesToDisplay = [Note]()
    var listVideoLinks = [VideoLink]()
    var listVideoLinksToDisplay = [VideoLink]()
    var listDocuments = [Document]()
    var listDocumentsToDisplay = [Document]()
    
    @IBOutlet weak var tfTema: UITextField!
    @IBOutlet weak var tfParcial: UITextField!
    @IBOutlet weak var segCtrlSortType: UISegmentedControl!
    @IBOutlet weak var segCtrlAsc: UISegmentedControl!
    
    func displayAllNotes() {
        for note in listNotes {
            listNotesToDisplay.append(note)
        }
    }
    
    func displayAllVideoLinks() {
        for videoLink in listVideoLinks {
            listVideoLinksToDisplay.append(videoLink)
        }
    }
    
    func displayAllDocuments() {
        for document in listDocuments {
            listDocumentsToDisplay.append(document)
        }
    }
    
    func loadNotes() {
        let notesRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "isTheory == %@ AND belongsTo.name == %@", NSNumber(value: isTheory), currentCourse.name!)
        notesRequest.predicate = predicate
        
        do {
            listNotes = try PersistenceService.context.fetch(notesRequest)
            displayAllNotes()
            tableView.reloadData()
        } catch {
            // TODO: Update this to improve error handling
            print("Could not retrieve data from notes")
        }
    }
    
    func loadVideoLinks() {
        let videoLinksRequest: NSFetchRequest<VideoLink> = VideoLink.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "isTheory == %@ AND belongsTo.name == %@", NSNumber(value: isTheory), currentCourse.name!)
        videoLinksRequest.predicate = predicate
        
        do {
            listVideoLinks = try PersistenceService.context.fetch(videoLinksRequest)
            displayAllVideoLinks()
            tableView.reloadData()
        } catch {
            // TODO: Update this to improve error handling
            print("Could not retrieve data from notes")
        }
    }
    
    func loadDocuments() {
        let documentsRequest: NSFetchRequest<Document> = Document.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "isTheory == %@ AND belongsTo.name == %@", NSNumber(value: isTheory), currentCourse.name!)
        documentsRequest.predicate = predicate
        
        do {
            listDocuments = try PersistenceService.context.fetch(documentsRequest)
            displayAllDocuments()
            tableView.reloadData()
        } catch {
            // TODO: Update this to improve error handling
            print("Could not retrieve data from notes")
        }
    }
    
    
    
    func loadMaterial(type : Int) {
        listNotesToDisplay.removeAll()
        listVideoLinksToDisplay.removeAll()
        listDocumentsToDisplay.removeAll()
        
        switch type {
        case 0:
            loadNotes()
        case 1:
            loadVideoLinks()
        case 2:
            loadDocuments()
        default:
            break
        }
    }
    
    func openWebLink(link: String?, type: String?) {
        
        if let link = link, !link.isEmpty {
            // Check if link has http (or https) protocol.
            var urlLink : String
            
            if !link.hasPrefix("http") {
                urlLink = "http://" + link
            } else {
                urlLink = link
            }
            
            if let url = NSURL(string: urlLink) {
                if let type = type {
                    if urlLink.hasSuffix(type) {
                        if UIApplication.shared.canOpenURL(url as URL) {
                            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                            return
                        }
                    } else {
                        // Display alert because of invalid extension of link.
                        let alert = UIAlertController(title: "Link inválido", message: "El link no contiene la extensión '\(type)'.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        present(alert, animated: true, completion: nil)
                        return
                    }
                }
            
                if UIApplication.shared.canOpenURL(url as URL) {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                    return
                }
            }
        }
        
        // Display alert because of invalid/non-existent link.
        let alert = UIAlertController(title: "Link inválido", message: "La entrada seleccionada no contiene un link válido.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isTheory {
            self.title = currentCourse.name! + ": Teoría"
        } else {
            self.title = currentCourse.name! + ": Práctica"
        }
        
        loadMaterial(type: materialType.selectedSegmentIndex)
        //let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        //view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Filter Functions
    func filterNotes(partial : Int?, tema: String?){
        listNotesToDisplay.removeAll()
        
        if partial == nil && tema == nil {
            displayAllNotes()
        } else if partial == nil {
            for note in listNotes {
                if note.topic == tema {
                    listNotesToDisplay.append(note)
                }
            }
        } else if tema == nil {
            for note in listNotes {
                if Int(note.partial) == partial {
                    listNotesToDisplay.append(note)
                }
            }
        } else {
            for note in listNotes {
                if note.topic == tema && Int(note.partial) == partial {
                    listNotesToDisplay.append(note)
                }
            }
        }
    }
    
    func filterVideoLinks(partial : Int?, tema: String?){
        listVideoLinksToDisplay.removeAll()
        
        if partial == nil && tema == nil {
            displayAllVideoLinks()
        } else if partial == nil {
            for videoLink in listVideoLinks {
                if videoLink.topic == tema {
                    listVideoLinksToDisplay.append(videoLink)
                }
            }
        } else if tema == nil {
            for videoLink in listVideoLinks {
                if Int(videoLink.partial) == partial {
                    listVideoLinksToDisplay.append(videoLink)
                }
            }
        } else {
            for videoLink in listVideoLinks {
                print(Int(videoLink.partial))
                print(partial!)
                if videoLink.topic == tema && Int(videoLink.partial) == partial {
                    listVideoLinksToDisplay.append(videoLink)
                }
            }
        }
    }
    
    func filterDocuments(partial : Int?, tema: String?){
        listDocumentsToDisplay.removeAll()
        
        if partial == nil && tema == nil {
            displayAllDocuments()
        } else if partial == nil {
            for document in listDocuments {
                if document.topic == tema {
                    listDocumentsToDisplay.append(document)
                }
            }
        } else if tema == nil {
            for document in listDocuments {
                if Int(document.partial) == partial {
                    listDocumentsToDisplay.append(document)
                }
            }
        } else {
            for document in listDocuments {
                if document.topic == tema && Int(document.partial) == partial {
                    listDocumentsToDisplay.append(document)
                }
            }
        }
    }
    
    // MARK: - IBActions
    
    //@IBAction func hideKeyboard() {
    //    view.endEditing(true)
    //}
    
    @IBAction func createNewMaterial(_ sender: UIButton) {
        if materialType.selectedSegmentIndex == 0 {
            performSegue(withIdentifier: "newNote", sender: sender)
        } else {
            performSegue(withIdentifier: "newNotNote", sender: sender)
        }
    }
    
    @IBAction func changeMaterialType(_ sender: UISegmentedControl) {
        loadMaterial(type: sender.selectedSegmentIndex)
    }
    
    @IBAction func filterSearch(_ sender: UIButton) {
        segCtrlSortType.selectedSegmentIndex = 0
        segCtrlAsc.selectedSegmentIndex = 0
        
        var partial : Int?
        var tema : String?
        
        partial = nil
        tema = nil
        
        if let extractParcial = tfParcial.text {
            if extractParcial.trimmingCharacters(in: CharacterSet(charactersIn: " ")).count == 0 {
                partial = nil
            }
            else {
                if let partialInt = Int(extractParcial) {
                    partial = partialInt
                } else {
                    let alert = UIAlertController(title: "Dato inválido", message: "El campo de 'Parcial' debe ser numérico", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    present(alert, animated: true, completion: nil)
                    return
                }
            }
        }
        
        if tfParcial.text == nil || tfParcial.text!.trimmingCharacters(in: CharacterSet(charactersIn: " ")).count == 0 {
            partial = nil
        } else {
            if let partialInt = Int(tfParcial.text!) {
                partial = partialInt
            } else {
                let alert = UIAlertController(title: "Dato inválido", message: "El campo de 'Parcial' debe ser numérico", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }
        }
        
        if let extractTema = tfTema.text {
            if extractTema.trimmingCharacters(in: CharacterSet(charactersIn: " ")).count == 0 {
                tema = nil
            }
            else {
                tema = extractTema
            }
        }
        
        switch materialType.selectedSegmentIndex {
        case 0:
            filterNotes(partial: partial, tema: tema)
        case 1:
            filterVideoLinks(partial: partial, tema: tema)
        case 2:
            filterDocuments(partial: partial, tema: tema)
        default:
            break
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Sort Button Functions
    
    // Sorts the table when Nombre/Fecha SegmentedControl is clicked
    @IBAction func changeSortBy(_ sender: UISegmentedControl) {
        switch materialType.selectedSegmentIndex {
        case 0:
            if sender.selectedSegmentIndex == 0 {
                if segCtrlAsc.selectedSegmentIndex == 0 {
                    listNotesToDisplay = listNotesToDisplay.sorted(by: { $0.name! < $1.name!})
                }
                else {
                    listNotesToDisplay = listNotesToDisplay.sorted(by: {$0.name! > $1.name!})
                }
            }
            else {
                if segCtrlAsc.selectedSegmentIndex == 0 {
                    listNotesToDisplay = listNotesToDisplay.sorted(by: { Int($0.date!.timeIntervalSince1970) < Int($1.date!.timeIntervalSince1970)})
                }
                else {
                    listNotesToDisplay = listNotesToDisplay.sorted(by: {Int($0.date!.timeIntervalSince1970) > Int($1.date!.timeIntervalSince1970)})
                }
            }
        case 1:
            if sender.selectedSegmentIndex == 0 {
                if segCtrlAsc.selectedSegmentIndex == 0 {
                    listVideoLinks = listVideoLinks.sorted(by: { $0.name! < $1.name!})
                }
                else {
                    listVideoLinks = listVideoLinks.sorted(by: {$0.name! > $1.name!})
                }
            }
            else {
                if segCtrlAsc.selectedSegmentIndex == 0 {
                    listVideoLinks = listVideoLinks.sorted(by: { Int($0.date!.timeIntervalSince1970) < Int($1.date!.timeIntervalSince1970)})
                }
                else {
                    listVideoLinks = listVideoLinks.sorted(by: {Int($0.date!.timeIntervalSince1970) > Int($1.date!.timeIntervalSince1970)})
                }
            }
        case 2:
            if sender.selectedSegmentIndex == 0 {
                if segCtrlAsc.selectedSegmentIndex == 0 {
                    listDocuments = listDocuments.sorted(by: { $0.name! < $1.name!})
                }
                else {
                    listDocuments = listDocuments.sorted(by: {$0.name! > $1.name!})
                }
            }
            else {
                if segCtrlAsc.selectedSegmentIndex == 0 {
                    listDocuments = listDocuments.sorted(by: { Int($0.date!.timeIntervalSince1970) < Int($1.date!.timeIntervalSince1970)})
                }
                else {
                    listDocuments = listDocuments.sorted(by: {Int($0.date!.timeIntervalSince1970) > Int($1.date!.timeIntervalSince1970)})
                }
            }
        default:
            return
        }
        
        tableView.reloadData()
    }
    
    // Sorts the table when ASC/DESC SegmentedControl is clicked
    @IBAction func changeSortAsc(_ sender: UISegmentedControl) {
        switch materialType.selectedSegmentIndex {
        case 0:
            if segCtrlSortType.selectedSegmentIndex == 0 {
                if sender.selectedSegmentIndex == 0 {
                    listNotesToDisplay = listNotesToDisplay.sorted(by: { $0.name! < $1.name!})
                }
                else {
                    listNotesToDisplay = listNotesToDisplay.sorted(by: {$0.name! > $1.name!})
                }
            }
            else {
                if sender.selectedSegmentIndex == 0 {
                    listNotesToDisplay = listNotesToDisplay.sorted(by: { Int($0.date!.timeIntervalSince1970) < Int($1.date!.timeIntervalSince1970)})
                }
                else {
                    listNotesToDisplay = listNotesToDisplay.sorted(by: {Int($0.date!.timeIntervalSince1970) > Int($1.date!.timeIntervalSince1970)})
                }
            }
        case 1:
            if segCtrlSortType.selectedSegmentIndex == 0 {
                if sender.selectedSegmentIndex == 0 {
                    listVideoLinks = listVideoLinks.sorted(by: { $0.name! < $1.name!})
                }
                else {
                    listVideoLinks = listVideoLinks.sorted(by: {$0.name! > $1.name!})
                }
            }
            else {
                if sender.selectedSegmentIndex == 0 {
                    listVideoLinks = listVideoLinks.sorted(by: { Int($0.date!.timeIntervalSince1970) < Int($1.date!.timeIntervalSince1970)})
                }
                else {
                    listVideoLinks = listVideoLinks.sorted(by: {Int($0.date!.timeIntervalSince1970) > Int($1.date!.timeIntervalSince1970)})
                }
            }
        case 2:
            if segCtrlSortType.selectedSegmentIndex == 0 {
                if sender.selectedSegmentIndex == 0 {
                    listDocuments = listDocuments.sorted(by: { $0.name! < $1.name!})
                }
                else {
                    listDocuments = listDocuments.sorted(by: {$0.name! > $1.name!})
                }
            }
            else {
                if sender.selectedSegmentIndex == 0 {
                    listDocuments = listDocuments.sorted(by: { Int($0.date!.timeIntervalSince1970) < Int($1.date!.timeIntervalSince1970)})
                }
                else {
                    listDocuments = listDocuments.sorted(by: {Int($0.date!.timeIntervalSince1970) > Int($1.date!.timeIntervalSince1970)})
                }
            }
        default:
            return
        }
        
        tableView.reloadData()
    }
    
    // MARK: - tableViewDelegate and tableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch materialType.selectedSegmentIndex {
        case 0:
            return listNotesToDisplay.count
        case 1:
            return listVideoLinksToDisplay.count
        case 2:
            return listDocumentsToDisplay.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "cellMaterial") as! MaterialTableViewCell
        switch materialType.selectedSegmentIndex {
        case 0:
            celda.lbName.text = listNotesToDisplay[indexPath.row].name
        case 1:
            celda.lbName.text = listVideoLinksToDisplay[indexPath.row].name
        case 2:
            celda.lbName.text = listDocumentsToDisplay[indexPath.row].name
        default:
            break
        }
        return celda
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
    
    // MARK: - protocolManageMaterial methods
    
    func addMaterial(material: Note, listImages: [UIImage]) {
        var imageId: Int = CoreDataUtilities.getNextImageId()
        
        material.isTheory = self.isTheory
        currentCourse.addToHasNote(material)
        
        for image in listImages {
            if CoreDataUtilities.saveToDocumentDirectory(image: image, id: String(imageId) + ".jpeg") {
                let imageAsCoreData = Image(context: PersistenceService.context)
                imageAsCoreData.id = Int32(imageId)
                material.addToHasImage(imageAsCoreData)
                imageId = imageId + 1
            } else {
                print("Could not save image #", imageId)
            }
        }
        
        listNotes.append(material)
        listNotesToDisplay.removeAll()
        displayAllNotes()
        PersistenceService.saveContext()
        tableView.reloadData()
    }
    
    func addMaterial(material: VideoLink) {
        material.isTheory = self.isTheory
        currentCourse.addToHasVideoLink(material)
        
        listVideoLinks.append(material)
        listVideoLinksToDisplay.removeAll()
        displayAllVideoLinks()
        PersistenceService.saveContext()
        tableView.reloadData()
    }
    
    func addMaterial(material: Document) {
        material.isTheory = self.isTheory
        currentCourse.addToHasDocument(material)
        
        listDocuments.append(material)
        listDocumentsToDisplay.removeAll()
        displayAllDocuments()
        PersistenceService.saveContext()
        tableView.reloadData()
    }
    
    func delMaterial(material: Note) {
        if let images = material.hasImage {
            for image in images {
                CoreDataUtilities.deleteImageFromDocumentDirectory(id: Int((image as! Image).id))
                PersistenceService.context.delete(image as! Image)
            }
        }
        PersistenceService.context.delete(material)
        listNotesToDisplay.remove(at: lastSelectedCell)
        self.tableView.reloadData()
        PersistenceService.saveContext()
    }
    
    func delMaterial(material: VideoLink) {
        PersistenceService.context.delete(material)
        listVideoLinks.remove(at: lastSelectedCell)
        self.tableView.reloadData()
        PersistenceService.saveContext()
    }
    
    func delMaterial(material: Document) {
        PersistenceService.context.delete(material)
        listDocuments.remove(at: lastSelectedCell)
        self.tableView.reloadData()
        PersistenceService.saveContext()
    }
    
    func editMaterial() {
        PersistenceService.saveContext()
        tableView.reloadData()
    }

    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "noteContent" {
            switch materialType.selectedSegmentIndex {
            case 0:
                return true
            case 1:
                let indexPath = tableView.indexPathForSelectedRow!
                let link = listVideoLinks[indexPath.row].link
                openWebLink(link: link, type: nil)
                return false
            default:
                let indexPath = tableView.indexPathForSelectedRow!
                let link = listDocuments[indexPath.row].link
                openWebLink(link: link, type: "pdf")
                return false
            }
        }
        
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "noteContent" {
            let viewNoteContent = segue.destination as! NoteContentViewController
            let indexPath = tableView.indexPathForSelectedRow!
            viewNoteContent.materialView = self
            viewNoteContent.currentCourse = self.currentCourse
            viewNoteContent.currentNote = listNotesToDisplay[indexPath.row]
            viewNoteContent.isNewNote = false
        } else if segue.identifier == "newNote" {
            let viewNoteContent = segue.destination as! NoteContentViewController
            viewNoteContent.currentCourse = self.currentCourse
            viewNoteContent.materialView = self
            viewNoteContent.isNewNote = true
        } else if segue.identifier == "newNotNote" {
            let viewMaterialInfo = segue.destination as! MaterialInfoViewController
            viewMaterialInfo.materialType = materialType.selectedSegmentIndex
            viewMaterialInfo.materialView = self
            if materialType.selectedSegmentIndex == 1 {
                viewMaterialInfo.isNewNote = false
                viewMaterialInfo.isNewVideoLink = true
                viewMaterialInfo.isNewDocument = false
            } else {
                viewMaterialInfo.isNewNote = false
                viewMaterialInfo.isNewVideoLink = false
                viewMaterialInfo.isNewDocument = true
            }
        } else if segue.identifier == "materialInfo" {
            let viewMaterialInfo = segue.destination as! MaterialInfoViewController
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview! as! MaterialTableViewCell
            let indexPath = tableView.indexPath(for: cell)!
            lastSelectedCell = indexPath.row
            
            viewMaterialInfo.materialType = materialType.selectedSegmentIndex
            switch viewMaterialInfo.materialType {
            case 0:
                viewMaterialInfo.currentNote = listNotesToDisplay[lastSelectedCell]
                viewMaterialInfo.isNewNote = false
                viewMaterialInfo.isNewVideoLink = false
                viewMaterialInfo.isNewDocument = false
            case 1:
                viewMaterialInfo.currentVideoLink = listVideoLinksToDisplay[lastSelectedCell]
                viewMaterialInfo.isNewNote = false
                viewMaterialInfo.isNewVideoLink = false
                viewMaterialInfo.isNewDocument = false
            case 2:
                viewMaterialInfo.currentDocument = listDocumentsToDisplay[lastSelectedCell]
                viewMaterialInfo.isNewNote = false
                viewMaterialInfo.isNewVideoLink = false
                viewMaterialInfo.isNewDocument = false
            default:
                break
            }
            
            viewMaterialInfo.materialView = self
        }
    }

}
