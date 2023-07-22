//
//  MovieTableViewCell.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 23/07/23.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    static let IDENTIFIER = "MovieTableViewCell"
    
    private let moviePosterImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private var movie: Movie? = nil
    // another uiIamge view for icon
    // two ui button -> remind me and info
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private let titleLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    private let descriptionLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    private let genreLabels : UILabel = {
        let label = UILabel()
        return label
    }()
    
    public func configure(with movie: Movie){
        self.movie = movie
        configureUI()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(moviePosterImageView)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(genreLabels)
        
        
        
        
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        moviePosterImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func configureUI(){
            configureMoviePosterImage()
    }
    
    private func configureMoviePosterImage(){
        let margin: CGFloat = 16
        // Hero image constraints
        moviePosterImageView.sd_setImage(with: URL(string: "\(Constants.POSTER_PATH)/\(self.movie?.poster_path ?? "")"), placeholderImage: UIImage(named: "placeholder.png"))


        moviePosterImageView .translatesAutoresizingMaskIntoConstraints = false
        moviePosterImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true

        moviePosterImageView .leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        moviePosterImageView .trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin).isActive = true
//        moviePosterImageView .topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
//        moviePosterImageView .bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin-100).isActive = true

    }
    
    
}
