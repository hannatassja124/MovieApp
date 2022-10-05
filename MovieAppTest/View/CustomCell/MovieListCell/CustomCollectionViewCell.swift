//
//  CustomCollectionViewCell.swift
//  MovieAppTest
//
//  Created by Hannatassja Hardjadinata on 05/10/22.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var movie: Movie?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie?.poster ?? "")")
        
        self.movieImageView.layer.cornerRadius = 30
        self.movieImageView.contentMode = .scaleAspectFill
        self.movieImageView.downloadImage(from: url!)
        
        self.titleLabel.text = movie?.title
    }

}
