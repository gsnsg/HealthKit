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
    
    private let dateFormatter = DateFormatter()
    
//    public func getDate(for type: UserDefaultsKeyType) -> Date? {
//        guard let dateString = UserDefaults.standard.string(forKey: type.key) else { return nil }
//        return dateFormatter.date(from: dateString)
//    }
//    
//    public func setDate(for type: UserDefaultsKeyType, date: Date) {
//        let dateString = date.dateTimeString()
//        UserDefaults.standard.setValue(dateString, forKey: type.key)
//    }
    
    public func setValue<T>(for key: UserDefaultsKeyType, value: T) {
        UserDefaults.standard.set(value, forKey: key.key)
    }
    
    public func getValue<T>(for key: UserDefaultsKeyType) -> T? {
        return UserDefaults.standard.value(forKey: key.key) as? T
    }
}
