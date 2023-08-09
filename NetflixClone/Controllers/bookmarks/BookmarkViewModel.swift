//
//  BookmarkViewModel.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 09/08/23.
//

import Foundation

//MARK: - BookmarksViewModelProtocol

protocol BookmarksViewModelProtocol {
    var numberOfTitles: Int { get }
    var viewModelDidChange: ((BookmarksViewModelProtocol) -> Void)? { get set }
    func fetchTitles(completion: @escaping () -> Void)
    func deleteBookmark(at indexPath: IndexPath, completion: @escaping () -> Void)
    func deleteAllBookmarks(completion: @escaping () -> Void)
//    func viewModelForCell(at indexPath: IndexPath) -> BookmarkCellView ModelProtocol
    func idForTitle(at indexPath: IndexPath) -> Int?
//    func showTitlePageForCell(at indexPath: IndexPath)
}

//MARK: - BookmarksViewModelProtocol

class BookmarksViewModel: BookmarksViewModelProtocol {

    
    
    //MARK: Properties
    
    var numberOfTitles: Int {
        titles.count
    }
    
    var viewModelDidChange: ((BookmarksViewModelProtocol) -> Void)?
    
    private var titles: [MovieStorageModel] = []
    private let storageManager = StorageManager()



    func fetchTitles(completion: @escaping () -> Void) {
        storageManager.fetchData { [weak self] storedTitles in
            guard
                let strongSelf = self,
                let titles = storedTitles
            else { return }
            strongSelf.titles = titles
            strongSelf.viewModelDidChange?(strongSelf)
            completion()
        }
    }
    
    func deleteBookmark(at indexPath: IndexPath, completion: @escaping () -> Void) {
        storageManager.delete(titles[indexPath.row])
        titles.remove(at: indexPath.row)
        viewModelDidChange?(self)
        completion()
    }
    
    func deleteAllBookmarks(completion: @escaping () -> Void) {
        storageManager.deleteAll()
        titles = []
        viewModelDidChange?(self)
        completion()
    }
    
//    func viewModelForCell(at indexPath: IndexPath) -> BookmarkCellViewModelProtocol {
//        let viewModel = BookmarkCellViewModel(title: titles[indexPath.row])
//        return viewModel
//    }
//
    func idForTitle(at indexPath: IndexPath) -> Int? {
        Int(titles[indexPath.row].id)
    }
    
//    func showTitlePageForCell(at indexPath: IndexPath) {
//        let selectedTitle = titles[indexPath.row]
//        router.present(module: .titlePage, animated: true, context: TMDBTitle(titleStorageModel: selectedTitle), completion: nil)
//    }
}
