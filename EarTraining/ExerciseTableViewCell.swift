//
//  ExerciseTableViewCell.swift
//  EarTraining
//
//  Created by Ariel Todoki on 2/4/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
