//
//  HealthKitManager.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 8/28/23.
//

import Combine
import Foundation
import HealthKit
import SwiftUI

enum HealthAccessError: Error {
    case error(Error?)
    case healthDataNotAvailable
    case stepsStatisticError
}

public final class HealthKitManager: ObservableObject {
    
    @Published var isHealthKitAuthorized = false
    
    private var healthStore:HKHealthStore?
    private var collectionQueries: [HKStatisticsCollectionQuery] = []
    private var sampleQueries: [HKSampleQuery] = []
    
    @Published public var dataCsvPairs = [(String, String)]()
    
    // Publishers for sending data
    private let stepsPublisher = PassthroughSubject<Void, Never>()
    private let heartRatePublisher = PassthroughSubject<Void, Never>()
    private let workoutPublisher = PassthroughSubject<Void, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    
    var combinedPublisher: AnyPublisher<Void, Never>
    
    private let readDatatypes = ["Steps", "Heart Rate", "Workout"]
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        } else {
            fatalError("HealthKit not available")
        }
        
        combinedPublisher = Publishers.CombineLatest3(stepsPublisher, heartRatePublisher, workoutPublisher)
               .map { _ in () }
               .eraseToAnyPublisher()
    }
    
    func startObserving() {
        combinedPublisher
            .sink(receiveValue: {})
            .store(in: &cancellables)
    }
    
    func getDatatypes() -> [String] {
        readDatatypes
    }
    
    func requestPermissions(completion: @escaping (Result<Bool, HealthAccessError>) -> Void) {
        guard let healthStore = self.healthStore else {
            completion(.failure(.healthDataNotAvailable))
            return
        }
        
        guard let stepCount = HKQuantityType.quantityType(forIdentifier: .stepCount),
              let heartRate = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            completion(.failure(.healthDataNotAvailable))
            return
        }
        

        let allTypes = Set([stepCount, heartRate, HKWorkoutType.workoutType()])
        
        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            if success {
                completion(.success(true))
                DispatchQueue.main.async {
                    self.isHealthKitAuthorized = true
                }
                
            } else {
                completion(.failure(.error(error)))
            }
        }
    }
    
    deinit {
        collectionQueries.forEach({ healthStore?.stop($0) })
        sampleQueries.forEach({ healthStore?.stop($0) })
        healthStore = nil
    }
}

// Get All Health Data
extension HealthKitManager {
    public func exportAllHealthData() {
        exportSteps()
        exportHeartRate()
        exportWorkoutData()
    }
}

// Steps Data
extension HealthKitManager {
    
    public func exportSteps() {
        
        //   Define the Step Quantity Type
        let stepsCount = HKQuantityType(.stepCount)
        
        // TODO:- Check with professor on what should be the frequency for collecting this data
        let startDate: Date = Date.getStartOfYear(for: Date())
        // get current date as end date
        let endDate = Date()
        
        // define the predicate
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        // define an anchor, date doesn't matter only time matters
        let anchorDate: Date = startDate
        
        // Define one minute intervals
        let intervalComponents = DateComponents(minute:1)
        
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount,
                                                quantitySamplePredicate: predicate,
                                                anchorDate: anchorDate,
                                                intervalComponents: intervalComponents)
        
        query.initialResultsHandler = { [weak self] query, results, error in
            guard let self = self else { return }
            if let statCollection = results {
                let data = self.parseStatisticsArray(statistics: statCollection.statistics())
                
                DispatchQueue.main.async {
                    // add steps data
                    self.dataCsvPairs.append((FileNames.steps.rawValue, data.joined(separator: "\n")))
                    self.stepsPublisher.send()
                    print("Steps: ", self.dataCsvPairs.count)
                }
            }
        }
        
        collectionQueries.append(query)
        healthStore?.execute(query)
    }
    
    private func parseStatisticsArray(statistics: [HKStatistics])  -> [String] {
        var parsedStats = statistics.map { (stat) in
            do {
                let response = try parseStatistic(statistic: stat)
                return response
            } catch {
                return ""
            }
        }
        let headerString = CSVHeaders.steps.headers.joined(separator: ",") + "\n"
        parsedStats.insert(headerString, at: 0)
        // Remove the empty strings (errors)
        return parsedStats.filter({ !$0.isEmpty })
    }
    
    private func parseStatistic(statistic: HKStatistics) throws -> String {
        guard let stepsCount = statistic.sumQuantity()?.doubleValue(for: .count()) else { throw HealthAccessError.stepsStatisticError }
        
        let startDate = statistic.startDate
        let endDate = statistic.endDate
        return "\(startDate),\(endDate),\(stepsCount),1 min"
    }
}

// Heart Rate
extension HealthKitManager {
    func exportHeartRate() {
        
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        
        let startDate = Date.getStartOfYear(for: Date())
        let endDate = Date()
        
        let datePredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        let query = HKSampleQuery(sampleType: heartRateType, predicate: datePredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] (_, results, error) in
            guard let self = self else { return }
            if let heartRateSamples = results as? [HKQuantitySample] {
                let data = parseHeartRate(for: heartRateSamples)
                DispatchQueue.main.async {
                    self.dataCsvPairs.append((FileNames.heartRate.rawValue, data))
                    self.heartRatePublisher.send()
                    print("Heart: ", self.dataCsvPairs.count)
                }
            }
        }

        sampleQueries.append(query)
        healthStore?.execute(query)
    }
    
    private func parseHeartRate(for samples: [HKQuantitySample]) -> String {
        var result = [String]()
        result.append(CSVHeaders.heartRate.headers.joined(separator: ","))
        
        for sample in samples {
            // get heart rate
            let heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            let timestamp = sample.startDate

            // Add the heart rate value to the CSV string.
            result.append("\(timestamp),\(heartRate),1 min")
        }
        
        return result.joined(separator: "\n")
    }
}

// Workouts data
extension HealthKitManager {
    func exportWorkoutData() {
        
        let startDate = Date.getStartOfYear(for: Date())
        let endDate = Date()
        
        let datePredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        // Create a query to fetch the workouts.
        let query = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate: datePredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] query, samples, error in
            guard let self = self else { return }
            guard let samples = samples as? [HKWorkout] else {
                fatalError("An error occurred while fetching workouts: \(error?.localizedDescription ?? "")")
            }
            
            var strings = [CSVHeaders.workout.headers.joined(separator: ",")]
            samples.forEach{ strings.append(self.getWorkoutString($0)) }
            
            let data = strings.joined(separator: "\n")
            DispatchQueue.main.async {
                self.dataCsvPairs.append((FileNames.workout.rawValue, data))
                self.workoutPublisher.send()
            }
        }
        
        sampleQueries.append(query)
        healthStore?.execute(query)
    }
    
    private func getWorkoutString(_ workout: HKWorkout) -> String {
        // type, date, calories, heart rate
        return "\(workout.workoutActivityType),\(workout.startDate),\(String(describing: workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0))"
    }
}
