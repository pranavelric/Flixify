//
//  MovieInterface.swift
//  Flixify
//
//  Created by Pranav Choudhary on 18/08/23.
//

import Foundation


protocol MovieInterface: AnyObject {
    func configureVC()
    func configureCollectionView()
    func reloadCollectionView()
    func didTapItem(with viewModel: MoviePreviewViewModel)
    func showToast(message msg: String)
}

