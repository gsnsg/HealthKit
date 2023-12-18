//
//  FavoritesViewModel.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 12/4/23.
//

import Foundation
import SwiftUI
import PhotosUI

class FavoritesViewModel: ObservableObject {

    @Published var selectedImages = [UIImage]()
    @Published var selectedItems: [PhotosPickerItem] = [] {
        didSet {
            processSelectedItems(pickedItems: selectedItems)
        }
    }
    
    @Published var favorites: [FavoriteEntry] = []
    @Published var dismissAddFavoriteView = false
    @Published var foodName: String = ""
    @Published var protein: String = ""
    @Published var carbs: String = ""
    @Published var fats: String = ""
    
    private var itemsSet = Set<PhotosPickerItem>()
    
    init() {
        getAllFavorites()
    }
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
    
    func saveFavoriteItem() {
        let imageData = !selectedImages.isEmpty ? selectedImages.encodeImagesToData() : nil
        let dataDict: [String : Any] = [
            "name" : foodName,
            "date":Date(), // default
            "protein" : protein,
            "carbs" : carbs,
            "fats" : fats,
            "images" : imageData
        ]
        
        do {
            try CoreDataManager.shared.saveEntry(entityName: "FavoriteEntry", info: dataDict)
            self.dismissAddFavoriteView = true
            self.getAllFavorites()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func deleteFavorites() {
        
    }
    
    func getAllFavorites() {
        DispatchQueue.main.async {
            self.favorites = CoreDataManager.shared.fetchAllEntries()
        }
    }
    
    private func resetForm() {
        // go back to all favorites
    }
    
}
