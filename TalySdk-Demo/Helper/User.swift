//
//  User.swift
//  TalySdk-Demo
//
//  Created by Taly on 06/09/23.
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

struct UserData {
    var userName: String
    var password: String
    var environment: String
    
    init(userName: String, password: String, environment: String) {
        self.userName = userName
        self.password = password
        self.environment = environment
    }
}

enum appEnv: String{
    case dev = "Development"
    case prd = "Production"
}
