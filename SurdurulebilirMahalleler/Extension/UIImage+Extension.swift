//
//  UIImage+Extension.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 25.04.2024.
//

import UIKit
import FirebaseStorage

extension UIImage {
    func upload(to folder: FireBaseStorageFolders, withName name: String?, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = self.jpegData(compressionQuality: 0.5) else {
            let error = NSError(domain: "FirebaseStorage", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])
            completion(.failure(error))
            return
        }
        let path = "\(folder.rawValue)/\(name ?? UUID().uuidString)"
        
        let storageReference = Storage.storage().reference(withPath: path)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageReference.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Error: \(#function) couldn't upload image data, \(error)")
                completion(.failure(error))
                return
            }
            
            storageReference.downloadURL { url, error in
                if let error = error {
                    print("Error: \(#function) couldn't get download URL, \(error)")
                    completion(.failure(error))
                    return
                }
                
                guard let downloadURL = url else {
                    let error = NSError(domain: "FirebaseStorage", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])
                    completion(.failure(error))
                    return
                }
                
                completion(.success(downloadURL))
            }
        }
    }
}
