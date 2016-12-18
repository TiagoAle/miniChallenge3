//
//  DailyMissionViewController.swift
//  Challenge3
//
//  Created by Alan Rabelo Martins on 18/12/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import CoreMotion
import CoreLocation
import HealthKit
import FirebaseDatabase

class DailyMissionViewController: UIViewController {
    
    var backgroundOrigin: UIColor?
    var mili: Int?
    var sec: Int?
    var min: Int?
    var calorias: String?
    var timePause: TimeInterval = 0
    var paused: Bool = false
    var mission: Mission? //= Mission(title: "dorgas", type: .daily, activityType: .walk, startDate: Date(), goal: 10, description: "deu ruim eim", prize: "ganha algo")
    // @IBOutlet weak var activityState: UILabel!
    
    //Mission
    var ref = FIRDatabase.database().reference(fromURL: "https://gitmove-e1481.firebaseio.com/")

    
    
    //     self.mission = Mission(title: "dorgas", type: .daily, activityType: .walk, startDate: Date(), goal: 10, description: "deu ruim eim", prize: "ganha algo")
    
    
    //Cronometer


    var zeroTime = TimeInterval()
    let healthManager:HealthKitManager = HealthKitManager()
//    var height: HKQuantitySample?
    var distanceTraveled = 0.0
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    
    //Pedometer

    var stepsQuant: NSNumber = 0
    var pedometer = PedometerManager()
    var speed: Double?
    
    var manager = CLLocationManager()
    var locations = [CLLocation]()
    
    
    var cal = Calendar.current
    var comps: DateComponents?
    var endDate: Date?


    @IBOutlet weak var progressBarMain: MBCircularProgressBarView!
    
    @IBOutlet weak var progressBarLeft: MBCircularProgressBarView!
    
    @IBOutlet weak var progressBarRight: MBCircularProgressBarView!
    
    @IBOutlet weak var labelMinutes: UILabel!
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    
    @IBOutlet weak var startStopButton: UIButton!
    
    @IBAction func startStop(_ sender: UIButton) {
        if sender.currentTitle == "START" {
            blurEffectView.isHidden = true
            sender.setTitle("STOP", for: .normal)
            sender.backgroundColor = UIColor.flatRed
            manager.startUpdatingLocation()
            pedometer.updateValues(startDate: Date())

            initTimer()
            
        } else {
            blurEffectView.isHidden = false
            sender.setTitle("START", for: .normal)
            sender.backgroundColor = UIColor.flatGreen
            manager.stopUpdatingLocation()
        }
    }
    
    override func viewDidLoad() {
        configureBars()
        manager.delegate = self
        
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.requestAlwaysAuthorization()
        
        pedometer.delegate = self
        pedometer.congigure()

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
    
    func configureBars() {
        progressBarMain.unitString = " s"
        
    }
    
    var timer : Timer?
    
    func initTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            self.increase(progressBar: self.progressBarMain, inSeconds: 1)
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        
        UIView.animate(withDuration: 1.0) { 
            self.progressBarMain.value = 0
        }
    }
    
    
    
    func increase(progressBar bar : MBCircularProgressBarView, inSeconds seconds : Int) {
        
        UIView.animate(withDuration: 1.0) {
            if bar.value == 10 {
                bar.value = 1
                
                if self.labelMinutes.text == "" {
                    self.labelMinutes.text = "1 min"
                } else {
                    let currentMinutes = Int((self.labelMinutes.text?.replacingOccurrences(of: " min", with: ""))!)! + 1
                    self.labelMinutes.text = "\(currentMinutes) min"
                }
                
            } else {
                bar.value += CGFloat(seconds)
                
            }
        }

        
    }
    
    
}

import CoreLocation

extension DailyMissionViewController : CLLocationManagerDelegate {
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var lastLocation = locations.last

        if !(lastLocation?.speed.isLessThanOrEqualTo(-1.0))!{
            progressBarLeft.value = CGFloat(Float((lastLocation?.speed)!)
                * 3.6)
            print((lastLocation?.speed)!)
        }
        
        if startLocation == nil {
            startLocation = locations.first as CLLocation!
        } else {
            let lastDistance = lastLocation?.distance(from: locations.last as CLLocation!)
            distanceTraveled += lastDistance! * 0.000621371
            
            let trimmedDistance = String(format: "%.2f", distanceTraveled)
            
            //milesLabel.text = "\(trimmedDistance)"
        }
        
        lastLocation = locations.last as CLLocation!
    }
}

extension DailyMissionViewController : PedometerManagerDelegate {
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
            self.progressBarRight.value = CGFloat(steps)
        }
        
        
    }
    
    func clearVelocity() {
        speed = 0
        self.progressBarLeft.value = 0
        
    }

}




extension UIColor {
    static var flatGreen : UIColor {
        return UIColor.init(red: 0.0, green: 171.0/255.0, blue: 7.0/255.0, alpha: 1.0)
    }
    
    static var flatRed : UIColor {
        return UIColor.init(red: 236.0/255.0, green: 11.0/255.0, blue: 68.0/255.0, alpha: 1.0)
    }
}
