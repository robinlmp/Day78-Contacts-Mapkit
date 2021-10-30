//
//  Person+CoreDataProperties.swift
//  Person
//
//  Created by Robin Phillips on 21/08/2021.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var dateAdded: Date?
    @NSManaged public var firstName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var lastName: String?
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double

    
    
    var wrapFormattedDateAdded: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        if let dateAdded = dateAdded {
            return dateFormatter.string(from: dateAdded)
        } else {
            return "unknown date"
        }
        
    }
    
    
    var wrappedFirstName: String {
        return firstName ?? "Unknown first name"
    }
    
    var wrappedLastName: String {
        return lastName ?? "Unknown last name"
    }
    
    var wrappedID: String {
        if let id = id {
            return id.description
        } else {
            self.id = UUID()
            return id!.description // there should be no way this can be anything other than a String of a valid UUID
        }
        
    }
    
}

extension Person : Identifiable {

}
