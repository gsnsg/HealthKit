//
//  HomeViewModel.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 11/6/23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    
    @Published var isExportButtonDisabled = false
    @Published var exportData = false
    
    // Alert variables
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    // managers dependenceis
    private let healthKitManager = HealthKitManager()
    
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        healthKitManager.combinedPublisher
            .sink { _ in
                self.exportData.toggle()
            }.store(in: &cancellables)
    }
    
    func startSetup() {
        healthKitManager.requestPermissions(completion: { result in })
        
        healthKitManager.startObserving()
    }
    
    func fileExportedCompletion(result: Result<[URL], Error>) {
        switch result {
        case .success(let url):
            print("Saved to \(url)")
        case .failure(let error):
            print(error.localizedDescription)
            
        }
        isExportButtonDisabled.toggle()
    }
    
    func exportHealthData() {
        healthKitManager.exportAllHealthData()
        isExportButtonDisabled = true
    }
    
    func getCsvFiles() -> [CSVFile] {
        healthKitManager.dataCsvPairs.map({ CSVFile(data: $1, filename: $0) })
    }
    
    func getDataTypes() -> [String] {
        healthKitManager.getDatatypes()
    }
}
