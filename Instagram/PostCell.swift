//
//  PostCell.swift
//  Instagram
//
//  Created by Jackson Didat on 2/8/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var caption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
