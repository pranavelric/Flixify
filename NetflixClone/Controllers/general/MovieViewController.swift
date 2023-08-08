//
//  MovieViewController.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 26/07/23.
//

import UIKit
import WebKit
import YouTubeiOSPlayerHelper

/* what extra changes : images*/
/*credits done
 videos done
 recommendations similar
 */
 /*
 
 
 MovieDetail(
adult: Optional(false),
backdropPath: Optional("/dWvDlTkt9VEGCDww6IzNRgm8fRQ.jpg"),
belongsToCollection: nil,
budget: Optional(80000000),
 
genres: Optional([NetflixClone.Genre(id: 28, name: "Action"),
NetflixClone.Genre(id: 12, name: "Adventure"),
NetflixClone.Genre(id: 53, name: "Thriller")]),
 
homepage: Optional("https://www.xyzfilms.com/hidden-strike"),

id: Optional(457332), imdbId: Optional("tt6879446"),

originalLanguage: Optional("en"),
originalTitle: Optional("Hidden Strike"),

 
overview: Optional("Two elite soldiers must escort civilians through a gauntlet of gunfire and explosions."),
popularity: Optional(209.601),
posterPath: Optional("/zsbolOkw8RhTU4DKOrpf4M7KCmi.jpg"),

productionCompanies: Optional(
     [NetflixClone.ProductionCompany(id: Optional(79732),
          logoPath: nil, name: Optional("Talent International Media"),
           originCountry: Optional("")),
     NetflixClone.ProductionCompany(id: Optional(36958),
          logoPath: nil, name: Optional("Sparkle Roll Media"),
          originCountry: Optional("CN")),
     NetflixClone.ProductionCompany(id: Optional(81620),
          logoPath: Optional("/gNp4dfuBOXmVWdGKb63NfbFNbFi.png"),
          name: Optional("Tencent Pictures"),
          originCountry: Optional("CN")),
     NetflixClone.ProductionCompany(id: Optional(12142),
          logoPath: Optional("/rPnEeMwxjI6rYMGqkWqIWwIJXxi.png"),
          name: Optional("XYZ Films"),
          originCountry: Optional("US")),
     NetflixClone.ProductionCompany(id: Optional(48805),
          logoPath: nil,
          name: Optional("Changchun Film Studio"),
          originCountry: Optional("CN")),
     NetflixClone.ProductionCompany(id: Optional(122328),
          logoPath: nil,
          name: Optional("Huaxia Film Distribution"),
          originCountry: Optional("CN"))]),
 productionCountries: Optional([
      NetflixClone.ProductionCountry(iso_3166_1: Optional("CN"),
             name: Optional("China")),
      NetflixClone.ProductionCountry(iso_3166_1: Optional("US"),
             name: Optional("United States of America"))]),
 
 releaseDate: Optional("2023-07-06"),
 revenue: Optional(0),
 runtime: Optional(103),
 spokenLanguages: Optional([NetflixClone.SpokenLanguage(englishName: Optional("Mandarin"), iso_639_1: Optional("zh"), name: Optional("普通话")), NetflixClone.SpokenLanguage(englishName: Optional("English"), iso_639_1: Optional("en"), name: Optional("English")), NetflixClone.SpokenLanguage(englishName: Optional("Portuguese"), iso_639_1: Optional("pt"), name: Optional("Português"))]), status: Optional("Released"),
 
 tagline: Optional("There is a plan. They just don\'t know what it is."),
 
 title: Optional("Hidden Strike"),
 video: Optional(false),
 voteAverage: Optional(7.153),
 voteCount: Optional(59))
 
 
 
 
 
 
 */


enum Section: Int {
    case genres = 0
    case cast   = 1
    case trailer = 2
    case clips  = 3
    case recommended = 4
    case similar = 5
//    case crew   = 2
   
}



class MovieViewController: UIViewController {
    
    private var movieDetail : MovieDetail? = nil
    private var currentMovie: Movie? = nil
    private var genres : [Genre]? = []
    private var castMembers: [Cast]? = []
    private var crewMembers: [Crew]? = []
    private var trailers: [YouTubeVideoItem]? = []
    private var clips: [ClipResult]? = []
    private var recommendations: [Movie]? = []
    private var similarMovies: [Movie]? = []
    private var movieImages: [Backdrop]? = []
    private var movieImagesPosters: [Poster]? = []
    private var movieImagesLogos: [Logo]? = []
    let storage =  Storage.shared
    private let scrollView: UIScrollView  =  {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    private let contentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
//    private let webView: WKWebView  = {
//
//        let webView = WKWebView()
//        webView.translatesAutoresizingMaskIntoConstraints = false
//        webView.isUserInteractionEnabled = true
//        return webView
//    }()
    
    // testing ytplayer
    private let trailerView : YTPlayerView = {
        let trailerView = YTPlayerView()
        trailerView.translatesAutoresizingMaskIntoConstraints = false
        trailerView.isUserInteractionEnabled = true
        return trailerView
    }()
//    private let trailerView = YTPlayerView(frame: CGRect(x: 0, y: 0, width: .zero, height: 350))
    let playerVar = [
        "playsinline":1,
        "showinfo": 1,
        "rel": 0,
        "modestbranding": 1,
        "controls": 1,
        "color": "white",
        "iv_load_policy": 3,
        "origin" : "https://www.youtube.com/embed/"
        
    ] as [AnyHashable  :Any]?
    
    private let customThumnailImageView : UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        imageView.backgroundColor = .systemBackground
        return imageView
    }()
    
