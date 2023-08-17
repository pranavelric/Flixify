//
//  ImageCardOverlay.swift
//  Flixify
//
//  Created by Pranav Choudhary on 05/08/23.
//

import Shuffle
import UIKit

class ImageCardOverlay: UIView {

  init(direction: SwipeDirection) {
    super.init(frame: .zero)
    switch direction {
    case .left:
      createLeftOverlay()
    case .up:
      createUpOverlay()
    case .right:
      createRightOverlay()
    default:
      break
    }
  }

  required init?(coder: NSCoder) {
    return nil
  }

  private func createLeftOverlay() {
    let leftTextView = ImageCardOverlayLabelView(withTitle: "Next",
                                                  color: .sampleBlue,
                                                  rotation: CGFloat.pi / 10)
    addSubview(leftTextView)
      leftTextView.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
      
//    leftTextView.anchor(top: topAnchor,
//                        right: rightAnchor,
//                        paddingTop: 30,
//                        paddingRight: 14)
  }

  private func createUpOverlay() {
    let upTextView = ImageCardOverlayLabelView(withTitle: "Next",
                                                color: .sampleBlue,
                                                rotation: -CGFloat.pi / 20)
    addSubview(upTextView)
      upTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 20).isActive = true
//          .anchor(bottom: bottomAnchor, paddingBottom: 20)
    upTextView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
  }

  private func createRightOverlay() {
    let rightTextView = ImageCardOverlayLabelView(withTitle: "Next",
                                                   color: .sampleBlue,
                                                   rotation: -CGFloat.pi / 10)
    addSubview(rightTextView)
      rightTextView.topAnchor.constraint(equalTo: topAnchor, constant: 26).isActive = true
      rightTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true
//    rightTextView.anchor(top: topAnchor,
//                         left: leftAnchor,
//                         paddingTop: 26,
//                         paddingLeft: 14)
  }
}

private class ImageCardOverlayLabelView: UIView {

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    return label
  }()

  init(withTitle title: String, color: UIColor, rotation: CGFloat) {
    super.init(frame: CGRect.zero)
    layer.borderColor = color.cgColor
    layer.borderWidth = 4
    layer.cornerRadius = 4
    transform = CGAffineTransform(rotationAngle: rotation)

    addSubview(titleLabel)
    titleLabel.textColor = color
    titleLabel.attributedText = NSAttributedString(string: title,
                                                   attributes: NSAttributedString.Key.overlayAttributes)
      titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 3).isActive = true
//    titleLabel.anchor(top: topAnchor,
//                      left: leftAnchor,
//                      bottom: bottomAnchor,
//                      right: rightAnchor,
//                      paddingLeft: 8,
//                      paddingRight: 3)
  }

  required init?(coder aDecoder: NSCoder) {
    return nil
  }
}

extension NSAttributedString.Key {

  static var overlayAttributes: [NSAttributedString.Key: Any] = [
    // swiftlint:disable:next force_unwrapping
    NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 42)!,
    NSAttributedString.Key.kern: 5.0
  ]
}

extension UIColor {
  static var sampleRed = UIColor(red: 252 / 255, green: 70 / 255, blue: 93 / 255, alpha: 1)
  static var sampleGreen = UIColor(red: 49 / 255, green: 193 / 255, blue: 109 / 255, alpha: 1)
  static var sampleBlue = UIColor(red: 52 / 255, green: 154 / 255, blue: 254 / 255, alpha: 1)
}
