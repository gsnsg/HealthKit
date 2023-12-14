//
//  CalendarView.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 12/7/23.
//

import SwiftUI
import FSCalendar


struct CalendarViewRepresentable: UIViewRepresentable {
    
    @Binding var selectedDate: Date
    
    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        
        // Added the below code to change calendar appearance
        calendar.appearance.todayColor = UIColor(displayP3Red: 0,
                                                 green: 0,
                                                 blue: 0, alpha: 0)
        
        // TODO:- Update Color Schemas
        calendar.appearance.todaySelectionColor = .red
        calendar.appearance.titleTodayColor = .black
        
        calendar.appearance.eventSelectionColor = .red
        calendar.appearance.selectionColor = .red
        calendar.appearance.eventDefaultColor = .red
        calendar.appearance.titleTodayColor = .red
        calendar.appearance.titleFont = .boldSystemFont(ofSize: 15)
        calendar.appearance.weekdayTextColor = .lightGray
        calendar.appearance.headerMinimumDissolvedAlpha = 0.12
        calendar.appearance.headerTitleFont = .systemFont(
            ofSize: 15,
            weight: .black)
        
        calendar.appearance.headerTitleColor = .darkGray
        calendar.scrollDirection = .horizontal
        calendar.scope = .month
        calendar.clipsToBounds = false
        
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        print("Update UI called")
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        let parent: CalendarViewRepresentable
        
        init(_ calendar: CalendarViewRepresentable) {
            self.parent = calendar
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
        }
    }
}

struct CalendarView: View {
    @State private var selectedDate = Date()

    var body: some View {
        NavigationStack {
            VStack(spacing: .zero) {
                CalendarViewRepresentable(selectedDate: $selectedDate)
                Divider()
                // Get the data
                List {
                    ForEach(0 ..< 9) { _ in
                        EventRow()
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Today") {
                        // Action for Today button
                        selectedDate = Date()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Action for Plus button
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    CalendarView()
}
