//
//  NewContactView.swift
//  NewContactView
//
//  Created by Robin Phillips on 19/08/2021.
//

import SwiftUI
import CoreData
import Foundation
import MapKit
import CoreLocation

import CoreImage
import CoreImage.CIFilterBuiltins

class Settings: ObservableObject {
    @Published var inputImage: UIImage? = nil {
        didSet {
            print("inputImage was changed")
        }
    }
    
    @Published var centerCoordinate = CLLocationCoordinate2D()
    @Published var locations = [MKPointAnnotation]()
    @Published var selectedPlace: MKPointAnnotation?
    @Published var showingPlaceDetails = false
    @Published var showingEditScreen = false
    @Published var latitude = 0.0
    @Published var longitude = 0.0
}


struct NewContactView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var settings = Settings()
    
    @State private var image: Image?
    @State private var showingImagePicker = false
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    
    @Binding var sheetIsShowing: Bool
    let locationFetcher: LocationFetcher
    
    let fileManager = FileManager()
    
    
    var body: some View {
        NavigationView {
            VStack {
                
                ImageView(settings: settings)
                    .padding()
                
                Spacer()
                
                VStack{
                    Text("Enter name of new contact")
                        .font(.callout)
                        .fontWeight(.light)
                        .frame(maxWidth: .infinity ,alignment: .leading)
                        .padding(.horizontal)
                    
                    TextField("First name", text: $firstName, prompt: Text("First name"))
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    
                    TextField("Last name", text: $lastName, prompt: Text("Last name"))
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                }
                .padding()
                
                Button() {
                    print("This will add a contact")
                    addContact()
                    sheetIsShowing = false
                } label: {
                    Text("Add contact")
                        .padding(.horizontal)
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .disabled(firstName.isEmpty || lastName.isEmpty || settings.inputImage == nil)
            }
            .onAppear {
                setLocation()
            }
            
            .navigationTitle("Add new contact")
        }
    }
    
    func setLocation() {
        if let location = locationFetcher.lastKnownLocation {
            print("Your location is \(location)")
            settings.longitude = location.longitude
            settings.latitude = location.latitude
            print("Your longitude is \(settings.longitude)")
            print("Your latitude is \(settings.latitude)")
        } else {
            print("Your location is unknown")
        }
    }
    
    func addContact() {
        let newContact = Person(context: viewContext)
        newContact.id = UUID()
        newContact.dateAdded = Date()
        newContact.lastName = lastName
        newContact.firstName = firstName
        newContact.longitude = settings.longitude
        newContact.latitude = settings.latitude
        
        let newLocation = MKPointAnnotation()  //
        newLocation.coordinate = CLLocationCoordinate2D(latitude: settings.latitude, longitude: settings.longitude)
        newLocation.title = "\(firstName) \(lastName)"
        newLocation.subtitle = ""
        
        settings.locations.append(newLocation)
        settings.selectedPlace = newLocation
        settings.showingEditScreen = true
        
        do {
            viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)") // should be replaced in a shipping app
        }
        
        do {
            if settings.inputImage != nil {
                try fileManager.writeImageToFile(image: settings.inputImage!, fileName: newContact.wrappedID, imageDim: 1000)
                print("image attempted save as \(newContact.wrappedID)")
            } else {
                print("no image to save")
            }
        } catch {
            print("image did not save") // should provide UI to communicate to user that it failed
        }
    }
}

