//
//  DivideTableViewCell.swift
//  Swift Practice # 95 StopWatch Test
//
//  Created by Dogpa's MBAir M1 on 2021/10/16.
//

import UIKit

class DivideTableViewCell: UITableViewCell {

    @IBOutlet weak var loopIndexLabel: UILabel!
    
    @IBOutlet weak var loopTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
