//
//  Extensions.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 14/07/23.
//

import Foundation

extension String {
    func capitalizeFirstLetter()-> String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
