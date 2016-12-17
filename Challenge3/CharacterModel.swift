//
//  CharacterModel.swift
//  Challenge3
//
//  Created by Daniel Dias on 28/11/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CharacterModel: NSObject, FIRDataModel, Uploadable, Typeable {
    
    var charImage: UIImage?
    var nickName: String?
    var age: Int?
    var items: [String]?  
    var missions: [String]?
    var gender: String?
    var exp: Double?
    var level: Int?
    var missionsAvailable = [Mission]()
    
    typealias JSON = [String: AnyObject]
    
    override init() {
        super.init()
    }
    init(gender:String , nickName: String, age: Int, items: [String], missions: [String]) {
        if gender == "male" {
            self.charImage = UIImage(named: "male")
        }else{
            self.charImage = UIImage(named: "female")
        }

        self.nickName = nickName
        self.age = age
        self.items = items
        self.missions = missions
        self.exp = 0.0
        self.level = 1
    }
    
    func toAnyObject() -> JSON {
        return getJSON()
    }
    
    func getJSON() -> [String: AnyObject] {
        let keyPaths = [#keyPath(Mission.title), #keyPath(Mission.goal), #keyPath(Mission.prize)]
        return PathsManager.shared.configureJSON(keyPaths: keyPaths, type: self)
    }
    

}
