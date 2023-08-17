//
//  TableHeaderViewCarouselCellCollectionViewCell.swift
//  Flixify
//
//  Created by Pranav Choudhary on 22/07/23.
//

import UIKit

import ScalingCarousel

class carouselCell: ScalingCarouselCell {
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        mainView = UIView(frame: contentView.bounds)
        mainView.backgroundColor = .red
        contentView.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                    mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
                    mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
                    ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

class CarouselViewController : UIViewController{
    
    // MARK: - Properties (Private)
        fileprivate var scalingCarousel: ScalingCarouselView!

        // MARK: - Lifecycle
        
        override func viewDidLoad() {
            super.viewDidLoad()

            addCarousel()
            
            
        }
    
    override func viewDidLayoutSubviews() {
        
        scalingCarousel.scrollToItem(at: IndexPath(item: 3 , section: 0), at: .centeredHorizontally, animated: true)
        scalingCarousel.setNeedsLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
                 if scalingCarousel != nil {
                    scalingCarousel.deviceRotated()
                 }
    }
    
    // MARK: - Configuration
    private func addCarousel(){
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)

        scalingCarousel = ScalingCarouselView(withFrame: frame, andInset: 50)
        scalingCarousel.scrollDirection = .horizontal
        scalingCarousel.dataSource = self
        scalingCarousel.delegate = self
        scalingCarousel.translatesAutoresizingMaskIntoConstraints = false
        scalingCarousel.backgroundColor = .white
        scalingCarousel.register(carouselCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(scalingCarousel)
        
       
        scalingCarousel.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        scalingCarousel.heightAnchor.constraint(equalToConstant: 300).isActive = true
        scalingCarousel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scalingCarousel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
   
//        let middleIndexPath = IndexPath(item: 4, section: 0)
//        scalingCarousel.scrollToItem(at: middleIndexPath, at: .centeredHorizontally, animated: false)

    }
}

extension CarouselViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if let scalingCell = cell as? ScalingCarouselCell {
                    scalingCell.mainView.backgroundColor = .blue
                }
        DispatchQueue.main.async {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        return cell
    }
}

extension CarouselViewController : UICollectionViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scalingCarousel.didScroll()
    }
}
