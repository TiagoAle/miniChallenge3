//
//  ViewController.swift
//  Challenge3
//
//  Created by Tiago Queiroz on 10/11/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController, UserDataManagerDelegate {

    let dataManager = UserDataManager()
    var arrayInformations = [Any]()
    
    var descriptionInfo = ["Age", "Sex", "Blood Type", "Weight", "Height", "BMI"]
    
    
    @IBOutlet weak var continueButtom: UIButton!
    @IBOutlet weak var switchStatus: UISwitch!
    
    //@IBOutlet weak var statusLabel: UILabel!
    
    //@IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        //self.dataManager.checkData()
        
        self.dataManager.receiveProfile()
        
        //self.tableView.reloadData()
        self.view.backgroundColor = UIColor.white
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
        self.dataManager.delegate = self
        
        if self.dataManager.UserExist(){
            //pula direto para a view da ficha
            self.performSegue(withIdentifier: "ProfileSegue", sender: nil)
            
        }
        
        //self.tableView.reloadData()
        
        self.continueButtom.isEnabled = false
        
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
    
    //action to change status
    
    @IBAction func termsAction(_ sender: UISwitch) {
        
        if sender.isOn{
            
            //self.statusLabel.text = "Yes"
            self.continueButtom.isEnabled = true
            
        }else{
            //self.statusLabel.text = "No"
            self.continueButtom.isEnabled = false
        }
        
    }
    
    
    // TRY USE USERDATAMANAGERDELEGATE
    func updatingDataTableView(arrayInfo: [Any]) {
        self.arrayInformations = arrayInfo
        print(self.arrayInformations)
    }


//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.descriptionInfo.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
//    
//        cell.textLabel?.text = "\(self.descriptionInfo[indexPath.row])"
//        if self.arrayInformations.count > 0{
//            cell.detailTextLabel?.text = "\(self.arrayInformations[indexPath.row])"
//        }
//        return cell
//    }

}

