//
//  MovieViewController.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 26/07/23.
//

import UIKit
import WebKit



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
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(overviewLabel)
    }
    

    private func  configureConstraints(){
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 0),
            webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 350)
            
        ]
        
        webView.isUserInteractionEnabled = true
        webView.scrollView.isScrollEnabled = true
        webView.configuration.allowsInlineMediaPlayback = true
        webView.configuration.mediaTypesRequiringUserActionForPlayback = []
        webView.configuration.allowsPictureInPictureMediaPlayback = true
        webView.contentMode = .scaleToFill
        webView.sizeToFit()
        webView.autoresizesSubviews = true
        
        
        
        let movieTitleLabelConstraints = [
            movieTitleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor,constant: 20),
            movieTitleLabel.leadingAnchor.constraint(equalTo: webView.leadingAnchor,constant: 20),
            movieTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        let overviewLabelConstraints = [
            overviewLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor,constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: movieTitleLabel.leadingAnchor,constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]

        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(movieTitleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        
    }
    func configure(with model: MoviePreviewViewModel){
        self.movieDetail = model.movieDetail
        self.movieTitleLabel.text = movieDetail?.title ?? movieDetail?.originalTitle ?? "unknown"
        self.overviewLabel.text = movieDetail?.overview ?? "unknown"
        
        guard  let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView[0].id.videoId)") else{
            return
        }
       
        self.webView.load(URLRequest(url: url))
        self.webView.isUserInteractionEnabled = true
    }

}
