//
//  SearchViewModel.swift
//  Flixify
//
//  Created by Pranav Choudhary on 18/08/23.
//

import Foundation
import UIKit
protocol SearchViewModelInterface {
    var view : SearchInterface? {get set}
    func viewDidLoad()
}

final class SearchViewModel {
    
    weak var view: SearchInterface?
    var topSearchMovies : [Movie] = []
    var page: Int = 1
    var query: String = ""
    public static var shared = SearchViewModel()
    private let actionsBuilder = MovieCellActionsBuilder.shared
}

extension SearchViewModel: SearchViewModelInterface {

    func viewDidLoad() {
        view?.configureVC()
        view?.configureCollectionView()
    }
    
    
    func getTopSearchMovies(){
        ApiCaller.shared.fetchData(from: Constants.DICOVER_MOVIES, with: "&include_adult=false&include_video=true&language=en-US&page=\(page)&sort_by=popularity.desc") { (result: Result<TrendingMovieResponse, Error>) in
               switch result {
               case .success(let response):
                   self.topSearchMovies.append(contentsOf: response.results)
                   self.view?.reloadCollectionView()
                   self.page += 1
//                   self.topSearchTable.reloadData()
//                   self.topSearchTable.scrollToBottom()
//                   self.topSearchTable.scrollToTop()
               case .failure(let error):
                   print(error)
               }
           }
    }
    
    func getData(with movie: Movie?){
        ApiCaller.shared.getMoviesFromYoutube(with: movie?.title ?? (movie?.original_title ?? "" ) + "trailer"){

                    [weak self] (result: Result<YouTubeSearchListResponse, Error>) in
                    switch result {
                    case .success(let response):

                        let videoNames = response.items
                        
                        guard let id = movie?.id else{
                            return
                        }
                   
                        
                        self?.getMovieDetail(with:id,youtubeView: videoNames, movie: movie)


                    case .failure(let error):
                        print(error)
                    }
                }
    }
    
    
    func getMovieDetail(with movieId: Int,youtubeView videoNames: [YouTubeVideoItem]?, movie: Movie? ) {
        ApiCaller.shared.fetchData(from: Constants.MOVIE_DETAILS+"\(movieId)"){
            (result: Result<MovieDetail, Error>) in
            switch result {
            case .success(let response):
                let viewModel = MoviePreviewViewModel( movieDetail: response, youtubeView: videoNames, movie: movie )
                DispatchQueue.main.async { [weak self] in
                    self?.view?.didTapItem(with: viewModel)
                }
            case .failure(let error):
                print(error)
            }
        }
 
    }
    
    
    
   func setupActionsForCell(at indexPath: IndexPath) -> [UIAction] {
        let bookmarksAction = setupBookmarksAction(indexPath)
        let learnMoreAction = setupLearnMoreAction(indexPath)
        return [bookmarksAction, learnMoreAction]
    }
    
    private func setupLearnMoreAction(_ indexPath: IndexPath) -> UIAction {
        return actionsBuilder.createLearnMoreAction {
            self.getData(with: self.topSearchMovies[indexPath.row])
        }
    }
    private func setupBookmarksAction(_ indexPath: IndexPath) -> UIAction {
        if Storage.shared.isTitleInStorage(title: self.topSearchMovies[indexPath.row] ) {
            return actionsBuilder.createDeleteAction {
                Storage.shared.deleteBookmark(title: self.topSearchMovies[indexPath.row])
                self.view?.showToast(message: "Bookmark removed")
               
            }
        } else {
            return actionsBuilder.createAddToBookmarksAction {
                Storage.shared.addBookmarkForTitle(title: self.topSearchMovies[indexPath.row])
                self.view?.showToast(message: "Bookmark added")
            }
        }
    }

    
    func bookmarkAction(indexPath: IndexPath) -> UIContextualAction {
        if Storage.shared.isTitleInStorage(title: self.topSearchMovies[indexPath.row] ) {
            let action = UIContextualAction(style: .destructive, title: "Remove bookmark") { [weak self] _, _, completion in
                Storage.shared.deleteBookmark(title: (self?.topSearchMovies[indexPath.row])!)
                self?.view?.showToast(message: "Bookmark removed")
                self?.view?.reloadCollectionViewRows(at: [indexPath])
            }
            action.image = UIImage(systemName: "bookmark.slash")
            return action
            
        } else {
            let action = UIContextualAction(style: .normal, title: "Add bookmark") { [weak self] _, _, completion in
                Storage.shared.addBookmarkForTitle(title: self!.topSearchMovies[indexPath.row])
                self?.view?.showToast(message: "Bookmark added")
                self?.view?.reloadCollectionViewRows(at: [indexPath])
            }
            action.image = UIImage(systemName: "bookmark")
            return action
        }
        
       
    }
    
}
