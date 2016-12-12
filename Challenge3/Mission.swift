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


class Mission: NSObject, FIRDataModel, Uploadable, Typeable {
    
    
    var title: String?
    
    var type: String?
    var activityType: String?
    
    var xpEarned: Int?
    var status: StatusMission?
    var startDate: Date?
    var endDate: Date?
    var goal: NSNumber?
    var id: Int?
    var currentProgress: NSNumber?
    
    var prize: String?
    var missionDescription: String?
    var enabled: Bool?
    var lastDate: String?
    
    typealias JSON = [String: AnyObject]
    
    
    override init() {
        super.init()
    }
    
    init(title: String, type: String, activityType: String, startDate: Date, goal: NSNumber, description: String, prize: String) {
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
        self.id = 1
        
        let todaysDate:Date = Date()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString:String = dateFormatter.string(from: todaysDate)
        self.lastDate = todayString
       // print(self.prize)
        let myString: String = self.prize!
        let myStringArr = myString.components(separatedBy: " ")
        for i in myStringArr {
        
            if let exp = Int(i){
                self.xpEarned = exp
                //print(self.xpEarned!)
            }
        }
    }

    
    func verifyMission() {
        if currentProgress?.doubleValue == 0{
            self.status = StatusMission.stoped
        }else if (self.currentProgress?.doubleValue)! >= (self.goal?.doubleValue)! {
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
    
    func toAnyObject() -> JSON {
        return getJSON()
    }
    
    func getJSON() -> [String: AnyObject] {
        let keyPaths = [#keyPath(Mission.title), #keyPath(Mission.goal), #keyPath(Mission.prize), #keyPath(Mission.activityType), #keyPath(Mission.missionDescription), #keyPath(Mission.currentProgress), #keyPath(Mission.type)]
        return PathsManager.shared.configureJSON(keyPaths: keyPaths, type: self)
    }
}


