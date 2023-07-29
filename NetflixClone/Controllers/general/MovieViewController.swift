//
//  MovieViewController.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 26/07/23.
//

import UIKit
import WebKit
import YouTubeiOSPlayerHelper



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




class MovieViewController: UIViewController {
    
    private var movieDetail : MovieDetail? = nil
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
    
    private let webView: WKWebView  = {
        
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isUserInteractionEnabled = true
        return webView
    }()
    
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
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.configuration?.image = UIImage(systemName: "play")
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
    
    private let taglineLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.5)
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
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
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
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
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
      
        contentView.addSubview(webView)
        contentView.addSubview(trailerView)
        contentView.addSubview(customThumnailImageView)
        contentView.addSubview(customThumnailCardImageView)
        contentView.addSubview(playButton)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(goToWebsiteButton)
        contentView.addSubview(infoButton)
        contentView.addSubview(bookmarkButton)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(overviewLabel)
        
        
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
            customThumnailImageView.heightAnchor.constraint(equalToConstant: 500)
            
        ]
        customThumnailImageView.layer.cornerRadius = 10
        

        let customThumbnailCardConstraints = [
            customThumnailCardImageView.centerXAnchor.constraint(equalTo: customThumnailImageView.centerXAnchor),
            customThumnailCardImageView.centerYAnchor.constraint(equalTo: customThumnailImageView.centerYAnchor,constant: -20),
            customThumnailCardImageView.heightAnchor.constraint(equalToConstant: 400),
            customThumnailCardImageView.widthAnchor.constraint(equalToConstant: view.bounds.width-150)
        ]
        customThumnailCardImageView.layer.cornerRadius = 10
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 600, height: 500)
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
   
        
        
        let releaseDateConstraints = [
            releaseDateLabel.topAnchor.constraint(equalTo: customThumnailImageView.bottomAnchor,constant: 10),
            releaseDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            releaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            releaseDateLabel.heightAnchor.constraint(equalToConstant: 20),
        ]
        
        let goToWebsiteButtonConstraints = [
            goToWebsiteButton.topAnchor.constraint(equalTo: customThumnailImageView.bottomAnchor,constant: 10),
            goToWebsiteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            goToWebsiteButton.heightAnchor.constraint(equalToConstant: 20),
        ]
        
        let infoButtonConstraints = [
            infoButton.topAnchor.constraint(equalTo: customThumnailImageView.bottomAnchor,constant: 10),
            infoButton.trailingAnchor.constraint(equalTo: goToWebsiteButton.leadingAnchor, constant: -5),
            infoButton.heightAnchor.constraint(equalToConstant: 20),
        ]
        
       
        let bookmarkButtonConstraints = [
            bookmarkButton.topAnchor.constraint(equalTo: customThumnailImageView.bottomAnchor,constant: 10),
            bookmarkButton.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor, constant: -5),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 20),
        ]
        
        
        
        
        
        
        
        let movieTitleLabelConstraints = [
            movieTitleLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor,constant: 20),
            movieTitleLabel.leadingAnchor.constraint(equalTo: customThumnailImageView.leadingAnchor,constant: 20),
            movieTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        let overviewLabelConstraints = [
            overviewLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor,constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: movieTitleLabel.leadingAnchor,constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]

//        let taglineLabelConstraints = [
//            taglineLabel.topAnchor.constraint(equalTo: customThumnailCardImageView.bottomAnchor,constant: 20),
//            taglineLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//
//
//        ]
//
       
        
        
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(movieTitleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(customThumbnailConstraints)
        NSLayoutConstraint.activate(customThumbnailCardConstraints)
        NSLayoutConstraint.activate(playButtonConstrains)
        
//        NSLayoutConstraint.activate(taglineLabelConstraints)
        NSLayoutConstraint.activate(releaseDateConstraints)
        NSLayoutConstraint.activate(goToWebsiteButtonConstraints)
        NSLayoutConstraint.activate(infoButtonConstraints)
        NSLayoutConstraint.activate(bookmarkButtonConstraints)
        
        
    }
    func configure(with model: MoviePreviewViewModel){
        self.movieDetail = model.movieDetail
        self.movieTitleLabel.text = movieDetail?.title ?? movieDetail?.originalTitle ?? "unknown"
        self.overviewLabel.text = movieDetail?.overview ?? "unknown"
        
//        guard  let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView[0].id.videoId)") else{
//            return
//        }
       
//        self.webView.load(URLRequest(url: url))
//        self.webView.isUserInteractionEnabled = true
        customThumnailImageView.sd_setImage(with: URL(string: "\(Constants.POSTER_PATH)/\(self.movieDetail?.backdropPath ?? self.movieDetail?.posterPath ?? "")"), placeholderImage: UIImage(named: "placeholder.png"))
        
        customThumnailCardImageView.sd_setImage(with: URL(string: "\(Constants.POSTER_PATH)/\(self.movieDetail?.posterPath ?? self.movieDetail?.backdropPath ?? "")"), placeholderImage: UIImage(named: "placeholder.png"))
        
        trailerView.load(withPlayerParams: playerVar)
        trailerView.load(withVideoId: "\(model.youtubeView?[0].id.videoId)", playerVars: playerVar)
        trailerView.layer.cornerRadius = 10
        trailerView.clipsToBounds = true
        
        releaseDateLabel.text = "\(self.movieDetail?.releaseDate?.getFormattedDate() ?? "")"
//        taglineLabel.text = " \"\(self.movieDetail?.tagline ??  "")\" "
        
        
    
    }
    
    @objc private func playButtonTapped(){
//        customThumnailImageView.isHidden = true
//        self.movieTitleLabel.topAnchor.constraint(equalTo: self.trailerView.bottomAnchor,constant: 20).isActive = true
//        self.movieTitleLabel.leadingAnchor.constraint(equalTo: self.trailerView.leadingAnchor,constant: 20).isActive = true
        self.releaseDateLabel.topAnchor.constraint(equalTo: self.trailerView.bottomAnchor, constant: 20).isActive = true
        self.goToWebsiteButton.topAnchor.constraint(equalTo: self.trailerView.bottomAnchor, constant: 20).isActive = true
        self.infoButton.topAnchor.constraint(equalTo: self.trailerView.bottomAnchor, constant: 20).isActive = true
        self.bookmarkButton.topAnchor.constraint(equalTo: self.trailerView.bottomAnchor, constant: 20).isActive = true
        
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
