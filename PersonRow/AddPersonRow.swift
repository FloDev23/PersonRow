//
//  AddPersonRow.swift
//  PersonRow
//
//  Created by Floriano Fraccastoro on 17/02/23.
//

import CoreImage
import SwiftUI
import CoreData

struct AddPersonRow: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var namePhoto = ""
    
    let locationFetcher = LocationFetcher()
    let context = CIContext()
    
    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    Color.secondary
                    Text("Select a picture")
                        .foregroundColor(.white)
                    image?
                        .resizable()
                        .scaledToFit()
                }
                Section{
                    TextField("Photo's name", text: $namePhoto)
                        .padding()
                        .padding(.horizontal)
                }
                ImagePicker(image: $inputImage)
            }
            .navigationTitle("New photo")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: inputImage){ _ in loadImage() }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Save", action: save)
                        .disabled(image == nil || namePhoto.isEmpty)
                }
            }
        }
        .onAppear{
            self.locationFetcher.start()
        }
    }
    func loadImage(){
        guard let inputImage = inputImage else { return }
        guard let outputImage = CIImage(image: inputImage) else { return }
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
        }
    }
           
    func save() {
        guard let inputImage = inputImage else { return }
        guard let data = inputImage.jpegData(compressionQuality: 0.8) else { return }

        let uuid = UUID().uuidString
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(uuid)
        
        do {
            try data.write(to: fileURL)

            let newPerson = Persons(context: moc)
            newPerson.name = namePhoto
            newPerson.uuid = uuid
            newPerson.latitude = locationFetcher.latitude ?? 0
            newPerson.longitude = locationFetcher.longitude ?? 0

            try moc.save()
            
            dismiss()
        } catch {
            print("Error saving image: \(error)")
        }
    }
}

struct AddPersonRow_Previews: PreviewProvider {
    static var previews: some View {
        AddPersonRow()
    }
}
