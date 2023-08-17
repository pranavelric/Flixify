//
//  CharacterDetailViewController.swift
//  Flixify
//
//  Created by Pranav Choudhary on 12/08/23.
//

import Foundation
import Foundation
import UIKit

class CharacterDetailViewController: UIViewController {
    
//    https://api.themoviedb.org/3/person/976/images
//    https://api.themoviedb.org/3/person/{person_id}
//https://api.themoviedb.org/3/person/person_id/movie_credits
    
   
//    {
//      "adult": false,
//      "also_known_as": [
//        "로건 레먼"
//      ],
//      "biography": "Logan Wade Lerman (born January 19, 1992) is an American actor, known for playing the title role in the fantasy-adventure Percy Jackson films. He appeared in commercials in the mid-1990s, before starring in the series Jack & Bobby (2004–2005) and the movies The Butterfly Effect (2004) and Hoot (2006). Lerman gained further recognition for his roles in the western 3:10 to Yuma, the thriller The Number 23, the comedy Meet Bill, and 2009's Gamer and My One and Only. He subsequently played d'Artagnan in 2011's The Three Musketeers, starred in the coming-of-age dramas The Perks of Being a Wallflower (2012), Indignation (2016) and The Vanishing of Sidney Hall (2017), and had major roles in the 2014 films Noah and Fury. In 2020, he returned to television with the series Hunters.",
//      "birthday": "1992-01-19",
//      "deathday": null,
//      "gender": 2,
//      "homepage": null,
//      "id": 33235,
//      "imdb_id": "nm0503567",
//      "known_for_department": "Acting",
//      "name": "Logan Lerman",
//      "place_of_birth": "Beverly Hills, California, USA",
//      "popularity": 21.105,
//      "profile_path": "/qWbN2toEEQgW9DFjgy3gT2VoVlQ.jpg"
//    }
    
    
//    {
//         "adult": false,
//         "gender": 1,
//         "id": 90633,
//         "known_for_department": "Acting",
//         "name": "Gal Gadot",
//         "original_name": "Gal Gadot",
//         "popularity": 148.421,
//         "profile_path": "/plLfB60M5cJrnog8KvAKhI4UJuk.jpg",
//         "cast_id": 1,
//         "character": "Rachel Stone",
//         "credit_id": "5f0cbd1113a3200036746c3c",
//         "order": 0
//       },
    
    
    enum CharacterSection: Int {
        case images = 0
        case movies   = 1
    
       
    }
    let detailViewController = CharacterPopupViewController()
    private var cast: Cast? = nil
    private var characterImages: [CharacterImage]? = []
    private var characterMovie: [Movie]? = []
    private var randomBgImage: String? = nil
    private var person: Person? = nil
    fileprivate var imageView: UIImageView = {
        let imageView = UIImageView()
          imageView.contentMode = .scaleAspectFill
          imageView.image = UIImage(named: "film_poster_placeholder")
          imageView.backgroundColor = .black
          imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
      }()
    
    private var bgImageView: UIImageView = {
        let imageView = UIImageView()
          imageView.contentMode = .scaleAspectFill
//          imageView.image = UIImage(named: "film_poster_placeholder")
          imageView.backgroundColor = .black
          imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
      }()
//    fileprivate var headerMaskLayer: CAShapeLayer!
    private let scrollView: UIScrollView  =  {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    private let characterName : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white.withAlphaComponent(0.9)
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    
    private let movieCharacterLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.9)
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    
    
