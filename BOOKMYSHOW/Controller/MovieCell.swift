//
//  MovieCell.swift
//  BOOKMYSHOW
//
//  Created by Sanjay Mali on 23/02/19.
//  Copyright © 2019 LoyltyRewardz. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var movieTitleLbl: UILabel!
    @IBOutlet weak var bannerImageView: ImagePlaceholderLoader!
    @IBOutlet weak var bannerView:UIView!

    @IBOutlet weak var bookBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
