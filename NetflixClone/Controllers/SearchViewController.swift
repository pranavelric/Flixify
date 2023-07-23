//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 04/07/23.
//

import UIKit

class SearchViewController: UIViewController {

    
    
//https://api.themoviedb.org/3/discover/movie?include_adult=true&include_video=true&language=en-US&page=1&sort_by=popularity.desc
    
    private var topSearchMovies: [Movie] = []
    private var toTop:Bool = false
    private var newOffset :CGFloat = CGFloat()
    private var currentOffset : CGFloat =  CGFloat()
    
    private let topSearchTable: UITableView = {
        let table  = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.IDENTIFIER)
        table.separatorColor = .clear
        table.backgroundColor = .clear
        return table
    }()
    
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 0.60, green: 0.21, blue: 0.08, alpha: 0.2).cgColor
        let colorBetween = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00).cgColor
        let colorBottom = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00).cgColor
             
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBetween , colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 450)
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(topSearchTable)
        topSearchTable.dataSource = self
        topSearchTable.delegate = self
        
        getTopSearchMovies()
        
        
    }

    override func viewDidLayoutSubviews() {
        setGradientBackground()
        super.viewDidLayoutSubviews()
        topSearchTable.frame = view.bounds
    }
    
    private func getTopSearchMovies(){
        ApiCaller.shared.fetchData(from: Constants.DICOVER_MOVIES, with: "&include_adult=true&include_video=true&language=en-US&page=1&sort_by=popularity.desc") { (result: Result<TrendingMovieResponse, Error>) in
               switch result {
               case .success(let response):
                   self.topSearchMovies = response.results
                   print(self.topSearchMovies)
                   DispatchQueue.main.async {
                       self.topSearchTable.reloadData()
                   }
               case .failure(let error):
                   print(error)
               }
           }
    }


}


extension SearchViewController  : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topSearchMovies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 420
    }
    
    
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.IDENTIFIER, for: indexPath) as? MovieTableViewCell else{
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.configure(with: self.topSearchMovies[indexPath.row])

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // instead of return perhaps should do a simpler animation
        if !tableView.isDragging || indexPath.row == self.topSearchMovies.count { return }
        

        
        
        if toTop {
            cell.contentView.transform = CGAffineTransformMakeTranslation(0, -80)
            
        } else {
            cell.contentView.transform = CGAffineTransformMakeTranslation(0, 80)
            
        }
        
        UIView.animate(withDuration: 1.0, delay: 0.05 , usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
            cell.contentView.transform = CGAffineTransformMakeTranslation(0, 0)
        }, completion: nil)

    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        currentOffset = scrollView.contentOffset.y
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newOffset = scrollView.contentOffset.y

        if newOffset > currentOffset {
            toTop = false
        } else {
            toTop = true
        }
        currentOffset = newOffset
    }
 
}

