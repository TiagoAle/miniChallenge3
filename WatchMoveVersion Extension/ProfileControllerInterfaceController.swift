//
//  ProfileControllerInterfaceController.swift
//  Challenge3
//
//  Created by Tiago Queiroz on 13/12/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import WatchKit
import Foundation


class ProfileControllerInterfaceController: WKInterfaceController {

    @IBOutlet var labelNick: WKInterfaceLabel!
    @IBOutlet var level: WKInterfaceLabel!
    @IBOutlet var expImage: WKInterfaceImage!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        let user = context as! Dictionary<String, Any>
        if user.count > 0{
            let info = user[user.keys.first!] as! [String: AnyObject]
            let nick = info["nick"] as! String
            let lvl = info["level"] as! Int
            let exp = info["exp"] as! Int
            var progress = Float(exp)/(info["xpTotal"] as! Float) * 100
            if progress > 100{
                progress = 100
            }
            print(String.init(format: "%.0f", progress))
            self.labelNick.setText(nick)
            self.level.setText(lvl.description)
            self.expImage.setImageNamed(String.init(format: "exp%.0f", progress))
        }
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

}
