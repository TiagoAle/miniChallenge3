//
//  ExpandedTableViewCell.swift
//  Challenge3
//
//  Created by Daniel Dias on 02/12/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit

protocol MyCustomCellDelegator {
    func callSegueFromCell(myData dataobject: AnyObject)
}

class ExpandedTableViewCell: UITableViewCell {

    
    var delegate:MyCustomCellDelegator!
    
    var mission: Mission?
    
    @IBOutlet weak var questImage: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var reward: UILabel!
    
    @IBOutlet weak var questDescription: UILabel!
    
    @IBOutlet weak var buttonState: UIButton!
 
    @IBOutlet weak var cellState: UIView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.title.text = "titulodaquest"
        self.questImage.image = #imageLiteral(resourceName: "questIcon")
        self.reward.text = "tu perde peso"
        self.questDescription.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In faucibus, orci ac tempor eleifend, tellus leo ultricies erat, sed sodales nisl velit in enim. "
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func startMission(_ sender: UIButton) {
        
        
        let mydata = "segue"
        if(self.delegate != nil){ //Just to be safe.
            self.delegate.callSegueFromCell(myData: mydata as AnyObject)
        }
        
       
        
    }
    
    
}
