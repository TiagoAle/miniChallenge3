//
//  WorkoutManager.swift
//  Challenge3
//
//  Created by Tiago Queiroz on 29/11/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit
import HealthKit

class WorkoutManager: NSObject {
    
    func initVars(){
        var finish = Date() // Now
        var start = finish.addingTimeInterval(-3600)  // 1 hour ago
        
        //let workout = HKWorkout(activityType: .Running, startDate: start, endDate: finish)
        
        let workoutEvents: [HKWorkoutEvent] = [
            HKWorkoutEvent(type: .pause, date: start.addingTimeInterval(300)),
            HKWorkoutEvent(type: .resume, date: start.addingTimeInterval(600))
        ]
        

        // 1,000 kilojoules
        let totalEnergyBurned = HKQuantity(unit: HKUnit.jouleUnit(with: .kilo), doubleValue: 1000)
        
        // 3 KM distance
        let totalDistance = HKQuantity(unit: HKUnit.meter(), doubleValue: 3000)

        let metadata: [String: AnyObject] = [
            HKMetadataKeyGroupFitness: true as AnyObject,
            HKMetadataKeyIndoorWorkout: false as AnyObject,
            HKMetadataKeyCoachedWorkout: true as AnyObject
        ]
        
        let workout = HKWorkout(
            activityType: .running,
            start: start,
            end: finish,
            workoutEvents: workoutEvents,
            totalEnergyBurned: totalEnergyBurned,
            totalDistance: totalDistance,
            device: nil,
            metadata: metadata
        )
    }
}
