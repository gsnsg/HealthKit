//
//  DiaryViewModel.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 11/6/23.
//

import Foundation
import SwiftUI
import PhotosUI

enum DiaryError: Error {
    case emptyEntryFound
    case invalidData
    case unknownError
}

class DiaryViewModel: ObservableObject {
    @Published var selectedImages = [UIImage]()
    @Published var selectedItems: [PhotosPickerItem] = [] {
        didSet {
            processSelectedItems(pickedItems: selectedItems)
        }
    }
    
    // Form Values
    @Published var foodName: String = ""
    @Published var selectedDate = Date()
    @Published var protein: String = ""
    @Published var carbs: String = ""
    @Published var fats: String = ""
    
    @Published var dismissView = false
    
    private var itemsSet = Set<PhotosPickerItem>()
    
    func processSelectedItems(pickedItems: [PhotosPickerItem]) {
        pickedItems.forEach { item in
            // if its already in images then no need to consider it
            if itemsSet.contains(item) {
                return
            }
            
            // add the item
            itemsSet.insert(item)

            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let imageData) where imageData != nil:
                    DispatchQueue.main.async {
                        self.selectedImages.append(UIImage(data: imageData!)!)
                    }
                default:
                    print("Error Occured while getting data from image")
                }
            }
        }
    }
    
    func submitEntry() {
        // api call goes here
        // core data entry
        
        let imageData = !selectedImages.isEmpty ? selectedImages.encodeImagesToData() : nil
        
        let dataDict: [String : Any] = [
            "name" : foodName,
            "date" : selectedDate,
            "protein" : protein,
            "carbs" : carbs,
            "fats" : fats,
            "images" : imageData]
        
        do {
            try CoreDataManager.shared.saveEntry(entityName: "DiaryEntry", info: dataDict)
            dismissView = true
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    // Update from favorite
    func fillDetailsFromFavorite(favorite: FavoriteEntry) {
        foodName = favorite.name ?? ""
        protein = favorite.protein ?? ""
        carbs = favorite.carbs ?? ""
        fats = favorite.fats ?? ""
        selectedDate = Date()
        selectedImages = favorite.uiImages
    }
}
