//
//  CSVFile.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 10/9/23.
//

import Foundation
import UniformTypeIdentifiers
import SwiftUI
import Combine // Add this import for Combine

struct CSVFile: FileDocument {
    
    static var readableContentTypes: [UTType] { [.commaSeparatedText] }
    static var writableContentTypes: [UTType] { [.commaSeparatedText] }
    
    var data: String
    var filename: String
    
    init(data: String, filename: String) {
        self.data = data
        self.filename = filename
    }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            self.data = String(data: data, encoding: .utf8) ?? ""
            self.filename = configuration.file.filename ?? ""
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(data.utf8)
        
        // Set the suggested file name here
        let fileWrapper = FileWrapper(regularFileWithContents: data)
        fileWrapper.preferredFilename = self.filename
        
        return fileWrapper
    }
}

