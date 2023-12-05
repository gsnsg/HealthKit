//
//  DiaryEntriesViewModel.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 11/6/23.
//

import Foundation

class DiaryEntriesViewModel: ObservableObject {
    @Published var entries: [any FoodEntry] = []
    
    init() {
        DispatchQueue.main.async {
            self.entries = CoreDataManager.shared.getAllDiaryEntries()
        }
    }
}
