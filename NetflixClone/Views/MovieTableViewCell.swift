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
    private let remindMeButton : UIButton = {
        let button:UIButton =  UIButton()
//        button.setTitle("Remind Me", for: .normal)
        button.configuration = .tinted()
        button.titleLabel?.font = .systemFont(ofSize: 2)
        button.configuration?.baseBackgroundColor = .black
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
        button.configuration?.baseBackgroundColor = .black
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
        return label
    }()
    private let descriptionLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let genreLabels : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public func configure(with movie: Movie){
        self.movie = movie        
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
        moviePosterImageView.sd_setImage(with: URL(string: "\(Constants.POSTER_PATH)/\(self.movie?.poster_path ?? "")"), placeholderImage: UIImage(named: "placeholder.png"))


        moviePosterImageView .translatesAutoresizingMaskIntoConstraints = false
        moviePosterImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        moviePosterImageView .leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        moviePosterImageView .trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin).isActive = true
//        moviePosterImageView .topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
//        moviePosterImageView .bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin-100).isActive = true

    }
    
    private func configureReleaseDateLabel(){
        releaseDateLabel.text = "Coming:  \(self.movie?.release_date?.getFormattedDate() ?? "---")"
        releaseDateLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.leadingAnchor).isActive = true
        releaseDateLabel.topAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor,constant: 20).isActive = true
    }
    
    private func configureInfoButton(){
        infoButton.trailingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor).isActive = true
        infoButton.topAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor, constant: 15).isActive = true
    }
    private func configureRemindMeButton(){
        remindMeButton.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor).isActive = true
        remindMeButton.topAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor, constant: 15).isActive = true
    }
    
    private func configureTitleLabel(){
        titleLabel.text = "\(self.movie?.title ?? self.movie?.original_title ?? "unknown")"
        titleLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor,constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor).isActive = true
    }
    
    private func configureDescriptionLabel(){
        descriptionLabel.text = "\(self.movie?.overview ?? "unknown")"
        descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 10).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor).isActive = true
        descriptionLabel.numberOfLines = 0
    }
    
    
    private func configureGenreLabel(){
//        genreLabels.text = "\(self.movie?.genre_ids ?? "unknown")"
        let genreNames = self.movie?.genre_ids?.compactMap({ Constants.genreMap[$0] as? String }).joined(separator: " \u{2022} ") ?? ""

                
        genreLabels.text = "\u{2022} \(genreNames)"
        genreLabels.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor).isActive = true
        genreLabels.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: 10).isActive = true
        genreLabels.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor).isActive = true
        genreLabels.numberOfLines = 0
    }
}
