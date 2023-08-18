//
//  UpcomingViewController.swift
//  Flixify
//
//  Created by Pranav Choudhary on 04/07/23.
//

import UIKit

protocol UpcomingInterface: AnyObject {
    func configureVC()
    func configureCollectionView()
    func reloadCollectionView()
    func didTapItem(with viewModel: MoviePreviewViewModel)
    func showToast(message msg: String)
    func reloadCollectionViewRows(at indexPaths: [IndexPath])
}



class UpcomingViewController: UIViewController {
    
    private var upComingMovies: [Movie] = []
    private var toTop:Bool = false
    private var newOffset :CGFloat = CGFloat()
    private var currentOffset : CGFloat =  CGFloat()
    private let actionsBuilder = MovieCellActionsBuilder()
    public var viewModel = UpcomingViewModel.shared
    private let upcomingTable: UITableView = {
        let table  = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.IDENTIFIER)
        table.separatorColor = .clear
        table.backgroundColor = .clear
        table.estimatedRowHeight = 600
        table.rowHeight = UITableView.automaticDimension
        return table
    }()
    
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
        
        
    }

    override func viewDidLayoutSubviews() {
        view.setGradientBackground()
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
        navigationController?.navigationBar.isHidden = false
    
    }

    

}

extension UpcomingViewController : UITableViewDelegate, UITableViewDataSource{

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.upcomingMovies.count
    }
    
  
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
           return 400
       }

       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 400
       }
    
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.IDENTIFIER, for: indexPath) as? MovieTableViewCell else{
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.configure(with: self.viewModel.upcomingMovies[indexPath.row])

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
              viewModel.getUpcomingMovies()
          }

      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.getData(with: self.viewModel.upcomingMovies[indexPath.row])
    }
 
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            return UIMenu(title: "", children: self.viewModel.setupActionsForCell(at: indexPath))
        }
          return config
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let bookmark = self.viewModel.bookmarkAction(indexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [bookmark])
    }
    
    
    func bookmarkAction(indexPath: IndexPath) -> UIContextualAction {
//        if Storage.shared.isTitleInStorage(title: self.viewModel.upcomingMovies[indexPath.row] ) {
//            let action = UIContextualAction(style: .destructive, title: "Remove bookmark") { [weak self] _, _, completion in
//
//                Storage.shared.deleteBookmark(title: (self?.viewModel.upcomingMovies[indexPath.row])!)
////                self.view?.showToast(message: "Bookmark removed")
//            }
//            action.image = UIImage(systemName: "bookmark.slash")
//            return action
//
//        } else {
//            let action = UIContextualAction(style: .normal, title: "Add bookmark") { [weak self] _, _, completion in
//                Storage.shared.addBookmarkForTitle(title: (self?.viewModel.upcomingMovies[indexPath.row])!)
////                self.view?.showToast(message: "Bookmark added")
//
//            }
//            action.image = UIImage(systemName: "bookmark")
//            return action
//        }
        let action = UIContextualAction(style: .normal, title: "Add bookmark") { [weak self] _, _, completion in
            Storage.shared.addBookmarkForTitle(title: (self?.viewModel.upcomingMovies[indexPath.row])!)
//                self.view?.showToast(message: "Bookmark added")
            self?.showToast(message: "Bookmark added")
            self?.upcomingTable.reloadRows(at: [indexPath], with: .fade)
        }
        action.image = UIImage(systemName: "bookmark")
        return action
       
    }

    
    
}





extension UpcomingViewController: UpcomingInterface {
    func showToast(message msg: String) {
        Toast.show(message: msg, controller: self)
    }

    func didTapItem(with viewModel: MoviePreviewViewModel) {
        let vc = MovieViewController()
        vc.configure(with: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func reloadCollectionView() {
        upcomingTable.reloadOnMainThread()
        

    }
    
    func reloadCollectionViewRows(at indexPaths: [IndexPath]){

            self.upcomingTable.reloadRows(at: indexPaths, with: .automatic)
        
    }
    


    func configureVC() {
        view.backgroundColor = .black
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }

    func configureCollectionView() {
        view.addSubview(upcomingTable)
        upcomingTable.dataSource = self
        upcomingTable.delegate = self
        self.viewModel.getUpcomingMovies()
    }


}

