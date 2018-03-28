//
//  Image+CoreDataProperties.swift
//  ProyectoFinal - Organizador de Apuntes
//
//  Created by Angel Seiji Morimoto Burgos on 3/26/18.
//  Copyright © 2018 itesm. All rights reserved.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var id: Int32
    @NSManaged public var belongsTo: Note?

}
