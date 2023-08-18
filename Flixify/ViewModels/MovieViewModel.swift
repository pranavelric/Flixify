//
//  MovieViewModel.swift
//  Flixify
//
//  Created by Pranav Choudhary on 18/08/23.
//

import Foundation
import UIKit
protocol MovieViewModelInterface {
    var view : MovieInterface? {get set}
    func viewDidLoad()
}

final class MovieViewModel {
    
    weak var view: MovieInterface?
    var movies : [Movie] = []
    var headerMovieImage: [Movie?] = []
    var page: Int = 1
    var query: String = ""
    public static var shared = MovieViewModel()
    private let actionsBuilder = MovieCellActionsBuilder.shared
}

extension MovieViewModel: MovieViewModelInterface {

    func viewDidLoad() {
        view?.configureVC()
        view?.configureCollectionView()
    }
    
//
//    func getUpcomingMovies(){
//        ApiCaller.shared.fetchData(from: Constants.UPCOMING_MOVIES, with: "&include_adult=false&include_video=true&language=en-US&page=\(page)&sort_by=popularity.desc") { (result: Result<TrendingMovieResponse, Error>) in
//               switch result {
//               case .success(let response):
//                   self.upcomingMovies.append(contentsOf: response.results)
//                   self.view?.reloadCollectionView()
//                   self.page += 1
//               case .failure(let error):
//                   print(error)
//               }
//           }
//    }
    
    
    func getTrendingMovies(with cell:CollectionViewTableViewCell){
        ApiCaller.shared.fetchData(from: Constants.TRENDING_MOVIES) { (result: Result<TrendingMovieResponse, Error>) in
               switch result {
               case .success(let response):
                   self.headerMovieImage.append(response.results.randomElement())
                   let movie = self.headerMovieImage.randomElement()!
                   let url = movie?.poster_path ?? movie?.backdrop_path ?? ""
                   self.view?.configureHeaderView(imageUrl: url,currentMovie: movie)
                   self.view?.configureCell(with: cell,results: response.results)
                  
               case .failure(let error):
                   print(error)
               }
           }
    }

    
    func getTopRatedMovies(with cell:CollectionViewTableViewCell){
        ApiCaller.shared.fetchData(from: Constants.TOP_RATED_MOVIES) { (result: Result<TrendingMovieResponse, Error>) in
               switch result {
               case .success(let response):
                   self.headerMovieImage.append(response.results.randomElement())
                   self.view?.configureCell(with: cell,results: response.results)
               case .failure(let error):
                   print(error)
               }
           }
    }
    
    func getUpComingMovies(with cell:CollectionViewTableViewCell){
        ApiCaller.shared.fetchData(from: Constants.UPCOMING_MOVIES) { (result: Result<TrendingMovieResponse, Error>) in
               switch result {
               case .success(let response):
                   self.headerMovieImage.append(response.results.randomElement())
                   
                   self.view?.configureCell(with: cell,results: response.results)
               case .failure(let error):
                   print(error)
               }
           }
    }
    
    func getPopularMovies(with cell:CollectionViewTableViewCell){
        ApiCaller.shared.fetchData(from: Constants.POPULAR_MOVIES) { (result: Result<TrendingMovieResponse, Error>) in
               switch result {
               case .success(let response):
                   self.headerMovieImage.append(response.results.randomElement())
                   self.view?.configureCell(with: cell,results: response.results)
               case .failure(let error):
                   print(error)
               }
           }
    }
    func getNowPlayingMovies(with cell:CollectionViewTableViewCell){
        ApiCaller.shared.fetchData(from: Constants.POPULAR_MOVIES) { (result: Result<TrendingMovieResponse, Error>) in
               switch result {
               case .success(let response):
                   self.headerMovieImage.append(response.results.randomElement())
                   self.view?.configureCell(with: cell,results: response.results)
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
    
    
    
//   func setupActionsForCell(at indexPath: IndexPath) -> [UIAction] {
//        let bookmarksAction = setupBookmarksAction(indexPath)
//        let learnMoreAction = setupLearnMoreAction(indexPath)
//        return [bookmarksAction, learnMoreAction]
//    }
//    
//    private func setupLearnMoreAction(_ indexPath: IndexPath) -> UIAction {
//        return actionsBuilder.createLearnMoreAction {
//            self.getData(with: self.upcomingMovies[indexPath.row])
//        }
//    }
//    private func setupBookmarksAction(_ indexPath: IndexPath) -> UIAction {
//        if Storage.shared.isTitleInStorage(title: self.upcomingMovies[indexPath.row] ) {
//            return actionsBuilder.createDeleteAction {
//                Storage.shared.deleteBookmark(title: self.upcomingMovies[indexPath.row])
//                self.view?.showToast(message: "Bookmark removed")
//                
//               
//            }
//        } else {
//            return actionsBuilder.createAddToBookmarksAction {
//                Storage.shared.addBookmarkForTitle(title: self.upcomingMovies[indexPath.row])
//                self.view?.showToast(message: "Bookmark added")
//                
//            }
//        }
//    }
//    
//    func bookmarkAction(indexPath: IndexPath) -> UIContextualAction {
//        if Storage.shared.isTitleInStorage(title: self.upcomingMovies[indexPath.row] ) {
//            let action = UIContextualAction(style: .destructive, title: "Remove bookmark") { [weak self] _, _, completion in
//                Storage.shared.deleteBookmark(title: self!.upcomingMovies[indexPath.row])
//                self?.view?.showToast(message: "Bookmark removed")
//                self?.view?.reloadCollectionViewRows(at: [indexPath])
//            }
//            action.image = UIImage(systemName: "bookmark.slash")
//            return action
//            
//        } else {
//            let action = UIContextualAction(style: .normal, title: "Add bookmark") { [weak self] _, _, completion in
//                Storage.shared.addBookmarkForTitle(title: self!.upcomingMovies[indexPath.row])
//                self?.view?.showToast(message: "Bookmark added")
//                self?.view?.reloadCollectionViewRows(at: [indexPath])
//            }
//            action.image = UIImage(systemName: "bookmark")
//            return action
//        }
//        
//       
//    }

    
}