    private let bioTitleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white.withAlphaComponent(0.9)
        label.text = "Bio"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    private let bioLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.7)
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    
    
    private let mContentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    private let goToWebsiteButton : UIButton = {
        let button:UIButton =  UIButton()
//        button.setTitle("Info", for: .normal)
        button.configuration = .tinted()
        button.titleLabel?.font = .systemFont(ofSize: 2)
        button.configuration?.baseBackgroundColor = .clear
        button.configuration?.baseForegroundColor = .white
        button.configuration?.buttonSize = .mini
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.configuration?.image = UIImage(systemName: "globe",withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        
        button.configuration?.imagePadding = 2
        button.configuration?.imagePlacement = .top
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    
    private let characterImagesLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white.withAlphaComponent(0.9)
        label.text = "Cast"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let characterImagesCollectionView : UICollectionView = {
                let castLayout = UICollectionViewFlowLayout()
                let castCollectioView = UICollectionView(frame: .zero, collectionViewLayout: castLayout)
                castLayout.scrollDirection = .horizontal
                castCollectioView.translatesAutoresizingMaskIntoConstraints = false
                castCollectioView.backgroundColor = .clear
                castCollectioView.tag = CharacterSection.images.rawValue
                castCollectioView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
                castLayout.minimumInteritemSpacing = 20
                castCollectioView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
                return castCollectioView
    }()
    
    
        
    
    private let characterMoviesLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white.withAlphaComponent(0.9)
        label.text = "Featured Films"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let characterMoviesCollectionView : UICollectionView = {
                let castLayout = UICollectionViewFlowLayout()
                let castCollectioView = UICollectionView(frame: .zero, collectionViewLayout: castLayout)
                castLayout.scrollDirection = .horizontal
                castCollectioView.translatesAutoresizingMaskIntoConstraints = false
                castCollectioView.backgroundColor = .clear
                castCollectioView.tag = CharacterSection.movies.rawValue
                castCollectioView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
                castLayout.minimumInteritemSpacing = 20
                castCollectioView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
                return castCollectioView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
//        headerMaskLayer = CAShapeLayer()
//            headerMaskLayer.fillColor = UIColor.black.cgColor
//            imageView.layer.mask = headerMaskLayer
        setupScrollView()
        setupViews()
        navigationController?.navigationBar.isHidden = true
        characterImagesCollectionView.dataSource = self
        characterImagesCollectionView.delegate = self
        
        characterMoviesCollectionView.dataSource = self
        characterMoviesCollectionView.delegate  = self
        
        configureConstraints()

        self.edgesForExtendedLayout = []
         
    }
    
    

    
    private func setupScrollView(){
        
        view.addSubview(scrollView)
        scrollView.addSubview(bgImageView)
        scrollView.addSubview(mContentView)
        mContentView.backgroundColor =  .clear
        scrollView.backgroundColor =  .clear
       
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        mContentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        mContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        mContentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        mContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    private func setupViews(){
        
        mContentView.addSubview(imageView)
        mContentView.addSubview(characterName)
        mContentView.addSubview(movieCharacterLabel)
        mContentView.addSubview(characterImagesCollectionView)
        mContentView.addSubview(bioTitleLabel)
        mContentView.addSubview(bioLabel)
        mContentView.addSubview(characterMoviesLabel)
        mContentView.addSubview(characterMoviesCollectionView)
    }

 
    private func configureConstraints(){

        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: mContentView.topAnchor,constant: 0),
            imageView.leadingAnchor.constraint(equalTo: mContentView.leadingAnchor,constant: 0),
            imageView.trailingAnchor.constraint(equalTo: mContentView.trailingAnchor,constant: 0),
            imageView.heightAnchor.constraint(equalToConstant: 500)

        ]
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true


        let bgImageViewConstraints = [
            bgImageView.topAnchor.constraint(equalTo: view.topAnchor),
            bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bgImageView.trailingAnchor.constraint(equalTo: mContentView.trailingAnchor),
            bgImageView.leadingAnchor.constraint(equalTo: mContentView.leadingAnchor)
        ]
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 500)
        gradient.locations = [0.0, 1.0]
        gradient.colors = [UIColor.clear.cgColor,UIColor.systemBackground.cgColor]
        imageView.layer.addSublayer(gradient)
        
        
        let bgGradient: CAGradientLayer = CAGradientLayer()
        bgGradient.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        bgGradient.locations = [0.0, 1.0]
        bgGradient.colors = [UIColor.black.withAlphaComponent(0.1).cgColor,UIColor.black.withAlphaComponent(0.2).cgColor]
        bgImageView.layer.addSublayer(bgGradient)

        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds

        bgImageView.addSubview(blurEffectView)
//       contentView.insertSubview(blurEffectView, aboveSubview: bgImageView)
        

        let characterNameConstraint = [
//            characterName.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            characterName.bottomAnchor.constraint(equalTo: movieCharacterLabel.topAnchor,constant: -5),
            characterName.trailingAnchor.constraint(equalTo: mContentView.trailingAnchor),
            characterName.leadingAnchor.constraint(equalTo: mContentView.leadingAnchor,constant: 20)
        ]
        
        
        
        let movieCharacterLabelConstraint = [
//            characterName.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            movieCharacterLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor,constant: -20),
            movieCharacterLabel.trailingAnchor.constraint(equalTo: mContentView.trailingAnchor),
            movieCharacterLabel.leadingAnchor.constraint(equalTo: mContentView.leadingAnchor,constant: 20)
        ]
        
        
        let characterImageCollectionConstraint = [
            characterImagesCollectionView.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 10),
            characterImagesCollectionView.trailingAnchor.constraint(equalTo: mContentView.trailingAnchor),
            characterImagesCollectionView.heightAnchor.constraint(equalToConstant: 200),
            characterImagesCollectionView.leadingAnchor.constraint(equalTo: mContentView.leadingAnchor,constant: 0)
        ]
        
        let bioTitleLabelConstraint = [
            bioTitleLabel.topAnchor.constraint(equalTo: characterImagesCollectionView.bottomAnchor,constant: 10),
            bioTitleLabel.trailingAnchor.constraint(equalTo: mContentView.trailingAnchor,constant: -20),
            bioTitleLabel.leadingAnchor.constraint(equalTo: mContentView.leadingAnchor,constant: 10)
        ]
        
        let bioLabelConstraint = [
            bioLabel.topAnchor.constraint(equalTo: bioTitleLabel.bottomAnchor,constant: 10),
//            bioLabel.bottomAnchor.constraint(equalTo: mContentView.bottomAnchor,constant: -20),
            bioLabel.trailingAnchor.constraint(equalTo: mContentView.trailingAnchor,constant: -20),
            bioLabel.leadingAnchor.constraint(equalTo: mContentView.leadingAnchor,constant: 10)
        ]
        
        
        let characterMovieCollectionLabelConstraint = [
            characterMoviesLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor,constant: 10),
            characterMoviesLabel.trailingAnchor.constraint(equalTo: mContentView.trailingAnchor),
            characterMoviesLabel.leadingAnchor.constraint(equalTo: mContentView.leadingAnchor,constant: 10)
        ]
        
        
        let characterMovieCollectionConstraint = [
            characterMoviesCollectionView.topAnchor.constraint(equalTo: characterMoviesLabel.bottomAnchor,constant: 10),
            characterMoviesCollectionView.trailingAnchor.constraint(equalTo: mContentView.trailingAnchor),
            characterMoviesCollectionView.heightAnchor.constraint(equalToConstant: 200),
            characterMoviesCollectionView.leadingAnchor.constraint(equalTo: mContentView.leadingAnchor,constant: 0),
            characterMoviesCollectionView.bottomAnchor.constraint(equalTo: mContentView.bottomAnchor,constant: -20),
        ]
        
        
        NSLayoutConstraint.activate(bgImageViewConstraints)
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(movieCharacterLabelConstraint)
        NSLayoutConstraint.activate(characterNameConstraint)
        NSLayoutConstraint.activate(characterImageCollectionConstraint)
        NSLayoutConstraint.activate(bioTitleLabelConstraint)
        NSLayoutConstraint.activate(bioLabelConstraint)
        NSLayoutConstraint.activate(characterMovieCollectionLabelConstraint)
        NSLayoutConstraint.activate(characterMovieCollectionConstraint)
        
       
     
         
       
    }
    
    public func configure(_ cast: Cast?){
        self.cast = cast
        
        imageView.sd_setImage(with: URL(string: "\(Constants.POSTER_PATH)/\(self.cast?.profile_path ?? "")"), placeholderImage: UIImage(named: "film_poster_placeholder"))
        bgImageView.sd_setImage(with: URL(string: "\(Constants.POSTER_PATH)/\(self.cast?.profile_path  ?? "")"), placeholderImage: UIImage(named: "film_poster_placeholder"))
        
        characterName.text = self.cast?.name ?? self.cast?.original_name
        movieCharacterLabel.text = self.cast?.character

        
    }
