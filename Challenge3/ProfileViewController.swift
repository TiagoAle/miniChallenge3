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
    
    var index: Int? = nil
    var nickName = ""
    let healthManager = HealthKitManager()
    
    var missionsArray: [Mission] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.missionTable.delegate = self
        self.missionTable.dataSource = self
         self.missionTable.register(UINib(nibName: "QuestTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.missionTable.register(UINib(nibName: "ExpandedTableViewCell", bundle: nil), forCellReuseIdentifier: "CellExp")
        
        let mission1 = Mission(title: "Walk for prize", type: "Daily", activityType: "Walk", startDate: Date(), goal: 100)
        self.missionsArray.append(mission1)
        
        self.missionTable.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "segue") {
//            let vc = segue.destination as! testeViewController
//            present(vc, animated: true, completion: nil)
//           // self.navigationController?.pushViewController(vc, animated: true)
//        }
//    }

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
            
            //cell.reward.text = "deu man"
            self.missionTable.rowHeight = 193
            print(indexPath.row)
            cell.delegate = self
            return cell
        }else {
        
            let cell = self.missionTable.dequeueReusableCell(withIdentifier: "Cell")! as! QuestTableViewCell
            cell.mission = self.missionsArray[indexPath.row]
            cell.title.text = cell.mission?.title
            //cell.reward.text = "deu man"
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
