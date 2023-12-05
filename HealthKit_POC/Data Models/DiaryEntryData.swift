//
//  DiaryEntryData.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 11/6/23.
//

import UIKit

protocol FoodEntry: Identifiable {
    var id: String { get }
    var name: String { get }
    var date: Date { get }
    var protein: String { get }
    var carbs: String { get }
    var fats: String { get }
    var uiImages: [UIImage] { get }
}

struct DiaryEntryData: FoodEntry {
    var name: String = ""
    let date: Date
    let protein: String
    let carbs: String
    let fats: String
    let uiImages: [UIImage]
    
    var id: String {
        date.dateTimeString()
    }
    
    init(entry: DiaryEntry) {
        date = entry.date ?? Date()
        protein = entry.protein ?? ""
        carbs = entry.carbs ?? ""
        fats = entry.fats ?? ""
        uiImages = entry.uiImages
    }
    
    init(entry: FavoritesEntry) {
        name = entry.name ?? ""
        date = entry.date ?? Date()
        protein = entry.protein ?? ""
        carbs = entry.carbs ?? ""
        fats = entry.fats ?? ""
        uiImages = entry.uiImages
    }
}
//
//struct FavoriteItem: FoodEntry {
//    let name: String
//    let date: Date
//    let protein: String
//    let carbs: String
//    let fats: String
//    let uiImages: [UIImage]
//    
//    var id: String {
//        date.dateTimeString()
//    }
//    
//    init(entry: DiaryEntry) {
//        name = entry.name ?? ""
//        date = entry.date ?? Date()
//        protein = entry.protein ?? ""
//        carbs = entry.carbs ?? ""
//        fats = entry.fats ?? ""
//        uiImages = entry.uiImages
//    }
//}

