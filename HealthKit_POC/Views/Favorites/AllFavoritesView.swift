//
//  AllFavoritesView.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 12/4/23.
//

import SwiftUI

struct AllFavoritesView: View {
    @StateObject var favoritesViewModel = FavoritesViewModel()
    @EnvironmentObject var parent: DiaryViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List(favoritesViewModel.favorites, id: \.date) { favorite in
                EventRow(entry: favorite)
                .onTapGesture {
                    didTapFavorite(favorite)
                }
        }
        .listStyle(.plain)
        .navigationTitle("Choose a Favorite")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    AddFavoriteItemView()
                        .environmentObject(favoritesViewModel)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    private func didTapFavorite(_ favorite: FavoriteEntry) {
        parent.fillDetailsFromFavorite(favorite: favorite)
        self.presentationMode.wrappedValue.dismiss()
    }
}
