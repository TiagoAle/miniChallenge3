//
//  HealthKitManager.swift
//  Challenge3
//
//  Created by Tiago Queiroz on 24/11/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit
import HealthKit


class HealthKitManager: NSObject{
    let healthKitStore: HKHealthStore = HKHealthStore()
    
    func authorizeHealthKit(completion: ((_ success:Bool,_ error:Error?) -> Void)!)
    {
        // 1. Set the types you want to read from HK Store
        
        let healthKitTypesToRead: Set<HKObjectType> = [
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!,
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
            HKObjectType.workoutType()
        ]
        
        // 2. Set the types you want to write to HK Store
        let healthKitTypesToWrite: Set<HKSampleType> = [
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMassIndex)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
            HKQuantityType.workoutType()
        ]
        
        // 3. If the store is not available (for instance, iPad) return an error and don't go on.
        if !HKHealthStore.isHealthDataAvailable()
        {
            let error = NSError(domain: "com.bepid.tiago.Challenge3", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
            if( completion != nil )
            {
                completion(false, error)
            }
            return
        }
        
        healthKitStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead, completion: completion as (Bool, Error?) -> Void)
    }
    
    func receiveUserData() -> ( age:Int?,  biologicalsex:String?, bloodtype:String?)
    {
        var dateOfBirth: Date! = nil
        var userAge: Int! = -1
        do {
            
            dateOfBirth = try healthKitStore.dateOfBirthComponents().date
            let now = Date()
            
            let ageComponents: DateComponents = Calendar.current.dateComponents([.year], from: dateOfBirth, to: now)
            
            userAge = ageComponents.year!
            
        } catch {
            
            print("Either an error occured fetching the user's age information or none has been stored yet. In your app, try to handle this gracefully.")
            
        }
        
        
        
        //let ageValue: String = NumberFormatter.localizedString(from: userAge as NSNumber, number: NumberFormatter.Style.none)
        // 3. Read blood type
        var bloodType:HKBloodTypeObject! = nil
        do {
            
            bloodType = try healthKitStore.bloodType()
        } catch {
            
            print("Either an error occured fetching the user's age information or none has been stored yet. In your app, try to handle this gracefully.")
            
        }
        
        var biologicalSex: HKBiologicalSexObject?
        do {
            
            biologicalSex = try healthKitStore.biologicalSex()
        } catch {
            
            print("Either an error occured fetching the user's age information or none has been stored yet. In your app, try to handle this gracefully.")
            
        }
        
        var bSex: String? {
            if let biologicalSex =  try? healthKitStore.biologicalSex(){
                switch biologicalSex.biologicalSex {
                case .female:
                    return "Female"
                case .male:
                    return "Male"
                case .notSet:
                    return "Unknown"
                default:
                    return "Unknown"
                }
            }
            return "Unknown"
        }
        
        
        var bType: String? {
            if let bloodType = try? healthKitStore.bloodType(){
                switch bloodType.bloodType {
                case .aPositive:
                    return "A+"
                case .aNegative:
                    return "A-"
                case .bPositive:
                    return "B+"
                case .bNegative:
                    return "B-"
                case .abPositive:
                    return "AB+"
                case .abNegative:
                    return "AB-"
                case .oPositive:
                    return "O+"
                case .oNegative:
                    return "O-"
                case .notSet:
                    return "Unknown"
                }
            }
            return "Unknown"
        }
        // 4. Return the information read in a tuple
        return (userAge, bSex, bType)
    }
    
    func readMostRecentSample(sampleType:HKSampleType , completion: ((HKSample?, Error?) -> Void)!)
    {
        
        // 1. Build the Predicate
        let past = Date.distantPast
        let now   = Date()
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: past, end:now, options: [])
        
        // 2. Build the sort descriptor to return the samples in descending order
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        // 3. we want to limit the number of samples returned by the query to just 1 (the most recent)
        let limit = 1
        
        // 4. Build samples query
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor])
        { (sampleQuery, results, error ) -> Void in
            
            if error != nil {
                completion(nil,error)
                return
            }
            
            // Get the first sample
            let mostRecentSample = results?.first as? HKQuantitySample
            
            // Execute the completion closure
            if completion != nil {
                completion(mostRecentSample,nil)
            }
        }
        // 5. Execute the Query
        self.healthKitStore.execute(sampleQuery)
    }
    
}
