//
//  FirebaseIdentifiable+Extension.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 15.04.2024.
//

import Foundation

extension FirebaseIdentifiable {
    /// POST to Firebase
    func post(to collection: FirebaseCollections.RawValue,_ completion: @escaping (Result<Self, Error>) -> Void){
        return Network.shared.post(self, to: collection, completion: completion)
    }

    /// PUT to Firebase
    func put(to collection: FirebaseCollections.RawValue, _ completion: @escaping (Result<Self, Error>)-> Void) {
        return Network.shared.put(self, to: collection, completion: completion)
    }

    /// DELETE from Firebase
    func delete(from collection: FirebaseCollections.RawValue, _ completion: @escaping (Result<Void, Error>)-> Void) {
        return Network.shared.delete(self, in: collection, completion: completion)
    }
}
