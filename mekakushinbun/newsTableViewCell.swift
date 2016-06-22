//  newsViewCell.swift
//  mekakushinbun
//  Created by satoshiii on 2016/06/15.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit

class newsTableViewCell: UITableViewCell {

	@IBOutlet weak var subjectLabel: UILabel!
	@IBOutlet weak var dateTimeLabel: UILabel!
	@IBOutlet weak var categoryLabel: UILabel!

	
	override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
