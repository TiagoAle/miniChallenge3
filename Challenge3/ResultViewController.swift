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
    
    var goal: Bool? = true
    //var workoutsArray: [HKWorkout]?
    var missionData: Mission?
    var ref = FIRDatabase.database().reference(fromURL: "https://gitmove-e1481.firebaseio.com/")
    override func viewDidLoad() {
        
        super.viewDidLoad()

        //print((workoutsArray?.first?.totalEnergyBurned?.doubleValue(for: HKUnit.calorie()))!)
        // Do any additional setup after loading the view.
        self.userMadeIt()
        
        //self.goal = true
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//         self.userMadeIt()
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
             ref.child((UserDefaults.standard.object(forKey: "nick") as? String)!).observeSingleEvent(of: .value, with: { (snapshot) in
                DispatchQueue.main.async {
                    if snapshot.exists() {
                        //completion((snapshoot.value as! [String : AnyOb)!)
                        var dict = snapshot.value as! [String: AnyObject]
                        var exp = dict["exp"] as! Int
                        exp = exp + (self.missionData?.xpEarned!)!
                        ref.child((UserDefaults.standard.object(forKey: "nick") as? String)!).updateChildValues(["exp":exp])
                        print((UserDefaults.standard.object(forKey: "nick") as? String)!)
                        print(self.ref)
                        self.ref.updateChildValues(["enabled":false])
                    }
                    
                    
                }
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
