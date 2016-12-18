//
//  WorkoutInterfaceController.swift
//  Challenge3
//
//  Created by Tiago Queiroz on 14/12/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion


class WorkoutInterfaceController: WKInterfaceController {

    
    @IBOutlet var timerLabel: WKInterfaceLabel!
    @IBOutlet var groupTime: WKInterfaceGroup!
    @IBOutlet var labelSteps: WKInterfaceLabel!
    @IBOutlet var startPauseButton: WKInterfaceButton!
    @IBOutlet var labelTotal: WKInterfaceLabel!
    var stop = true
    var zeroTime = TimeInterval()
    var timer : Timer = Timer()
    var numSteps: NSNumber = 0
    var goal: NSNumber?
    //var pedometer = PedometerManager()
    let pedometer = CMPedometer()
    public typealias CMPedometerHandler = (CMPedometerData?, NSError?) -> Void
    var mission: Dictionary<String, Any>?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.mission = context as? Dictionary<String, Any>
        print(self.mission!)
        labelSteps.setText((mission?["currentProgress"] as! Int).description)
        labelTotal.setText((mission?["goal"] as! Int).description)
        self.goal = mission?["goal"] as? NSNumber
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        //pedometer.delegate = self
//        if CMPedometer.isPaceAvailable() {
//            pedometer.startUpdates(from: Date(), withHandler:{(data: CMPedometerData?, error: Error?) -> Void in
//                
//                if let data = data {
//                    self.numSteps = data.numberOfSteps
//                    //let distance = data.distance
//                    self.labelSteps.setText("\(self.numSteps)")
//                    // Now do something with these values
//                }
//                
//            })
//
//        }
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func startStopAction() {
        if self.stop{
            self.startPauseButton.setTitle("Stop")
            //wkTimerReset(timer: self.timer, interval: 0.0)
            if !timer.isValid{
                //pedometer.updateValues(startDate: Date())
                if CMPedometer.isPaceAvailable() {
                    pedometer.startUpdates(from: Date(), withHandler:{(data: CMPedometerData?, error: Error?) -> Void in
                        
                        if let data = data {
                            self.numSteps = data.numberOfSteps
                            
                            if self.numSteps.intValue >= (self.goal?.intValue)!{
                                let action = WKAlertAction(title: "OK", style: .default, handler: {
                                    self.dismiss()
                                })
                                self.presentAlert(withTitle: "Results", message: "Activity: \((self.mission?["activityType"] as? String)!)\nSteps: \(((self.mission?["currentProgress"] as? Int)?.description)!)\nExp: +\((self.mission?["prize"])!)", preferredStyle: .alert, actions: [action])
                            }
                            //let distance = data.distance
                            self.labelSteps.setText("\(self.numSteps)")
                            // Now do something with these values
                        }
                        
                    })
                    
                }
                timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
                zeroTime = Date.timeIntervalSinceReferenceDate
                
            }
            self.stop = false
        }else{
            pedometer.stopUpdates()
            timer.invalidate()
            self.mission?["enabled"] = false
            do{
                print(self.mission!)
                try WatchSessionManager.sharedManager.updateApplicationContext(self.mission! as [String : AnyObject])
            }catch{
                print("Erro")
            }
            self.startPauseButton.setTitle("Start")
            //self.timer.stop()
            self.stop = true
            
            let action = WKAlertAction(title: "OK", style: .default, handler: {
                self.dismiss()
            })
            
            self.presentAlert(withTitle: "Results", message: "Activity: \((self.mission?["activityType"] as? String)!)\nSteps: \(((self.mission?["currentProgress"] as? Int)?.description)!)\nExp: +\((self.mission?["prize"])!)", preferredStyle: .alert, actions: [action])
            //self.presentController(withName: "ResultView", context: self.mission)
        }
    }
    
//    func updateSteps(steps: NSNumber) {
//        self.mission?["currentProgress"] = steps
//        if (self.mission?["currentProgress"] as? Int)! >= (self.mission?["goal"] as? Int)! {
//            DispatchQueue.main.async {
//                self.mission?["status"] = "done" as AnyObject?
//                self.presentController(withName: "ResultView", context: self.mission)
//            }
//        }
//        DispatchQueue.main.async {
//            self.labelSteps.setText(steps.description)
//        }
//        
//        
//    }
    
//    func clearVelocity() {
//        //faz nada
//    }
    
    func updateTime() {
        let currentTime = Date.timeIntervalSinceReferenceDate
        
        var timePassed: TimeInterval = currentTime - zeroTime
        
        let minutes = UInt8(timePassed / 60.0)
        timePassed -= (TimeInterval(minutes) * 60)
        let seconds = UInt8(timePassed)
        timePassed -= TimeInterval(seconds)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        self.groupTime.setBackgroundImageNamed("time\(seconds)")
        self.timerLabel.setText("\(strMinutes):\(strSeconds)")
    
        if "\(strMinutes):\(strSeconds)" == "60:00" {
            timer.invalidate()
        }
        
    }

}
