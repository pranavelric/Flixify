//
//  MovieViewModelProtocol.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 06/08/23.
//

import Foundation

protocol MovieViewModelProtocol {
    func isTitleInStorage(at indexPath: IndexPath) -> Bool
    func learnMoreAboutTitle(at indexPath: IndexPath)
    func deleteBookmark(at indexPath: IndexPath)
    func addBookmarkForTitle(at indexPath: IndexPath)
}
