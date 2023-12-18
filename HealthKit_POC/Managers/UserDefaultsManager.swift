//
//  UserDefaultsManager.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 10/9/23.
//

import Foundation

let TAG = "health-poc-user-defaults"

public enum UserDefaultsKeyType: String {
    case steps
    case heartrate
    
    //
    case userName
    case userId
    
    var key: String {
        return "\(TAG)-\(self.rawValue)"
    }
}

public class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    public func setValue<T>(for key: UserDefaultsKeyType, value: T) {
        UserDefaults.standard.set(value, forKey: key.key)
    }
    
    public func getValue<T>(for key: UserDefaultsKeyType) -> T? {
        return UserDefaults.standard.value(forKey: key.key) as? T
    }
}
