//
//  Student+CoreDataProperties.swift
//  SwiftUI-CoreData
//
//  Created by Phuc Bui  on 9/25/21.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var name: String?
    @NSManaged public var id: UUID?

}

extension Student : Identifiable {

}
