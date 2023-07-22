//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 04/07/23.
//

import UIKit


enum Sections: Int{
    case TrendingMovie  = 0
    case TrendingTv     = 1
    case Popular        = 2
    case UpcomingMovies = 3
    case TopRated       = 4
    case NowPlaying     = 5
    
}


class HomeViewController: UIViewController {
    
    let sectionTitle:[String] = ["Trending movies","Treding tv","Popular","Upcoming movies","Top rated", "Now playing"]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView()
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
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
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 550)
        self.view.layer.insertSublayer(gradientLayer, at:0)
//        homeFeedTable.superview?.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        homeFeedTable.delegate   = self
        homeFeedTable.dataSource = self
        configNavBar()
        
        
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 550))
        homeFeedTable.tableHeaderView =  headerView
        homeFeedTable.sectionHeaderTopPadding = 0
    }
    
    override func viewDidLayoutSubviews() {
        setGradientBackground()
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    private func configNavBar(){
        var image = UIImage(named: "Netflix-Symbol")
        
        
        image = image?.scaleImage(toSize: CGSize(width: 10, height: 10))
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.title = ""
        let label = UILabel()
        label.textColor = UIColor.white
//        replace this with "For <username>"
        label.text = "Home"
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationItem.rightBarButtonItems?.forEach({ button in
            button.tintColor = .white
        })
        self.navigationController!.navigationBar.isTranslucent = true
    }

    
    private func getTrendingMovies(with cell:CollectionViewTableViewCell){
        ApiCaller.shared.fetchData(from: Constants.TRENDING_MOVIES) { (result: Result<TrendingMovieResponse, Error>) in
               switch result {
               case .success(let response):
                   cell.configure(with: response.results)
               case .failure(let error):
                   print(error)
               }
           }
        
    }
    
//    private func getTrendingTv(with cell:CollectionViewTableViewCell){
//        ApiCaller.shared.fetchData(from: Constants.TRENDING_TV) { (result: Result<TrendingTvResponse, Error>) in
//               switch result {
//               case .success(let response):
//                   cell.configure(with: response.results)
//               case .failure(let error):
//                   print(error)
//               }
//           }
//    }
    
    
    private func getTopRatedMovies(with cell:CollectionViewTableViewCell){
        ApiCaller.shared.fetchData(from: Constants.TOP_RATED_MOVIES) { (result: Result<TrendingMovieResponse, Error>) in
               switch result {
               case .success(let response):
                   cell.configure(with: response.results)
               case .failure(let error):
                   print(error)
               }
           }
    }
    
    private func getUpComingMovies(with cell:CollectionViewTableViewCell){
        ApiCaller.shared.fetchData(from: Constants.UPCOMING_MOVIES) { (result: Result<TrendingMovieResponse, Error>) in
               switch result {
               case .success(let response):
                   cell.configure(with: response.results)
               case .failure(let error):
                   print(error)
               }
           }
    }
    
    private func getPopularMovies(with cell:CollectionViewTableViewCell){
        ApiCaller.shared.fetchData(from: Constants.POPULAR_MOVIES) { (result: Result<TrendingMovieResponse, Error>) in
               switch result {
               case .success(let response):
                   cell.configure(with: response.results)
               case .failure(let error):
                   print(error)
               }
           }
    }
    private func getNowPlayingMovies(with cell:CollectionViewTableViewCell){
        ApiCaller.shared.fetchData(from: Constants.POPULAR_MOVIES) { (result: Result<TrendingMovieResponse, Error>) in
               switch result {
               case .success(let response):
                   cell.configure(with: response.results)
               case .failure(let error):
                   print(error)
               }
           }
    }
    
    
}


extension UIImage {
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
}


extension HomeViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int)->Int{
            return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else{
            return UITableViewCell()
        }
        
        switch indexPath.section{
            case Sections.TrendingMovie.rawValue:
                getTrendingMovies(with: cell)
//            case Sections.TrendingTv.rawValue:
//                getTrendingTv(with: cell)
            case Sections.Popular.rawValue:
                getPopularMovies(with: cell)
            case Sections.UpcomingMovies.rawValue:
                getUpComingMovies(with: cell)
            case Sections.TopRated.rawValue:
                getTopRatedMovies(with: cell)
            case Sections.NowPlaying.rawValue:
                getNowPlayingMovies(with: cell)
            default:
                return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset

        let gradientLayer =  self.view?.layer.sublayers?.first
        let offsetY = self.homeFeedTable.contentOffset.y
        let gradientY = min(-offsetY, 0)
        let gradientFrame = CGRect(x: 0, y: gradientY, width: homeFeedTable.bounds.width, height: 550)
        gradientLayer!.frame = gradientFrame

//        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0,-offset))

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }

    
}
