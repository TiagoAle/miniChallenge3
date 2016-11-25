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
    
    func updateUserAge() -> Void
    {
        var dateOfBirth: Date! = nil
        
        do {
            
            dateOfBirth = try healthKitStore.dateOfBirthComponents().date
            
        } catch {
            
            print("Either an error occured fetching the user's age information or none has been stored yet. In your app, try to handle this gracefully.")
            
            return
        }
        
        let now = Date()
        
        let ageComponents: DateComponents = Calendar.current.dateComponents([.year], from: dateOfBirth, to: now)
        
        let userAge: Int = ageComponents.year!
        
        //let ageValue: String = NumberFormatter.localizedString(from: userAge as NSNumber, number: NumberFormatter.Style.none)
        print(userAge)
    }
    
}
