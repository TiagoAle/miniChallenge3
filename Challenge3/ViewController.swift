//
//  ViewController.swift
//  Challenge3
//
//  Created by Tiago Queiroz on 10/11/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {

    let healthManager = HealthKitManager()
    let dataManager = UserDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.dataManager.UserExist(){
            //pula direto para a view da ficha
            self.performSegue(withIdentifier: "ProfileSegue", sender: nil)
            
        }
        
        let completion: ((Bool, Error?) -> Void)! = {
            (success, error) -> Void in
            
            if !success {
                
                print("You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: \(error). If you're using a simulator, try it on a device.")
                
                return
            }
            
            DispatchQueue.main.async{
                
                // Update the user interface based on the current user's health information.
                self.healthManager.receiveUserAge()
            }
        }
        
        healthManager.authorizeHealthKit(completion: completion)
    
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "ProfileSegue") {
            // pass data to next view
            let profileView = segue.destination as? ProfileViewController
            profileView?.nickName = self.dataManager.nickName
        }
        
    }


}

