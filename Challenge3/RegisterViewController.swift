//
//  RegisterViewController.swift
//  Castelinho
//
//  Created by Daniel Dias on 24/11/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit


class RegisterViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var nickTextField: UITextField!
    
    @IBOutlet weak var nickLabel: UILabel!
    
    let dataManager = UserDataManager()
 


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nickTextField.delegate = self
        
        

    }
    
    @IBAction func registerAction(_ sender: UIButton) {

        
        self.nickLabel.text = self.dataManager.saveNickName(nickName: self.nickTextField.text!)
        
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
