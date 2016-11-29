//
//  PedometerViewController.swift
//  Challenge3
//
//  Created by Tiago Queiroz on 29/11/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit
import CoreMotion
class PedometerViewController: UIViewController {
    
   // @IBOutlet weak var activityState: UILabel!
    @IBOutlet weak var steps: UILabel!
    
    var days:[String] = []
    var stepsTaken:[Int] = []
    
   // @IBOutlet weak var stateImageView: UIImageView!
    let activityManager = CMMotionActivityManager()
    let pedoMeter = CMPedometer()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var cal = Calendar.current
        var comps = cal.dateComponents([Calendar.Component.year,Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second], from: Date())
        
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        let timeZone = NSTimeZone.system
        cal.timeZone = timeZone
    
        let midnightOfToday = cal.date(from: comps)
        
        
//        if(CMMotionActivityManager.isActivityAvailable()){
//            self.activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: { (data) -> Void in
//                DispatchQueue.main.async(execute: { () -> Void in
//                    if(data!.stationary == true){
//                        self.activityState.text = "Stationary"
//                        self.stateImageView.image = UIImage(named: "Sitting")
//                    } else if (data!.walking == true){
//                        self.activityState.text = "Walking"
//                        self.stateImageView.image = UIImage(named: "Walking")
//                    } else if (data!.running == true){
//                        self.activityState.text = "Running"
//                        self.stateImageView.image = UIImage(named: "Running")
//                    } else if (data!.automotive == true){
//                        self.activityState.text = "Automotive"
//                    }
//                })
//                
//            })
//        }
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
    
    
}
