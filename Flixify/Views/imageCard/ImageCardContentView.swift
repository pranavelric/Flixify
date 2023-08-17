//
//  ImageCardContentView.swift
//  Flixify
//
//  Created by Pranav Choudhary on 05/08/23.
//

import UIKit

class ImageCardContentView: UIView {

  private let backgroundView: UIView = {
    let background = UIView()
    background.clipsToBounds = true
    background.layer.cornerRadius = 10
      background.translatesAutoresizingMaskIntoConstraints = false
    return background
  }()

  private let imageView: UIImageView = {
    let imageView = UIImageView()
      imageView.contentMode = .scaleAspectFill
      imageView.image = UIImage(named: "film_poster_placeholder")
      imageView.backgroundColor = .black
      imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private let gradientLayer: CAGradientLayer = {
    let gradient = CAGradientLayer()
    gradient.colors = [UIColor.black.withAlphaComponent(0.01).cgColor,
                       UIColor.black.withAlphaComponent(0.8).cgColor]
    gradient.startPoint = CGPoint(x: 0.5, y: 0)
    gradient.endPoint = CGPoint(x: 0.5, y: 1)
    return gradient
  }()

  init(withImageUrl imageUrl: String?) {
    super.init(frame: .zero)
    imageView.sd_setImage(with: URL(string: "\(Constants.POSTER_PATH)/\(imageUrl ?? "")"), placeholderImage: UIImage(named: "film_poster_placeholder"))
    initialize()
  }

  required init?(coder aDecoder: NSCoder) {
    return nil
  }

  private func initialize() {
    addSubview(backgroundView)
//      backgroundView.bounds = bounds
      backgroundView.topAnchor.constraint(equalTo: topAnchor ).isActive = true
      backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
      backgroundView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
      backgroundView.rightAnchor.constraint(equalTo: rightAnchor ).isActive = true
//
    backgroundView.addSubview(imageView)
    imageView.topAnchor.constraint(equalTo: topAnchor ).isActive = true
      imageView.bottomAnchor.constraint(equalTo: bottomAnchor ).isActive = true
      imageView.leftAnchor.constraint(equalTo: leftAnchor ).isActive = true
      imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
      imageView.heightAnchor.constraint(equalToConstant: 600).isActive = true
    applyShadow(radius: 8, opacity: 0.2, offset: CGSize(width: 0, height: 2))
    backgroundView.layer.insertSublayer(gradientLayer, above: imageView.layer)
  }

  override func draw(_ rect: CGRect) {
    super.draw(rect)
    let heightFactor: CGFloat = 0.35
    gradientLayer.frame = CGRect(x: 0,
                                 y: (1 - heightFactor) * bounds.height,
                                 width: bounds.width,
                                 height: heightFactor * bounds.height)
  }
}