//    func updateHeaderView() {
//        let effectiveHeight = 600  - 550 / 2
//
//        let headerRect = CGRect(x: 0, y: Int(-effectiveHeight), width: Int(contentView.bounds.width), height: 800)
//
//        imageView.frame = headerRect
//
//        // cut away
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: 0, y: 0))
//        path.addLine(to: CGPoint(x: headerRect.width, y: 0))
//        path.addLine(to: CGPoint(x: headerRect.width, y: headerRect.height))
//        path.addLine(to: CGPoint(x: 0, y: headerRect.height - 165))
//        headerMaskLayer?.path = path.cgPath
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.navigationBar.isHidden = true
        
        fetchData()
    }
    
    
    private func fetchData(){
//    https://api.themoviedb.org/3/person/976/images
        ApiCaller.shared.fetchData(from: "/3/person/\(self.cast?.id ?? 0)/images"){

                    [weak self] (result: Result<CharacterImages, Error>) in
                    switch result {
                    case .success(let response):

                        self?.characterImages = response.profiles
                        self?.randomBgImage = self?.characterImages?.randomElement()?.filePath
                        DispatchQueue.main.async { [weak self] in
                            self?.characterImagesCollectionView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
        
        self.bgImageView.sd_setImage(with: URL(string: "\(Constants.POSTER_PATH)/\(self.randomBgImage  ?? "")"), placeholderImage: UIImage(named: "film_poster_placeholder"))
        //    https://api.themoviedb.org/3/person/976/images
        
        ApiCaller.shared.fetchData(from: "/3/person/\(self.cast?.id ?? 0)"){

                    [weak self] (result: Result<Person, Error>) in
                    switch result {
                    case .success(let response):

                        self?.person = response
                        DispatchQueue.main.async {
                            self?.setPersonData()
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                }
        
        ApiCaller.shared.fetchData(from: "/3/person/\(self.cast?.id ?? 0)/movie_credits"){

                    [weak self] (result: Result<PersonMovieCredit, Error>) in
                    switch result {
                    case .success(let response):

                        self?.characterMovie = response.cast
                        DispatchQueue.main.async {
                            self?.characterMoviesCollectionView.reloadData()
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                }
        
        
    }
    
    
    
    private func setPersonData(){
        self.bioLabel.text = self.person?.biography ?? ""
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
    
    
    

}


extension CharacterDetailViewController : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch CharacterSection(rawValue: collectionView.tag) {
        case .images:
            return characterImages?.count ?? 0
        case .movies:
            return characterMovie?.count ?? 0
        case .none:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        switch CharacterSection(rawValue: collectionView.tag) {
        case .images:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as! TitleCollectionViewCell
            cell.configure(with: self.characterImages?[indexPath.row].filePath ?? "")
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            return cell
        case .movies:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as! TitleCollectionViewCell
            cell.configure(with: self.characterMovie?[indexPath.row].poster_path ?? self.characterMovie?[indexPath.row].backdrop_path ?? "")
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            return cell
        case .none:
            return UICollectionViewCell()
        }
        

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch CharacterSection(rawValue: collectionView.tag) {
        case .images:
                break
        case .movies:
            self.getData(with: self.characterMovie?[indexPath.row])
        case .none: break
        }
    }

    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = 120 //some width
        let height = 180//ratio
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        let config = UIContextMenuConfiguration()
          return config
    }
    
}
