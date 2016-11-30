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

class PedometerViewController: UIViewController, CLLocationManagerDelegate {
    
   // @IBOutlet weak var activityState: UILabel!
    @IBOutlet weak var steps: UILabel!
    
    @IBOutlet weak var labelSpeed: UILabel!
    var days:[String] = []
    var stepsTaken:[Int] = []
    var manager = CLLocationManager()
    
   // @IBOutlet weak var stateImageView: UIImageView!
    let activityManager = CMMotionActivityManager()
    let pedoMeter = CMPedometer()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.manager.delegate = self
        self.manager.requestAlwaysAuthorization()
        
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.distanceFilter = kCLDistanceFilterNone
        self.manager.startUpdatingLocation()
        self.manager.startUpdatingHeading()
        
        var cal = Calendar.current
        var comps = cal.dateComponents([Calendar.Component.year,Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second], from: Date())
        
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        let timeZone = NSTimeZone.system
        cal.timeZone = timeZone
    
        let midnightOfToday = cal.date(from: comps)
        
        
        if(CMMotionActivityManager.isActivityAvailable()){
            self.activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: { (data) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    if(data!.stationary == true){
                        print("Stationary")
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
            let fromDate = NSDate(timeIntervalSinceNow: -86400 * 7)
            self.pedoMeter.queryPedometerData(from: fromDate as Date, to: Date(), withHandler: { (data, error) in
                print(data!)
                
                DispatchQueue.main.async {
                    if(error == nil){
                        self.steps.text = "\(data!.numberOfSteps)"
                    }
                }
                
            })
            
            self.pedoMeter.startUpdates(from: midnightOfToday!) { (data, error) -> Void in
                DispatchQueue.main.async {
                    if(error == nil){
                        self.steps.text = "\(data!.numberOfSteps)"
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var lastLocation = locations.last
        //var secondLast = locations[locations.count - 2]
        //var speed: CLLocationSpeed = (lastLocation?.speed)! - secondLast.speed
        labelSpeed.text = "\((lastLocation?.speed)!)"
        //print(speed)
        print(lastLocation?.speed)
    }
    
}
