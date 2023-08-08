//
//  HeroHeaderUIView.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 05/07/23.
//

import UIKit






class HeroHeaderUIView: UIView {
    private let storage =  Storage()
    private var currentMovie : Movie? = nil
    private var controller: UIViewController? = nil
    private let downloadButton:UIButton = {
        let button:UIButton =  UIButton()
        button.setTitle("Bookmark", for: .normal)
//        button.layer.borderColor = UIColor.white.cgColor
//        button.layer.borderWidth = 1
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = .darkGray
        button.configuration?.baseForegroundColor = .white
        button.configuration?.image = UIImage(systemName: "bookmark.fill",withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        button.configuration?.imagePadding = 2
        button.configuration?.imagePlacement = .leading
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius =  8
        return button
    }()
    
    private let playbutton : UIButton = {
        let button:UIButton = UIButton()
        button.setTitle("Play", for: .normal)
//        button.layer.borderColor = UIColor.white.cgColor
//        button.layer.borderWidth = 1
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = .white
        button.configuration?.baseForegroundColor = .black
        button.configuration?.image = UIImage(systemName: "play.fill",withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        button.configuration?.imagePlacement = .leading
        button.configuration?.imagePadding = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius =  8
        return button
    }()
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "film_poster_placeholder")
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
//        addGradient()
        addSubview(playbutton)
        addSubview(downloadButton)
        applyConstraint()     
    }
    
    func addGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        heroImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func applyConstraint(){
        
        let margin: CGFloat = 16 // Set your desired margin value here

          // Hero image constraints
          heroImageView.translatesAutoresizingMaskIntoConstraints = false
          heroImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
          heroImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin).isActive = true
          heroImageView.topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
          heroImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin).isActive = true

        
        
        let playButtonConstraints = [
            playbutton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playbutton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playbutton.widthAnchor.constraint(equalToConstant: 130)
        ]
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 130)
        ]
        downloadButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        playbutton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
         
    }
    
    public func configure(imageUrl url : String?,currentMovie: Movie?,controller: HomeViewController){
        self.controller = controller
        self.currentMovie = currentMovie
        heroImageView.sd_setImage(with: URL(string: "\(Constants.POSTER_PATH)/\(url ?? "")"), placeholderImage: UIImage(named: "film_poster_placeholder"))
        DispatchQueue.main.async {
            self.checkBookmarkButton()
        }
    }
    @objc func bookmarkButtonTapped(){
        
        
        if storage.isTitleInStorage(title: self.currentMovie! ) {
            storage.deleteBookmark(title: self.currentMovie!)
            downloadButton.configuration?.image = UIImage(systemName: "bookmark",withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
            downloadButton.configuration?.baseForegroundColor = .white
            Toast.show(message: "Bookmark removed", controller: self.controller!)
           
        } else {
            storage.addBookmarkForTitle(title: self.currentMovie!)
            downloadButton.configuration?.image = UIImage(systemName: "bookmark.fill",withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
            downloadButton.configuration?.baseForegroundColor = .systemYellow
            Toast.show(message: "Bookmark added", controller: self.controller!)
           
        }

    }
    
    func checkBookmarkButton(){
        if storage.isTitleInStorage(title: self.currentMovie! ) {
           
            downloadButton.configuration?.image = UIImage(systemName: "bookmark.fill",withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
            downloadButton.configuration?.baseForegroundColor = .systemYellow
           
        } else {
            downloadButton.configuration?.image?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(paletteColors: [.white]))
            downloadButton.configuration?.image = UIImage(systemName: "bookmark",withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
            downloadButton.configuration?.baseForegroundColor = .white
        }
    }
    
    @objc func playButtonTapped(){
        
        getData()
        
        
    }
    
    
    
    func getData(){
        //        getMovieDetail(with:title.id,youtubeView: nil)
        ApiCaller.shared.getMoviesFromYoutube(with: self.currentMovie?.title ?? (self.currentMovie?.original_title ?? "" ) + "trailer"){

                    [weak self] (result: Result<YouTubeSearchListResponse, Error>) in
                    switch result {
                    case .success(let response):

                        let videoNames = response.items
                        let title = self?.currentMovie
                        guard let id = title?.id else{
                            return
                        }
                        guard let titleOverview = title?.overview else{
                            return
                        }

                        guard let strongSelf = self else {
                            return
                        }

                        
                        self?.getMovieDetail(with:id,youtubeView: videoNames, movie: title)


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
                    let vc = MovieViewController()
                    vc.configure(with: viewModel)
                    vc.modalPresentationStyle = .formSheet
                    self?.controller?.present(vc, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
 
    }
    
    

    
    
}
