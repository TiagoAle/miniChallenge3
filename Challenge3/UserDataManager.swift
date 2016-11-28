//
//  dataManager.swift
//  Castelinho
//
//  Created by Daniel Dias on 25/11/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit
import HealthKit

protocol UserDataManagerDelegate {
    func updatingDataTableView(arrayInfo: [Any])
}

class UserDataManager: NSObject {
    
    var nickName = ""
    var delegate: UserDataManagerDelegate?
    var arrayInformations = [Any]()
    let healthManager = HealthKitManager()
    var sex: String?
    var age: Int?
    var bloodType: String?
    var weight: String?
    var height: String?
    var heightSample: HKQuantitySample?
    var weightSample: HKQuantitySample?
    var bmi: Double?
    
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
        
        UserDefaults.standard.set(nickName, forKey: "nick")
        if let nick = UserDefaults.standard.object(forKey: "nick") as? String{
            self.nickName = nick
        }
        
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
    
    func checkData() {
        if self.sex == nil{
            self.sex = "Unknown"
        }
        if self.age == nil{
            self.age = -1
        }
        if self.bloodType == nil{
            self.bloodType = "Unknown"
        }
        if self.height == nil{
            self.height = "Unknown"
        }
        if self.weight == nil{
            self.weight = "Unknown"
        }
        if self.bmi == nil{
            self.bmi = -1
        }
    }
    
    func receiveProfile() {
        let completion: ((Bool, Error?) -> Void)! = {
            (success, error) -> Void in
            
            if !success {
                
                print("You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: \(error). If you're using a simulator, try it on a device.")
                
                return
            }
            
            DispatchQueue.main.async{
                
                // Update the user interface based on the current user's health information.
                self.age = self.healthManager.receiveUserData().age
                self.bloodType = self.healthManager.receiveUserData().bloodtype
                self.sex = self.healthManager.receiveUserData().biologicalsex
                self.updateHeight()
                self.updateWeight()
                
                self.checkData()
                
                self.arrayInformations.append(self.age! as Int)
                self.arrayInformations.append(self.sex! as String)
                self.arrayInformations.append(self.bloodType! as String)
                self.arrayInformations.append(self.height! as String)
                self.arrayInformations.append(self.weight! as String)
                self.arrayInformations.append(self.bmi! as Double)
                
                
                self.delegate?.updatingDataTableView(arrayInfo: self.arrayInformations)
                
            }
        }
        
        healthManager.authorizeHealthKit(completion: completion)
    }
    
    func updateWeight() {
        // 1. Construct an HKSampleType for weight
        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
        
        // 2. Call the method to read the most recent weight sample
        self.healthManager.readMostRecentSample(sampleType: sampleType!, completion: { (mostRecentWeight, error) -> Void in
            
            if( error != nil )
            {
                print("Error reading weight from HealthKit Store: \(error?.localizedDescription)")
                return
            }
            
            var weightLocalizedString = "UnKnown"
            // 3. Format the weight to display it on the screen
            self.weightSample = mostRecentWeight as? HKQuantitySample
            if let kilograms = self.weightSample?.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo)) {
                let weightFormatter = MassFormatter()
                weightFormatter.isForPersonMassUse = true
                weightLocalizedString = weightFormatter.string(fromKilograms: kilograms)
            }
            
            // 4. Update UI in the main thread
            DispatchQueue.main.async{
                self.weight = weightLocalizedString
                self.arrayInformations[4] = self.weight! as String
                self.updateBMI()
            }
        })
    }
    
    func updateHeight(){
        // 1. Construct an HKSampleType for Height
        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)
        
        // 2. Call the method to read the most recent Height sample
        self.healthManager.readMostRecentSample(sampleType: sampleType!, completion: { (mostRecentHeight, error) -> Void in
            
            if( error != nil )
            {
                print("Error reading height from HealthKit Store: \(error?.localizedDescription)")
                return
            }
            
            var heightLocalizedString = "Unknown"
            self.heightSample = mostRecentHeight as? HKQuantitySample;
            // 3. Format the height to display it on the screen
            if let meters = self.heightSample?.quantity.doubleValue(for: HKUnit.meter()) {
                let heightFormatter = LengthFormatter()
                heightFormatter.isForPersonHeightUse = true
                heightLocalizedString = heightFormatter.string(fromMeters: meters);
            }
            
            
            // 4. Update UI. HealthKit use an internal queue. We make sure that we interact with the UI in the main thread
            DispatchQueue.main.async {
                self.height = heightLocalizedString
                self.arrayInformations[3] = self.height! as String
                self.updateBMI()
            }
            
        })
    }
    
    func updateBMI() {
        if weightSample != nil && heightSample != nil {
            // 1. Get the weight and height values from the samples read from HealthKit
            let weightInKilograms = weightSample!.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            let heightInMeters = heightSample!.quantity.doubleValue(for: HKUnit.meter())
            // 2. Call the method to calculate the BMI
            self.bmi  = weightInKilograms/(heightInMeters*heightInMeters)
        }
        // 3. Show the calculated BMI
        self.arrayInformations[5] = self.bmi! as Double
        self.delegate?.updatingDataTableView(arrayInfo: self.arrayInformations)
    }
    
}