    private let customThumnailCardImageView : UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        imageView.backgroundColor = .systemBackground
        return imageView
    }()
    
    private let bookmarkButton : UIButton = {
        let button:UIButton =  UIButton()
//        button.setTitle("Remind Me", for: .normal)
        button.configuration = .tinted()
        button.titleLabel?.font = .systemFont(ofSize: 2)
        button.configuration?.baseBackgroundColor = .clear
        button.configuration?.baseForegroundColor = .white
        button.configuration?.buttonSize = .mini
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.configuration?.image = UIImage(systemName: "bookmark",withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        
        button.configuration?.imagePadding = 2
        button.configuration?.imagePlacement = .top
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let infoButton : UIButton = {
        let button:UIButton =  UIButton()
//        button.setTitle("Info", for: .normal)
        button.configuration = .tinted()
        button.titleLabel?.font = .systemFont(ofSize: 2)
        button.configuration?.baseBackgroundColor = .clear
        button.configuration?.baseForegroundColor = .white
        button.configuration?.buttonSize = .mini
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.configuration?.image = UIImage(systemName: "info.circle",withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        
        button.configuration?.imagePadding = 2
        button.configuration?.imagePlacement = .top
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    
    private let playButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
//        button.setImage(UIImage(named: "play_button"), for: .normal)
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = .clear
        button.configuration?.baseForegroundColor = .white
//        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor.white.cgColor
        button.configuration?.image = UIImage(systemName: "play.fill")
        button.configuration?.imagePadding = 2
        button.configuration?.imagePlacement = .all
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius =  8
        
        button.clipsToBounds = true
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = button.bounds
        gradient.locations = [0.0, 1.0]
        gradient.colors = [UIColor.red.withAlphaComponent(0.9).cgColor,UIColor.black.cgColor]
        button.layer.insertSublayer(gradient, at: 1)
        
        return button
    }()
    
    
    // collection views
    private let genreCollectionView : UICollectionView = {
               let genresLayout = UICollectionViewFlowLayout()
               let genresCollectioView = UICollectionView(frame: .zero, collectionViewLayout: genresLayout)
        genresLayout.scrollDirection = .horizontal
        
        genresCollectioView.translatesAutoresizingMaskIntoConstraints = false
        genresCollectioView.backgroundColor = .clear
               genresCollectioView.tag = Section.genres.rawValue
               genresCollectioView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.IDENTIFIER)
        genresLayout.minimumInteritemSpacing = 20
        genresCollectioView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
               return genresCollectioView
    }()
    
    private let trailerLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white.withAlphaComponent(0.9)
        label.text = "Trailers"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    private let trailerCollectionView : UICollectionView = {
                let trailerLayout = UICollectionViewFlowLayout()
                let trailerCollectioView = UICollectionView(frame: .zero, collectionViewLayout: trailerLayout)
        trailerLayout.scrollDirection = .horizontal
        trailerCollectioView.translatesAutoresizingMaskIntoConstraints = false
        trailerCollectioView.backgroundColor = .clear
        trailerCollectioView.tag = Section.trailer.rawValue
        trailerCollectioView.register(TrailerCollectionViewCell.self, forCellWithReuseIdentifier: TrailerCollectionViewCell.identifier)
        trailerLayout.minimumInteritemSpacing = 20
        trailerCollectioView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)

                return trailerCollectioView
    }()
    
    
    private let clipsLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white.withAlphaComponent(0.9)
        label.text = "Clips"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    private let clipsCollectionView : UICollectionView = {
                let layout = UICollectionViewFlowLayout()
                let collectioView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collectioView.translatesAutoresizingMaskIntoConstraints = false
        collectioView.backgroundColor = .clear
        collectioView.tag = Section.clips.rawValue
        collectioView.register(TrailerCollectionViewCell.self, forCellWithReuseIdentifier: TrailerCollectionViewCell.identifier)
        layout.minimumInteritemSpacing = 20
        collectioView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)

                return collectioView
    }()
    
    
    private let recommendationLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white.withAlphaComponent(0.9)
        label.text = "Recommended for you"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    private let recommendedCollectionView : UICollectionView = {
                let layout = UICollectionViewFlowLayout()
                let collectioView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collectioView.translatesAutoresizingMaskIntoConstraints = false
        collectioView.backgroundColor = .clear
        collectioView.tag = Section.recommended.rawValue
        collectioView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        layout.minimumInteritemSpacing = 20
        collectioView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)

                return collectioView
    }()
    
    
    private let similarMoviesLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white.withAlphaComponent(0.9)
        label.text = "You may also like"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    private let similarMoviesCollectionView : UICollectionView = {
                let layout = UICollectionViewFlowLayout()
                let collectioView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collectioView.translatesAutoresizingMaskIntoConstraints = false
        collectioView.backgroundColor = .clear
        collectioView.tag = Section.similar.rawValue
        collectioView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        layout.minimumInteritemSpacing = 20
        collectioView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
                return collectioView
    }()
    
    private let castLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white.withAlphaComponent(0.9)
        label.text = "Cast"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let castCollectionView : UICollectionView = {
                let castLayout = UICollectionViewFlowLayout()
                let castCollectioView = UICollectionView(frame: .zero, collectionViewLayout: castLayout)
                castLayout.scrollDirection = .horizontal
                castCollectioView.translatesAutoresizingMaskIntoConstraints = false
                castCollectioView.backgroundColor = .clear
                castCollectioView.tag = Section.cast.rawValue
                castCollectioView.register(CreditCollectionViewCell.self, forCellWithReuseIdentifier: CreditCollectionViewCell.identifier)
                castLayout.minimumInteritemSpacing = 20
                castCollectioView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
                return castCollectioView
    }()
    
    
    private let starLabel : UILabel = {
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
        
        
//        let button = UIButton(frame: .zero)
//        button.configuration = .tinted()
//        button.configuration?.baseBackgroundColor = .clear
//        button.configuration?.baseForegroundColor = .systemYellow
//        button.configuration?.image = UIImage(systemName: "star",withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
//        button.configuration?.imagePadding = 0
//        button.configuration?.imagePlacement = .leading
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.clipsToBounds = true
//        return button
    }()
    
    private let runtimeLabel : UILabel = {
        

        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
        
    }()
    
    
    private let taglineLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let synopsisLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white.withAlphaComponent(0.9)
        label.text = "Synopsis"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    
    private let ratingLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let releaseDateLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        
        return label
    }()
    
    private let lengthLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    //end here
        
    private let movieTitleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white.withAlphaComponent(0.99)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    private let overviewLabel: UILabel = {

        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        setupScrollView()
        setupViews()
        trailerView.delegate = self
        genreCollectionView.delegate = self
        genreCollectionView.dataSource = self
        
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        
        trailerCollectionView.delegate = self
        trailerCollectionView.dataSource = self
        
        clipsCollectionView.delegate = self
        clipsCollectionView.dataSource = self
        
        recommendedCollectionView.dataSource = self
        recommendedCollectionView.delegate   = self
        
        similarMoviesCollectionView.dataSource = self
        similarMoviesCollectionView.delegate   = self

        navigationController?.navigationBar.isHidden = true
        configureConstraints()

        self.edgesForExtendedLayout = []
    }
    
    private func setupScrollView(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
       
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    private func setupViews(){
      
//        contentView.addSubview(webView)
        contentView.addSubview(trailerView)
        contentView.addSubview(customThumnailImageView)
        contentView.addSubview(customThumnailCardImageView)
        contentView.addSubview(playButton)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(goToWebsiteButton)
        contentView.addSubview(infoButton)
        contentView.addSubview(bookmarkButton)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(synopsisLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(starLabel)
        contentView.addSubview(runtimeLabel)
        contentView.addSubview(genreCollectionView)
        contentView.addSubview(castLabel)
        contentView.addSubview(castCollectionView)
        contentView.addSubview(trailerLabel)
        contentView.addSubview(trailerCollectionView)
        contentView.addSubview(clipsLabel)
        contentView.addSubview(clipsCollectionView)
        contentView.addSubview(recommendationLabel)
        contentView.addSubview(recommendedCollectionView)
        contentView.addSubview(similarMoviesLabel)
        contentView.addSubview(similarMoviesCollectionView)
//        contentView.addSubview(taglineLabel)

    }
    

    private func  configureConstraints(){
//        let webViewConstraints = [
//            webView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 0),
//            webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            webView.heightAnchor.constraint(equalToConstant: 350)
//
//        ]
        
//        webView.isUserInteractionEnabled = true
//        webView.scrollView.isScrollEnabled = true
//        webView.configuration.allowsInlineMediaPlayback = true
//        webView.configuration.mediaTypesRequiringUserActionForPlayback = []
//        webView.configuration.allowsPictureInPictureMediaPlayback = true
//        webView.contentMode = .scaleToFill
//        webView.sizeToFit()
//        webView.autoresizesSubviews = true
//
        let aspectRatio: CGFloat = 16.0 / 9.0 // 16:9 aspect ratio for YouTube videos
              
        let webViewConstraints = [
            trailerView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 0),
            trailerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trailerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trailerView.heightAnchor.constraint(equalToConstant: 250),
            trailerView.widthAnchor.constraint(equalTo: trailerView.heightAnchor, multiplier: aspectRatio)
        ]

        //custom thumbnail
        customThumnailImageView.translatesAutoresizingMaskIntoConstraints = false
        let customThumbnailConstraints = [
            customThumnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 0),
            customThumnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customThumnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customThumnailImageView.heightAnchor.constraint(equalToConstant: 700)
            
        ]
        customThumnailImageView.layer.cornerRadius = 10
        

        let customThumbnailCardConstraints = [
            customThumnailCardImageView.centerXAnchor.constraint(equalTo: customThumnailImageView.centerXAnchor),
            customThumnailCardImageView.centerYAnchor.constraint(equalTo: customThumnailImageView.centerYAnchor,constant: -30),
            customThumnailCardImageView.heightAnchor.constraint(equalToConstant: 450),
            customThumnailCardImageView.widthAnchor.constraint(equalToConstant: view.bounds.width-120)
        ]
        customThumnailCardImageView.layer.cornerRadius = 10
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 700)
        gradient.locations = [0.0, 1.0]
        gradient.colors = [UIColor.clear.cgColor,UIColor.systemBackground.cgColor]
        customThumnailImageView.layer.addSublayer(gradient)
  
        let effect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: effect)
       
       // set boundry and alpha
        effectView.frame = CGRect(x: 0, y: 0, width: 600, height: 500)
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectView.alpha = 0.6
       
        customThumnailImageView.addSubview(effectView)
        
        
