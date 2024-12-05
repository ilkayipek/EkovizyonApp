//
//  FirebaseIdentifiable+Extension.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 15.04.2024.
//

import Foundation

extension FirebaseIdentifiable {
    /// POST to Firebase
    func post(to collection: FirebaseCollections,_ completion: @escaping (Result<Self, Error>) -> Void){
        return Network.shared.post(self, to: collection.rawValue, completion: completion)
    }

    /// PUT to Firebase
    func put(to collection: FirebaseCollections, _ completion: @escaping (Result<Self, Error>)-> Void) {
        return Network.shared.put(self, to: collection.rawValue, completion: completion)
    }

    /// DELETE from Firebase
    func delete(from collection: FirebaseCollections, _ completion: @escaping (Result<Void, Error>)-> Void) {
        return Network.shared.delete(self, in: collection.rawValue, completion: completion)
    }
}
