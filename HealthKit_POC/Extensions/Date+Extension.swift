//
//  Extensions.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 9/5/23.
//

import Foundation


extension Date {
    static var startOfToday = Calendar.current.startOfDay(for: Date())
    
    static func getStartOfYear(for date: Date) -> Date {
        let calendar = Calendar.current

        // Get the current date
        let currentDate = Date()

        // Get the year component of the current date
        let yearComponent = calendar.component(.year, from: currentDate)

        // Create a date representing the start of the year with all time components set to 0
        return calendar.date(from: DateComponents(year: yearComponent, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0))!
    }
    
    
    func dateTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Define the desired date and time format

        let currentDate = self

        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }
}

