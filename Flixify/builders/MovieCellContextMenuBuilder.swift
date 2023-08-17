////
////  MovieCellContextMenuBuilder.swift
////  Flixify
////
////  Created by Pranav Choudhary on 06/08/23.
////
//
//import UIKit
//
//struct MovieCellContextMenuBuilder {
//    
//    //MARK: Properties
//    
//    private let viewModel: MovieViewModelProtocol
//    private let actionsBuilder = MovieCellActionsBuilder()
//    
//    //MARK: - Initialization
//    
//    init(viewModel: MovieViewModelProtocol) {
//        self.viewModel = viewModel
//    }
//    
//    //MARK: - Methods
//    
//    func configureContextMenuForCell(at indexPath: IndexPath) -> UIContextMenuConfiguration {
//        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
//            return UIMenu(title: "", children: setupActionsForCell(at: indexPath))
//        }
//    }
//    
//    //MARK: - Private methods
//    
////    private func setupActionsForCell(at indexPath: IndexPath) -> [UIAction] {
////        let bookmarksAction = setupBookmarksAction(indexPath)
////        let learnMoreAction = setupLearnMoreAction(indexPath)
////        return [bookmarksAction, learnMoreAction]
////    }
////    
////    private func setupLearnMoreAction(_ indexPath: IndexPath) -> UIAction {
////        return actionsBuilder.createLearnMoreAction {
////            viewModel.learnMoreAboutTitle(at: indexPath)
////        }
////    }
////    private func setupBookmarksAction(_ indexPath: IndexPath) -> UIAction {
////        print("here")
////        if viewModel.isTitleInStorage(at: indexPath) {
////            return actionsBuilder.createDeleteAction {
////                viewModel.deleteBookmark(at: indexPath)
////            }
////        } else {
////            return actionsBuilder.createAddToBookmarksAction {
////                viewModel.addBookmarkForTitle(at: indexPath)
////            }
////        }
////    }
//}
