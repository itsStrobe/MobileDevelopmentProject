//
//  Course+CoreDataProperties.swift
//  ProyectoFinal - Organizador de Apuntes
//
//  Created by Alumno on 4/10/18.
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
    @NSManaged public var hasVideoLink: NSSet?
    @NSManaged public var hasDocument: NSSet?

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

// MARK: Generated accessors for hasVideoLink
extension Course {

    @objc(addHasVideoLinkObject:)
    @NSManaged public func addToHasVideoLink(_ value: VideoLink)

    @objc(removeHasVideoLinkObject:)
    @NSManaged public func removeFromHasVideoLink(_ value: VideoLink)

    @objc(addHasVideoLink:)
    @NSManaged public func addToHasVideoLink(_ values: NSSet)

    @objc(removeHasVideoLink:)
    @NSManaged public func removeFromHasVideoLink(_ values: NSSet)

}

// MARK: Generated accessors for hasDocument
extension Course {

    @objc(addHasDocumentObject:)
    @NSManaged public func addToHasDocument(_ value: Document)

    @objc(removeHasDocumentObject:)
    @NSManaged public func removeFromHasDocument(_ value: Document)

    @objc(addHasDocument:)
    @NSManaged public func addToHasDocument(_ values: NSSet)

    @objc(removeHasDocument:)
    @NSManaged public func removeFromHasDocument(_ values: NSSet)

}
