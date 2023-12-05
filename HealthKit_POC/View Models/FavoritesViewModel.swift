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
    
    @Published var entries: [any FoodEntry] = []
    
    @Published var dismissAddFavoriteView = false
    @Published var name: String = ""
    @Published var protein: String = ""
    @Published var carbs: String = ""
    @Published var fats: String = ""
    
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
    
    func saveFavoriteItem() {
        
        let dataDict = [ "protein" : protein, "carbs" : carbs, "fats" : fats, "name" : name ]
        let imageData = selectedImages.count > 0 ? selectedImages.encodeImagesToData() : nil
        
        do {
            try CoreDataManager.shared.saveFavorites(info: dataDict, images: imageData)
            resetForm()
            DispatchQueue.main.async {
                self.dismissAddFavoriteView = true
            }
            
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func deleteFavorites() {
        
    }
    
    func getAllFavorites() {
        DispatchQueue.main.async {
            self.entries = CoreDataManager.shared.getAllFavorites()
        }
    }
    
    private func resetForm() {
        name = ""
        protein = ""
        fats = ""
        carbs = ""
        selectedItems = []
        selectedImages = []
    }
    
}
