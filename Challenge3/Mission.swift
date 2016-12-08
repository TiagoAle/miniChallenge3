//
//  Mission.swift
//  Challenge3
//
//  Created by Tiago Queiroz on 06/12/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit
import HealthKit

enum StatusMission {
    case done
    case inProgress
    case stoped
}

enum TypeMission {
    case daily
    case extra
    case event
}

enum TypeActivity {
    case run
    case walk
    case upStairs
}


class Mission: NSObject {
    
    
    var title: String
    
    var type: TypeMission
    var activityType: TypeActivity
    
    var xpEarned: Int?
    var status: StatusMission
    var startDate: Date
    var endDate: Date?
    var goal: NSNumber
    var currentProgress: NSNumber
    
    var prize: String?
    var missionDescription: String
    var enabled: Bool?
    var lastDate: String
    
    
    
    
    
    init(title: String, type: TypeMission, activityType: TypeActivity, startDate: Date, goal: NSNumber, description: String, prize: String) {
        self.title = title
        self.type = type
        self.activityType = activityType
        self.startDate = startDate
        self.goal = goal
        self.currentProgress = 0
        self.status = .stoped
        self.missionDescription = description
        self.prize = prize
        self.enabled = true
        
        let todaysDate:Date = Date()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString:String = dateFormatter.string(from: todaysDate)
        self.lastDate = todayString
        print(self.prize)
        let myString: String = self.prize!
        let myStringArr = myString.components(separatedBy: " ")
        for i in myStringArr {
        
            if let exp = Int(i){
                self.xpEarned = exp
                print(self.xpEarned!)
            }
            
        }


        //print(self.enabled)

        
        
    }

    
    func verifyMission() {
        if currentProgress.doubleValue == 0{
            self.status = StatusMission.stoped
        }else if self.currentProgress.doubleValue >= self.goal.doubleValue {
            self.status = StatusMission.done
        }else{
            self.status = StatusMission.inProgress
        }
    }
    
    func missionEnabled(){
        let todaysDate:Date = Date()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString:String = dateFormatter.string(from: todaysDate)

        
        if self.lastDate != todayString{
            self.enabled = true
            print(todayString)
           // print(self.enabled)
        }
        
        
    }
}


