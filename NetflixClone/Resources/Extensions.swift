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
