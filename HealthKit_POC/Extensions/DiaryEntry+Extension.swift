//
//  DiaryEntry+Extension.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 11/6/23.
//

import UIKit

protocol EventRowDataSource {
    var name: String? { get }
    var protein: String? { get }
    var carbs: String? { get }
    var fats: String? { get }
    var uiImages: [UIImage] { get }
}

extension DiaryEntry: EventRowDataSource {
    var uiImages: [UIImage] {
        guard let data = self.images, let decodedImages: [UIImage] = [UIImage].decodeImagesFromData(data: data) else {
            return []
        }
        return decodedImages
        
    }
}

extension FavoriteEntry: EventRowDataSource {
    var uiImages: [UIImage] {
        guard let data = self.images, let decodedImages: [UIImage] = [UIImage].decodeImagesFromData(data: data) else {
            return []
        }
        return decodedImages
        
    }
}
