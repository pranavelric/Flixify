//
//  UITableView.swift
//  Flixify
//
//  Created by Pranav Choudhary on 18/08/23.
//

import Foundation
import UIKit

extension UITableView {
    func reloadOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
