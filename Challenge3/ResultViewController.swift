//
//  ResultViewController.swift
//  Challenge3
//
//  Created by Daniel Dias on 30/11/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit
import HealthKit
import FirebaseDatabase

class ResultViewController: UIViewController {

    let dataManager = UserDataManager()
    @IBOutlet weak var resultTextView: UITextView!
    
    var goal: Bool?
    //var workoutsArray: [HKWorkout]?
    var missionData: Mission?
    var ref = FIRDatabase.database().reference(fromURL: "https://gitmove-e1481.firebaseio.com/")
    override func viewDidLoad() {
        
        super.viewDidLoad()

        //print((workoutsArray?.first?.totalEnergyBurned?.doubleValue(for: HKUnit.calorie()))!)
        // Do any additional setup after loading the view.
        
        self.goal = true
        self.userMadeIt()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToProfile(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)

        let presentingVC = self.presentingViewController!
        let navigationController = presentingVC is UINavigationController ? presentingVC as? UINavigationController : presentingVC.navigationController
        navigationController?.popViewController(animated: false)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    

    func userMadeIt(){
    
        if self.goal == true{
            var text = self.resultTextView.text
            text?.append(" User win")
            text?.append("\n Type: \((self.missionData?.type)!)")
            text?.append("\n Steps: \((self.missionData?.currentProgress)!)")
            text?.append("\n Activity: \((self.missionData?.activityType)!)")
            text?.append("\n \((self.missionData?.startDate)!)")
            text?.append("\n \((self.missionData?.endDate)!)")
            self.resultTextView.text = text
            
            //salvar xp
            
            let ref = FIRDatabase.database().reference().child("CharacterModel")
            print(ref.child("Daniel"))
//            let xp = ref.child((UserDefaults.standard.object(forKey: "nick") as? String)!).observe(.value, with: { snapshoot in
//                DispatchQueue.main.async {
//                    if snapshoot.exists() {
//                        //completion((snapshoot.value as! [String : AnyOb)!)
//                        print(snapshot.value)
//                    }
//            
//            
//                }
//            })
            
            
            CharacterModel.asyncAll(path: (UserDefaults.standard.object(forKey: "nick") as! String), completion: {(json) in
                var exp = json["exp"] as! Int
                exp = exp + (self.missionData?.xpEarned!)!
                ref.child((UserDefaults.standard.object(forKey: "nick") as? String)!).updateChildValues(["exp":exp])
                print(self.ref)
                self.ref.updateChildValues(["enabled":false])
                
                
            })

            
            
            
        }else{
        
            var text = self.resultTextView.text
            text?.append(" User lose")
            self.resultTextView.text = text
            
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
