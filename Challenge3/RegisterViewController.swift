//
//  RegisterViewController.swift
//  Castelinho
//
//  Created by Daniel Dias on 24/11/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegisterViewController: UIViewController,UITextFieldDelegate, UserDataManagerDelegate {
    
    @IBOutlet weak var nickTextField: UITextField!
    
    @IBOutlet weak var nickLabel: UILabel!
    
    let dataManager = UserDataManager()
    var info: [Any]?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataManager.delegate = self
        self.dataManager.receiveProfile()
        self.nickTextField.delegate = self
        

    }
    
    @IBAction func registerAction(_ sender: UIButton) {

        
        self.nickLabel.text = self.dataManager.saveNickName(nickName: self.nickTextField.text!)
        //let dict = ["missão1" : "muito difícil", "gol": "Da Alemanha"]
        let ref = FIRDatabase.database().reference(fromURL: "https://gitmove-e1481.firebaseio.com/")
        ref.child("CharacterModel").child(self.dataManager.nickName).updateChildValues(["nick" : self.dataManager.nickName])
        ref.child("CharacterModel").child(self.dataManager.nickName).updateChildValues(["age" : self.info?[0] as! Int])
        ref.child("CharacterModel").child(self.dataManager.nickName).updateChildValues(["gender" : self.info?[1] as! String])
        ref.child("CharacterModel").child(self.dataManager.nickName).updateChildValues(["exp" : 0])
        ref.child("CharacterModel").child(self.dataManager.nickName).updateChildValues(["level" : 1])
        //ref.child("CharacterModel").child(self.dataManager.nickName).child("missionsAvailable").childByAutoId().setValue(dict)
        
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ProfileViewController
        vc.flag = false

    }
    
    
    func updatingDataTableView(arrayInfo: [Any]) {
        self.info = arrayInfo
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
