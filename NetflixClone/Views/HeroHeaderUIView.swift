//
//  HeroHeaderUIView.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 05/07/23.
//

import UIKit






class HeroHeaderUIView: UIView {
    
    private let downloadButton:UIButton = {
        let button:UIButton =  UIButton()
        button.setTitle("Bookmark", for: .normal)
//        button.layer.borderColor = UIColor.white.cgColor
//        button.layer.borderWidth = 1
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = .darkGray
        button.configuration?.baseForegroundColor = .white
        button.configuration?.image = UIImage(systemName: "bookmark.fill")
        button.configuration?.imagePadding = 2
        button.configuration?.imagePlacement = .leading
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius =  8
        return button
    }()
    
    private let playbutton : UIButton = {
        let button:UIButton = UIButton()
        button.setTitle("Play", for: .normal)
//        button.layer.borderColor = UIColor.white.cgColor
//        button.layer.borderWidth = 1
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = .white
        button.configuration?.baseForegroundColor = .black
        button.configuration?.image = UIImage(systemName: "play.fill")
        button.configuration?.imagePlacement = .leading
        button.configuration?.imagePadding = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius =  8
        return button
    }()
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "film_poster_placeholder")
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
//        addGradient()
        addSubview(playbutton)
        addSubview(downloadButton)
        applyConstraint()     
    }
    
    func addGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        heroImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func applyConstraint(){
        
        let margin: CGFloat = 16 // Set your desired margin value here

          // Hero image constraints
          heroImageView.translatesAutoresizingMaskIntoConstraints = false
          heroImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
          heroImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin).isActive = true
          heroImageView.topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
          heroImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin).isActive = true

        
        
        let playButtonConstraints = [
            playbutton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playbutton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playbutton.widthAnchor.constraint(equalToConstant: 130)
        ]
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 130)
        ]

        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
         
    }
    
    public func configure(imageUrl url : String?){
        print("hereherehehehrherheh")
        heroImageView.sd_setImage(with: URL(string: "\(Constants.POSTER_PATH)/\(url ?? "")"), placeholderImage: UIImage(named: "film_poster_placeholder"))
    }
    
    
}
