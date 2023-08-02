//
//  CollectionVIewTableViewCell.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 04/07/23.
//

import UIKit

protocol CollectionViewTableViewCellDelegate :AnyObject{
    func collectionViewTableViewCellDidTapCell(_cell: CollectionViewTableViewCell, viewModel: MoviePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    weak var delegate: (CollectionViewTableViewCellDelegate)?
    private var titles:[Movie] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 180)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .red
        contentView.addSubview(collectionView)
        
       
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with titles: [Movie]){
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    
}


extension CollectionViewTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else{
            return UICollectionViewCell()
        }
        guard let posterPath = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        cell.configure(with: posterPath)
        cell.contentView.layer.cornerRadius = 10 // Set the desired corner radius value
        cell.contentView.layer.masksToBounds = true // Ensure the cell's content stays within rounded corners
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.title else {
            return
        }
//        getMovieDetail(with:title.id,youtubeView: nil)
        ApiCaller.shared.getMoviesFromYoutube(with: titleName + "trailer"){

            [weak self] (result: Result<YouTubeSearchListResponse, Error>) in
            switch result {
            case .success(let response):

                let videoNames = response.items
                let title = self?.titles[indexPath.row]
                guard let id = title?.id else{
                    return
                }
                guard let titleOverview = title?.overview else{
                    return
                }

                guard let strongSelf = self else {
                    return
                }

                // here after fetching video , fetch details
                self?.getMovieDetail(with:id,youtubeView: videoNames)

                //                       let viewModel = MoviePreviewViewModel(title: titleName , youtubeView: videoNames, titleOverview: titleOverview)
                //                       self?.delegate?.collectionViewTableViewCellDidTapCell(_cell: strongSelf, viewModel: viewModel)


            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    
    
    func getMovieDetail(with movieId: Int,youtubeView videoNames: [YouTubeVideoItem]? ) {
        //    https://api.themoviedb.org/3/movie/12
        ApiCaller.shared.fetchData(from: Constants.MOVIE_DETAILS+"\(movieId)"){
            (result: Result<MovieDetail, Error>) in
            switch result {
            case .success(let response):
                let viewModel = MoviePreviewViewModel( movieDetail: response, youtubeView: videoNames)
                self.delegate?.collectionViewTableViewCellDidTapCell(_cell: self, viewModel: viewModel)
            case .failure(let error):
                print(error)
            }
        }
 
    }
    
}
