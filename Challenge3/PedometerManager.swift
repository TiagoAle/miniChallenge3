//
//  PedometerManager.swift
//  Challenge3
//
//  Created by Tiago Queiroz on 30/11/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit
import CoreMotion

protocol PedometerManagerDelegate {
    func updateSteps(steps: NSNumber)
    func clearVelocity()
}

class PedometerManager: NSObject {
    
    var delegate: PedometerManagerDelegate?
    var stepsQuant: NSNumber?
    var days:[String] = []
    var stepsTaken:[Int] = []
    let activityManager = CMMotionActivityManager()
    let manager = CMMotionManager()
    let pedoMeter = CMPedometer()
    var midnightOfToday: Date?
    
    let desafio = 10.0
    
    func congigure() {
        var cal = Calendar.current
        var comps = cal.dateComponents([Calendar.Component.year,Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second], from: Date())
        
        manager.deviceMotionUpdateInterval = 0
       
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        //print("Cal: \(comps.hour)")
        let timeZone = NSTimeZone.system
        cal.timeZone = timeZone
        
        
        
        self.midnightOfToday = cal.date(from: comps)
        
    }
    func updateValues(){
        if(CMMotionActivityManager.isActivityAvailable()){
            self.activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: { (data) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    if(data!.stationary == true){
                        print("Stationary")
                        // func zerar velocidade
                        self.delegate?.clearVelocity()
                    } else if (data!.walking == true){
                        print("Walking")
                    } else if (data!.running == true){
                        print("Running")
                    } else if (data!.automotive == true){
                        print("Automotive")
                    }
                })
                
            })
        }
        if(CMPedometer.isStepCountingAvailable()){
//            let fromDate = Date(timeIntervalSinceNow: -86400 * 7)
//            //let fromDate = Date()
//            self.pedoMeter.queryPedometerData(from: fromDate as Date, to: Date(), withHandler: { (data, error) in
//                print(data!)
//                
//                DispatchQueue.main.async {
//                    if(error == nil){
//                        self.stepsQuant = data!.numberOfSteps
//                        // passar por delegate
//                        self.delegate?.updateSteps(steps: self.stepsQuant!)
//                    }
//                }
//                
//            })
            
            self.pedoMeter.startUpdates(from: self.midnightOfToday!) { (data, error) -> Void in
                DispatchQueue.main.async {
                    if(error == nil){
                        self.stepsQuant = data!.numberOfSteps
                        // passar por delegate
                        self.delegate?.updateSteps(steps: self.stepsQuant!)
                    }
                }
            }
        }

    }

}

