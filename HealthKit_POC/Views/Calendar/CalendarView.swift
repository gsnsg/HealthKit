//
//  CalendarView.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 12/7/23.
//

import Combine
import SwiftUI
import FSCalendar

class CalendarViewModel: ObservableObject {
    
    @Published var selectedDate = Date()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var dateEntries: [DiaryEntry] = []
    
    init() {
       initializeSubscriptions()
    }
    
    private func initializeSubscriptions() {
        // when new date is selected
        $selectedDate
            .map { date in
                self.fetchEntriesForDate(date: date)
            }
            .receive(on: DispatchQueue.main)
            .sink { entries in
                self.dateEntries = entries
            }
            .store(in: &cancellables)
    }
    
    func fetchEntriesForDate(date: Date) -> [DiaryEntry] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        guard let startOfDay = calendar.date(from: components) else {
            return []
        }
        
        // Calculate the end of the day
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            return []
        }
        
        let predicate = NSPredicate(format: "(date >= %@) AND (date < %@)", argumentArray: [startOfDay, endOfDay])
        
        let result: [DiaryEntry] = CoreDataManager.shared.fetchAllEntries(using: predicate)
        return result
    }
    
    func refresh() {
        // triggers the subscription
        selectedDate = Date()
    }
}

struct CalendarView: View {
    
    @StateObject private var calendarViewModel = CalendarViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: .zero) {
                CalendarViewRepresentable(selectedDate: $calendarViewModel.selectedDate)
                Divider()
                List(calendarViewModel.dateEntries, id: \.date) { entry in 
                    EventRow(entry: entry)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // TODO:- do this later
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Today") {
//                        // Action for Today button
//                        selectedDate = Date()
//                    }
//                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        DiaryView()
                            .environmentObject(calendarViewModel)
                    } label: {
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
