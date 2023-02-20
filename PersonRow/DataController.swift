//
//  DataController.swift
//  PersonRow
//
//  Created by Floriano Fraccastoro on 17/02/23.
//

import CoreData
import SwiftUI

class DataController: ObservableObject{
    let container = NSPersistentContainer(name: "PersonRow")
    
    init(){
        container.loadPersistentStores{ description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
