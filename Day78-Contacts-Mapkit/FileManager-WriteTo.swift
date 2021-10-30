//
//  FileManager-WriteTo.swift
//  FileManager-WriteTo
//
//  Created by Robin Phillips on 19/08/2021.
//

import Foundation
import UIKit


extension FileManager {
    func writeImageToFile(image: UIImage, fileName: String, imageDim: Double) throws {
        
        
        let url = getDocumentsDirectory().appendingPathComponent("\(fileName).jpeg")
        
        let tempImage = image.resizeImage(targetSize: CGSize(width: imageDim, height: imageDim))
        
        do {
            if let jpegData = tempImage.jpegData(compressionQuality: 0.8) {
                
                try? jpegData.write(to: url, options: [.atomicWrite, .completeFileProtection])
            }
            let input = try Data(contentsOf: url)
            print(input)
        } catch {
            print(error.localizedDescription)
        }
        
        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0]
        }
    }
}
