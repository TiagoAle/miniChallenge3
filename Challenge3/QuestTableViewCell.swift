//
//  QuestTableViewCell.swift
//  miniChallenge3
//
//  Created by Islas Girão Garcia on 01/12/16.
//  Copyright © 2016 Islas Girão Garcia. All rights reserved.
//

import UIKit

class QuestTableViewCell: UITableViewCell {

    

    @IBOutlet weak var questImage: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var reward: UILabel!
    
    @IBOutlet weak var questDescription: UILabel!
    
    @IBOutlet weak var buttonStartQuest: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.title.text = "titulodaquest"
        self.questImage.image = #imageLiteral(resourceName: "male")
        self.reward.text = "tu perde peso"
        self.questDescription.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In faucibus, orci ac tempor eleifend, tellus leo ultricies erat, sed sodales nisl velit in enim. "
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
