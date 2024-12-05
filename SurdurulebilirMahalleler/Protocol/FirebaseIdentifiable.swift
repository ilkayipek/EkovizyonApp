//
//  FirebaseIdentifiable.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 15.04.2024.
//

import Foundation

protocol FirebaseIdentifiable: Hashable, Codable {
    var id: String { get set }
}
