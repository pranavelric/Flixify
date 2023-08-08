//
//  Extensions.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 14/07/23.
//

import Foundation
import UIKit

extension String {
    func capitalizeFirstLetter()-> String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    func getFormattedDate()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "MMMM d, yyyy"
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate
        } else {
            return "Unknown Date" // Return a default value in case the date conversion fails.
        }
    }
}



extension UITableView {
   func scrollToBottom(){

    DispatchQueue.main.async {
        let indexPath = IndexPath(
            row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
            section: self.numberOfSections - 1)
        self.scrollToRow(at: indexPath, at: .bottom, animated: true)//        if self.hasRowAtIndexPath(indexPath: indexPath) {
//            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
//        }
    }
}

func scrollToTop() {
    DispatchQueue.main.async {
        let indexPath = IndexPath(row: 0, section: 0)
        if self.hasRowAtIndexPath(indexPath: indexPath) {
            self.scrollToRow(at: indexPath, at: .top, animated: true)
       }
    }
}

func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
    return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
}
}



extension UILabel {
    
    func addTrailing(image: UIImage, text:String) {
        let attachment = NSTextAttachment()
        attachment.image = image

        let attachmentString = NSAttributedString(attachment: attachment)
        let string = NSMutableAttributedString(string: text, attributes: [:])

        string.append(attachmentString)
        self.attributedText = string
    }
    
    func addLeading(image: UIImage, text:String, height:CGFloat? = CGFloat(integerLiteral: 10),color:UIColor) {
        let attachment = NSTextAttachment()
        attachment.image = image.withTintColor(color)
        
        let yImage = (font.capHeight - height!).rounded() / 2
        let ratio = image.size.width / image.size.height
        attachment.bounds = CGRect(x: 0, y: yImage, width: ratio * height!, height: height!)
     

        let attachmentString = NSAttributedString(attachment: attachment)
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentString)
        
        let string = NSMutableAttributedString(string: " \(text)", attributes: [:])
        mutableAttributedString.append(string)
        self.attributedText = mutableAttributedString
    }
}


extension UIView {

  func applyShadow(radius: CGFloat,
                   opacity: Float,
                   offset: CGSize,
                   color: UIColor = .black) {
    layer.shadowRadius = radius
    layer.shadowOpacity = opacity
    layer.shadowOffset = offset
    layer.shadowColor = color.cgColor
  }
}

extension UIButton {
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.4
        pulse.fromValue = 0.98
        pulse.toValue = 1.2
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        self.layer.add(pulse, forKey: nil)
    }
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.3
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 2
        self.layer.add(flash, forKey: nil)
    }

    
}


