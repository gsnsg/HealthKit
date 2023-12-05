//
//  DairyEntries.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 11/6/23.
//

import SwiftUI

struct DetailView: View {
    let entry: any FoodEntry
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Date: \(entry.date.dateTimeString())")
                .bold()
            Text("P: \(entry.protein), C: \(entry.carbs), F: \(entry.fats)")
            if entry.uiImages.count > 0 {
                Text("\(entry.uiImages.count) \(entry.uiImages.count == 1 ? "image" : "images")")
            }
        }
    }
}

struct DiaryEntries: View {
    
    @StateObject var viewModel = DiaryEntriesViewModel()
    
    var body: some View {
        List {
            Section("P - Protein, C - Carbs, F - Fats") {
                ForEach(viewModel.entries, id: \.id) { entry in
                    if entry.uiImages.count > 0 {
                        NavigationLink {
                            SelectedImagesView(images: entry.uiImages)
                        } label: {
                            DetailView(entry: entry)
                        }
                    } else {
                        DetailView(entry: entry)
                    }
                }
            }
        }.navigationTitle("Past Entries")
        .navigationBarTitleDisplayMode(.inline)
    }
}
