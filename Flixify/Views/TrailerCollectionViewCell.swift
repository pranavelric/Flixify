//
//  TrailerCollectionViewCell.swift
//  Flixify
//
//  Created by Pranav Choudhary on 02/08/23.
//

import Foundation
import UIKit
import YouTubeiOSPlayerHelper

class TrailerCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TrailerCollectionViewCell"
    
    private let trailerPosterImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "film_poster_placeholder")
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let trailerView : YTPlayerView = {
        let trailerView = YTPlayerView()
        trailerView.translatesAutoresizingMaskIntoConstraints = false
        trailerView.isUserInteractionEnabled = true
        return trailerView
    }()
    
    let playerVar = [
        "playsinline":1,
        "showinfo": 1,
        "rel": 0,
        "modestbranding": 1,
        "controls": 0,
        "color": "white",
        "iv_load_policy": 3,
        "origin" : "https://www.youtube.com/embed/"
        
    ] as [AnyHashable  :Any]?
    
    private var youtubeItem: String? = nil
    // another uiIamge view for icon
 
    
    public func configure(with videoId: String?){
        self.youtubeItem = videoId
        setupTrailer()
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
   
    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func configureUI(){
            configureTrailerPosterImage()
    }
        
    private func  configureTrailerPosterImage(){
        
        let aspectRatio: CGFloat = 16.0 / 9.0 // 16:9 aspect ratio for YouTube videos
        contentView.addSubview(trailerView)
        let webViewConstraints = [
            trailerView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 0),
            trailerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trailerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trailerView.heightAnchor.constraint(equalToConstant: 250),
            trailerView.widthAnchor.constraint(equalTo: trailerView.heightAnchor, multiplier: aspectRatio)
        ]
        
       
   
        NSLayoutConstraint.activate(webViewConstraints)
        
        

    }

    private func setupTrailer(){
        trailerView.load(withPlayerParams: playerVar)
        trailerView.load(withVideoId: "\(self.youtubeItem ?? "8zIf0XvoL9Y" )", playerVars: playerVar)
        trailerView.layer.cornerRadius = 10
        trailerView.clipsToBounds = true
    }
}
