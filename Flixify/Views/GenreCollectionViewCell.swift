//
//  MovieTableViewCell.swift
//  Flixify
//
//  Created by Pranav Choudhary on 23/07/23.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    static let IDENTIFIER = "GenreCollectionViewCell"
    
    
  
    private let genreButton : UIButton = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 12)
//        label.textColor = .white.withAlphaComponent(0.9)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.lineBreakMode = NSLineBreakMode.byWordWrapping
//        label.numberOfLines = 0
//        label.backgroundColor = .red
//        label.layer.cornerRadius = 4.0
//        label.clipsToBounds = true
//        label.layer.masksToBounds = true
//        return label
        
        let button = UIButton()
        button.configuration = .tinted()
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.configuration?.baseBackgroundColor = .red.withAlphaComponent(0.4)
        button.configuration?.baseForegroundColor = .white.withAlphaComponent(0.8)
        button.configuration?.buttonSize = .mini
        button.configuration?.cornerStyle = .medium
        button.configuration?.imagePadding = 2
        button.configuration?.imagePlacement = .top
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    
    public func configure(with genre:Genre?){
        self.genreButton.setTitle(genre?.name ?? "", for: .normal)
  
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(genreButton)
       }



    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func configureUI(){
            configureGenreButton()
    }
        
   
    private func configureGenreButton(){
        NSLayoutConstraint.activate([
            
//            genreButton.topAnchor.constraint(equalTo: contentView.topAnchor),
//            genreButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor ),
//            genreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            genreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            genreButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            genreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
                   
               ])
    }
    

}
