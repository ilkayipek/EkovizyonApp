//
//  network.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 13.04.2024.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

class Network {
    static let shared = Network()
    let database = Firestore.firestore()
    let firestore = Firestore.self
    
    private init() {
        let settings = FirestoreSettings()
        database.settings = settings
    }
    
    func refCreate(collection: FirebaseCollections,uid: String) -> DocumentReference {
        return database.collection(collection.rawValue).document(uid)
    }
    
    
}

extension Network {
    
    func getOne<T: Decodable>(of type: T.Type, with query: Query, completion: @escaping (Result<T, Error>) -> Void) {
        query.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error: \(#function) couldn't access snapshot, \(error)")
                completion(.failure(error))
                return
            }
            
            guard let document = querySnapshot?.documents.first else {
                print("Warning: \(#function) document not found")
                completion(.failure(DocumentError.documentNotFound))
                return
            }
            
            do {
                let data = try document.data(as: T.self)
                completion(.success(data))
            } catch let error {
                print("Error: \(#function) document(s) not decoded from data, \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func getMany<T: FirebaseIdentifiable>(of type: T.Type, with query: Query, completion: @escaping (Result<[T], Error>) -> Void) {
        query.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error: couldn't access snapshot, \(error)")
                completion(.failure(error))
                return
            }
            
            var response: [T] = []
            guard let documents = querySnapshot?.documents else {
                completion(.success(response))
                return
            }
            
            for document in documents {
                do {
                    let data = try document.data(as: T.self)
                    response.append(data)
                } catch let error {
                    print("Error: \(#function) document(s) not decoded from data, \(error)")
                    completion(.failure(error))
                    return
                }
            }
            print(response)
            completion(.success(response))
        }
    }
    
    func getMany<T: FirebaseIdentifiable>(lastDoc: DocumentSnapshot? = nil, of type: T.Type, with query: Query, completion: @escaping (Result<([T], DocumentSnapshot?), Error>) -> Void) {
        
        var newQuery = query
        if let lastDoc {
            newQuery = newQuery.start(afterDocument: lastDoc)
        }
        
        newQuery.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error: couldn't access snapshot, \(error)")
                completion(.failure(error))
                return
            }
            
            var response: [T] = []
            guard let documents = querySnapshot?.documents else {
                completion(.success((response, nil)))
                return
            }
            
            for document in documents {
                do {
                    let data = try document.data(as: T.self)
                    response.append(data)
                } catch let error {
                    print("Error: \(#function) document(s) not decoded from data, \(error)")
                    completion(.failure(error))
                    return
                }
            }
            
            let lastDoc = documents.last
            completion(.success((response, lastDoc)))
        }
    }

    
    func getDocument<T: Decodable>(reference: DocumentReference, completion: @escaping (Result<T, Error>) -> Void) {
        reference.getDocument { documentSnapshot, error in
            
            guard let data = try? documentSnapshot?.data(as: T.self) else {
                let error = NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode document"])
                completion(.failure(error))
                return
            }
            completion(.success(data))
        }
    }
    
    
    
    
    func post<T: FirebaseIdentifiable>(_ value: T, to collection: FirebaseCollections, completion: @escaping (Result<T, Error>) -> Void) {
        let valueToWrite: T = value
        let ref = database.collection(collection.rawValue).document(value.id)
        
        do {
            try ref.setData(from: valueToWrite) { error in
                if let error = error {
                    print("Error: \(#function) in collection: \(collection), \(error)")
                    completion(.failure(error))
                    return
                }
                completion(.success(valueToWrite))
            }
        } catch let error {
            print("Error: \(#function) in collection: \(collection), \(error)")
            completion(.failure(error))
        }
    }
    
    func put<T: FirebaseIdentifiable>(_ value: T, to collection: FirebaseCollections, completion: @escaping (Result<T, Error>) -> Void) {
        let ref = database.collection(collection.rawValue).document(value.id)
        do {
            try ref.setData(from: value) { error in
                if let error = error {
                    print("Error: \(#function) in \(collection) for id: \(value.id), \(error)")
                    completion(.failure(error))
                    return
                }
                completion(.success(value))
            }
        } catch let error {
            print("Error: \(#function) in \(collection) for id: \(value.id), \(error)")
            completion(.failure(error))
        }
    }
    
    func delete<T: FirebaseIdentifiable>(_ value: T, in collection: FirebaseCollections, completion: @escaping (Result<Void, Error>) -> Void) {
        let ref = database.collection(collection.rawValue).document(value.id)
        ref.delete { error in
            if let error = error {
                print("Error: \(#function) in \(collection) for id: \(value.id), \(error)")
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
    
    func deleteMany<T: FirebaseIdentifiable>(of type: T.Type,with query: Query,_ completion: @escaping(Result<Void, any Error>) -> Void) {
        query.getDocuments { querySnapshot, error in
            if let error {
                print("Error:\(#function), \(error)")
                completion(.failure(error))
            }
            
            guard let documents = querySnapshot?.documents else {
                print("Document is empty, \(#function)")
                let error = NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document is empty"])
                completion(.failure(error)); return
            }
            
            for document in documents {
                document.reference.delete()
            }
            
            completion(.success(()))
        }
    }
    
}
