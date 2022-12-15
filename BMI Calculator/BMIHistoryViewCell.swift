//
//  BMIHistoryViewCell.swift
//  BMI Calculator
//
//  Created by Jovi on 15/12/2022.
//

import UIKit

class BMIHistoryViewCell: UITableViewCell {

    @IBOutlet weak var bmiDescriptionLabel: UILabel!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var heightWeightLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
