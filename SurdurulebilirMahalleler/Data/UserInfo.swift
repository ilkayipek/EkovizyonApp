//
//  UserDefault.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 19.04.2024.
//

import Foundation

class UserInfo {
    static let shared = UserInfo()
    
    private init() {}
    
    private var values = [UserInfoEnum: Any]()
    
    
    func retrieve<T>(key: UserInfoEnum) -> T? {
        return values[key] as? T
    }
    
    func store<T>(key: UserInfoEnum, value: T) {
        values[key] = value
    }
    
    func remove(key: UserInfoEnum) {
        values[key] = nil
    }
}
