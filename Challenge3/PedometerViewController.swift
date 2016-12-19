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
    
//     self.mission = Mission(title: "dorgas", type: .daily, activityType: .walk, startDate: Date(), goal: 10, description: "deu ruim eim", prize: "ganha algo")


    //Cronometer
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    var zeroTime = TimeInterval()
    var timer : Timer = Timer()
    let healthManager:HealthKitManager = HealthKitManager()
    var height: HKQuantitySample?
    var distanceTraveled = 0.0
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    let SECS_OLD_MAX = 2.0;
    
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
        self.pauseButton.isEnabled = true
    }
    
    @IBAction func pauseTimer(_ sender: Any) {
        timer.invalidate()
        self.timePause = self.timePause + Date.timeIntervalSinceReferenceDate - zeroTime
        self.paused = true
        self.pauseButton.isEnabled = false
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
            resultView?.missionData = self.mission
            resultView?.ref = self.ref
            
        }
        
    }
    
    func updateSteps(steps: NSNumber, distance: NSNumber) {
        self.stepsQuant = steps
        self.distanceTraveled = distance.doubleValue
        self.mission?.currentProgress = steps
        DispatchQueue.main.async {
            self.labelSteps.text = "\((self.mission?.currentProgress)!)"
            self.milesLabel.text = String.init(format: "%.2f", self.distanceTraveled)
        }
        if (self.mission?.currentProgress?.intValue)! >= (self.mission?.goal?.intValue)! {
            DispatchQueue.main.async {
                self.mission?.endDate = Date()
                
                self.mission?.verifyMission()
                PedometerManager.pedoMeter.stopUpdates()
                self.pedometer.activityManager.stopActivityUpdates()
                self.manager.stopUpdatingLocation()
                self.manager.stopUpdatingHeading()
                self.performSegue(withIdentifier: "Result", sender: nil)
            }
            
        }
    }
    
    func clearVelocity() {
        self.speed = 0
        self.labelSpeed.text = "\(self.speed!)"
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let eventDate:Date = (locations.first?.timestamp)!
        let howRecent: TimeInterval = eventDate.timeIntervalSinceNow
        //Is the event recent and accurate enough ?
        if (abs(howRecent) < SECS_OLD_MAX) {
            let lastLocation = locations.last
            //var secondLast = locations[locations.count - 2]
            //var speed: CLLocationSpeed = (lastLocation?.speed)! - secondLast.speed
            if !(lastLocation?.speed.isLessThanOrEqualTo(-1.0))!{
                self.speed = (lastLocation?.speed)! * 3.6
                labelSpeed.text = String.init(format: "%.2f", self.speed!)
                //print(speed)
                print((lastLocation?.speed)!)
            }
        }
        
    }
    
}
