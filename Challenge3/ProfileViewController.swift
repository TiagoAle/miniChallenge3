//
//  ProfileViewController.swift
//  Castelinho
//
//  Created by Daniel Dias on 25/11/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit
import HealthKit
import FirebaseDatabase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MyCustomCellDelegator {
    
    @IBOutlet weak var missionTable: UITableView!
    @IBOutlet weak var labelNickName: UILabel!
    
    @IBOutlet weak var expProgress: UIProgressView!
    
    
    var index: Int? = nil
    var nickName = ""
    let healthManager = HealthKitManager()
    let dataManager = UserDataManager()
   //var character: CharacterModel?
    
    var missionsArray: [Mission] = []
    var usersArray: [CharacterModel] = []
    var level = Level()
    var currentUser = CharacterModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.missionTable.delegate = self
        self.missionTable.dataSource = self
        //labelNickName.text = UserDefaults.standard.object(forKey: "nick") as? String
 //       self.character = CharacterModel(gender: "Male", nickName: self.nickName, age: 16, items: [], missions: [])
        
        // atualiza o progresso na barra
        //self.character?.exp = self.dataManager.saveExp(exp: (self.character?.exp)!)
        //self.expProgress.setProgress(Float((self.character?.exp)!), animated: true)

        
        self.missionTable.register(UINib(nibName: "QuestTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.missionTable.register(UINib(nibName: "ExpandedTableViewCell", bundle: nil), forCellReuseIdentifier: "CellExp")
        

//        let mission1 = Mission(title: "Walk for prize", type: .daily, activityType: .walk, startDate: Date(), goal: 100, description: "ande 100 passos", prize: "win 70 Exp")
//        let mission2 = Mission(title: "Run for prize", type: .extra, activityType: .run, startDate: Date(), goal: 2, description: "run for 2 meters", prize: "Win 120 Exp")
//        let mission3 = Mission(title: "Walk for prize", type: .daily, activityType: .run, startDate: Date(), goal: 20, description: "ande 20 passos", prize: "Win 50 Exp")
//        let mission4 = Mission(title: "Walk for prize", type: .daily, activityType: .run, startDate: Date(), goal: 10, description: "ande 10 passos", prize: "Win 30 Exp")
//        let mission5 = Mission(title: "Walk for prize", type: .daily, activityType: .run, startDate: Date(), goal: 10, description: "ande 10 passos", prize: "Win 30 Exp")
        
//        self.missionsArray.append(mission1)
//        self.missionsArray.append(mission2)
//        self.missionsArray.append(mission3)
//        self.missionsArray.append(mission4)
//        self.missionsArray.append(mission5)
        Level.asyncAll { (json) in
            for key in json.keys{
                Level.asyncAll(path: key, completion: { (json) in
                    self.level.missionsIndexs?[key] = [Int]()
                    for i in 1...json.count{
                        self.level.missionsIndexs?[key]?.append(json["mission\(i)"] as! Int)
                    }
                })
            }
        }
        //
        CharacterModel.asyncAll { (json) in
            for key in json.keys {
                CharacterModel.asyncAll(path: key, completion: { (json) in
                    print("---------inicio------")
                    let user = CharacterModel()
                    user.age = json["age"] as? Int
                    user.exp = json["exp"] as? Double
                    print("------------------------")
                    print(user.exp!)
                    print("------------------------")
                    user.gender = json["gender"] as? String
                    user.level = json["level"] as? Int
                    user.nickName = json["nick"] as? String
                    self.usersArray.append(user)
                    self.logIn(user: user)
                    
                    for i in self.usersArray{
                        
                        if i.nickName == self.nickName {
                        
                            print(i)
                            let progress =  ((i.exp)!/200)
                            self.expProgress.setProgress(Float(progress), animated: true)
                            
                        }
                    }
                })
            }
        }
        
        //let userID = FIRAuth.auth()?.currentUser?.uid
        Mission.asyncAll(completion: {(json) in
            for key in json.keys {
                Mission.asyncAll(path: key, completion: { (json) in

                    let title = json["title"] as? String
                    let activityType = json["activityType"] as? String
                    let missionDescription = json["description"] as? String
                    let goal = json["goal"] as? NSNumber
                    let prize = json["prize"] as? String
                    let type = json["type"] as? String
                    
                    let mission = Mission(title: title!, type: type!, activityType: activityType!, startDate: Date(), goal: goal!, description: missionDescription!, prize: prize!)
                    mission.id = json["id"] as? Int
        
                    self.missionsArray.append(mission)
                    self.missionsArray = self.missionsArray.sorted(by: {$0.id! < $1.id!})
                    self.missionTable.reloadData()
                    
                })
                
            }
            
        })

        
        self.missionTable.reloadData()
        // Do any additional setup after loading the view.
        
    }
    
    func logIn(user: CharacterModel){
        if user.nickName == UserDefaults.standard.object(forKey: "nick") as? String{
            self.currentUser = user
            self.labelNickName.text = self.currentUser.nickName
            self.verifyLevel()
        }
    }

    //É ESSA A FUNÇAO GAMBIARRA
    func verifyLevel(){
        for lvl in self.level.missionsIndexs!{
            if lvl.key.contains((currentUser.level?.description)!){
                var j = 0
                for i in lvl.value{
                    j = j+1
                    let dict = ["activityType": self.missionsArray[i-1].activityType! , "description": self.missionsArray[i-1].missionDescription!, "prize": self.missionsArray[i-1].prize!, "goal": self.missionsArray[i-1].goal!, "id":self.missionsArray[i-1].id!, "type":self.missionsArray[i-1].type!, "title": self.missionsArray[i-1].title!, "currentProgress": self.missionsArray[i-1].currentProgress!, "status": (self.missionsArray[i-1].status?.rawValue)! as String] as [String : Any]
                    let ref = FIRDatabase.database().reference(fromURL: "https://gitmove-e1481.firebaseio.com/")
                    ref.child("CharacterModel").child(self.currentUser.nickName!).child("missionsAvailable").child("mission\(j)").setValue(dict)
                }
            }
        }
       // let ref = FIRDatabase.database().reference(fromURL: "https://gitmove-e1481.firebaseio.com/")
      //  ref.child("CharacterModel").child(self.dataManager.nickName).child("missionsAvailable").childByAutoId().setValue(dict)
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
            cell.reward.text = (cell.mission?.prize)!
            self.missionTable.rowHeight = 193
            //print(indexPath.row)
            cell.delegate = self
            return cell
        }else {
        
            let cell = self.missionTable.dequeueReusableCell(withIdentifier: "Cell")! as! QuestTableViewCell
            cell.mission = self.missionsArray[indexPath.row]
            cell.title.text = cell.mission?.title
            //cell.questDescription.text = cell.mission?.missionDescription
            cell.reward.text = (cell.mission?.prize)!
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
           // print(indexPath.row)
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
