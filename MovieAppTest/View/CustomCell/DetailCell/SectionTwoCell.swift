//
//  SectionTwoCell.swift
//  MovieAppTest
//
//  Created by Hannatassja Hardjadinata on 05/10/22.
//

import UIKit
import youtube_ios_player_helper

class SectionTwoCell: UITableViewCell {

    @IBOutlet weak var playerView: YTPlayerView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
