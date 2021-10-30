//
//  ImageView.swift
//  ImageView
//
//  Created by Robin Phillips on 20/08/2021.
//

import SwiftUI

struct ImageView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var settings: Settings
    
    @State private var image: Image?
    @State private var showingImagePicker = false
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""

    
    var body: some View {
        GeometryReader() { geo in
            VStack {
                ZStack {
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width / 1.1)
                            .background(.black)
                            .clipShape(Circle())
                            .onTapGesture {
                                print("tapped to add contact picture")
                                showingImagePicker = true
                            }
                    } else {
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .padding(geo.size.width / 6)
                            .foregroundColor(.white)
                            .offset(x: 0, y: -(geo.size.width / 30))
                            .frame(width: geo.size.width / 1.1)
                            .background(.black)
                            .clipShape(Circle())
                            .onTapGesture {
                                print("tapped to add contact picture")
                                showingImagePicker = true
                            }
                    }
                }
            }
            .frame(width: geo.size.width, alignment: .center)
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $settings.inputImage)
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = settings.inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(settings: Settings())
    }
}
