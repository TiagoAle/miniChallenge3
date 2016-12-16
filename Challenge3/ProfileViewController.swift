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
import WatchConnectivity

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MyCustomCellDelegator, DataSourceChangedDelegate{
    
    @IBOutlet weak var missionTable: UITableView!
    @IBOutlet weak var labelNickName: UILabel!
    
    @IBOutlet weak var expProgress: UIProgressView!
    
    var flag: Bool? = false
    var xp: Int? = 100
    
    var index: Int? = nil
    var nickName = ""
    let healthManager = HealthKitManager()
    let dataManager = UserDataManager()
   // var xpLevel: Int?
   //var character: CharacterModel?
    
    var missionsArray: [Mission] = []
    var usersArray: [CharacterModel] = []
    var level = Level()
    var currentUser = CharacterModel()
    var missionChanged = [String:Any]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.updateProgressBar()
        if let flag = self.flag{
        
            if flag == true {
                CharacterModel.asyncAllSingle(path: self.currentUser.nickName!, completion: { (json) in
                    let dict = json["missionsAvailable"] as! [String: AnyObject]
                    
                    self.getMissionsAvailable(dict: dict)
                })
               // self.flag = false
            }
        
        }
        
        self.flag = true
        
        WatchSessionManager.sharedManager.addDataSourceChangedDelegate(self)
        
       // self.missionTable.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.missionTable.delegate = self
        self.missionTable.dataSource = self
        
        self.missionTable.becomeFirstResponder()

        
        self.missionTable.register(UINib(nibName: "QuestTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.missionTable.register(UINib(nibName: "ExpandedTableViewCell", bundle: nil), forCellReuseIdentifier: "CellExp")
        
        
        
        Level.asyncAll { (json) in
            for key in json.keys{
                Level.asyncAll(path: key, completion: { (json) in
                    self.level.missionsIndexs?[key] = [Int]()
                    for i in 1...json.count-1{
                        self.level.missionsIndexs?[key]?.append(json["mission\(i)"] as! Int)
                        
                    }
                })
            }
            //self.logIn()
        }
        self.updateProgressBar()
        Mission.asyncAll(completion: {(json) in
            for key in json.keys {
                Mission.asyncAll(path: key, completion: { (json) in

                    let title = json["title"] as? String
                    let activityType = json["activityType"] as? String
                    let missionDescription = json["description"] as? String
                    let goal = json["goal"] as? NSNumber
                    let prize = json["prize"] as? NSNumber
                    let type = json["type"] as? String
                    
                    let mission = Mission(title: title!, type: type!, activityType: activityType!, startDate: Date(), goal: goal!, description: missionDescription!, prize: prize!, identifier: key)
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
    
    func updateProgressBar(){
        let ref = FIRDatabase.database().reference().child("CharacterModel")
        ref.child(UserDefaults.standard.object(forKey: "nick") as! String).observe(.value, with: { (snapshot) in
             DispatchQueue.main.async {
                if let dict = snapshot.value as? [String: AnyObject]{
                    print(dict)
                    //let level = dict["level"] as! Int
                    if let exp = dict["exp"] as? Double{
                        let progress = Float(exp)/Float(self.xp!)
                        self.expProgress.setProgress(progress, animated: true)
                    }
                }
            }
            
            
        })
        if let nick = UserDefaults.standard.object(forKey: "nick") as? String{
            CharacterModel.asyncAll(path: nick, completion: { (json) in
                print("---------inicio------")
                let user = CharacterModel()
                user.age = json["age"] as? Int
                user.exp = json["exp"] as? Double
                print("------------------------")
                //print(user.exp!)
                print("------------------------")
                user.gender = json["gender"] as? String
                user.level = json["level"] as? Int
                user.nickName = json["nick"] as? String
                self.currentUser = user
                self.labelNickName.text = self.currentUser.nickName
                
                var aux = json
                //            // mudei aqui
                print("--------------    -----------------")
                print("level\(self.currentUser.level!)")
                print("-------------------------------")
                print("-------------------------------")
                
                Level.asyncAllSingle(path: "level\(self.currentUser.level!)", completion: { (json) in
                    
                    self.xp = json["xp"] as? Int
                    
                    aux["xpTotal"] = self.xp! as AnyObject?
                    
                    let infoUsers = [nick: aux]
                    
                    do{
                        try WatchSessionManager.sharedManager.updateApplicationContext(infoUsers as [String : AnyObject])
                    }catch{
                        print("Erro")
                    }
                    
                })
                //            //-------
                
            })
        }
        self.verifyLevel()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        WatchSessionManager.sharedManager.removeDataSourceChangedDelegate(self)
    }
    
    //Delegate do Watch
    func dataSourceDidUpdate(_ dataSource: [String : Any]) {
        self.missionChanged = dataSource
        let p = (self.missionChanged["prize"] as? Double)!
        self.currentUser.exp = self.currentUser.exp! + p
        let ref = FIRDatabase.database().reference(fromURL: "https://gitmove-e1481.firebaseio.com/CharacterModel")
        ref.child(self.currentUser.nickName!).child("exp").setValue(self.currentUser.exp)
        ref.child(self.currentUser.nickName!).child("missionsAvailable").child(self.missionChanged["identifier"] as! String).setValue(self.missionChanged)
        print(self.missionChanged["enabled"] as! Bool)
        
        
        var id = 0
        let str = self.missionChanged["identifier"] as! String
        
        


        //self.currentUser.missionsAvailable[]
    }
    
//    func logIn(){
//        let nick = UserDefaults.standard.object(forKey: "nick") as! String
//        CharacterModel.asyncAllSingle(path: nick, completion: { (json) in
//            print("---------inicio------")
//            let user = CharacterModel()
//            user.age = json["age"] as? Int
//            user.exp = json["exp"] as? Double
//            print("------------------------")
//            //print(user.exp!)
//            print("------------------------")
//            user.gender = json["gender"] as? String
//            user.level = json["level"] as? Int
//            user.nickName = json["nick"] as? String
//            
////            let progress =  ((user.exp)!/200)
////            self.expProgress.setProgress(Float(progress), animated: true)
//            
//            self.currentUser = user
//            self.labelNickName.text = self.currentUser.nickName
//            
//            var aux = json
////            // mudei aqui
//            print("--------------    -----------------")
//            print("level\(self.currentUser.level!)")
//            print("-------------------------------")
//            print("-------------------------------")
//
//            Level.asyncAllSingle(path: "level\(self.currentUser.level!)", completion: { (json) in
//             
//                self.xp = json["xp"] as? Int
//                
//                aux["xpTotal"] = self.xp! as AnyObject?
//                
//                let infoUsers = [nick: aux]
//                
//                do{
//                    try WatchSessionManager.sharedManager.updateApplicationContext(infoUsers as [String : AnyObject])
//                }catch{
//                    print("Erro")
//                }
//
//            })
////            //-------
//            
//            self.verifyLevel()
//
//        })
//        
//    }

    //É ESSA A FUNÇAO GAMBIARRA
    func verifyLevel(){
        for lvl in self.level.missionsIndexs!{
            if lvl.key.contains((currentUser.level?.description)!){
                var j = 0
                for i in lvl.value{
                    j = j+1
                    if self.missionsArray.count > 0{
                        let dict = ["activityType": self.missionsArray[i-1].activityType! , "description": self.missionsArray[i-1].missionDescription!, "prize": self.missionsArray[i-1].prize!, "goal": self.missionsArray[i-1].goal!, "id":self.missionsArray[i-1].id!, "type":self.missionsArray[i-1].type!, "title": self.missionsArray[i-1].title!, "currentProgress": self.missionsArray[i-1].currentProgress!, "status": (self.missionsArray[i-1].status?.rawValue)! as String, "enabled": self.missionsArray[i-1].enabled!, "identifier": "mission\(j)"] as [String : Any]
                        let ref = FIRDatabase.database().reference(fromURL: "https://gitmove-e1481.firebaseio.com/")
                        ref.child("CharacterModel").child(self.currentUser.nickName!).child("missionsAvailable").child("mission\(j)").setValue(dict)

                        
                    }
                }
            }
        }
        if let name = self.currentUser.nickName{
            CharacterModel.asyncAllSingle(path: name, completion: { (json) in
                let dict = json["missionsAvailable"] as! [String: AnyObject]
                
                self.getMissionsAvailable(dict: dict)
            })
        }
    }
    
    func getMissionsAvailable(dict: [String: AnyObject]){
        self.currentUser.missionsAvailable = []
        for d in dict{
            let m = Mission(title: d.value["title"] as! String, type: d.value["type"] as! String, activityType:d.value["activityType"] as! String, startDate: Date(), goal: d.value["goal"] as! NSNumber, description: d.value["description"] as! String, prize: d.value["prize"] as! NSNumber, identifier: d.value["identifier"] as! String)
            m.enabled = d.value["enabled"] as? Bool
            if !(currentUser.missionsAvailable.contains(m)){
                currentUser.missionsAvailable.append(m)
            }
        }
        self.missionTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segue") {
            let vc = segue.destination as! PedometerViewController
            vc.mission = self.currentUser.missionsAvailable[self.index!]
            vc.ref = FIRDatabase.database().reference(fromURL: "https://gitmove-e1481.firebaseio.com/").child("CharacterModel").child(self.currentUser.nickName!).child("missionsAvailable").child(self.currentUser.missionsAvailable[self.index!].identifier!)
            // missionsArray[self.index!]
        }
    }

    // MARK: - Navigation
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentUser.missionsAvailable.count
        
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
    
//    func tableView(tableView: UITableView, canFocusRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        if indexPath.row == 2 {
//            self.missionTable.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.bottom, animated: true)
//            return true
//        }
//        return false
//    }
    

    
    

    
//    func tableViewScrollToBottom(to row: NSIndexPath, animated: Bool) {
//        
//        let delay = 0.1 * Double(NSEC_PER_SEC)
//        //let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//        
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
//            let numberOfSections = self.missionTable.numberOfSections
//            let numberOfRows = self.missionTable.numberOfRows(inSection: numberOfSections-1)
//            
//            if numberOfRows > 0 {
//                let indexPath = row
//                //(forRow: numberOfRows-1, inSection: (numberOfSections-1))
//                self.missionTable.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.bottom, animated: animated)
//            }
//        }
//        
//    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.index == indexPath.row{
//            print(self.missionTable.rowHeight)
            
            
            let cell = self.missionTable.dequeueReusableCell(withIdentifier: "CellExp")! as! ExpandedTableViewCell
            
            
            cell.mission = self.currentUser.missionsAvailable[indexPath.row]
            cell.title.text = cell.mission?.title
            cell.questDescription.text = cell.mission?.missionDescription
            cell.reward.text = ("You will earn \((cell.mission?.prize)!) exp")
            self.missionTable.rowHeight = 193
            //print(indexPath.row)
            cell.delegate = self
            
            if cell.mission?.enabled == false {
                cell.cellState.backgroundColor = UIColor.orange
                cell.buttonState.isHidden = true
                cell.buttonState.isEnabled = false
            }else{
                cell.cellState.backgroundColor = UIColor.white
                cell.buttonState.isHidden = false
                cell.buttonState.isEnabled = true
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.missionTable.scrollToRow(at: IndexPath(row: self.index!, section: 0), at: .bottom, animated: true)
            }
            
            return cell
        }else {
        
            let cell = self.missionTable.dequeueReusableCell(withIdentifier: "Cell")! as! QuestTableViewCell
            cell.mission = self.currentUser.missionsAvailable[indexPath.row]
            cell.title.text = cell.mission?.title
            //cell.questDescription.text = cell.mission?.missionDescription
            cell.reward.text = ("You will earn \((cell.mission?.prize)!) exp")
            self.missionTable.rowHeight = 80
            cell.delegate = self
            
            if cell.mission?.enabled == false {
                cell.enabledLabel.backgroundColor = UIColor.orange
                cell.enabledLabel.alpha = 0.5
            }else{
            
                cell.enabledLabel.backgroundColor = UIColor.white
                cell.enabledLabel.alpha = 1
            
            }
            
            return cell
        
        }
//       self.missionTable.reloadData()

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
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
        
        
    }
  
}
