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
    var listVideoLinks = [VideoLink]()
    var listDocuments = [Document]()
    
    @IBOutlet weak var tfTema: UITextField!
    @IBOutlet weak var tfParcial: UITextField!
    @IBOutlet weak var segCtrlSortType: UISegmentedControl!
    @IBOutlet weak var segCtrlAsc: UISegmentedControl!
    
    func loadNotes() {
        let notesRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "isTheory == %@ AND belongsTo.name == %@", NSNumber(value: isTheory), currentCourse.name!)
        notesRequest.predicate = predicate
        
        do {
            listNotes = try PersistenceService.context.fetch(notesRequest)
            tableView.reloadData()
        } catch {
            // TODO: Update this to improve error handling
            print("Could not retrieve data from notes")
        }
    }
    
    func loadNotesTema(tema : String) {
        let notesRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "isTheory == %@ AND belongsTo.name == %@ AND topic == %@", NSNumber(value: isTheory), currentCourse.name!, tema)
        notesRequest.predicate = predicate
        
        do {
            listNotes = try PersistenceService.context.fetch(notesRequest)
            tableView.reloadData()
        } catch {
            // TODO: Update this to improve error handling
            print("Could not retrieve data from notes")
        }
    }
    
    func loadNotesPartial(partial : String) {
        let notesRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "isTheory == %@ AND belongsTo.name == %@ AND partial == %@", NSNumber(value: isTheory), currentCourse.name!, partial)
        notesRequest.predicate = predicate
        
        do {
            listNotes = try PersistenceService.context.fetch(notesRequest)
            tableView.reloadData()
        } catch {
            // TODO: Update this to improve error handling
            print("Could not retrieve data from notes")
        }
    }
    
    func loadNotesTemaPartial(tema : String, partial : String) {
        let notesRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "isTheory == %@ AND belongsTo.name == %@ AND topic == %@ AND partial == %@", NSNumber(value: isTheory), currentCourse.name!, tema, partial)
        notesRequest.predicate = predicate
        
        do {
            listNotes = try PersistenceService.context.fetch(notesRequest)
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
            tableView.reloadData()
        } catch {
            // TODO: Update this to improve error handling
            print("Could not retrieve data from notes")
        }
    }
    
    func loadVideoLinksTema(tema : String) {
        let videoLinksRequest: NSFetchRequest<VideoLink> = VideoLink.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "isTheory == %@ AND belongsTo.name == %@ AND topic == %@", NSNumber(value: isTheory), currentCourse.name!, tema)
        videoLinksRequest.predicate = predicate
        
        do {
            listVideoLinks = try PersistenceService.context.fetch(videoLinksRequest)
            tableView.reloadData()
        } catch {
            // TODO: Update this to improve error handling
            print("Could not retrieve data from notes")
        }
    }
    
    func loadVideoLinksPartial(partial : String) {
        let videoLinksRequest: NSFetchRequest<VideoLink> = VideoLink.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "isTheory == %@ AND belongsTo.name == %@ AND partial == %@", NSNumber(value: isTheory), currentCourse.name!, partial)
        videoLinksRequest.predicate = predicate
        
        do {
            listVideoLinks = try PersistenceService.context.fetch(videoLinksRequest)
            tableView.reloadData()
        } catch {
            // TODO: Update this to improve error handling
            print("Could not retrieve data from notes")
        }
    }
    
    func loadVideoLinksTemaPartial(tema : String, partial : String) {
        let videoLinksRequest: NSFetchRequest<VideoLink> = VideoLink.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "isTheory == %@ AND belongsTo.name == %@ AND topic == %@ AND partial == %@", NSNumber(value: isTheory), currentCourse.name!, tema, partial)
        videoLinksRequest.predicate = predicate
        
        do {
            listVideoLinks = try PersistenceService.context.fetch(videoLinksRequest)
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
            tableView.reloadData()
        } catch {
            // TODO: Update this to improve error handling
            print("Could not retrieve data from notes")
        }
    }
    
    func loadDocumentsTema(tema : String) {
        let documentsRequest: NSFetchRequest<Document> = Document.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "isTheory == %@ AND belongsTo.name == %@ AND topic == %@", NSNumber(value: isTheory), currentCourse.name!, tema)
        documentsRequest.predicate = predicate
        
        do {
            listDocuments = try PersistenceService.context.fetch(documentsRequest)
            tableView.reloadData()
        } catch {
            // TODO: Update this to improve error handling
            print("Could not retrieve data from notes")
        }
    }
    
    func loadDocumentsPartial(partial : String) {
        let documentsRequest: NSFetchRequest<Document> = Document.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "isTheory == %@ AND belongsTo.name == %@ AND partial == %@", NSNumber(value: isTheory), currentCourse.name!, partial)
        documentsRequest.predicate = predicate
        
        do {
            listDocuments = try PersistenceService.context.fetch(documentsRequest)
            tableView.reloadData()
        } catch {
            // TODO: Update this to improve error handling
            print("Could not retrieve data from notes")
        }
    }
    
    func loadDocumentsTemaPartial(tema : String, partial : String) {
        let documentsRequest: NSFetchRequest<Document> = Document.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "isTheory == %@ AND belongsTo.name == %@ AND topic == %@ AND partial == %@", NSNumber(value: isTheory), currentCourse.name!, tema, partial)
        documentsRequest.predicate = predicate
        
        do {
            listDocuments = try PersistenceService.context.fetch(documentsRequest)
            tableView.reloadData()
        } catch {
            // TODO: Update this to improve error handling
            print("Could not retrieve data from notes")
        }
    }
    
    func loadMaterial(type : Int) {
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBActions
    
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
        var hasTopic : Bool!
        var hasPartial : Bool!
        
        var tema = "nil"
        var parcial = "nil"
        
        if let valTema = tfTema.text {
            hasTopic = true
            tema = valTema
        }
        else {
            hasTopic = false
        }
        
        if let valParcial = tfParcial.text {
            hasPartial = true
            parcial = valParcial
        }
        else {
            hasPartial = false
        }
        
        switch materialType.selectedSegmentIndex {
        case 0:
            if hasTopic, !hasPartial {
                loadNotesTema(tema: tema)
            }
            if !hasTopic, hasPartial {
                loadNotesPartial(partial: parcial)
            }
            if hasTopic, hasPartial {
                loadNotesTemaPartial(tema: tema, partial: parcial)
            }
        case 1:
            if hasTopic, !hasPartial {
                loadVideoLinksTema(tema: tema)
            }
            if !hasTopic, hasPartial {
                loadVideoLinksPartial(partial: parcial)
            }
            if hasTopic, hasPartial {
                loadVideoLinksTemaPartial(tema: tema, partial: parcial)
            }
        case 2:
            if hasTopic, !hasPartial {
                loadDocumentsTema(tema: tema)
            }
            if !hasTopic, hasPartial {
                loadDocumentsPartial(partial: parcial)
            }
            if hasTopic, hasPartial {
                loadDocumentsTemaPartial(tema: tema, partial: parcial)
            }
        default:
            return
        }
        
    }
    
    @IBAction func changeSortBy(_ sender: UISegmentedControl) {
        switch materialType.selectedSegmentIndex {
        case 0:
            if sender.selectedSegmentIndex == 0 {
                if segCtrlAsc.selectedSegmentIndex == 0 {
                    listNotes = listNotes.sorted(by: { $0.name! < $1.name!})
                }
                else {
                    listNotes = listNotes.sorted(by: {$0.name! > $1.name!})
                }
            }
            else {
                if segCtrlAsc.selectedSegmentIndex == 0 {
                    listNotes = listNotes.sorted(by: { Int($0.date!.timeIntervalSince1970) < Int($1.date!.timeIntervalSince1970)})
                }
                else {
                    listNotes = listNotes.sorted(by: {Int($0.date!.timeIntervalSince1970) > Int($1.date!.timeIntervalSince1970)})
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
    
    @IBAction func changeSortAsc(_ sender: UISegmentedControl) {
        switch materialType.selectedSegmentIndex {
        case 0:
            if segCtrlSortType.selectedSegmentIndex == 0 {
                if sender.selectedSegmentIndex == 0 {
                    listNotes = listNotes.sorted(by: { $0.name! < $1.name!})
                }
                else {
                    listNotes = listNotes.sorted(by: {$0.name! > $1.name!})
                }
            }
            else {
                if sender.selectedSegmentIndex == 0 {
                    listNotes = listNotes.sorted(by: { Int($0.date!.timeIntervalSince1970) < Int($1.date!.timeIntervalSince1970)})
                }
                else {
                    listNotes = listNotes.sorted(by: {Int($0.date!.timeIntervalSince1970) > Int($1.date!.timeIntervalSince1970)})
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
            return listNotes.count
        case 1:
            return listVideoLinks.count
        case 2:
            return listDocuments.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "cellMaterial") as! MaterialTableViewCell
        switch materialType.selectedSegmentIndex {
        case 0:
            celda.lbName.text = listNotes[indexPath.row].name
        case 1:
            celda.lbName.text = listVideoLinks[indexPath.row].name
        case 2:
            celda.lbName.text = listDocuments[indexPath.row].name
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
            if CoreDataUtilities.saveToDocumentDirectory(image: image, id: imageId) {
                let imageAsCoreData = Image(context: PersistenceService.context)
                imageAsCoreData.id = Int32(imageId)
                material.addToHasImage(imageAsCoreData)
                imageId = imageId + 1
            } else {
                print("Could not save image #", imageId)
            }
        }
        
        listNotes.append(material)
        PersistenceService.saveContext()
        tableView.reloadData()
    }
    
    func addMaterial(material: VideoLink) {
        material.isTheory = self.isTheory
        currentCourse.addToHasVideoLink(material)
        listVideoLinks.append(material)
        PersistenceService.saveContext()
        tableView.reloadData()
    }
    
    func addMaterial(material: Document) {
        material.isTheory = self.isTheory
        currentCourse.addToHasDocument(material)
        listDocuments.append(material)
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
        listNotes.remove(at: lastSelectedCell)
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
            viewNoteContent.currentNote = listNotes[indexPath.row]
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
                viewMaterialInfo.isNewVideoLink = true
            } else {
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
                viewMaterialInfo.currentNote = listNotes[lastSelectedCell]
                viewMaterialInfo.isNewNote = false
            case 1:
                viewMaterialInfo.currentVideoLink = listVideoLinks[lastSelectedCell]
                viewMaterialInfo.isNewVideoLink = false
            case 2:
                viewMaterialInfo.currentDocument = listDocuments[lastSelectedCell]
                viewMaterialInfo.isNewDocument = false
            default:
                break
            }
            
            viewMaterialInfo.materialView = self
        }
    }

}
