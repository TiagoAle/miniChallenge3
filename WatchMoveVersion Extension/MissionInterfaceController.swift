//
//  MissionInterfaceController.swift
//  Challenge3
//
//  Created by Tiago Queiroz on 13/12/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import WatchKit
import Foundation


class MissionInterfaceController: WKInterfaceController {

    
    var dictionary = [String: Any]()
    var dictMission = [Any]()
    @IBOutlet var table: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        let user = context as! Dictionary<String, Any>
        if user.count > 0{
            let info = user[user.keys.first!] as! [String: AnyObject]
            self.dictionary = info["missionsAvailable"] as! [String: AnyObject]
            print(self.dictionary)
        }
        setupTable()
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
    func setupTable() {
        table.setNumberOfRows(self.dictionary.count, withRowType: "MissionRow")
        
        for i in 0 ..< self.dictionary.count {
            if let row = table.rowController(at: i) as? MissionRow {
                let dict = self.dictionary["mission\(i+1)"] as! [String: AnyObject]
                if dict["enabled"] as! Bool == false{
                    row.enabled.setColor(UIColor.red)
                }
                row.titleLabel.setText((dict["title"] as! String))
                row.steps.setText("\(dict["goal"] as! NSNumber) steps")
                row.xpEarned.setText("\(dict["prize"] as! NSNumber) exp")
                self.dictMission.append(dict)
            }
        }
    }

    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let row = table.rowController(at: rowIndex) as? MissionRow
        row?.enabled.setColor(UIColor.red)
        let dict = self.dictionary["mission\(rowIndex+1)"] as! [String: AnyObject]
        if dict["enabled"] as! Bool == false{
            self.presentAlert(withTitle: "Mission already done!", message: "Please pick a green mission", preferredStyle: .alert, actions: [WKAlertAction.init(title: "OK", style: .cancel, handler: {
                    self.dismiss()
            })])
        }
        let mission = self.dictMission[rowIndex]
        presentController(withName: "WorkoutView", context: mission)
    }

}
