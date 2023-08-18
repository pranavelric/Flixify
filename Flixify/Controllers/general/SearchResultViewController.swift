//
//  SearchResiltViewController.swift
//  Flixify
//
//  Created by Pranav Choudhary on 24/07/23.
//

import UIKit

protocol SearchResultInterface: AnyObject {

    func configureVC()
    func configureCollectionView()
    func reloadCollectionView()
    func didTapItem(with viewModel: MoviePreviewViewModel)
    
}



protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultViewControllerDidTapItem(_ viewModel: MoviePreviewViewModel)
}

class SearchResultViewController: UIViewController {

    
//    public var movies : [Movie] = []
    private let actionsBuilder = MovieCellActionsBuilder.shared
    public weak var delegate: SearchResultsViewControllerDelegate?
    public var viewModel = SearchResultViewModel.shared
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
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searcResultCollectionView.frame = view.bounds
        navigationController?.navigationBar.isHidden = false
    }
    

    
    private func setupActionsForCell(at indexPath: IndexPath) -> [UIAction] {
        let bookmarksAction = setupBookmarksAction(indexPath)
        let learnMoreAction = setupLearnMoreAction(indexPath)
        return [bookmarksAction, learnMoreAction]
    }

    private func setupLearnMoreAction(_ indexPath: IndexPath) -> UIAction {
        return actionsBuilder.createLearnMoreAction {
            self.viewModel.getData(with: self.viewModel.movies[indexPath.row])
        }
    }
    private func setupBookmarksAction(_ indexPath: IndexPath) -> UIAction {
        if Storage.shared.isTitleInStorage(title: self.viewModel.movies[indexPath.row] ) {
            return actionsBuilder.createDeleteAction {
                Storage.shared.deleteBookmark(title: self.viewModel.movies[indexPath.row])
                Toast.show(message: "Bookmark removed", controller: self)
            }
        } else {
            return actionsBuilder.createAddToBookmarksAction {
                Storage.shared.addBookmarkForTitle(title: self.viewModel.movies[indexPath.row])
                Toast.show(message: "Bookmark added", controller: self)

            }
        }
    }
 

}


extension SearchResultViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else{
           return UICollectionViewCell()
        }
        let posterPath = viewModel.movies[indexPath.row].poster_path ?? ""
        cell.configure(with: posterPath)
        cell.backgroundColor = .darkGray
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.getData(with: viewModel.movies[indexPath.row])
        collectionView.deselectItem(at: indexPath, animated: true)
       
    }

    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            return UIMenu(title: "", children: self.setupActionsForCell(at: indexPath))
        }
          return config
    }


    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

          let offsetY = scrollView.contentOffset.y
          let contentHeight = scrollView.contentSize.height
          let height = scrollView.frame.size.height

          if offsetY >= contentHeight - (2 * height) {
              viewModel.getMovies(with: viewModel.query)
          }

      }

}




extension SearchResultViewController: SearchResultInterface {
    func didTapItem(with viewModel: MoviePreviewViewModel) {
        self.delegate?.searchResultViewControllerDidTapItem(viewModel)
    }
    
    func reloadCollectionView() {
        searcResultCollectionView.reloadOnMainThread()
    }

    
    func configureVC() {
        view.backgroundColor = .systemBackground
    }

    func configureCollectionView() {

        view.addSubview(searcResultCollectionView)
        searcResultCollectionView.delegate = self
        searcResultCollectionView.dataSource = self
    }


}
