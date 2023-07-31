//
//  UpcomingViewController.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 04/07/23.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var upComingMovies: [Movie] = []
    private var toTop:Bool = false
    private var newOffset :CGFloat = CGFloat()
    private var currentOffset : CGFloat =  CGFloat()
    
    private let upcomingTable: UITableView = {
        let table  = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.IDENTIFIER)
        table.separatorColor = .clear
        table.backgroundColor = .clear
        table.estimatedRowHeight = 600
        table.rowHeight = UITableView.automaticDimension
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
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(upcomingTable)
        upcomingTable.dataSource = self
        upcomingTable.delegate = self

        getUpComingMovies()
        
    }

    override func viewDidLayoutSubviews() {
        setGradientBackground()
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
   
    
    }
    
    private func getUpComingMovies(){
        ApiCaller.shared.fetchData(from: Constants.UPCOMING_MOVIES) { (result: Result<TrendingMovieResponse, Error>) in
               switch result {
               case .success(let response):
                   self.upComingMovies = response.results
                   DispatchQueue.main.async {
                       self.upcomingTable.reloadData()
                   }
                   
//                   self.upcomingTable.reloadData()
                   self.upcomingTable.scrollToBottom()
//                   self.upcomingTable.scrollToTop()
                   
                   
               case .failure(let error):
                   print(error)
               }
           }
    }

}

extension UpcomingViewController : UITableViewDelegate, UITableViewDataSource{

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.upComingMovies.count
    }
    
  
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
           return 600
       }

       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableView.automaticDimension
       }
    
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.IDENTIFIER, for: indexPath) as? MovieTableViewCell else{
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.configure(with: self.upComingMovies[indexPath.row])

        return cell
    }
    
    // used for animation, but will disable userinteration untill animation
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        // instead of return perhaps should do a simpler animation
//        if !tableView.isDragging || indexPath.row == self.upComingMovies.count { return }
//        
//
//        
//        
//        if toTop {
//            cell.contentView.transform = CGAffineTransformMakeTranslation(0, -80)
//            
//        } else {
//            cell.contentView.transform = CGAffineTransformMakeTranslation(0, 80)
//            
//        }
//        
//        UIView.animate(withDuration: 1.0, delay: 0.05 , usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
//            cell.contentView.transform = CGAffineTransformMakeTranslation(0, 0)
//        }, completion: nil)
//
//    }
    
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
