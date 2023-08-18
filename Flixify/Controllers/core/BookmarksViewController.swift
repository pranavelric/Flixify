//
//  DownloadsViewController.swift
//  Flixify
//
//  Created by Pranav Choudhary on 04/07/23.
//

import UIKit

protocol BookmarkInterface: AnyObject {
    func configureVC()
    func configureCollectionView()
    func reloadCollectionView()
    func didTapItem(with viewModel: MoviePreviewViewModel)
    func showToast(message msg: String)
    func deleteAllBookmarks(_ alert: UIAlertController)
}


class BookmarksViewController: UIViewController {

    private let deleteAllButton:UIButton = {
        let button:UIButton =  UIButton()
        button.setTitle("Delete all", for: .normal)
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = .clear
        button.configuration?.baseForegroundColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius =  8
        
        return button
    }()
    
//    private let storageManager = StorageManager.shared
    private var toTop:Bool = false
    private var newOffset :CGFloat = CGFloat()
    private var currentOffset : CGFloat =  CGFloat()
    public var viewModel = BookmarkViewModel.shared
    private let bookmarkTable: UITableView = {
        let table  = UITableView()
        table.register(BookmarkMovieCell.self, forCellReuseIdentifier: BookmarkMovieCell.IDENTIFIER)
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.getBookmarkedMovies()
        setEnablingToDeleteAllButton()
        
    }
    
    @objc private func deleteAllAction(_ sender: UIBarButtonItem) {
        guard sender == deleteAllButton else { return }
        self.viewModel.showDeleteAllAlert()
    }

    override func viewDidLayoutSubviews() {
        view.setGradientBackground()
        super.viewDidLayoutSubviews()
        bookmarkTable.frame = view.bounds
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setEnablingToDeleteAllButton() {
        deleteAllButton.isHidden = self.viewModel.bookmarkedMovies.count <= 0
    }
    
    var deleteMovieIndexPath: IndexPath? = nil
}




extension BookmarksViewController : UITableViewDelegate, UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.bookmarkedMovies.count
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
        let movie = self.viewModel.bookmarkedMovies[indexPath.row]

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
        self.viewModel.getData(with: self.viewModel.bookmarkedMovies[indexPath.row])
    }
 
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            return UIMenu(title: "", children: self.viewModel.setupActionsForCell(at: indexPath))
        }
          return config
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
                      deleteMovieIndexPath = indexPath
            let itemToDelete = self.viewModel.bookmarkedMovies[indexPath.row]
            confirmDelete(movie: itemToDelete)
                 }
    }
    private  func confirmDelete(movie: MovieStorageModel) {
        let alert = UIAlertController(title: "Delete bookmark", message: "Are you sure you want to remove \(movie.title ?? movie.originalTitle ?? "")?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeletePlanet)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeletePlanet)

        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)

        self.present(alert, animated: true, completion: nil)
           }
    func handleDeletePlanet(alertAction: UIAlertAction!) -> Void {
            if let indexPath = deleteMovieIndexPath {
                self.bookmarkTable.beginUpdates()
                self.viewModel.deleteBookmark(at: indexPath)
                self.bookmarkTable.deleteRows(at: [indexPath], with: .automatic)
                deleteMovieIndexPath = nil
                self.bookmarkTable.endUpdates()
            }
        }
        func cancelDeletePlanet(alertAction: UIAlertAction!) {
            deleteMovieIndexPath = nil
        }

    
//    private func deleteAction(indexPath: IndexPath) -> UIContextualAction {
//        let action = UIContextualAction(style: .destructive, title: "") { [weak self] _, _, completion in
//            self?.viewModel.deleteBookmark(at: indexPath)
//
//        }
//        action.image = UIImage(systemName: "trash")
//        return action
//    }
    
    
}






extension BookmarksViewController: BookmarkInterface {
    func deleteAllBookmarks(_ alert: UIAlertController) {
        present(alert, animated: true)
    }
    
    func showToast(message msg: String) {
        Toast.show(message: msg, controller: self)
    }

    func didTapItem(with viewModel: MoviePreviewViewModel) {
        let vc = MovieViewController()
        vc.configure(with: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func reloadCollectionView() {
        setEnablingToDeleteAllButton()
    }


    func configureVC() {
        view.backgroundColor = .systemBackground
        title = "Bookmarks"

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
       
        navigationController?.navigationBar.addSubview(deleteAllButton)
        deleteAllButton.addTarget(self, action: #selector(deleteAllAction(_:)), for: .touchUpInside)
        let targetView = self.navigationController?.navigationBar
        let trailingConstraint = NSLayoutConstraint(item: deleteAllButton, attribute:
           .trailingMargin, relatedBy: .equal, toItem: targetView,
                            attribute: .trailingMargin, multiplier: 1.0, constant: -16)
        let bottomConstraint = NSLayoutConstraint(item: deleteAllButton, attribute: .bottom, relatedBy: .equal,
                                                 toItem: targetView, attribute: .bottom, multiplier: 1.0, constant: -6)
       NSLayoutConstraint.activate([trailingConstraint, bottomConstraint])
    }

    func configureCollectionView() {
        view.addSubview(bookmarkTable)
        bookmarkTable.dataSource = self
        bookmarkTable.delegate = self
    }


}
