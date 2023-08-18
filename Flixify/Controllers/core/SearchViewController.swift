//
//  SearchViewController.swift
//  Flixify
//
//  Created by Pranav Choudhary on 04/07/23.
//

import UIKit


protocol SearchInterface: AnyObject {
    func configureVC()
    func configureCollectionView()
    func reloadCollectionView()
    func didTapItem(with viewModel: MoviePreviewViewModel)
    func showToast(message msg: String)
}




class SearchViewController: UIViewController {

    

    
//    private var topSearchMovies: [Movie] = []
    private var toTop:Bool = false
    private var newOffset :CGFloat = CGFloat()
    private var currentOffset : CGFloat =  CGFloat()
    
    public var viewModel = SearchViewModel.shared
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
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.view = self
        viewModel.viewDidLoad()

       
       
        
        
        
    }

    override func viewDidLayoutSubviews() {
        view.setGradientBackground()
        super.viewDidLayoutSubviews()
        topSearchTable.frame = view.bounds
        navigationController?.navigationBar.isHidden = false
    }
    

    
    
    
    private func getSearchedMovies(with query: String, controller searchResultController : SearchResultViewController){
        if (searchResultController.viewModel.query != query){
            searchResultController.viewModel.movies = []
            searchResultController.viewModel.page = 1
        }
        searchResultController.viewModel.getMovies(with: query)
    }
    
}


extension SearchViewController  : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.topSearchMovies.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
           return 400
       }
//
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 400
       }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.IDENTIFIER, for: indexPath) as? MovieTableViewCell else{
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.configure(with: self.viewModel.topSearchMovies[indexPath.row])
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
    

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

          let offsetY = scrollView.contentOffset.y
          let contentHeight = scrollView.contentSize.height
          let height = scrollView.frame.size.height

          if offsetY >= contentHeight - (2 * height) {
              viewModel.getTopSearchMovies()
          }

      }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.getData(with: self.viewModel.topSearchMovies[indexPath.row])
    }
 
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            return UIMenu(title: "", children: self.viewModel.setupActionsForCell(at: indexPath))
        }
          return config
    }


    
 
}


extension SearchViewController :  UISearchResultsUpdating, SearchResultsViewControllerDelegate{
    func searchResultViewControllerDidTapItem(_ viewModel: MoviePreviewViewModel) {
        let vc = MovieViewController()
        vc.configure(with: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
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
        
        resultsController.delegate = self
 
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





extension SearchViewController: SearchInterface {
    func showToast(message msg: String) {
        Toast.show(message: msg, controller: self)
    }
    
    func didTapItem(with viewModel: MoviePreviewViewModel) {
        let vc = MovieViewController()
        vc.configure(with: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func reloadCollectionView() {
        topSearchTable.reloadOnMainThread()

    }

    
    func configureVC() {
        view.backgroundColor = .black
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.isHidden = false
    }

    func configureCollectionView() {

        
        view.addSubview(topSearchTable)
        topSearchTable.dataSource = self
        topSearchTable.delegate = self
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        self.viewModel.getTopSearchMovies()
        navigationItem.searchController?.searchResultsUpdater = self
        
        
    }


}
