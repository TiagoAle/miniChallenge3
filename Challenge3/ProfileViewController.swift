//
//  ProfileViewController.swift
//  Castelinho
//
//  Created by Daniel Dias on 25/11/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit
import HealthKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var missionTable: UITableView!
    
    
    var nickName = ""
    let healthManager = HealthKitManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.missionTable.delegate = self
        self.missionTable.dataSource = self
        self.missionTable.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Navigation
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let cell = self.missionTable.dequeueReusableCell(withIdentifier: "cell")! as! QuestTableViewCell
        cell.reward.text = "deu man"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segue", sender: nil)
    }
}
