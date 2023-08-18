//
//  HomeViewController.swift
//  Flixify
//
//  Created by Pranav Choudhary on 04/07/23.
//

import UIKit

enum Sections: Int{
    case TrendingMovie  = 0
    case Popular        = 1
    case UpcomingMovies = 2
    case TopRated       = 3
    case NowPlaying     = 4
    
}


protocol MovieInterface: AnyObject {
    func configureVC()
    func configureCollectionView()
    func reloadCollectionView()
    func didTapItem(with viewModel: MoviePreviewViewModel)
    func showToast(message msg: String)
    func reloadCollectionViewRows(at indexPaths: [IndexPath])
    func configureHeaderView(imageUrl url: String, currentMovie movie: Movie?)
    func configureCell(with cell:CollectionViewTableViewCell,results result : [Movie])
}




class HomeViewController: UIViewController {
    
    let sectionTitle:[String] = ["Trending movies","Popular","Upcoming movies","Top rated", "Now playing"]
    public var viewModel = MovieViewModel.shared
//    var headerMovieImage: [Movie?] = []
    private var  headerView : HeroHeaderUIView = HeroHeaderUIView()
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: CGRect(), style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        table.separatorColor = .clear
        table.backgroundColor = .clear
        return table
        
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
        

    }
    

    
    override func viewDidLayoutSubviews() {
        view.setGradientBackground()
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
        navigationController?.navigationBar.isHidden = false
        
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
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationItem.rightBarButtonItems?.forEach({ button in
            button.tintColor = .white
        })
        self.navigationController!.navigationBar.isTranslucent = true
    }

    
//    private func getTrendingMovies(with cell:CollectionViewTableViewCell){
//        ApiCaller.shared.fetchData(from: Constants.TRENDING_MOVIES) { (result: Result<TrendingMovieResponse, Error>) in
//               switch result {
//               case .success(let response):
//                   self.headerMovieImage.append(response.results.randomElement())
//                   let movie = self.headerMovieImage.randomElement()!
//                   let url = movie?.poster_path ?? movie?.backdrop_path ?? ""
//                   self.headerView.configure(imageUrl: url,currentMovie: movie,controller: self)
//                   cell.configure(with: response.results,controller: self)
//               case .failure(let error):
//                   print(error)
//               }
//           }
//    }
//
//
//    private func getTopRatedMovies(with cell:CollectionViewTableViewCell){
//        ApiCaller.shared.fetchData(from: Constants.TOP_RATED_MOVIES) { (result: Result<TrendingMovieResponse, Error>) in
//               switch result {
//               case .success(let response):
//                   self.headerMovieImage.append(response.results.randomElement())
//                   cell.configure(with: response.results, controller: self)
//               case .failure(let error):
//                   print(error)
//               }
//           }
//    }
//
//    private func getUpComingMovies(with cell:CollectionViewTableViewCell){
//        ApiCaller.shared.fetchData(from: Constants.UPCOMING_MOVIES) { (result: Result<TrendingMovieResponse, Error>) in
//               switch result {
//               case .success(let response):
//                   self.headerMovieImage.append(response.results.randomElement())
//
//                   cell.configure(with: response.results,controller: self)
//               case .failure(let error):
//                   print(error)
//               }
//           }
//    }
//
//    private func getPopularMovies(with cell:CollectionViewTableViewCell){
//        ApiCaller.shared.fetchData(from: Constants.POPULAR_MOVIES) { (result: Result<TrendingMovieResponse, Error>) in
//               switch result {
//               case .success(let response):
//                   self.headerMovieImage.append(response.results.randomElement())
//                   cell.configure(with: response.results,controller: self)
//               case .failure(let error):
//                   print(error)
//               }
//           }
//    }
//    private func getNowPlayingMovies(with cell:CollectionViewTableViewCell){
//        ApiCaller.shared.fetchData(from: Constants.POPULAR_MOVIES) { (result: Result<TrendingMovieResponse, Error>) in
//               switch result {
//               case .success(let response):
//                   self.headerMovieImage.append(response.results.randomElement())
//                   cell.configure(with: response.results,controller: self)
//               case .failure(let error):
//                   print(error)
//               }
//           }
//    }
//

    
    
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
        cell.delegate = self
        switch indexPath.section{
            case Sections.TrendingMovie.rawValue:
            self.viewModel.getTrendingMovies(with: cell)
            case Sections.Popular.rawValue:
            self.viewModel.getPopularMovies(with: cell)
            case Sections.UpcomingMovies.rawValue:
            self.viewModel.getUpComingMovies(with: cell)
            case Sections.TopRated.rawValue:
            self.viewModel.getTopRatedMovies(with: cell)
            case Sections.NowPlaying.rawValue:
            self.viewModel.getNowPlayingMovies(with: cell)
            default:
                return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: .leastNonzeroMagnitude))
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let gradientLayer =  self.view?.layer.sublayers?.first
               let offsetY = self.homeFeedTable.contentOffset.y
               let gradientY = min(-offsetY, 0)
               let gradientFrame = CGRect(x: 0, y: gradientY, width: homeFeedTable.bounds.width, height: 450)
               gradientLayer!.frame = gradientFrame


    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }

    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderLabelView = UIView()
        
        sectionHeaderLabelView.backgroundColor = .black
        let sectionHeaderLabel = UILabel()
        sectionHeaderLabel.text = sectionTitle[section]
        sectionHeaderLabel.textColor = .white.withAlphaComponent(0.8)
        sectionHeaderLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        sectionHeaderLabel.frame = CGRect(x: 20, y: 0, width: view.bounds.width, height: 40)
        sectionHeaderLabelView.addSubview(sectionHeaderLabel)

        return sectionHeaderLabelView
    }
    

    
}



extension HomeViewController : CollectionViewTableViewCellDelegate{
    func collectionViewTableViewCellDidTapCell(_cell: CollectionViewTableViewCell, viewModel: MoviePreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = MovieViewController()
            vc.configure(with: viewModel)
            vc.modalPresentationStyle = .formSheet
            self?.navigationController?.pushViewController(vc, animated: true)
        }
      
    }
}



extension HomeViewController: MovieInterface {
    func configureHeaderView(imageUrl url: String, currentMovie movie: Movie?) {
        self.headerView.configure(imageUrl: url,currentMovie: movie,controller: self)
    }
    
    func configureCell(with cell:CollectionViewTableViewCell, results result: [Movie]) {
        cell.configure(with: result,controller: self)
    }
    
    func showToast(message msg: String) {
        Toast.show(message: msg, controller: self)
    }

    func didTapItem(with viewModel: MoviePreviewViewModel) {
        let vc = MovieViewController()
        vc.configure(with: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func reloadCollectionView() {
    }
    
    func reloadCollectionViewRows(at indexPaths: [IndexPath]){

    }
    func configureVC() {
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
       
        
       
    }

    func configureCollectionView() {
        headerView  = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 550))
        homeFeedTable.delegate   = self
        homeFeedTable.dataSource = self
        homeFeedTable.tableHeaderView =  headerView
        homeFeedTable.sectionHeaderTopPadding = 0
        configNavBar()
    }


}

