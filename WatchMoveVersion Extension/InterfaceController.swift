//
//  InterfaceController.swift
//  WatchMoveVersion Extension
//
//  Created by Tiago Queiroz on 08/12/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate{

    var session: WCSession?
    
    @IBOutlet var label: WKInterfaceLabel!
    var dictionary = [String:Any]()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        if WCSession.isSupported(){
            session = WCSession.default()
            session?.delegate = self
            session?.activate()
        }
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        self.dictionary = applicationContext
        
        print(self.dictionary.description)
        self.label.setText(self.dictionary.keys.first)
        
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        if let error = error {
            print("session activation failed with error: \(error.localizedDescription)")
            return
        }
        
        /*
         Called when the activation of a session finishes. Your implementation
         should check the value of the activationState parameter to see if
         communication with the counterpart app is possible. When the state is
         WCSessionActivationStateActivated, you may communicate normally with
         the other app.
         */
        
        print("session activated with state: \(activationState.rawValue)")
    }

}
