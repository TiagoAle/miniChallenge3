//
//  PedometerViewController.swift
//  Challenge3
//
//  Created by Tiago Queiroz on 29/11/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
import HealthKit

class PedometerViewController: UIViewController, CLLocationManagerDelegate, PedometerManagerDelegate {
    
   // @IBOutlet weak var activityState: UILabel!
    
    //Cronometer
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    var zeroTime = TimeInterval()
    var timer : Timer = Timer()
    let healthManager:HealthKitManager = HealthKitManager()
    var height: HKQuantitySample?
    var distanceTraveled = 0.0
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    
    //Pedometer
    @IBOutlet weak var labelSteps: UILabel!
    
    @IBOutlet weak var labelSpeed: UILabel!
    var stepsQuant: NSNumber = 0
    var pedometer = PedometerManager()
    var speed: Double?
//    var days:[String] = []
//    var stepsTaken:[Int] = []
    var manager = CLLocationManager()
    var locations = [CLLocation]()
//   // @IBOutlet weak var stateImageView: UIImageView!
//    let activityManager = CMMotionActivityManager()
//    let pedoMeter = CMPedometer()
//    
//    let desafio = 10.0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.pedometer.delegate = self
        pedometer.congigure()
        pedometer.updateValues()
        self.manager.delegate = self
        self.manager.requestAlwaysAuthorization()
        
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.activityType = .fitness
        self.manager.distanceFilter = 1
        self.manager.startUpdatingLocation()
        self.manager.startUpdatingHeading()

    }
    
    // Cronometer
    @IBAction func startTimer(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        zeroTime = Date.timeIntervalSinceReferenceDate
        
        distanceTraveled = 0.0
        startLocation = nil
        lastLocation = nil
        
        manager.startUpdatingLocation()
    }
    
    
    @IBAction func stopTimer(_ sender: Any) {
        timer.invalidate()
        self.speed = 0.0
        manager.stopUpdatingLocation()
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
            manager.stopUpdatingLocation()
        }
    }
    //
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func showResultsAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "Result", sender: nil)
    }
    
    func updateSteps(steps: NSNumber) {
        self.stepsQuant = steps
        self.labelSteps.text = "\(self.stepsQuant)"
        
    }
    
    func clearVelocity() {
        speed = 0
        self.labelSpeed.text = "\(self.speed!)"
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var lastLocation = locations.last
        //var secondLast = locations[locations.count - 2]
        //var speed: CLLocationSpeed = (lastLocation?.speed)! - secondLast.speed
        labelSpeed.text = String.init(format: "%.2f", (lastLocation?.speed)! * 3.6)
        //print(speed)
        print((lastLocation?.speed)!)
        
        if startLocation == nil {
            startLocation = locations.first as CLLocation!
        } else {
            let lastDistance = lastLocation?.distance(from: locations.last as CLLocation!)
            distanceTraveled += lastDistance! * 0.000621371
            
            let trimmedDistance = String(format: "%.2f", distanceTraveled)
            
            milesLabel.text = "\(trimmedDistance) Meters"
        }
        
        lastLocation = locations.last as CLLocation!
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        
//        let lastLocation = locations.last
//        self.locations.append(lastLocation!)
//        let secondLast: CLLocation
//        if self.locations.count > 1{
//            secondLast = self.locations[self.locations.count-2]
//            let distanceChange: CLLocationDistance = (lastLocation?.distance(from: secondLast))!
//            let sinceLastUpdate: TimeInterval = (lastLocation?.timestamp.timeIntervalSince(secondLast.timestamp))!
//            let calculatedSpeed = distanceChange/sinceLastUpdate
//            labelSpeed.text = String.init(format: "%.2f", (calculatedSpeed) * 3.6)
//            print(calculatedSpeed)
//        }
//        
//    }
    
}
