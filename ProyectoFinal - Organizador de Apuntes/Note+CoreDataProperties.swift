//
//  Note+CoreDataProperties.swift
//  ProyectoFinal - Organizador de Apuntes
//
//  Created by Angel Seiji Morimoto Burgos on 3/26/18.
//  Copyright © 2018 itesm. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var isTheory: Bool
    @NSManaged public var name: String?
    @NSManaged public var partial: Int16
    @NSManaged public var text: String?
    @NSManaged public var topic: String?
    @NSManaged public var belongsTo: Course?
    @NSManaged public var hasImage: NSSet?

}

// MARK: Generated accessors for hasImage
extension Note {

    @objc(addHasImageObject:)
    @NSManaged public func addToHasImage(_ value: Image)

    @objc(removeHasImageObject:)
    @NSManaged public func removeFromHasImage(_ value: Image)

    @objc(addHasImage:)
    @NSManaged public func addToHasImage(_ values: NSSet)

    @objc(removeHasImage:)
    @NSManaged public func removeFromHasImage(_ values: NSSet)

}
