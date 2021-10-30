//
//  ContentView.swift
//  Day77-Contacts
//
//  Created by Robin Phillips on 18/08/2021.
//

import SwiftUI
import CoreData

import CoreImage
import CoreImage.CIFilterBuiltins


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    let locationFetcher = LocationFetcher()
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showingAddNewContact = false
    @State private var detailViewShowing = false
    
    @State private var directoryPath: String = ""
    let fileManager = FileManager()
    
    let imageSize: CGFloat = 75
    
    @ObservedObject var settings: Settings
    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Person.firstName, ascending: true)],
        animation: .default)
    private var contacts: FetchedResults<Person>
    
    var body: some View {
        
        return NavigationView {
            List {
                ForEach(contacts, id: \.id) { person in
                    
                    NavigationLink(destination: ContactDetailView(contact: person, viewShowing: $detailViewShowing, settings: settings)) {
                        
                        HStack {
                            
                            AsyncImage(url: URL(string: "\(directoryPath)\(person.wrappedID).jpeg")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imageSize, height: imageSize)
                                    .clipShape(Circle())
                                    .padding(.vertical, 5.0)
                            } placeholder: {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: imageSize, height: imageSize)
                                    .padding(.vertical, 5.0)
                            }
                            
                            Spacer()
                            
                            Text("\(person.wrappedFirstName) ") +
                            Text("\(person.wrappedLastName)")
                        }
                    }
                    .onAppear {
                        directoryPath = getDocumentsDirectory()
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle(Text("Contacts"))
            
            .sheet(isPresented: $showingAddNewContact) {
                NewContactView(sheetIsShowing: $showingAddNewContact, locationFetcher: locationFetcher)
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingAddNewContact = true
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
        .onAppear() {
            locationFetcher.start()
        }
    }
    
    
    func getDocumentsDirectory() -> String {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].description
    }
    
    
    func addContacts(viewContext: NSManagedObjectContext) {
        let lastNames = ["Johnson", "Potter", "Smith", "Bootle", "Kahn", "Cook", "Jackson"]
        let firstNames = ["Alex", "Sam", "Jo", "Frank", "Sarah", "Ellie", "Lucy"]
        
        for _ in 0..<10 {
            let newItem = Person(context: viewContext)
            
            newItem.dateAdded = Date()
            newItem.lastName = lastNames.randomElement()
            newItem.firstName = firstNames.randomElement()
            newItem.id = UUID()
        }
        do {
            viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Person(context: viewContext)
            newItem.dateAdded = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { contacts[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(settings: Settings()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
