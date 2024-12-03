//
//  User.swift
//  TalySdk-Demo
//
//  Created by Mehul Goswami on 06/09/23.
//

import Foundation

class User {
    private static let userDefaults = UserDefaults.standard
    
    static var userName: String {
        get {
            return userDefaults.string(forKey: "userName") ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: "userName")
        }
    }
    
    static var password: String {
        get {
            return userDefaults.string(forKey: "password") ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: "password")
        }
    }

}

