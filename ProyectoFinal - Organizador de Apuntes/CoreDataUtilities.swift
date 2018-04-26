//
//  CoreDataUtilities.swift
//  ProyectoFinal - Organizador de Apuntes
//
//  Created by Angel Seiji Morimoto Burgos on 3/28/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit
import CoreData

class CoreDataUtilities: NSObject {
    
    static let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
    
    // Gets the next available image id, by checking the maximum id of the images
    // stored in the persistent storage (core data and documentDirectory) and returning
    // that number + 1.
    static func getNextImageId() -> Int {
        let imageRequest: NSFetchRequest<Image> = Image.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "id == max(id)")
        imageRequest.fetchLimit = 1
        imageRequest.predicate = predicate
        do {
            let data = try PersistenceService.context.fetch(imageRequest)
            if data.count != 0 {
                return Int(data[0].id) + 1
            }
        } catch {
            // TODO: Update this to improve error handling
            print("Could not retrieve the max id of an image")
        }
        return 1
    }
    
    // Saves an image in the document directory. The image is saved with the name specified
    // by the variable 'id'.
    // Returns true if the image was successfully saved; false otherwise.
    static func saveToDocumentDirectory(image: UIImage, id: String) -> Bool {
        let path = documentDirectory.appendingPathComponent(id)
        var successWrite: Bool = false
        
        // Check if the image can be represented as a PNG or JPG image.
        if let imageAsData = UIImagePNGRepresentation(image) {
            successWrite = NSData(data: imageAsData).write(toFile: path, atomically: true)
        } else if let imageAsData = UIImageJPEGRepresentation(image, 1.0){
            successWrite = NSData(data: imageAsData).write(toFile: path, atomically: true)
        }
        
        return successWrite
    }
    
    // Deletes the image stored in the documentDirectory as a file with the name specified
    // by the variable 'id'.
    static func deleteImageFromDocumentDirectory(id: Int) {
        let fileManager = FileManager.default
        let path = documentDirectory.appendingPathComponent(String(id))
        do {
            try fileManager.removeItem(atPath: path)
        } catch {
            print("Could not delete image #\(id) from document directory.")
        }
    }
}
