//
//  DiaryView.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 10/31/23.
//

import SwiftUI
import PhotosUI

struct DiaryView: View {
    @StateObject private var diaryViewModel = DiaryViewModel()
    
    @State private var showSelectedImagesSheet = false
    
    var body: some View {
        Form {
            Section(header: Text("Images")) {
                PhotosPicker(selection: $diaryViewModel.selectedItems,
                             matching: .images) {
                    Text("Pick Images")
                }
                
                NavigationLink {
                    SelectedImagesView(images: diaryViewModel.selectedImages)
                } label: {
                    Text("View selected photos")
                        .foregroundStyle(.red)
                }.disabled(diaryViewModel.selectedImages.count == 0)
            }
            
            Section(header: Text("Macros (in gms)")) {
                TextField("Protein (g)", text: $diaryViewModel.protein)
                    .keyboardType(.numberPad)
                TextField("Carbs (g)", text: $diaryViewModel.carbs)
                    .keyboardType(.numberPad)
                TextField("Fats (g)", text: $diaryViewModel.fats)
                    .keyboardType(.numberPad)
            }
            
            Button(action: {
                diaryViewModel.submitEntry()
            }) {
                Text("Save Entry")
            }
            
            NavigationLink {
                DiaryEntries() 
            } label: {
                Text("View Past Entries")
                    .foregroundStyle(.red)
            }
            
            NavigationLink {
                AllFavoritesView()
            } label: {
                Text("Add/Update from Favorites")
                    .foregroundStyle(.red)
            }
        }
    }
}
