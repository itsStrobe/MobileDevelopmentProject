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
}
