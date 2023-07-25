//
//  SearchResiltViewController.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 24/07/23.
//

import UIKit

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
    



    
    

}
