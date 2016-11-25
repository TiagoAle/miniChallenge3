//
//  dataManager.swift
//  Castelinho
//
//  Created by Daniel Dias on 25/11/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit

class UserDataManager: NSObject {
    
    var nickName = ""
    
    func saveNickName(nickName: String) -> String{
        
        //        if let nickName = UserDefaults.standard.object(forKey: "nick") as? String{
        //            print("um usuario ja esta cadastrado")
        //
        //        // ---- mudar usuario ja cadastrado
        //        //----
        //
        //            self.nickName = nickName
        //        }else{
        //            UserDefaults.standard.set(nickName, forKey: "key")
        //            self.nickName = nickName
        //
        //        }
        
        UserDefaults.standard.set(nickName, forKey: "key")
        self.nickName = nickName
        return self.nickName
    }
    
    func UserExist() -> Bool{
        if let nickName = UserDefaults.standard.object(forKey: "nick") as? String{
            print("um usuario ja esta cadastrado")
            self.nickName = nickName
            return true
        }else{
            return false
        }
        
    }
    
    
}
