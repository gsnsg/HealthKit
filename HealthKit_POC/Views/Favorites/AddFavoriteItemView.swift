//
//  FavoritesView.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 12/4/23.
//

import SwiftUI
import PhotosUI

struct AddFavoriteItemView: View {
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("Food Details")) {
                TextField("Name", text: $favoritesViewModel.foodName)
            }
            
            Section(header: Text("Images")) {
                PhotosPicker(selection: $favoritesViewModel.selectedItems,
                             matching: .images) {
                    Text("Pick Images")
                }
                
                NavigationLink {
                    SelectedImagesView(images: favoritesViewModel.selectedImages)
                } label: {
                    Text("View selected photos")
                        .foregroundStyle(.red)
                }.disabled(favoritesViewModel.selectedImages.isEmpty)
            }
            
            Section(header: Text("Macros (in gms)")) {
                TextField("Protein (g)", text: $favoritesViewModel.protein)
                    .keyboardType(.numberPad)
                TextField("Carbs (g)", text: $favoritesViewModel.carbs)
                    .keyboardType(.numberPad)
                TextField("Fats (g)", text: $favoritesViewModel.fats)
                    .keyboardType(.numberPad)
            }
            
            Button(action: {
                favoritesViewModel.saveFavoriteItem()
            }) {
                Text("Save Favorites")
            }
        }
        .onChange(of: favoritesViewModel.dismissAddFavoriteView) { _ in
           presentationMode.wrappedValue.dismiss()
        }
    }
}
