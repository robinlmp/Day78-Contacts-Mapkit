//
//  ContactDetailView.swift
//  ContactDetailView
//
//  Created by Robin Phillips on 20/08/2021.
//

import SwiftUI
import MapKit



struct ContactDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    let imageSize: CGFloat = 300
    @State private var image: Image?
    @State private var directoryPath: String = ""
    @State var contact: FetchedResults<Person>.Element
    @Binding var viewShowing: Bool

    @ObservedObject var settings: Settings
    
    var body: some View {
        
        NavigationView {
            
            HStack {
                VStack {
                    AsyncImage(url: URL(string: "\(directoryPath)\(contact.wrappedID).jpeg")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .padding(.vertical, 5.0)
                    } placeholder: {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .padding(.vertical, 5.0)
                    }
                    
                    Spacer()

                    MapView(latitude: contact.latitude, longitude: contact.longitude, firstName: contact.wrappedFirstName, lastName: contact.wrappedLastName)
                        .clipShape(Circle())
                        .padding(.vertical, 5.0)
                }
                .frame(width: imageSize, alignment: .top)
                
            }
            
            .onAppear {
                directoryPath = getDocumentsDirectory()
            }
            
            Spacer()
        }
        .navigationTitle(Text("\(contact.wrappedFirstName) \(contact.wrappedLastName)"))
        .border(.red, width: 4)
        
    }
        
    
    func getDocumentsDirectory() -> String {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        // just send back the first one, which ought to be the only one
        return paths[0].description
    }
        
}
