//
//  CSVHeaders.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 10/9/23.
//

import Foundation


public enum CSVHeaders {
    case steps
    case heartRate
    case workout
    
    var headers: [String] {
        switch self {
        case .steps:
            return ["Start Date", "End Date", "Count", "Interval"]
        case .heartRate:
            return ["Timestamp", "Heart Rate", "Interval"]
        case .workout:
            return ["Workout Type", "Date", "Calories Burned"]
        }
    }
}
