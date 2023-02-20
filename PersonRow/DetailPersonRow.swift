//
//  DetailPersonRow.swift
//  PersonRow
//
//  Created by Floriano Fraccastoro on 17/02/23.
//

import SwiftUI
import MapKit
import CoreData

struct DetailPersonRow: View {
    let person: Persons
        
    func showURL(_ url: String) -> URL{
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(url)
    }
    
    var body: some View {
        VStack{
            ZStack{
                if let imageURL = showURL(person.uuid ?? ""){
                    Image(uiImage: UIImage(contentsOfFile: imageURL.path)!)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                }
            }
            List{
                Section{
                    Text(person.name ?? "Unknown")
                }header: {
                    Text("Name")
                }
                
                Section{
                    ZStack{
                        Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: person.latitude, longitude: person.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))), annotationItems: [person]){person in
                            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: person.latitude, longitude: person.longitude)){
                                if let imageURL = showURL(person.uuid ?? ""){
                                    Image(uiImage: UIImage(contentsOfFile: imageURL.path)!)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 40)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.green,lineWidth: 3))
                                }
                            }
                        }
                    }
                    .frame(height: 200)
                }header: {
                    Text("Map")
                }
                Section{
                    Text("Latitude: \(person.latitude)")
                    Text("Longitude: \(person.longitude)")
                }
            }
            .navigationTitle(person.name ?? "Unknown")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
