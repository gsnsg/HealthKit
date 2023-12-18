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
    
    @EnvironmentObject private var parent: CalendarViewModel
    @Environment(\.presentationMode) var presentationMode
    
    
    @State private var showSelectedImagesSheet = false
    
    var body: some View {
        Form {
            
            Section(header: Text("Food Details")) {
                            TextField("Enter Food Name", text: $diaryViewModel.foodName)
                            DatePicker("Select Date & Time", selection: $diaryViewModel.selectedDate, displayedComponents: [.date, .hourAndMinute])
            }
            
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
                }.disabled(diaryViewModel.selectedImages.isEmpty)
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
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    AllFavoritesView()
                        .environmentObject(diaryViewModel)
                } label: {
                    Text("Add from Favorites")
                        .foregroundStyle(.red)
                }
            }
        }.onChange(of: diaryViewModel.dismissView) { _ in
            parent.refresh()
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}
