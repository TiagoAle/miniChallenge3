//
//  Level.swift
//  Challenge3
//
//  Created by Tiago Queiroz on 11/12/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit

class Level: NSObject, FIRDataModel, Uploadable, Typeable {

    var missionsIndexs: [Int]?
    var id: Int?
    
    typealias JSON = [String: AnyObject]
    
    override init() {
        super.init()
    }
    
    func toAnyObject() -> JSON {
        return getJSON()
    }
    
    func getJSON() -> [String: AnyObject] {
        let keyPaths = [#keyPath(Mission.title), #keyPath(Mission.goal), #keyPath(Mission.prize)]
        return PathsManager.shared.configureJSON(keyPaths: keyPaths, type: self)
    }
}
