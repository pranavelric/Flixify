//
//  SearchResiltViewController.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 24/07/23.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultViewControllerDidTapItem(_ viewModel: MoviePreviewViewModel)
}

class SearchResultViewController: UIViewController {

    
//    private let genreLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 12, weight: .medium)
//        label.textColor = .white
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.backgroundColor = .red
//        return label
//    }()
    
    public var movies : [Movie] = []
    private let actionsBuilder = MovieCellActionsBuilder.shared
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    public let searcResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/4 - 10 , height: 150)
        layout.minimumInteritemSpacing = .zero
        let collectionView  = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(searcResultCollectionView)
//        view.addSubview(genreLabel)
//
//        genreLabel.text = "test"
//        genreLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
//        genreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        genreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        searcResultCollectionView.delegate = self
        searcResultCollectionView.dataSource = self
        
    }
    

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searcResultCollectionView.frame = view.bounds
        navigationController?.navigationBar.isHidden = false
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func getData(with movie: Movie?){
        //        getMovieDetail(with:title.id,youtubeView: nil)
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
        //    https://api.themoviedb.org/3/movie/12
        ApiCaller.shared.fetchData(from: Constants.MOVIE_DETAILS+"\(movieId)"){
            (result: Result<MovieDetail, Error>) in
            switch result {
            case .success(let response):
                let viewModel = MoviePreviewViewModel( movieDetail: response, youtubeView: videoNames, movie: movie )
                DispatchQueue.main.async { [weak self] in
//                    let vc = MovieViewController()
//                    vc.configure(with: viewModel)
////                    vc.modalPresentationStyle = .formSheet
////                    self?.present(vc, animated: true)
//                    self?.navigationController?.pushViewController(vc, animated: true)
                    self?.delegate?.searchResultViewControllerDidTapItem(viewModel)
                }
            case .failure(let error):
                print(error)
            }
        }
 
    }
    
    private func setupActionsForCell(at indexPath: IndexPath) -> [UIAction] {
        let bookmarksAction = setupBookmarksAction(indexPath)
        let learnMoreAction = setupLearnMoreAction(indexPath)
        return [bookmarksAction, learnMoreAction]
    }
    
    private func setupLearnMoreAction(_ indexPath: IndexPath) -> UIAction {
        return actionsBuilder.createLearnMoreAction {
           print("learn more")
        }
    }
    private func setupBookmarksAction(_ indexPath: IndexPath) -> UIAction {
        if Storage.shared.isTitleInStorage(title: movies[indexPath.row] ) {
            return actionsBuilder.createDeleteAction {
//                Storage.deleteBookmark(title : titles[indexPath.row])
                Storage.shared.deleteBookmark(title: self.movies[indexPath.row])
                Toast.show(message: "Bookmark removed", controller: self)
            }
        } else {
            return actionsBuilder.createAddToBookmarksAction {
                Storage.shared.addBookmarkForTitle(title: self.movies[indexPath.row])
                Toast.show(message: "Bookmark added", controller: self)
                
            }
        }
    }
    
    
    

}


extension SearchResultViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else{
           return UICollectionViewCell()
        }
        
        let posterPath = self.movies[indexPath.row].poster_path ?? ""
        cell.configure(with: posterPath)
        cell.backgroundColor = .darkGray
        cell.layer.cornerRadius = 8
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.getData(with: self.movies[indexPath.row])
        collectionView.deselectItem(at: indexPath, animated: true)
       
    }

//    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
//        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
//            return UIMenu(title: "", children: self.setupActionsForCell(at: indexPath))
//        }
//          return config
//    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            return UIMenu(title: "", children: self.setupActionsForCell(at: indexPath))
        }
          return config
    }
 
//    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
//            return UIMenu(title: "", children: self.setupActionsForCell(at: indexPath))
//        }
//          return config
//    }





    
    

}
