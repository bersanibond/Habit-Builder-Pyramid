//
//  CustomHabitCellTableViewCell.swift
//  Habit Builder
//
//  Created by Henrique Bersani on 5/26/20.
//  Copyright © 2020 Henrique Bersani. All rights reserved.
//

import UIKit

class CustomHabitCellTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pyramidView.layer.cornerRadius = pyramidView.frame.height/2
        pyramidView.layer.borderColor = UIColor.systemYellow.cgColor
        pyramidView.layer.borderWidth = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var habitName: UILabel!
    
    @IBOutlet weak var habitDescription: UILabel!
    @IBOutlet weak var pyramidImage: UIImageView!
    @IBOutlet weak var pyramidView: UIView!
    @IBOutlet weak var addLabel: UILabel!
    
}
