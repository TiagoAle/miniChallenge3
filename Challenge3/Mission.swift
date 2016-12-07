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

class Mission: NSObject {
    
    var type: String
    var activityType: String
    var xpEarned: Int?
    var status: StatusMission
    var startDate: Date
    var endDate: Date?
    var goal: NSNumber
    var currentProgress: NSNumber
    
    init(type: String, activityType: String, startDate: Date, goal: NSNumber) {
        self.type = type
        self.activityType = activityType
        self.startDate = startDate
        self.goal = goal
        self.currentProgress = 0
        self.status = .stoped
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
}
