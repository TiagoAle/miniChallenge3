//
//  WatchSessionManager.swift
//  WCApplicationContextDemo
//
//  Created by Natasha Murashev on 9/22/15.
//  Copyright © 2015 NatashaTheRobot. All rights reserved.
//

import WatchConnectivity

protocol DataSourceChangedDelegate {
    func dataSourceDidUpdate(_ dataSource: [String: Any])
}


class WatchSessionManager: NSObject, WCSessionDelegate {
    
    static let sharedManager = WatchSessionManager()
    fileprivate override init() {
        super.init()
    }

    fileprivate var dataSourceChangedDelegates = [DataSourceChangedDelegate]()
    
    fileprivate let session: WCSession = WCSession.default()
    
    func startSession() {
        session.delegate = self
        session.activate()
    }
    
    func addDataSourceChangedDelegate<T>(_ delegate: T) where T: DataSourceChangedDelegate, T: Equatable {
        dataSourceChangedDelegates.append(delegate)
    }
    
    func removeDataSourceChangedDelegate<T>(_ delegate: T) where T: DataSourceChangedDelegate, T: Equatable {
        for (index, indexDelegate) in dataSourceChangedDelegates.enumerated() {
            if let indexDelegate = indexDelegate as? T, indexDelegate == delegate {
                dataSourceChangedDelegates.remove(at: index)
                break
            }
        }
    }
    
}

// MARK: Application Context
// use when your app needs only the latest information
// if the data was not sent, it will be replaced
extension WatchSessionManager {
    
    //Sender
    func updateApplicationContext(_ applicationContext: [String : AnyObject]) throws {
        do {
            try session.updateApplicationContext(applicationContext)
        } catch let error {
            throw error
        }
    }
    
    

    // Receiver
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        
        DispatchQueue.main.async { [weak self] in
            self?.dataSourceChangedDelegates.forEach { $0.dataSourceDidUpdate(applicationContext as [String : AnyObject])}
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
}
