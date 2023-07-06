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
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius =  8
        return button
    }()
    
    private let playbutton : UIButton = {
        let button:UIButton = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius =  8
        return button
    }()
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        imageView.contentMode = .scaleAspectFill;
     
        
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
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
        heroImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func applyConstraint(){
        let playButtonConstraints = [
            playbutton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playbutton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playbutton.widthAnchor.constraint(equalToConstant: 120)
        ]
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    
}
