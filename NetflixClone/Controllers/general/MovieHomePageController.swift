//
//  MovieHomePageController.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 05/08/23.
//


import UIKit
import WebKit
import SafariServices
class MovieHomePageViewController: UIViewController, WKUIDelegate {

        private let webView: WKWebView  = {
    
            let webConfiguration = WKWebViewConfiguration()
            let webView = WKWebView(frame: .zero, configuration: webConfiguration)
            webView.translatesAutoresizingMaskIntoConstraints = false
            webView.isUserInteractionEnabled = true
            return webView
        }()
    private let progressView = UIProgressView(progressViewStyle: .default)
    /// The observation object for the progress of the web view (we only receive notifications until it is deallocated).
       private var estimatedProgressObserver: NSKeyValueObservation?
    
     override func viewDidLoad() {
        super.viewDidLoad()
         view.backgroundColor = .black
         view.addSubview(webView)
         webView.uiDelegate = self

         webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
         webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
         webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
         webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
         
         setupProgressView()
         setupEstimatedProgressObserver()
         
     }
    
    public func configure(with url : String?){
        let myURL = URL(string:url ?? "")
//        if let myURL = URL(string:url ?? ""){
//            let config = SFSafariViewController.Configuration()
//            config.entersReaderIfAvailable = true
//
//            let vc = SFSafariViewController(url: myURL, configuration: config)
//            present(vc, animated: true)
//        }
        
        if let  myURL = URL(string:url ?? "") {
                   setupWebview(url: myURL)
               }
//        let myRequest = URLRequest(url: myURL!)
//        webView.load(myRequest)
    }
    
//     override func loadView() {
//        let webConfiguration = WKWebViewConfiguration()
//        webView = WKWebView(frame: .zero, configuration: webConfiguration)
//        webView.uiDelegate = self
//        view = webView
//     }
//

     private func setupProgressView() {
//         guard let navigationBar = navigationController?.navigationBar else {
//             print("⚠️ – Expected to have a valid navigation controller at this point.")
////             return
//         }

         progressView.isHidden = true

         progressView.translatesAutoresizingMaskIntoConstraints = false
//         navigationBar.addSubview(progressView)

         view.addSubview(progressView)
         NSLayoutConstraint.activate([
             progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

             progressView.topAnchor.constraint(equalTo: view.topAnchor),
             progressView.heightAnchor.constraint(equalToConstant: 2.0)
         ])
     }

     private func setupEstimatedProgressObserver() {
         estimatedProgressObserver = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
             self?.progressView.progress = Float(webView.estimatedProgress)
         }
     }

     private func setupWebview(url: URL) {
         webView.navigationDelegate = self

         let request = URLRequest(url: url)
         webView.load(request)
     }
 }


extension MovieHomePageViewController: WKNavigationDelegate {
    func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        if progressView.isHidden {
            // Make sure our animation is visible.
            progressView.isHidden = false
        }

        UIView.animate(withDuration: 0.33,
                       animations: {
                           self.progressView.alpha = 1.0
        })
    }

    func webView(_: WKWebView, didFinish _: WKNavigation!) {
        UIView.animate(withDuration: 0.33,
                       animations: {
                           self.progressView.alpha = 0.0
                       },
                       completion: { isFinished in
                           // Update `isHidden` flag accordingly:
                           //  - set to `true` in case animation was completly finished.
                           //  - set to `false` in case animation was interrupted, e.g. due to starting of another animation.
                           self.progressView.isHidden = isFinished
        })
    }
}
