//
//  CreditCollectionViewCell.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 01/08/23.
//

import UIKit

class CreditCollectionViewCell: UICollectionViewCell {
    static let identifier = "CreditCollectionViewCell"
    
    private let personImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "placeholderImage")
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private var cast: Cast? = nil
    private var crew: Crew? = nil
    

    
  
    
    private let characterLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 8, weight: .light)
        label.textColor = .white.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 1
        return label
    }()
    private let departmentLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0

        return label
    }()
   
    
    public func configureCast(with cast: Cast?){
        self.cast = cast
        configureCastMemberData()
    }
    
    public func configureCrew(with crew: Crew?){
        self.crew = crew
        configureCrewMemberData()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(personImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(characterLabel)
        contentView.addSubview(departmentLabel)
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func configureUI(){
            configurePersonImageView()
            configureNameLabel()
            configureCharacterLabel()
//            configureDepartmentLabel()
    }
        
    private func  configurePersonImageView(){

//        personImageView.sd_setImage(with: URL(string: "\(Constants.POSTER_PATH)/\(self.cast?.profile_path ?? "")"), placeholderImage: UIImage(named: "profile_placeholder"))

        

        personImageView .translatesAutoresizingMaskIntoConstraints = false
        personImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        personImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        personImageView .leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        personImageView .trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        moviePosterImageView .topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
//        moviePosterImageView .bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin-100).isActive = true

    }
    
    private func configureNameLabel(){
//        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        nameLabel.text = "\(self.cast?.name ?? "")"
        nameLabel.leadingAnchor.constraint(equalTo: personImageView.leadingAnchor,constant: 2).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: personImageView.trailingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: personImageView.bottomAnchor,constant: 5).isActive = true
    }

    private func configureCharacterLabel(){
//        characterLabel.text = "\(self.cast?.character ?? "")"
//        characterLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        characterLabel.trailingAnchor.constraint(equalTo: personImageView.trailingAnchor).isActive = true
        characterLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        characterLabel.leadingAnchor.constraint(equalTo: personImageView.leadingAnchor, constant: 2).isActive = true
//        characterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
    }
    
    private func configureCastMemberData(){
        nameLabel.text = "\(self.cast?.name ?? "")"
        characterLabel.text = "\(self.cast?.character ?? "")"
        personImageView.sd_setImage(with: URL(string: "\(Constants.POSTER_PATH)/\(self.cast?.profile_path ?? "")"), placeholderImage: UIImage(named: "profile_placeholder"))

    }
    
    private func configureCrewMemberData(){
        nameLabel.text = "\(self.crew?.name ?? "")"
        characterLabel.text = "\(self.crew?.department ?? self.crew?.known_for_department ?? "" )"
        personImageView.sd_setImage(with: URL(string: "\(Constants.POSTER_PATH)/\(self.crew?.profile_path ?? "")"), placeholderImage: UIImage(named: "profile_placeholder"))

    }
    
//    private func configureRemindMeButton(){
//        remindMeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        remindMeButton.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor).isActive = true
//        remindMeButton.topAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor, constant: 15).isActive = true
//    }
//
//    private func configureTitleLabel(){
//
//        titleLabel.text = "\(self.movie?.title ?? self.movie?.original_title ?? "unknown")"
//        titleLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.leadingAnchor).isActive = true
//        titleLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor,constant: 15).isActive = true
//        titleLabel.trailingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor).isActive = true
//    }
//
//    private func configureDescriptionLabel(){
//
//        descriptionLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width).isActive = true
//        descriptionLabel.sizeToFit()
//        descriptionLabel.text = "\(self.movie?.overview ?? "unknown")"
//        descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
//        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 10).isActive = true
//        descriptionLabel.trailingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor).isActive = true
//
//
//    }
//
//
//    private func configureGenreLabel(){
////        genreLabels.text = "\(self.movie?.genre_ids ?? "unknown")"
//        let genreNames = self.movie?.genre_ids?.compactMap({ Constants.genreMap[$0] as? String }).joined(separator: " \u{2022} ") ?? ""
//        genreLabels.text = "\u{2022} \(genreNames)"
//        genreLabels.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor).isActive = true
//        genreLabels.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: 10).isActive = true
//        genreLabels.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor).isActive = true
//        genreLabels.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
//
//        genreLabels.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
//
//
//    }
    
}