//        contentView.addSubview(gradientView)
        
        
        let playButtonConstrains = [
            playButton.centerXAnchor.constraint(equalTo: customThumnailImageView.centerXAnchor,constant: 0),
            playButton.centerYAnchor.constraint(equalTo: customThumnailImageView.centerYAnchor),
            playButton.heightAnchor.constraint(equalToConstant: 40),
            playButton.widthAnchor.constraint(equalToConstant: 80)
        ]
        
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
   
        

        
        let goToWebsiteButtonConstraints = [
            goToWebsiteButton.topAnchor.constraint(equalTo: genreCollectionView.bottomAnchor,constant: 20),
            goToWebsiteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            goToWebsiteButton.heightAnchor.constraint(equalToConstant: 20),
        ]
        
        goToWebsiteButton.addTarget(self, action: #selector(goToWebsiteButtonTapped), for: .touchUpInside)
        
        let infoButtonConstraints = [
            infoButton.topAnchor.constraint(equalTo: genreCollectionView.bottomAnchor,constant: 20),
            infoButton.trailingAnchor.constraint(equalTo: goToWebsiteButton.leadingAnchor, constant: -5),
            infoButton.heightAnchor.constraint(equalToConstant: 20),
        ]
        
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        
       
        let bookmarkButtonConstraints = [
            bookmarkButton.topAnchor.constraint(equalTo: genreCollectionView.bottomAnchor,constant: 20),
            bookmarkButton.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor, constant: -5),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 20),
        ]
        
        
        
        bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        
        
        
        let movieTitleLabelConstraints = [
            movieTitleLabel.topAnchor.constraint(equalTo: customThumnailCardImageView.bottomAnchor,constant: 40),
            movieTitleLabel.leadingAnchor.constraint(equalTo: customThumnailImageView.leadingAnchor,constant: 20),
            movieTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        
        let starLabelConstraints = [
            starLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor,constant: 5),
            starLabel.leadingAnchor.constraint(equalTo: movieTitleLabel.leadingAnchor)
        ]
        let genreCollectionViewConstraints = [
            genreCollectionView.topAnchor.constraint(equalTo: starLabel.bottomAnchor,constant: 10),
            genreCollectionView.leadingAnchor.constraint(equalTo: movieTitleLabel.leadingAnchor),
            genreCollectionView.trailingAnchor.constraint(equalTo: movieTitleLabel.trailingAnchor),
//            genreCollectionView.bottomAnchor.constraint(equalTo: releaseDateLabel.topAnchor,constant: -20),
            genreCollectionView.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        let runtimeLabelConstraints = [
            runtimeLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor,constant: 5),
            runtimeLabel.leadingAnchor.constraint(equalTo: starLabel.trailingAnchor,constant: 5),
        ]
        
        
        let releaseDateConstraints = [
            releaseDateLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor,constant: 5),
            releaseDateLabel.leadingAnchor.constraint(equalTo: runtimeLabel.trailingAnchor,constant: 5),
        ]
        
        let synopsisLabelConstraints = [
            synopsisLabel.topAnchor.constraint(equalTo: genreCollectionView.bottomAnchor,constant: 20),
            synopsisLabel.leadingAnchor.constraint(equalTo: customThumnailImageView.leadingAnchor,constant: 20),
            synopsisLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        
        let overviewLabelConstraints = [
            overviewLabel.topAnchor.constraint(equalTo: synopsisLabel.bottomAnchor,constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: synopsisLabel.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]

        let castLabelConstraints = [
            castLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor,constant: 20),
            castLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            castLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        let castCollectionViewConstraints = [
            castCollectionView.topAnchor.constraint(equalTo: castLabel.bottomAnchor,constant: 10),
            castCollectionView.leadingAnchor.constraint(equalTo: castLabel.leadingAnchor),
            castCollectionView.trailingAnchor.constraint(equalTo: castLabel.trailingAnchor),
            castCollectionView.heightAnchor.constraint(equalToConstant: 200),
//            castCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        
        let trailerLabelConstraints = [
            trailerLabel.topAnchor.constraint(equalTo: castCollectionView.bottomAnchor,constant: 20),
            trailerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            trailerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        let trailerCollectionViewConstraints = [
            trailerCollectionView.topAnchor.constraint(equalTo: trailerLabel.bottomAnchor,constant: 10),
            trailerCollectionView.leadingAnchor.constraint(equalTo: trailerLabel.leadingAnchor),
            trailerCollectionView.trailingAnchor.constraint(equalTo: trailerLabel.trailingAnchor),
            trailerCollectionView.heightAnchor.constraint(equalToConstant: 200),
//            trailerCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        let clipsLabelConstraints = [
            clipsLabel.topAnchor.constraint(equalTo: trailerCollectionView.bottomAnchor,constant: 20),
            clipsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            clipsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        let clipsCollectionViewConstraints = [
            clipsCollectionView.topAnchor.constraint(equalTo: clipsLabel.bottomAnchor,constant: 10),
            clipsCollectionView.leadingAnchor.constraint(equalTo: clipsLabel.leadingAnchor),
            clipsCollectionView.trailingAnchor.constraint(equalTo: clipsLabel.trailingAnchor),
            clipsCollectionView.heightAnchor.constraint(equalToConstant: 200),
//            clipsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
//        let taglineLabelConstraints = [
//            taglineLabel.topAnchor.constraint(equalTo: customThumnailCardImageView.bottomAnchor,constant: 20),
//            taglineLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//
//
//        ]
        
        let recommendedLabelConstraints = [
            recommendationLabel.topAnchor.constraint(equalTo: clipsCollectionView.bottomAnchor,constant: 20),
            recommendationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            recommendationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        let recommendedCollectionViewConstraints = [
            recommendedCollectionView.topAnchor.constraint(equalTo: recommendationLabel.bottomAnchor,constant: 10),
            recommendedCollectionView.leadingAnchor.constraint(equalTo: recommendationLabel.leadingAnchor),
            recommendedCollectionView.trailingAnchor.constraint(equalTo: recommendationLabel.trailingAnchor),
            recommendedCollectionView.heightAnchor.constraint(equalToConstant: 200),
//            recommendedCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        let similarMoviesLabelConstraints = [
            similarMoviesLabel.topAnchor.constraint(equalTo: recommendedCollectionView.bottomAnchor,constant: 20),
            similarMoviesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            similarMoviesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        let similarMoviesCollectionViewConstraints = [
            similarMoviesCollectionView.topAnchor.constraint(equalTo: similarMoviesLabel.bottomAnchor,constant: 10),
            similarMoviesCollectionView.leadingAnchor.constraint(equalTo: similarMoviesLabel.leadingAnchor),
            similarMoviesCollectionView.trailingAnchor.constraint(equalTo: similarMoviesLabel.trailingAnchor),
            similarMoviesCollectionView.heightAnchor.constraint(equalToConstant: 200),
            similarMoviesCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
       
        
        
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(movieTitleLabelConstraints)
        NSLayoutConstraint.activate(starLabelConstraints)
        NSLayoutConstraint.activate(runtimeLabelConstraints)
        NSLayoutConstraint.activate(synopsisLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(customThumbnailConstraints)
        NSLayoutConstraint.activate(customThumbnailCardConstraints)
        NSLayoutConstraint.activate(playButtonConstrains)
        
//        NSLayoutConstraint.activate(taglineLabelConstraints)
        NSLayoutConstraint.activate(releaseDateConstraints)
        NSLayoutConstraint.activate(goToWebsiteButtonConstraints)
        NSLayoutConstraint.activate(infoButtonConstraints)
        NSLayoutConstraint.activate(bookmarkButtonConstraints)
        
        NSLayoutConstraint.activate(genreCollectionViewConstraints)
        NSLayoutConstraint.activate(castLabelConstraints)
        NSLayoutConstraint.activate(castCollectionViewConstraints)
        NSLayoutConstraint.activate(trailerLabelConstraints)
        NSLayoutConstraint.activate(trailerCollectionViewConstraints)
        NSLayoutConstraint.activate(clipsLabelConstraints)
        NSLayoutConstraint.activate(clipsCollectionViewConstraints)
        
        NSLayoutConstraint.activate(recommendedLabelConstraints)
        NSLayoutConstraint.activate(recommendedCollectionViewConstraints)
        NSLayoutConstraint.activate(similarMoviesLabelConstraints)
        NSLayoutConstraint.activate(similarMoviesCollectionViewConstraints)
        
        
        
    }
    
    @objc func goToWebsiteButtonTapped(){
        DispatchQueue.main.async { [weak self] in
            let vc = MovieHomePageViewController()
            vc.configure(with: self?.movieDetail?.homepage )
          
            vc.modalPresentationStyle = .formSheet
            self?.present(vc, animated: true)
//            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func infoButtonTapped(){
        
        DispatchQueue.main.async { [weak self] in
            let vc = MovieImagesViewController()
            vc.configure(with: MovieImagesViewModel(movieImages: self?.movieImages,movieImagesPosters: self?.movieImagesPosters,movieImagesLogos: self?.movieImagesLogos) )
            self?.showPopover(ofViewController: vc, originView: self?.view ?? UIView())
            vc.modalPresentationStyle = .popover
            vc.popoverPresentationController?.permittedArrowDirections = .up
            vc.modalTransitionStyle = .crossDissolve
            
            vc.preferredContentSize = .init(width:  1500, height:  600)  // the size of popover
//            vc.preferredContentSize = .init(width: 500, height: 600)  // the size of popover
//                   the view of the popover
                vc.popoverPresentationController?.sourceRect = CGRect(    // the place to display the popover
                    origin: CGPoint(
                        x: self?.view.frame.midX ?? 0,
                        y: 50
                    ),
                    size: .zero
                )
//            self?.present(vc, animated: true)
//            self?.navigationController?.pushViewController(vc, animated: true)
        }
      
        
    }
    
    @objc func bookmarkButtonTapped(){
        
        
        if storage.isTitleInStorage(title: self.currentMovie! ) {
            storage.deleteBookmark(title: self.currentMovie!)
            bookmarkButton.configuration?.image = UIImage(systemName: "bookmark",withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
            bookmarkButton.configuration?.baseForegroundColor = .white
            Toast.show(message: "Bookmark removed", controller: self)
            flash()
        } else {
            storage.addBookmarkForTitle(title: self.currentMovie!)
            bookmarkButton.configuration?.image = UIImage(systemName: "bookmark.fill",withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
            bookmarkButton.configuration?.baseForegroundColor = .systemYellow
            Toast.show(message: "Bookmark added", controller: self)
            pulsate()
        }

    }
    
    func checkBookmarkButton(){
        if storage.isTitleInStorage(title: self.currentMovie! ) {
           
            bookmarkButton.configuration?.image = UIImage(systemName: "bookmark.fill",withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
            bookmarkButton.configuration?.baseForegroundColor = .systemYellow
        } else {
            bookmarkButton.configuration?.image?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(paletteColors: [.white]))
            bookmarkButton.configuration?.image = UIImage(systemName: "bookmark",withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
            bookmarkButton.configuration?.baseForegroundColor = .white
        }
    }
    
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.4
        pulse.fromValue = 0.98
        pulse.toValue = 1.2
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        bookmarkButton.layer.add(pulse, forKey: nil)
    }
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.3
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 2
        bookmarkButton.layer.add(flash, forKey: nil)
    }
    
    
    
    
    
    
    func showPopover(ofViewController popoverViewController: UIViewController, originView: UIView) {
        popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        if let popoverController = popoverViewController.popoverPresentationController {
            popoverController.delegate = self
            popoverController.sourceView = originView
            popoverController.sourceRect = originView.bounds
            popoverController.backgroundColor = popoverViewController.view.backgroundColor
            popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
        }
        self.present(popoverViewController, animated: true)
    }
    
    func configure(with model: MoviePreviewViewModel){
        self.movieDetail = model.movieDetail
        self.genres = self.movieDetail?.genres
        self.movieTitleLabel.text = movieDetail?.title ?? movieDetail?.originalTitle ?? "unknown"
        self.overviewLabel.text = movieDetail?.overview ?? "unknown"
        
//        guard  let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView[0].id.videoId)") else{
//            return
//        }
       
//        self.webView.load(URLRequest(url: url))
//        self.webView.isUserInteractionEnabled = true
        customThumnailImageView.sd_setImage(with: URL(string: "\(Constants.POSTER_PATH)/\(self.movieDetail?.backdropPath ?? self.movieDetail?.posterPath ?? "")"), placeholderImage: UIImage(named: "film_poster_placeholder"))
        
        customThumnailCardImageView.sd_setImage(with: URL(string: "\(Constants.POSTER_PATH)/\(self.movieDetail?.posterPath ?? self.movieDetail?.backdropPath ?? "")"), placeholderImage: UIImage(named: "film_poster_placeholder"))
        
        trailers = model.youtubeView
        trailerView.load(withPlayerParams: playerVar)
        trailerView.load(withVideoId: "\(model.youtubeView?[0].id.videoId ?? "64766d1c00508a00a72cfd2f" )", playerVars: playerVar)
        trailerView.layer.cornerRadius = 10
        trailerView.clipsToBounds = true
        
        starLabel.addLeading(image: UIImage(systemName: "star") ?? UIImage(), text: "\(self.movieDetail?.voteAverage ?? 0.0)",height: CGFloat(integerLiteral: 12) ,color: .systemYellow.withAlphaComponent(0.5))
        runtimeLabel.addLeading(image: UIImage(systemName:  "clock") ?? UIImage(), text: "\(self.movieDetail?.runtime ?? 0) mins",height: CGFloat(integerLiteral: 12) ,color: .systemYellow.withAlphaComponent(0.5))
   
      
        releaseDateLabel.addLeading(image: UIImage(systemName:  "calendar") ?? UIImage(), text: "\(self.movieDetail?.releaseDate?.getFormattedDate() ?? "")",height: CGFloat(integerLiteral: 12) ,color: .systemYellow.withAlphaComponent(0.5))
//        releaseDateLabel.text = "\(self.movieDetail?.releaseDate?.getFormattedDate() ?? "")"
//        taglineLabel.text = " \"\(self.movieDetail?.tagline ??  "")\" "
        self.getMovieCredits(with: self.movieDetail?.id ?? 0)
        self.getMovieClips(with:self.movieDetail?.id ?? 0)
        
        self.getRecommendedMovies(with: self.movieDetail?.id ?? 0)
        self.getSimilarMovies(with: self.movieDetail?.id ?? 0)
        
        self.getMovieImages(with: self.movieDetail?.id ?? 0)
        self.currentMovie = model.movie
        checkBookmarkButton()
    
    }
    
    @objc private func playButtonTapped(){
//        customThumnailImageView.isHidden = true
        self.movieTitleLabel.topAnchor.constraint(equalTo: self.trailerView.bottomAnchor,constant: 20).isActive = true
//        self.movieTitleLabel.leadingAnchor.constraint(equalTo: self.trailerView.leadingAnchor,constant: 20).isActive = true
//        self.releaseDateLabel.topAnchor.constraint(equalTo: self.trailerView.bottomAnchor, constant: 20).isActive = true
//        self.goToWebsiteButton.topAnchor.constraint(equalTo: self.trailerView.bottomAnchor, constant: 20).isActive = true
//        self.infoButton.topAnchor.constraint(equalTo: self.trailerView.bottomAnchor, constant: 20).isActive = true
//        self.bookmarkButton.topAnchor.constraint(equalTo: self.trailerView.bottomAnchor, constant: 20).isActive = true
        
        UIView.animate(withDuration: 0.5, animations: {
                    // Set the view's alpha to 0 to make it fade out
//                    self.customThumnailImageView.alpha = 0
            
//            self.customThumnailImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
            self.customThumnailImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.customThumnailCardImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.playButton.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.playButton.alpha = 0
            self.customThumnailImageView.alpha = 0
            self.customThumnailCardImageView.alpha = 0
            self.view.layoutIfNeeded()
           
                }) { (finished) in
                    // Once the animation completes, hide the view completely (optional)
                    self.customThumnailImageView.isHidden = true
                    self.customThumnailCardImageView.isHidden = true
                    self.playButton.isHidden = true
//                    self.trailerView.playVideo()  //enable it later
                }
        
        
      
        
    }
    
    
    
    private func getMovieCredits(with movieId: Int){
            //    https://api.themoviedb.org/3/movie/12/credits
            ApiCaller.shared.fetchData(from: Constants.MOVIE_DETAILS+"\(movieId)/credits"){
                (result: Result<Credits, Error>) in
                switch result {
                case .success(let response):
                    self.castMembers = response.cast
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.castCollectionView.reloadData()
                    }
//                    self.crewMembers = response.crew
//                    DispatchQueue.main.async { [weak self] in
//                        self?.crewCollectionView.reloadData()
//                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    private func getMovieImages(with movieId: Int){
            //  https://api.themoviedb.org/3/movie/234567/images
            ApiCaller.shared.fetchData(from: Constants.MOVIE_DETAILS+"\(movieId)/images"){
                (result: Result<MovieImages, Error>) in
                switch result {
                case .success(let response):
                    self.movieImages = response.backdrops
                    self.movieImagesPosters = response.posters
                    self.movieImagesLogos = response.logos
//                    DispatchQueue.main.async { [weak self] in
//                        self?.castCollectionView.reloadData()
//                    }
//                    self.crewMembers = response.crew
//                    DispatchQueue.main.async { [weak self] in
//                        self?.crewCollectionView.reloadData()
//                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    
    private func getMovieClips(with movieId: Int){
        
            //    https://api.themoviedb.org/3/movie/12/videos
            ApiCaller.shared.fetchData(from: Constants.MOVIE_DETAILS+"\(movieId)/videos"){
                (result: Result<MovieClip, Error>) in
                switch result {
                case .success(let response):
                    self.clips = response.results
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.clipsCollectionView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    
    private func getRecommendedMovies(with movieId: Int){
        

            ApiCaller.shared.fetchData(from: Constants.MOVIE_DETAILS+"\(movieId)/recommendations"){
                (result: Result<TrendingMovieResponse, Error>) in
                switch result {
                case .success(let response):
                    self.recommendations = response.results
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.recommendedCollectionView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    
    
    private func getSimilarMovies(with movieId: Int){
        

            ApiCaller.shared.fetchData(from: Constants.MOVIE_DETAILS+"\(movieId)/similar"){
                (result: Result<TrendingMovieResponse, Error>) in
                switch result {
                case .success(let response):
                    self.similarMovies = response.results
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.similarMoviesCollectionView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
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


extension MovieViewController : YTPlayerViewDelegate {
      func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
           // The player is ready to play the video, you can control playback here if needed
//           trailerView.playVideo()
       }

       func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
           // Handle video state changes (e.g., started, paused, ended, etc.)
       }

       func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
           // Handle any errors encountered during video playback
           print("error is \(error)")
       }
}



extension MovieViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: collectionView.tag) {
                case .genres:
                    return genres?.count ?? 0
                case .cast:
            return castMembers?.count ?? 0
                case .trailer:
            return trailers?.count ?? 0
            case .clips:
            return clips?.count ?? 0
        case .recommended:
            return recommendations?.count ?? 0
        case .similar:
            return similarMovies?.count ?? 0
                case .none:
                    return 0
                }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch Section(rawValue: collectionView.tag) {
        case .genres: break
        case .cast: break
        case .trailer: break
        case .clips: break
        case .recommended:
            self.getData(with: self.recommendations?[indexPath.row])
        case .similar:
                self.getData(with: self.similarMovies?[indexPath.row])
        case .none: break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {




        switch Section(rawValue: collectionView.tag) {
                case .genres:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.IDENTIFIER, for: indexPath) as? GenreCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                            // Configure the cell with genre information
                    let genre = genres?[indexPath.item] ?? nil
                    cell.configure(with: genre)

                    return cell
                case .cast:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditCollectionViewCell.identifier, for: indexPath) as! CreditCollectionViewCell
                    cell.configureCast(with: castMembers?[indexPath.row])

                    return cell
        case .trailer:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrailerCollectionViewCell.identifier, for: indexPath) as! TrailerCollectionViewCell
            cell.configure(with: trailers?[indexPath.row].id.videoId)
            return cell
        case .clips:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrailerCollectionViewCell.identifier, for: indexPath) as! TrailerCollectionViewCell
            cell.configure(with: clips?[indexPath.row].key)
            return cell
        case .recommended:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as! TitleCollectionViewCell
            cell.configure(with: recommendations?[indexPath.row].poster_path ?? recommendations?[indexPath.row].backdrop_path ?? "")
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            return cell
        case .similar:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as! TitleCollectionViewCell
            cell.configure(with: similarMovies?[indexPath.row].poster_path ?? similarMovies?[indexPath.row].backdrop_path ?? "")
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            return cell
                case .none:
                    return UICollectionViewCell()
                }
            }

    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch Section(rawValue: collectionView.tag) {
                case .genres:
                    return CGSize(width: (genres?[indexPath.item].name
                            .size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]).width ?? 0) + 25, height: 30)
                case .cast:
                   let width = 100 //some width
                   let height = 180//ratio
                   return CGSize(width: width, height: height)
//                case .relatedMovies:
//                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelatedMoviesCollectionViewCell", for: indexPath) as! RelatedMoviesCollectionViewCell
//                    // Configure the cell with related movie information
//                    // Assuming Movie class has a 'title' property
//                    cell.movieTitleLabel.text = relatedMovies[indexPath.item].title
//                    return cell
//                case .recommendedMovies:
//                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedMoviesCollectionViewCell", for: indexPath) as! RecommendedMoviesCollectionViewCell
//                    // Configure the cell with recommended movie information
//                    // Assuming Movie class has a 'title' property
//                    cell.movieTitleLabel.text = recommendedMovies[indexPath.item].title
//                    return cell
        case .trailer:
            let width = 300 //some width
            let height = 180//ratio
            return CGSize(width: width, height: height)
        case .clips:
            let width = 300 //some width
            let height = 180//ratio
            return CGSize(width: width, height: height)
        case .recommended:
           let width = 120 //some width
           let height = 150//ratio
           return CGSize(width: width, height: height)
        case .similar:
            let width = 120 //some width
            let height = 150//ratio
           return CGSize(width: width, height: height)
                case .none:
                    return CGSizeZero
                }
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 40
//    }
    
    }
    


extension MovieViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
        //return UIModalPresentationStyle.fullScreen
    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        if traitCollection.horizontalSizeClass == .compact {
            return UIModalPresentationStyle.none
            //return UIModalPresentationStyle.fullScreen
        }
        //return UIModalPresentationStyle.fullScreen
        return UIModalPresentationStyle.none
    }

    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        switch style {
        default:
            return controller.presentedViewController
        }
    }
}
