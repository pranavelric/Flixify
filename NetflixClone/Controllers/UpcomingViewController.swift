//
//  UpcomingViewController.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 04/07/23.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var upComingMovies: [Movie] = []
    
    private let upcomingTable: UITableView = {
        let table  = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.IDENTIFIER)
        return table
    }()
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.IDENTIFIER, for: indexPath) as? MovieTableViewCell else{
            return UITableViewCell()
        }
        
//        cell.textLabel?.text = self.upComingMovies[indexPath.row].title ?? self.upComingMovies[indexPath.row].original_title ?? "unknown"

            
        cell.configure(with: self.upComingMovies[indexPath.row])

        return cell
    }
    
    
    
}
