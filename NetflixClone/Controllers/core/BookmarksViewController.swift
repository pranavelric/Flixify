//
//  DownloadsViewController.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 04/07/23.
//

import UIKit

class BookmarksViewController: UIViewController {

   
  
    
    private lazy var deleteAllButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "Delete all",
            style: .plain,
            target: self,
            action: #selector(deleteAllAction(_:))
        )
        button.tintColor = .systemRed
        return button
    }()
    
    
    private let storageManager = StorageManager.shared
    private var bookmarkedMovies: [MovieStorageModel] = []
    private var toTop:Bool = false
    private var newOffset :CGFloat = CGFloat()
    private var currentOffset : CGFloat =  CGFloat()
    private let actionsBuilder = MovieCellActionsBuilder()
    private let bookmarkTable: UITableView = {
        let table  = UITableView()
        table.register(BookmarkMovieCell.self, forCellReuseIdentifier: BookmarkMovieCell.IDENTIFIER)
        table.separatorColor = .clear
        table.backgroundColor = .clear
        table.estimatedRowHeight = 600
        table.rowHeight = UITableView.automaticDimension
        return table
    }()
    
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 0.60, green: 0.21, blue: 0.08, alpha: 0.2).cgColor
        let colorBetween = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00).cgColor
        let colorBottom = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00).cgColor
             
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBetween , colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 450)
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Bookmarks"

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(bookmarkTable)
        bookmarkTable.dataSource = self
        bookmarkTable.delegate = self

        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getBookmarkedMovies()
    }
    
    @objc private func deleteAllAction(_ sender: UIBarButtonItem) {
        guard sender == deleteAllButton else { return }
        showDeleteAllAlert()
    }

    private func getBookmarkedMovies(){
        
        storageManager.fetchData { [weak self] storedTitles in
            guard
                let strongSelf = self,
                let titles = storedTitles
            else { return }
            strongSelf.bookmarkedMovies = titles
            DispatchQueue.main.async {
                self?.bookmarkTable.reloadData()
            }
            
        }
        
    }
    override func viewDidLayoutSubviews() {
        setGradientBackground()
        super.viewDidLayoutSubviews()
        bookmarkTable.frame = view.bounds
        navigationController?.navigationBar.isHidden = false
    
    }
    
    private func setEnablingToDeleteAllButton() {
        deleteAllButton.isEnabled = bookmarkedMovies.count > 0
    }
    
    
    func deleteBookmark(at indexPath: IndexPath) {
        do {
            storageManager.delete(bookmarkedMovies[indexPath.row])
            bookmarkedMovies.remove(at: indexPath.row)
            DispatchQueue.main.async {
                self.bookmarkTable.reloadData()
            }
        }
        catch{
            print("Index out of range")
        }
        
        // view model changed
    }
    
    private func showDeleteAllAlert() {
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
        
        present(alert, animated: true)
    }
    
    private func deleteAllBookmarks() {
        storageManager.deleteAll()
        bookmarkedMovies = []
        DispatchQueue.main.async {
            self.bookmarkTable.reloadData()
        }
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
    
    
    func getMovieDetail(with movieId: Int,youtubeView videoNames: [YouTubeVideoItem]?, movie: MovieStorageModel? ) {
        //    https://api.themoviedb.org/3/movie/12
        ApiCaller.shared.fetchData(from: Constants.MOVIE_DETAILS+"\(movieId)"){
            (result: Result<MovieDetail, Error>) in
            switch result {
            case .success(let response):
                let movie = Movie(id: response.id!, adult: response.adult ?? false, popularity: response.popularity ?? 0, vote_count: response.voteCount ?? 0, poster_path: response.posterPath ?? "", backdrop_path: response.backdropPath ?? "", original_language: response.originalLanguage ?? "" , original_title: response.originalTitle ?? "", genre_ids: [1], title: response.title ?? "", vote_average: response.voteAverage ?? 0, overview: response.overview, release_date: response.releaseDate ?? "", media_type: "", video: false)
                let viewModel = MoviePreviewViewModel( movieDetail: response, youtubeView: videoNames, movie: movie )
                DispatchQueue.main.async { [weak self] in
                    let vc = MovieViewController()
                    vc.configure(with: viewModel)
//                    vc.modalPresentationStyle = .formSheet
//                    self?.present(vc, animated: true)
                    self?.navigationController?.pushViewController(vc, animated: true)
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
       
        return actionsBuilder.createDeleteAction {
            self.deleteBookmark(at: indexPath)
            Toast.show(message: "Bookmark removed", controller: self)
        }
       
      
    }
    
    
    

}




extension BookmarksViewController : UITableViewDelegate, UITableViewDataSource{

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookmarkedMovies.count
    }
    
  
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
           return 400
       }

       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 400
       }
    
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkMovieCell.IDENTIFIER, for: indexPath) as? BookmarkMovieCell else{
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        let movie = self.bookmarkedMovies[indexPath.row]

        cell.configure(movieImageUrl: movie.backdropPath ?? movie.posterPath, releaseDate: movie.releaseDate ?? "", title: movie.title ?? movie.originalTitle, genre_ids: movie.genre_ids, overview: movie.overview)

        return cell
    }
        
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        currentOffset = scrollView.contentOffset.y
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newOffset = scrollView.contentOffset.y

        if newOffset > currentOffset {
            toTop = false
        } else {
            toTop = true
        }
        currentOffset = newOffset
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let movie =  self.bookmarkedMovies[indexPath.row]
        self.getData(with: self.bookmarkedMovies[indexPath.row])
    }
 
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            return UIMenu(title: "", children: self.setupActionsForCell(at: indexPath))
        }
          return config
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(indexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    private func deleteAction(indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "") { [weak self] _, _, completion in
            self?.deleteBookmark(at: indexPath)
            
        }
        action.image = UIImage(systemName: "trash")
        return action
    }
    
    
}
