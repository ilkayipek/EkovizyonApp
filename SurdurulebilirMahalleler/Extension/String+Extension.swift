//
//  String+Extension.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 20.04.2024.
//

import Foundation

extension String {
    func generateUsername(length: Int) -> Self {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let numbers = "0123456789"
        let characters = letters + numbers
        
        var username = ""
        for _ in 0..<length {
            let randomIndex = Int.random(in: 0..<characters.count)
            let character = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
            username.append(character)
        }
        
        return username
    }
}
