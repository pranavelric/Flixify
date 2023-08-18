//
//  BookmarkViewModel.swift
//  Flixify
//
//  Created by Pranav Choudhary on 18/08/23.
//

import Foundation
import UIKit
protocol BookmarkViewModelInterface {
    var view : BookmarkInterface? {get set}
    func viewDidLoad()
}

final class BookmarkViewModel {
    
    weak var view: BookmarkInterface?
    var bookmarkedMovies : [MovieStorageModel] = []
    var page: Int = 1
    var query: String = ""
    public static var shared = BookmarkViewModel()
    private let storageManager = StorageManager.shared
    private let actionsBuilder = MovieCellActionsBuilder.shared
}

extension BookmarkViewModel: BookmarkViewModelInterface {

    func viewDidLoad() {
        view?.configureVC()
        view?.configureCollectionView()
    }
    
    
    func getBookmarkedMovies(){
        
        storageManager.fetchData { [weak self] storedTitles in
            guard
                let strongSelf = self,
                let titles = storedTitles
            else { return }
            strongSelf.bookmarkedMovies = titles
            strongSelf.view?.reloadCollectionView()
            
        }
    }
    
    func deleteBookmark(at indexPath: IndexPath) {
        do {
            storageManager.delete(bookmarkedMovies[indexPath.row])
            bookmarkedMovies.remove(at: indexPath.row)
                self.view?.enableToDeleteAllButton()
        }
        catch{
            print("Index out of range")
        }
        
        // view model changed
    }

    func getData(with movie: MovieStorageModel?){
        //        getMovieDetail(with:title.id,youtubeView: nil)
        ApiCaller.shared.getMoviesFromYoutube(with: movie?.title ?? (movie?.originalTitle ?? "" ) + "trailer"){

                    [weak self] (result: Result<YouTubeSearchListResponse, Error>) in
                    switch result {
                    case .success(let response):

                        let videoNames = response.items
                        
                        guard let id = movie?.id else{
                            return
                        }
                   
                       
                        self?.getMovieDetail(with:Int(id),youtubeView: videoNames, movie: movie)


                    case .failure(let error):
                        print(error)
                    }
                }
    }
    
    
    private func getMovieDetail(with movieId: Int,youtubeView videoNames: [YouTubeVideoItem]?, movie: MovieStorageModel? ) {
        //    https://api.themoviedb.org/3/movie/12
        ApiCaller.shared.fetchData(from: Constants.MOVIE_DETAILS+"\(movieId)"){
            (result: Result<MovieDetail, Error>) in
            switch result {
            case .success(let response):
                let movie = Movie(id: response.id!, adult: response.adult ?? false, popularity: response.popularity ?? 0, vote_count: response.voteCount ?? 0, poster_path: response.posterPath ?? "", backdrop_path: response.backdropPath ?? "", original_language: response.originalLanguage ?? "" , original_title: response.originalTitle ?? "", genre_ids: [1], title: response.title ?? "", vote_average: response.voteAverage ?? 0, overview: response.overview, release_date: response.releaseDate ?? "", media_type: "", video: false)
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
            self.getData(with: self.bookmarkedMovies[indexPath.row])
        }
    }

    private func setupBookmarksAction(_ indexPath: IndexPath) -> UIAction {
       
        return actionsBuilder.createDeleteAction {
            self.deleteBookmark(at: indexPath)
            self.view?.showToast(message: "Bookmark removed")
        }
       
      
    }
    
    
    
    func showDeleteAllAlert() {
        let alert = UIAlertController(
            title: "All your bookmarks will be removed from your list",
            message: "This action cannot be undone",
            preferredStyle: .actionSheet
        )
        
        let delete = UIAlertAction(title: "Delete bookmarks", style: .destructive) { [weak self] _ in
            self?.deleteAllBookmarks()
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        
        self.view?.deleteAllBookmarks(alert)
    }
    
    private func deleteAllBookmarks() {
        storageManager.deleteAll()
        self.bookmarkedMovies = []
        self.view?.reloadCollectionView()
    }
    
    
}
