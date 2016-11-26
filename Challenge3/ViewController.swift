//
//  ViewController.swift
//  Challenge3
//
//  Created by Tiago Queiroz on 10/11/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let healthManager = HealthKitManager()
    let dataManager = UserDataManager()
    
    var arrayInformations = [Any]()
    var descriptionInfo = ["Age", "Sex", "Blood Type"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        let completion: ((Bool, Error?) -> Void)! = {
            (success, error) -> Void in
            
            if !success {
                
                print("You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: \(error). If you're using a simulator, try it on a device.")
                
                return
            }
            
            DispatchQueue.main.async{
                
                // Update the user interface based on the current user's health information.
                self.dataManager.age = self.healthManager.receiveUserData().age
                self.dataManager.bloodType = self.healthManager.receiveUserData().bloodtype
                self.dataManager.sex = self.healthManager.receiveUserData().biologicalsex
                self.arrayInformations.append(self.dataManager.age! as Int)
                self.arrayInformations.append(self.dataManager.sex! as String)
                self.arrayInformations.append(self.dataManager.bloodType! as String)
                self.tableView.reloadData()
                
                print(self.healthManager.receiveUserData())
            }
        }
        
        healthManager.authorizeHealthKit(completion: completion)
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        if self.dataManager.UserExist(){
            //pula direto para a view da ficha
            self.performSegue(withIdentifier: "ProfileSegue", sender: nil)
            
        }
        
        
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.descriptionInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
        
        //cell.detailTextLabel?.text = "\(self.descriptionInfo[indexPath.row]) = \(self.arrayInformations[indexPath.row])"
        cell.textLabel?.text = "\(self.descriptionInfo[indexPath.row])"
        if self.arrayInformations.count > 0{
            cell.detailTextLabel?.text = "\(self.arrayInformations[indexPath.row])"
        }
        return cell
    }

}

