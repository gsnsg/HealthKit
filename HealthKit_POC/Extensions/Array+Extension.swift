//
//  List+Extension.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 11/6/23.
//

import Foundation
import UIKit

extension Array where Element: UIImage {
    func encodeImagesToData() -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
}

extension Array {
    static func decodeImagesFromData(data: Data) -> [UIImage]? {
        let allowedClasses = [NSArray.self, UIImage.self]
        return try? NSKeyedUnarchiver.unarchivedObject(ofClasses: allowedClasses, from: data) as? [UIImage]
    }
}
