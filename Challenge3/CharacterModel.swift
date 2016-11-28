//
//  CharacterModel.swift
//  Challenge3
//
//  Created by Daniel Dias on 28/11/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit

class CharacterModel: NSObject {
    
    var charImage: UIImage?
    var nickName: String?
    var age: Int?
    var items: [String]?
    var missions: [String]?
    var gender: String?


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
    }
    

}
