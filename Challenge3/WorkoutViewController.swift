//
//  TimerViewController.swift
//  OneHourWalker
//
//  Created by Matthew Maher on 2/18/16.
//  Copyright © 2016 Matt Maher. All rights reserved.
//

import UIKit
import CoreLocation
import HealthKit

class WorkoutViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    //@IBOutlet weak var heightLabel: UILabel!
    
    var zeroTime = TimeInterval()
    var timer : Timer = Timer()
    
    let locationManager = CLLocationManager()
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var distanceTraveled = 0.0
    
    let healthManager:HealthKitManager = HealthKitManager()
    var height: HKQuantitySample?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        } else {
            print("Need to Enable Location")
        }
        
        // We cannot access the user's HealthKit data without specific permission.
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func startTimer(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        zeroTime = Date.timeIntervalSinceReferenceDate
        
        distanceTraveled = 0.0
        startLocation = nil
        lastLocation = nil
        
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func stopTimer(_ sender: Any) {
        timer.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    func updateTime() {
        let currentTime = Date.timeIntervalSinceReferenceDate
        var timePassed: TimeInterval = currentTime - zeroTime
        let minutes = UInt8(timePassed / 60.0)
        timePassed -= (TimeInterval(minutes) * 60)
        let seconds = UInt8(timePassed)
        timePassed -= TimeInterval(seconds)
        let millisecsX10 = UInt8(timePassed * 100)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strMSX10 = String(format: "%02d", millisecsX10)
        
        timerLabel.text = "\(strMinutes):\(strSeconds):\(strMSX10)"
        
        if timerLabel.text == "60:00:00" {
            timer.invalidate()
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first as CLLocation!
        } else {
            let lastDistance = lastLocation.distance(from: locations.last as CLLocation!)
            distanceTraveled += lastDistance * 0.000621371
            
            let trimmedDistance = String(format: "%.2f", distanceTraveled)
            
            milesLabel.text = "\(trimmedDistance) Miles"
        }
        
        lastLocation = locations.last as CLLocation!
    }
    
    @IBAction func share(_ sender: Any) {
        healthManager.saveDistance(distanceRecorded: distanceTraveled, date: Date())
    }
    
}
