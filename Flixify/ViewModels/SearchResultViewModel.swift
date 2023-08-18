//
//  SearchViewModel.swift
//  Flixify
//
//  Created by Pranav Choudhary on 18/08/23.
//

import Foundation
protocol SearchResultViewModelInterface {
    var view : SearchResultInterface? {get set}
    func viewDidLoad()
}

final class SearchResultViewModel {
    
    weak var view: SearchResultInterface?
    var movies : [Movie] = []
    var page: Int = 1
    var query: String = ""
    public static var shared = SearchResultViewModel()
}

extension SearchResultViewModel: SearchResultViewModelInterface {

    func viewDidLoad() {
        view?.configureVC()
        view?.configureCollectionView()
    }

    func getMovies(with query: String) {
        let searchQuery = "query=\(query)&include_adult=false&language=en-US&page=\(self.page)"
        self.query = query

        ApiCaller.shared.fetchData(from: Constants.SEARCH_MOVIE,with: searchQuery) { (result: Result<TrendingMovieResponse, Error>) in
                DispatchQueue.main.async {
                    
                    switch result {
                    case .success(let response):

                        self.movies.append(contentsOf: response.results)
                        self.view?.reloadCollectionView()
                        self.page += 1
                    case .failure(let error):
                        print(error)
                    }
                    
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

    
}
