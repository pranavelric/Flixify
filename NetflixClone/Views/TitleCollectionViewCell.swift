//
//  TitleCollectionViewCell.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 15/07/23.
//

import UIKit
import SDWebImage


class TitleCollectionViewCell: UICollectionViewCell {
    static let identifier = "TitleCollectionViewCell"
    
    private let posterImageView :UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    
    public func configure(with url: String){
        posterImageView.sd_setImage(with: URL(string: "\(Constants.POSTER_PATH)/\(url)"), placeholderImage: UIImage(named: "placeholder.png"))

    }
    
}
