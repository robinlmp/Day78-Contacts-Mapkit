//
//  LoadSavedImage.swift
//  LoadSavedImage
//
//  Created by Robin Phillips on 20/08/2021.
//

import Foundation
import SwiftUI


func loadSavedImage(fileName: String, fileManager: FileManager) -> Image? {
    
    let url = getDocumentsDirectory().appendingPathComponent("\(fileName).jpeg")
    print(url.description)
    var tempImage: Image?
    
    if fileManager.fileExists(atPath: url.description) {
        tempImage = Image(url.description)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    return tempImage
}
