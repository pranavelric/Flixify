//
//  CharacterPopupController.swift
//  Flixify
//
//  Created by Pranav Choudhary on 12/08/23.
//

import Foundation
import Foundation
import UIKit


class CharacterPopupViewController: UIViewController {

    
    private var cast: Cast?
    private var crew: Crew?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        
    }
    

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.navigationBar.isHidden = true
    }
    
    
    
    
    
    
    
    
    
    
    
    

}

