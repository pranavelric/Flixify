//
//  MovieCellActionBuilder.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 06/08/23.
//

import Foundation
import UIKit

struct MovieCellActionsBuilder {
    static let shared = MovieCellActionsBuilder()
    func createDeleteAction(performedAction: @escaping () -> Void) -> UIAction {
        UIAction(title: "Delete bookmark", image: UIImage(systemName: "bookmark.slash"), attributes: .destructive) { _ in
            performedAction()
        }
    }
    
    func createAddToBookmarksAction(performedAction: @escaping () -> Void) -> UIAction {
        UIAction(title: "Add to bookmarks", image: UIImage(systemName: "bookmark")) { _ in
            performedAction()
        }
    }
    
    func createLearnMoreAction(performedAction: @escaping () -> Void) -> UIAction {
        UIAction(title: "Learn more", image: UIImage(systemName: "ellipsis.circle")) { _ in
            performedAction()
        }
    }
}
