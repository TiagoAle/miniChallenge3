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
import FirebaseDatabase

class PedometerViewController: UIViewController, CLLocationManagerDelegate, PedometerManagerDelegate {
    
    @IBOutlet weak var labelGoal: UILabel!
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var buttonStop: UIButton!
    var backgroundOrigin: UIColor?
    var mili: Int?
    var sec: Int?
    var min: Int?
    var calorias: String?
    var timePause: TimeInterval = 0
    var paused: Bool = false
    var mission: Mission? //= Mission(title: "dorgas", type: .daily, activityType: .walk, startDate: Date(), goal: 10, description: "deu ruim eim", prize: "ganha algo")
    var ref = FIRDatabase.database().reference(fromURL: "https://gitmove-e1481.firebaseio.com/")
   // @IBOutlet weak var activityState: UILabel!
    
    //Mission
    

    @IBOutlet weak var goal: UILabel!
    
//     self.mission = Mission(title: "dorgas", type: .daily, activityType: .walk, startDate: Date(), goal: 10, description: "deu ruim eim", prize: "ganha algo")


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
    
    @IBOutlet weak var miliSeconds: UILabel!
    @IBOutlet weak var labelSpeed: UILabel!
    var stepsQuant: NSNumber = 0
    var pedometer = PedometerManager()
    var speed: Double?

    var manager = CLLocationManager()
    var locations = [CLLocation]()


    var cal = Calendar.current
    var comps: DateComponents?
    var endDate: Date?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        backgroundOrigin = self.buttonStart.backgroundColor
        self.labelGoal.text = "\((self.mission?.goal?.intValue)!)"
        self.pedometer.delegate = self
        pedometer.congigure()
        self.manager.delegate = self
        self.manager.requestAlwaysAuthorization()
    
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.activityType = .fitness
        self.manager.distanceFilter = 1
        self.manager.startUpdatingLocation()
        self.manager.startUpdatingHeading()
    
        comps = self.cal.dateComponents([Calendar.Component.year,Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second], from: Date())
        
        comps?.hour = 10
        comps?.minute = 20
        comps?.second = 0
        //print("Cal: \(comps.hour)")
        let timeZone = NSTimeZone.system
        cal.timeZone = timeZone
        
        self.endDate = cal.date(from: comps!)
        print(ref)
        
    }
    
    // Cronometer
    
    @IBAction func startTimer(_ sender: Any) {
        if !timer.isValid{
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
            zeroTime = Date.timeIntervalSinceReferenceDate
            distanceTraveled = 0.0
            startLocation = nil
            lastLocation = nil
            
            self.mission?.verifyMission()
            pedometer.updateValues(startDate: Date())
            
            buttonStart.backgroundColor = UIColor(colorLiteralRed: 0, green: 0.7, blue: 0, alpha: 1)
            
        }
    }
    
    @IBAction func pauseTimer(_ sender: Any) {
        timer.invalidate()
        self.timePause = self.timePause + Date.timeIntervalSinceReferenceDate - zeroTime
        self.paused = true
    }
    

    @IBAction func stopTimer(_ sender: Any) {
        timer.invalidate()
        self.speed = 0.00
        self.timePause = 0
        
        manager.stopUpdatingLocation()
        
        buttonStart.backgroundColor = backgroundOrigin

    }
    
    func updateTime() {
        let currentTime = Date.timeIntervalSinceReferenceDate
        
        var timePassed: TimeInterval = currentTime - zeroTime + self.timePause
        
        let minutes = UInt8(timePassed / 60.0)
        timePassed -= (TimeInterval(minutes) * 60)
        let seconds = UInt8(timePassed)
        timePassed -= TimeInterval(seconds)
        let millisecsX10 = UInt8(timePassed * 100)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strMSX10 = String(format: "%02d", millisecsX10)
        
        miliSeconds.text = "\(strMSX10)"
        timerLabel.text = "\(strMinutes):\(strSeconds)"
        
        if timerLabel.text == "60:00:00" {
            timer.invalidate()
            manager.stopUpdatingLocation()
        }
       
    }
    //
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "Result") {
            // pass data to next view
            let resultView = segue.destination as? ResultViewController
            resultView?.missionData = sender as? Mission
            resultView?.ref = self.ref
            
        }
        
    }
    
    func updateSteps(steps: NSNumber) {
        self.stepsQuant = steps
        self.mission?.currentProgress = steps
        if (self.mission?.currentProgress?.intValue)! >= (self.mission?.goal?.intValue)! {
            DispatchQueue.main.async {
                self.mission?.endDate = Date()
//            self.mission?.xpEarned = 10
                self.mission?.verifyMission()
            
                self.performSegue(withIdentifier: "Result", sender: self.mission)
            }
            
        }
        DispatchQueue.main.async {
            self.labelSteps.text = "\((self.mission?.currentProgress)!)"
        }
        
        
    }
    
    func clearVelocity() {
        speed = 0
        self.labelSpeed.text = "\(self.speed!)"
        
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var lastLocation = locations.last
        //var secondLast = locations[locations.count - 2]
        //var speed: CLLocationSpeed = (lastLocation?.speed)! - secondLast.speed
        if !(lastLocation?.speed.isLessThanOrEqualTo(-1.0))!{
            labelSpeed.text = String.init(format: "%.2f", (lastLocation?.speed)! * 3.6)
            //print(speed)
            print((lastLocation?.speed)!)
        }
        
        
        if startLocation == nil {
            startLocation = locations.first as CLLocation!
        } else {
            let lastDistance = lastLocation?.distance(from: locations.last as CLLocation!)
            distanceTraveled += lastDistance! * 0.000621371
            
            let trimmedDistance = String(format: "%.2f", distanceTraveled)
            
            milesLabel.text = "\(trimmedDistance)"
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
