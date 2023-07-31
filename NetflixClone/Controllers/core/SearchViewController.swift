//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 04/07/23.
//

import UIKit

class SearchViewController: UIViewController {

    
    
//https://api.themoviedb.org/3/discover/movie?include_adult=true&include_video=true&language=en-US&page=1&sort_by=popularity.desc
    
    private var topSearchMovies: [Movie] = []
    private var toTop:Bool = false
    private var newOffset :CGFloat = CGFloat()
    private var currentOffset : CGFloat =  CGFloat()
    
    private let topSearchTable: UITableView = {
        let table  = UITableView(frame: CGRect(), style: .grouped)
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.IDENTIFIER)
        table.separatorColor = .clear
        table.backgroundColor = .clear
        table.estimatedRowHeight = 600
        table.rowHeight = UITableView.automaticDimension 
        return table
    }()
    
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search For a movie"
        controller.searchBar.searchBarStyle = .minimal
        return controller
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
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(topSearchTable)
        topSearchTable.dataSource = self
        topSearchTable.delegate = self
        
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        
        getTopSearchMovies()
        
        
        navigationItem.searchController?.searchResultsUpdater = self
        
       
        
        
        
    }

    override func viewDidLayoutSubviews() {
        setGradientBackground()
        super.viewDidLayoutSubviews()
        topSearchTable.frame = view.bounds
        
        
        
    }
    
    private func getTopSearchMovies(){
        ApiCaller.shared.fetchData(from: Constants.DICOVER_MOVIES, with: "&include_adult=true&include_video=true&language=en-US&page=1&sort_by=popularity.desc") { (result: Result<TrendingMovieResponse, Error>) in
               switch result {
               case .success(let response):
                   self.topSearchMovies = response.results
                   DispatchQueue.main.async {
                       self.topSearchTable.reloadData()
                   }
//                   self.topSearchTable.reloadData()
//                   self.topSearchTable.scrollToBottom()
//                   self.topSearchTable.scrollToTop()
               case .failure(let error):
                   print(error)
               }
           }
    }
    
    
    
    
    
    
    
    private func getSearchedMovies(with query: String, controller searchResultController : SearchResultViewController){
        
        let searchQuery = "query=\(query)&include_adult=true&language=en-US&page=1"
        
        
        ApiCaller.shared.fetchData(from: Constants.SEARCH_MOVIE,with: searchQuery) { (result: Result<TrendingMovieResponse, Error>) in
                DispatchQueue.main.async {
                    
                    switch result {
                    case .success(let response):

                        searchResultController.movies = response.results
                        searchResultController.searcResultCollectionView.reloadData()
                    case .failure(let error):
                        print(error)
                    }
                    
                }

           }
    }


}


extension SearchViewController  : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topSearchMovies.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 420
//    }
    


    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
           return 600
       }
//
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableView.automaticDimension 
       }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.IDENTIFIER, for: indexPath) as? MovieTableViewCell else{
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.configure(with: self.topSearchMovies[indexPath.row])
        return cell
    }
    
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        // instead of return perhaps should do a simpler animation
//        if !tableView.isDragging || indexPath.row == self.topSearchMovies.count { return }
//        
//
//        
//        
//        if toTop {
//            cell.contentView.transform = CGAffineTransformMakeTranslation(0, -80)
//            
//        } else {
//            cell.contentView.transform = CGAffineTransformMakeTranslation(0, 80)
//            
//        }
//        
//        UIView.animate(withDuration: 1.0, delay: 0.05 , usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
//            cell.contentView.transform = CGAffineTransformMakeTranslation(0, 0)
//        }, completion: nil)
//        
//    }
    
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
    
    
 
}


extension SearchViewController :  UISearchResultsUpdating{
//    UISearchResultsUpdating,
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        var searchWorkItem: DispatchWorkItem?
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultViewController else{
            return
        }
        
 
        // Cancel any ongoing search work item if user is still typing
        searchWorkItem?.cancel()


        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else{
            return
        }
            

        // Delay the search to avoid rapid updates while typing
       let newWorkItem = DispatchWorkItem { [weak self] in
           self?.getSearchedMovies(with: encodedQuery,controller: resultsController)
       }

       searchWorkItem = newWorkItem
       DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: newWorkItem)


    }
    
    
    
    
    
    

    
    
}
