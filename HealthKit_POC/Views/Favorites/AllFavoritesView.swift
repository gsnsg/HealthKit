//
//  AllFavoritesView.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 12/4/23.
//

import SwiftUI

struct AllFavoritesView: View {
    @StateObject var favoritesViewModel = FavoritesViewModel()
    @State private var isSheetPresented = false
    
    var body: some View {
        List(favoritesViewModel.entries, id: \.id) { entry in
            VStack(alignment: .leading) {
                Text(entry.name)
                Text("Date: \(entry.date, formatter: itemFormatter)")
                Text("Protein: \(entry.protein)g, Carbs: \(entry.carbs)g, Fats: \(entry.fats)g")
                // Display images if needed
                // For example, using a ScrollView
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(entry.uiImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        }
                    }
                }
            }
        }
        .navigationTitle("Favorites")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    AddFavoriteItemView()
                        .environmentObject(favoritesViewModel)
                } label: {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Refresh action
                    favoritesViewModel.getAllFavorites()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        .onAppear {
            favoritesViewModel.getAllFavorites()
        }
    }
}


// Formatter for the date
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
