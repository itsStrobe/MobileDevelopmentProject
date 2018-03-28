//
//  Course+CoreDataProperties.swift
//  ProyectoFinal - Organizador de Apuntes
//
//  Created by Angel Seiji Morimoto Burgos on 3/27/18.
//  Copyright © 2018 itesm. All rights reserved.
//
//

import Foundation
import CoreData


extension Course {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course")
    }

    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var office: String?
    @NSManaged public var professor: String?
    @NSManaged public var tutoring: String?
    @NSManaged public var hasNote: NSSet?

}

// MARK: Generated accessors for hasNote
extension Course {

    @objc(addHasNoteObject:)
    @NSManaged public func addToHasNote(_ value: Note)

    @objc(removeHasNoteObject:)
    @NSManaged public func removeFromHasNote(_ value: Note)

    @objc(addHasNote:)
    @NSManaged public func addToHasNote(_ values: NSSet)

    @objc(removeHasNote:)
    @NSManaged public func removeFromHasNote(_ values: NSSet)

}
