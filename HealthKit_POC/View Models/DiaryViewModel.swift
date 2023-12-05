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
    
    func submitEntry() {
        // TODO:- Data Validation Goes here
        // api call goes here
        // core data entry
        
        let dataDict = [ "protein" : protein, "carbs" : carbs, "fats" : fats]
        let imageData = selectedImages.count > 0 ? selectedImages.encodeImagesToData() : nil
        
        do {
            try CoreDataManager.shared.saveDiaryEntry(info: dataDict, images: imageData)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
