//
//  DiaryEntry+Extension.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 11/6/23.
//

import UIKit

extension DiaryEntry {
    var uiImages: [UIImage] {
        get {
            guard let data = self.images, let decodedImages = Array<UIImage>.decodeImagesFromData(data: data) else {
                return []
            }
            return decodedImages
        }
    }
}

extension FavoritesEntry {
    var uiImages: [UIImage] {
        get {
            guard let data = self.images, let decodedImages = Array<UIImage>.decodeImagesFromData(data: data) else {
                return []
            }
            return decodedImages
        }
    }
}
