//
//  SectionThreeCell.swift
//  MovieAppTest
//
//  Created by Hannatassja Hardjadinata on 05/10/22.
//

import UIKit

class SectionThreeCell: UITableViewCell {

    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var seeReviewLabel: UILabel!
    
    var onButtonTapped : (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupLabelTap()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        if let onButtonTapped = self.onButtonTapped {
            onButtonTapped()
        }
    }
    
    func setupLabelTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.seeReviewLabel.isUserInteractionEnabled = true
        self.seeReviewLabel.addGestureRecognizer(labelTap)
        
    }
    
}
