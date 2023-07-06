//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 04/07/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let homeFeedTable: UITableView = {
        let table = UITableView()
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        homeFeedTable.delegate   = self
        homeFeedTable.dataSource = self
        
        configNavBar()
        
        
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView =  headerView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }

    
    private func configNavBar(){
        var image = UIImage(named: "Netflix-Symbol")
        
        
        image = image?.scaleImage(toSize: CGSize(width: 10, height: 10))
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
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
        return 12
    }
    
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int)->Int{
            return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else{
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0,-offset))
        
    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let sectionHeaderBackgroundColor = UIColor(hue: 0.021, saturation: 0.34, brightness: 0.94, alpha: 0.4)
//    let sectionHeaderLabelView = UIView()
//        sectionHeaderLabelView.backgroundColor = sectionHeaderBackgroundColor
//
//        let sectionHeaderImage = UIImage(named: "SourceIcon")
//        let sectionHeaderImageView = UIImageView(image: sectionHeaderImage)
//        sectionHeaderImageView.frame = CGRect(x: 3, y: 10, width: 30, height: 30)
//        sectionHeaderLabelView.addSubview(sectionHeaderImageView)
//
//        let sectionHeaderLabel = UILabel()
//        sectionHeaderLabel.text = "text"
//        sectionHeaderLabel.textColor = .brown
//        sectionHeaderLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
//        sectionHeaderLabel.frame = CGRect(x: 43, y: 5, width: 250, height: 40)
//        sectionHeaderLabelView.addSubview(sectionHeaderLabel)
//
//        return sectionHeaderLabelView
//    }
//
    
}
