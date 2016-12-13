//
//  WatchSessionManager.swift
//  WCApplicationContextDemo
//
//  Created by Natasha Murashev on 9/22/15.
//  Copyright © 2015 NatashaTheRobot. All rights reserved.
//

import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {
    
    static let sharedManager = WatchSessionManager()
    fileprivate override init() {
        super.init()
    }
    
    fileprivate let session: WCSession? = WCSession.isSupported() ? WCSession.default() : nil
    
    fileprivate var validSession: WCSession? {
        
        // paired - the user has to have their device paired to the watch
        // watchAppInstalled - the user must have your watch app installed
        
        // Note: if the device is paired, but your watch app is not installed
        // consider prompting the user to install it for a better experience
        
        if let session = session {
            if session.isPaired && session.isWatchAppInstalled {
                return session
            }
        }
        return nil
    }
    
    func startSession() {
        session?.delegate = self
        session?.activate()
    }
}

// MARK: Application Context
// use when your app needs only the latest information
// if the data was not sent, it will be replaced
extension WatchSessionManager {
    
    // Sender
    func updateApplicationContext(_ applicationContext: [String : AnyObject]) throws {
        if let session = validSession {
            do {
                try session.updateApplicationContext(applicationContext)
            } catch let error {
                throw error
            }
        }
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
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
        print("session did become inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default().activate()
    }
}
