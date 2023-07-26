//
//  MovieViewController.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 26/07/23.
//

import UIKit
import WebKit



class MovieViewController: UIViewController {
    
    private let webView: WKWebView  = {
        
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
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
        view.addSubview(webView)
        view.addSubview(movieTitleLabel)
        view.addSubview(overviewLabel)
        
        
        
        
        navigationController?.navigationBar.isHidden = true
        
        configureConstraints()
        
        self.edgesForExtendedLayout = []
    }
    

    private func  configureConstraints(){
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor,constant: 0),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 350)
            
        ]
        
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
            movieTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        
        
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(movieTitleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        
    }
    func configure(with model: MoviePreviewViewModel){
        self.movieTitleLabel.text = model.title
        self.overviewLabel.text = model.titleOverview
        
        guard  let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView[0].id.videoId)") else{
            return
        }
        print(model.title)
        print(model.titleOverview
        )
        print(model.youtubeView[0])
        print(url)
        self.webView.load(URLRequest(url: url))
    }

}
