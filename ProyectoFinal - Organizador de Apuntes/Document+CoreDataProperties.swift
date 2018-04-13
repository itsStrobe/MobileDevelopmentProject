//
//  Document+CoreDataProperties.swift
//  ProyectoFinal - Organizador de Apuntes
//
//  Created by Alumno on 4/10/18.
//  Copyright © 2018 itesm. All rights reserved.
//
//

import Foundation
import CoreData


extension Document {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var topic: String?
    @NSManaged public var partial: Int16
    @NSManaged public var link: String?
    @NSManaged public var isTheory: Bool
    @NSManaged public var belongsTo: Course?

}
