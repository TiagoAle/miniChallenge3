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


class WorkoutInterfaceController: WKInterfaceController,PedometerManagerDelegate {

    @IBOutlet var timer: WKInterfaceTimer!
    @IBOutlet var groupTime: WKInterfaceGroup!
    @IBOutlet var labelSteps: WKInterfaceLabel!
    @IBOutlet var startPauseButton: WKInterfaceButton!
    @IBOutlet var labelTotal: WKInterfaceLabel!
    var stop = true
    var mission: Dictionary<String, AnyObject>?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.mission = context as? Dictionary<String, AnyObject>
        print(self.mission!)
        labelSteps.setText((mission?["currentProgress"] as! Int).description)
        labelTotal.setText((mission?["goal"] as! Int).description)
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func startStopAction() {
        if self.stop{
            self.startPauseButton.setTitle("Stop")
            wkTimerReset(timer: self.timer, interval: 0.0)
            self.stop = false
        }else{
            self.mission?["enabled"] = false as AnyObject? 
            do{
                print(self.mission!)
                try WatchSessionManager.sharedManager.updateApplicationContext(self.mission!)
            }catch{
                print("Erro")
            }
            self.startPauseButton.setTitle("Start")
            self.timer.stop()
            self.stop = true
            
            let action = WKAlertAction(title: "OK", style: .default, handler: { 
                self.dismiss()
            })
            
            self.presentAlert(withTitle: "Results", message: "Activity: \((self.mission?["activityType"] as? String)!)\nSteps: \(((self.mission?["currentProgress"] as? Int)?.description)!)\nExp: +30", preferredStyle: .alert, actions: [action])
            //self.presentController(withName: "ResultView", context: self.mission)
        }
    }
    
    func updateSteps(steps: NSNumber) {
        self.mission?["currentProgress"] = steps
        if (self.mission?["currentProgress"] as? Int)! >= (self.mission?["goal"] as? Int)! {
            DispatchQueue.main.async {
                self.mission?["status"] = "done" as AnyObject?
                self.presentController(withName: "ResultView", context: self.mission)
            }
        }
        DispatchQueue.main.async {
            self.labelSteps.setText(steps.description)
        }
        
        
    }
    
    func clearVelocity() {
        //faz nada
    }
    
    func wkTimerReset(timer:WKInterfaceTimer,interval:TimeInterval){
        timer.stop()
        let time  = Date(timeIntervalSinceNow: interval)
        timer.setDate(time)
        timer.start()
    }
}
