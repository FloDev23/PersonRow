//
//  Person.swift
//  PersonRow
//
//  Created by Floriano Fraccastoro on 15/02/23.
//

import Foundation
import SwiftUI

struct Person: Identifiable, Comparable{
    var id: UUID
    var name: String
    var image: Image?
    var latitude: Double
    var longitude: Double
    
    var wrappedImage: Image {
        image ?? Image(systemName: "questionmark.circle")
    }
    
    static func <(lhs: Person, rhs: Person) -> Bool{
        lhs.name < rhs.name
    }
}

class PersonsClass: ObservableObject{
    @Published var persons = [Person]()
}
