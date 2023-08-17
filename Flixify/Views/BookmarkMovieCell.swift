//
//  MovieTableViewCell.swift
//  Flixify
//
//  Created by Pranav Choudhary on 23/07/23.
//

import UIKit

class BookmarkMovieCell: UITableViewCell {
    
    static let IDENTIFIER = "BookmarkMovieCell"
    
    private let moviePosterImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "film_poster_placeholder")
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private var movieImageUrl: String? = nil
    private var releaseDate: String? = nil
    private var overview: String? = nil
    private var title: String? = nil
    private var genre: [Int]? = nil
    // another uiIamge view for icon
    private let remindMeButton : UIButton = {
        let button:UIButton =  UIButton()
//        button.setTitle("Remind Me", for: .normal)
        button.configuration = .tinted()
        button.titleLabel?.font = .systemFont(ofSize: 2)
        button.configuration?.baseBackgroundColor = .clear
        button.configuration?.baseForegroundColor = .white
        button.configuration?.buttonSize = .mini
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.configuration?.image = UIImage(systemName: "bell",withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        
        button.configuration?.imagePadding = 2
        button.configuration?.imagePlacement = .top
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let infoButton : UIButton = {
        let button:UIButton =  UIButton()
//        button.setTitle("Info", for: .normal)
        button.configuration = .tinted()
        button.titleLabel?.font = .systemFont(ofSize: 2)
        button.configuration?.baseBackgroundColor = .clear
        button.configuration?.baseForegroundColor = .white
        button.configuration?.buttonSize = .mini
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.configuration?.image = UIImage(systemName: "info.circle",withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        
        button.configuration?.imagePadding = 2
        button.configuration?.imagePlacement = .top
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // two ui button -> remind me and info
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    private let descriptionLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 5

        return label
    }()
    private let genreLabels : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    public func configure(movieImageUrl: String?,releaseDate: String, title: String?, genre_ids genreIds : [Int]?, overview: String?){
        self.movieImageUrl = movieImageUrl
        self.releaseDate = releaseDate
        self.title = title
        self.overview = overview
        self.genre = genreIds
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(moviePosterImageView)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(infoButton)
        contentView.addSubview(remindMeButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(genreLabels)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func configureUI(){
            configureMoviePosterImage()
            configureReleaseDateLabel()
            configureInfoButton()
            configureRemindMeButton()
            configureTitleLabel()
            configureDescriptionLabel()
            configureGenreLabel()
    }
        
    private func configureMoviePosterImage(){
        let margin: CGFloat = 16
        // Hero image constraints
        moviePosterImageView.sd_setImage(with: URL(string: "\(Constants.POSTER_PATH)/\(self.movieImageUrl ?? "")"), placeholderImage: UIImage(named: "film_poster_placeholder"))


        moviePosterImageView .translatesAutoresizingMaskIntoConstraints = false
        moviePosterImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        moviePosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        moviePosterImageView .leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        moviePosterImageView .trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin).isActive = true
//        moviePosterImageView .topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
//        moviePosterImageView .bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin-100).isActive = true

    }
    
    private func configureReleaseDateLabel(){
        releaseDateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        releaseDateLabel.text = "Coming:  \(self.releaseDate?.getFormattedDate() ?? "---")"
        releaseDateLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.leadingAnchor).isActive = true
        releaseDateLabel.topAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor,constant: 20).isActive = true
    }
    
    private func configureInfoButton(){
        infoButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        infoButton.trailingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor).isActive = true
        infoButton.topAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor, constant: 15).isActive = true
    }
    private func configureRemindMeButton(){
        remindMeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        remindMeButton.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor).isActive = true
        remindMeButton.topAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor, constant: 15).isActive = true
    }
    
    private func configureTitleLabel(){
        
        titleLabel.text = "\(self.title ?? "unknown")"
        titleLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor,constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor).isActive = true
    }
    
    private func configureDescriptionLabel(){
        
        descriptionLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width).isActive = true
        descriptionLabel.sizeToFit()
        descriptionLabel.text = "\(self.overview ?? "unknown")"
        descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 10).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor).isActive = true
    
        
    }
    
    
    private func configureGenreLabel(){
//        genreLabels.text = "\(self.movie?.genre_ids ?? "unknown")"
        
        let genreNames = self.genre?.compactMap({ Constants.genreMap[$0] as? String }).joined(separator: " \u{2022} ") ?? ""
        genreLabels.text = "\u{2022} \(genreNames)"
        genreLabels.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor).isActive = true
        genreLabels.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: 10).isActive = true
        genreLabels.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor).isActive = true
        genreLabels.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        genreLabels.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        

    }
    

}
