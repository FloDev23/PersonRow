//
//  ContentView.swift
//  PersonRow
//
//  Created by Floriano Fraccastoro on 14/02/23.
//

import SwiftUI
import CoreData
import CoreImage

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var persons: FetchedResults<Persons>
    
    @State private var showingAddPerson = false
    
    func showURL(_ url: String) -> URL{
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(url)
    }
    
    func delete(at offsets: IndexSet){
        for index in offsets{
            let person = persons[index]
            let imageURL = showURL(person.uuid ?? "")
            
            do{
                try FileManager.default.removeItem(at: imageURL)
            } catch {
                print("Error deleting image file: \(error.localizedDescription)")
            }
            
            moc.delete(person)
        }
        
        do{
            try moc.save()
        } catch{
            print("Error saving managed object context: \(error.localizedDescription)")
        }
    }
    var body: some View {
        NavigationView{
            VStack{
                List{
                    ForEach(persons, id: \.self){ person in
                        NavigationLink{
                            DetailPersonRow(person: person)
                        } label: {
                            HStack{
                                if let imageURL = showURL(person.uuid ?? ""){
                                    Image(uiImage: UIImage(contentsOfFile: imageURL.path)!)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                }
                                
                                Text(person.name ?? "Unknown")
                            }
                        }
                    }
                    .onDelete(perform: delete)
                }
            }
            .navigationTitle("PersonRow")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Add"){
                        showingAddPerson = true
                    }
                }
            }
            .sheet(isPresented: $showingAddPerson){
                AddPersonRow()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
