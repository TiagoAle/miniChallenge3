//
//  ProfileViewController.swift
//  Castelinho
//
//  Created by Daniel Dias on 25/11/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit
import HealthKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MyCustomCellDelegator {
    
    @IBOutlet weak var missionTable: UITableView!
    @IBOutlet weak var labelNickName: UILabel!
    
    var index: Int? = nil
    var nickName = ""
    let healthManager = HealthKitManager()
    
    var missionsArray: [Mission] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.missionTable.delegate = self
        self.missionTable.dataSource = self
        labelNickName.text = UserDefaults.standard.object(forKey: "nick") as? String

        self.missionTable.register(UINib(nibName: "QuestTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.missionTable.register(UINib(nibName: "ExpandedTableViewCell", bundle: nil), forCellReuseIdentifier: "CellExp")
        
        let mission1 = Mission(title: "Walk for prize", type: .daily, activityType: .walk, startDate: Date(), goal: 100, description: "ande 100 passos", prize: "win 70 Exp")
        let mission2 = Mission(title: "Run for prize", type: .extra, activityType: .run, startDate: Date(), goal: 2, description: "run for 2 meters", prize: "Win 120 Exp")
        let mission3 = Mission(title: "Walk for prize", type: .daily, activityType: .run, startDate: Date(), goal: 20, description: "ande 20 passos", prize: "Win 50 Exp")
        let mission4 = Mission(title: "Walk for prize", type: .daily, activityType: .run, startDate: Date(), goal: 10, description: "ande 10 passos", prize: "Win 30 Exp")
        let mission5 = Mission(title: "Walk for prize", type: .daily, activityType: .run, startDate: Date(), goal: 10, description: "ande 10 passos", prize: "Win 30 Exp")
        
        self.missionsArray.append(mission1)
        self.missionsArray.append(mission2)
        self.missionsArray.append(mission3)
        self.missionsArray.append(mission4)
        self.missionsArray.append(mission5)
        
        
        
        self.missionTable.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segue") {
            let vc = segue.destination as! PedometerViewController
            vc.mission = missionsArray[self.index!]
        }
    }

    // MARK: - Navigation
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.missionsArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.index == indexPath.row{
            
            return 193
        }else {
            
            return 80
            
        }

    }
    
    func callSegueFromCell(myData dataobject: AnyObject) {

        self.performSegue(withIdentifier: "segue", sender:nil)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.index == indexPath.row{
//            print(self.missionTable.rowHeight)
            
            
            let cell = self.missionTable.dequeueReusableCell(withIdentifier: "CellExp")! as! ExpandedTableViewCell
            cell.mission = self.missionsArray[indexPath.row]
            cell.title.text = cell.mission?.title
            cell.questDescription.text = cell.mission?.missionDescription
            cell.reward.text = cell.mission?.prize
            self.missionTable.rowHeight = 193
            print(indexPath.row)
            cell.delegate = self
            return cell
        }else {
        
            let cell = self.missionTable.dequeueReusableCell(withIdentifier: "Cell")! as! QuestTableViewCell
            cell.mission = self.missionsArray[indexPath.row]
            cell.title.text = cell.mission?.title
            //cell.questDescription.text = cell.mission?.missionDescription
            cell.reward.text = cell.mission?.prize
            self.missionTable.rowHeight = 80
            cell.delegate = self
            
            return cell
        
        }
//        self.missionTable.reloadData()

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "segue", sender: nil)
        if self.index == indexPath.row {
            self.index = nil
        }else{
            print(indexPath.row)
            self.index = nil
            self.missionTable.reloadData()
            self.index = indexPath.row
        }
        let indexP = NSIndexPath(row: indexPath.row, section: 0)
       self.missionTable.reloadRows(at:[indexP as IndexPath] , with: .fade)
        //self.missionTable.reloadData()
        //performSegue(withIdentifier: "segue", sender: nil)
        
    }
}
