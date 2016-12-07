//
//  QuestTableViewCell.swift
//  Challenge3
//
//  Created by Daniel Dias on 02/12/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit

class QuestTableViewCell: UITableViewCell {
    
    var delegate:MyCustomCellDelegator!
    var mission: Mission?
    
    @IBOutlet weak var questImage: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var reward: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.title.text = "titulodaquest"
        self.questImage.image = #imageLiteral(resourceName: "male")
        self.reward.text = "tu perde peso"
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
