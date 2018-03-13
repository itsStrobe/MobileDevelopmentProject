//
//  Note+CoreDataProperties.swift
//  ProyectoFinal - Organizador de Apuntes
//
//  Created by Alumno on 3/13/18.
//  Copyright © 2018 itesm. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var name: String?
    @NSManaged public var topic: String?
    @NSManaged public var partial: Int16
    @NSManaged public var date: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var belongsTo: Course?

}
