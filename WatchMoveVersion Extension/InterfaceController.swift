//
//  InterfaceController.swift
//  WatchMoveVersion Extension
//
//  Created by Tiago Queiroz on 08/12/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, DataSourceChangedDelegate{

    @IBOutlet var label: WKInterfaceLabel!
    var dictionary = [String:Any]()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        //WatchSessionManager.sharedManager.delegate = self
        WatchSessionManager.sharedManager.addDataSourceChangedDelegate(self)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        WatchSessionManager.sharedManager.removeDataSourceChangedDelegate(self)
        super.didDeactivate()
    }
    
    @IBAction func pushButtonPressed() {
        self.pushController(withName: "Profile", context: self.dictionary)
    }

    @IBAction func pushMissionButton() {
        self.pushController(withName: "MissionView", context: self.dictionary)
    }
    
    // MARK: DataSourceUpdatedDelegate
    func dataSourceDidUpdate(_ dataSource: [String : Any]) {
        self.dictionary = dataSource
        print(dictionary)
        self.label.setText(self.dictionary.keys.first)
    }
    
}
