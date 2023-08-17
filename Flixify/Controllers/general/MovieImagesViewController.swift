//
//  MovieImagesViewController.swift
//  Flixify
//
//  Created by Pranav Choudhary on 04/08/23.
//

import UIKit
import Shuffle

class MovieImagesViewController: UIViewController {

    private let imageCard : SwipeCard = {
        let card = SwipeCard()
        card.swipeDirections = [.left, .right]
//        card.content = UIImageView(image: image)
        
        let leftOverlay = UIView()
        leftOverlay.backgroundColor = .green
        
        let rightOverlay = UIView()
        rightOverlay.backgroundColor = .red
        
        card.setOverlays([.left: leftOverlay, .right: rightOverlay])
        
        return card
      }()
    
    private let cardStack = SwipeCardStack()
    private var imagesCard: [Backdrop]? = []
    private var imagesCardPosters : [Poster]? = []
    private var imagesCardLogo: [Logo]? = []
    private var imagesUrls : [String]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        layoutCardStackView()
        configureBackgroundGradient()
        cardStack.delegate = self
        cardStack.dataSource = self
//        cardStack.frame = view.safeAreaLayoutGuide.layoutFrame
    }
    
   
    
    public func configure(with model: MovieImagesViewModel){
        imagesCard = model.movieImages
        imagesCardPosters = model.movieImagesPosters
        imagesCardLogo = model.movieImagesLogos
        combineImagesUrls()
    }
    
    private func combineImagesUrls(){
        if let backdrops = imagesCard {
            let backdropPaths = backdrops.compactMap { $0.filePath }
            self.imagesUrls?.append(contentsOf: backdropPaths)
        }

        if let posters = imagesCardPosters {
            let posterPaths = posters.compactMap{ $0.filePath }
            self.imagesUrls?.append(contentsOf: posterPaths)
        }

        if let logos = imagesCardLogo {
            let logoPaths = logos.compactMap{ $0.filePath }
            self.imagesUrls?.append(contentsOf: logoPaths)
        }
    }
    
    private func layoutCardStackView() {
        view.addSubview(cardStack)
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        cardStack.backgroundColor = .clear
        cardStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 0).isActive = true
        cardStack.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 0).isActive = true
        cardStack.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 0).isActive = true
        cardStack.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 0).isActive = true
    }

    
    private func configureBackgroundGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.black.cgColor]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
      }
    
}



extension MovieImagesViewController: SwipeCardStackDataSource, SwipeCardStackDelegate {

  func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
    let card = SwipeCard()
//    card.footerHeight = 80
      card.swipeDirections = [.left, .up, .right]
    for direction in card.swipeDirections {
      card.setOverlay(ImageCardOverlay(direction: direction), forDirection: direction)
    }

      let image_url = imagesUrls?[index] ?? ""
    card.content = ImageCardContentView(withImageUrl: image_url)
//    card.footer = TinderCardFooterView(withTitle: "\(model.name), \(model.age)", subtitle: model.occupation)

    return card
  }

  func numberOfCards(in cardStack: SwipeCardStack) -> Int {
      return imagesUrls?.count ?? 0
  }

  func didSwipeAllCards(_ cardStack: SwipeCardStack) {
    print("Swiped all cards!")
  }

  func cardStack(_ cardStack: SwipeCardStack, didUndoCardAt index: Int, from direction: SwipeDirection) {
      print("Undo \(direction) swipe on \(imagesUrls?[index])")
  }

  func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
      print("Swiped \(direction) on \(imagesUrls?[index])")
  }

  func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
    print("Card tapped")
  }


}

